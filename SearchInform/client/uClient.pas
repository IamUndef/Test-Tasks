unit uClient;

interface

uses uSharedMemoryPoint;

type
  TSharedMemoryClient = class(TSharedMemoryPoint)
    private
      FileName_: String;
      Terminated_: Boolean;
    protected
      procedure Start(Callback: TSharedMemoryClient.TProcessCallBack); override;
    public
      constructor Create();
      destructor Destroy(); override;
      procedure Terminated(); override;
      procedure Send(const FileName: String;
                     Callback: TSharedMemoryClient.TProcessCallBack);

      property FileName: String read FileName_;
  end;

implementation

uses Vcl.Forms, Winapi.Windows, System.SysUtils, System.Classes,
     System.IniFiles, System.Math, uCommon;

constructor TSharedMemoryClient.Create();

procedure LoadSettings();
var
  Settings: TIniFile;
  AppDirName: String;
begin
  AppDirName := ExtractFilePath(Application.ExeName);
  try
    Settings := TIniFile.Create(Format('%s\client.ini', [AppDirName]));
    try
      FileName_ := Settings.ReadString('Client', 'FileName', '');
    finally
      FreeAndNil(Settings);
    end;
  except
  end;
end;

begin
  try
    LoadSettings();
    inherited Create(False);
  except
    on E: EGetSharedMemoryName do
      raise Exception.Create('Не удалось подключиться к COM-серверу!');
    on E: EExistSharedMemoryPoint do
      raise Exception.Create(Format('Клиент для объекта "%s" уже запущен!',
                                    [SharedMemoryName]));
    on E: EOpenSharedMemoryMapped do
      raise Exception.Create('Не удалось подключиться к серверу!');
    on E: Exception do
      raise Exception.Create(Format('Не удалось запустить клиент: "%s"!',
                                    [E.Message]));
  end;
end;

destructor TSharedMemoryClient.Destroy();

procedure SaveSettings();
var
  Settings: TIniFile;
  AppDirName: String;
begin
  AppDirName := ExtractFilePath(Application.ExeName);
  try
    Settings := TIniFile.Create(Format('%s\client.ini', [AppDirName]));
    try
      Settings.WriteString('Client', 'FileName', FileName_);
    finally
      FreeAndNil(Settings);
    end;
  except
  end;
end;

begin
  SaveSettings();
  inherited Destroy();
end;

procedure TSharedMemoryClient.Terminated();
begin
  Terminated_ := True;
end;

procedure TSharedMemoryClient.Send(const FileName: String;
    Callback: TSharedMemoryClient.TProcessCallBack);
begin
  if FileName = '' then
    raise Exception.Create('Не указан файл для передачи!')
  else
  if not FileExists(FileName) then
    raise Exception.Create('Указанный файл не найден!')
  else
  begin
    FileName_ := FileName;
    Terminated_ := False;
    Start(Callback);
  end;
end;

procedure
    TSharedMemoryClient.Start(Callback: TSharedMemoryClient.TProcessCallBack);

procedure WriteMetaData(DataPointer: Pointer; Stream: TStream);
var
  Memory: TMemoryStream;
  StreamSize: Int64;
  FileName: WideString;
  FileNameLength: Integer;
begin
  Memory := TMemoryStream.Create();
  try
    StreamSize := Stream.Size;
    FileName := ExtractFileName(FileName_);
    FileNameLength := Length(FileName);
    Memory.WriteBuffer(StreamSize, SizeOf(StreamSize));
    Memory.WriteBuffer(FileNameLength, SizeOf(FileNameLength));
    Memory.WriteBuffer(FileName[1], FileNameLength*SizeOf(WideChar));
    Memory.Position := 0;
    Memory.ReadBuffer(DataPointer^, Memory.Size);
  finally
    FreeAndNil(Memory);
  end;
end;

procedure WriteData(DataPointer: Pointer;
    Stream: TStream; var TransferSize: Int64);
var
  Memory: TMemoryStream;
  DataSize: Integer;
begin
  Memory := TMemoryStream.Create();
  try
    DataSize := Min(POINT_DATA_SIZE - SizeOf(DataSize),
                    Stream.Size - TransferSize);
    Memory.WriteBuffer(DataSize, SizeOf(DataSize));
    Memory.CopyFrom(Stream, DataSize);
    Memory.Position := 0;
    Memory.ReadBuffer(DataPointer^, Memory.Size);
    Inc(TransferSize, DataSize)
  finally
    FreeAndNil(Memory);
  end;
end;

var
  hRead,
  hWrite: THandle;
  Msg: String;
  PrevPercents,
  Percents,
  Attempts: Integer;
  IsTransfer: Boolean;
  TransferSize: Int64;
  Stream: TFileStream;
begin
  if Assigned(Callback) then
  begin
    hRead := 0;
    hWrite := 0;
    PrevPercents := 0;
    Percents := 0;
    Attempts := 0;
    IsTransfer := False;
    TransferSize := 0;
    Stream := NIL;
    try
      try
        hRead := OpenEvent(EVENT_ALL_ACCESS, False,
                           PChar(Format('%s.read', [SharedMemoryName])));
        hWrite := OpenEvent(EVENT_ALL_ACCESS, False,
                            PChar(Format('%s.write', [SharedMemoryName])));
        if (hRead = 0) or (hWrite = 0) then
          raise Exception.Create('Сервер не доступен!');
        Stream := TFileStream.Create(FileName_, fmOpenRead or fmShareDenyNone);
        while not Terminated_ and ((TransferSize < Stream.Size) or
            (Stream.Size = 0)) do
        begin
          case WaitForSingleObject(hWrite, POINT_WAIT_TIMEOUT) of
            WAIT_TIMEOUT:
              begin
                if IsTransfer then
                begin
                  Inc(Attempts);
                  if Attempts >= POINT_ATTEPMTS_COUNT then
                    raise Exception.Create('Сервер не доступен!');
                end;
              end;
            WAIT_OBJECT_0:
              begin
                if not IsTransfer then
                begin
                  WriteMetaData(DataPointer, Stream);
                  if Stream.Size = 0 then
                  begin
                    Terminated_ := True;
                    Msg := Format('Передан файл "%s" нулевого размера',
                                  [FileName_])
                  end else
                  begin
                    IsTransfer := True;
                    Msg := Format('Начата передача файла' +
                                  ' (Файл: "%s", Размер: %s)',
                                  [FileName_, FileSizeToStr(Stream.Size)]);
                  end;
                end else
                begin
                  Attempts := 0;
                  WriteData(DataPointer, Stream, TransferSize);
                  if TransferSize = Stream.Size then
                  begin
                    Terminated_ := True;
                    TransferSize := 0;
                    Msg := Format('Завершена передача файла "%s"', [FileName_]);
                  end;
                end;
                SetEvent(hRead);
              end
          else
            raise Exception.Create(SysErrorMessage(GetLastError()));
          end;
          if Stream.Size <> 0 then
            Percents := Floor(100*TransferSize/Stream.Size);
          if (Msg <> '') or (Percents <> PrevPercents) then
          begin
            Callback(Msg, Percents, False);
            PrevPercents := Percents;
            Msg := '';
          end;
        end;
      except
        on E: Exception do
          Callback(E.Message, Percents, True)
      end;
    finally
      if Assigned(Stream) then
        FreeAndNil(Stream);
      if hWrite <> 0 then
        CloseHandle(hWrite);
      if hRead <> 0 then
        CloseHandle(hRead);
    end;
  end;
end;

end.
