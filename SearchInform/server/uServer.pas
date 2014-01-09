unit uServer;

interface

uses System.Classes, uSharedMemoryPoint;

type
  TSharedMemoryServer = class(TSharedMemoryPoint)
    private
      type
        TServerThread = class(TThread)
          private
            type
              TServerThreadEvent = procedure of object;
            var
              OnReceive_,
              OnCallback_ : TServerThreadEvent;
          public
            constructor Create(OnReceive, OnCallback: TServerThreadEvent);
            procedure Execute(); override;
        end;
      var
        Thread: TServerThread;
        hRead,
        hWrite: THandle;
        Callback_: TSharedMemoryServer.TProcessCallBack;
        DirName_,
        Msg: String;
        FileName: WideString;
        PrevPercents,
        Percents,
        Attempts: Integer;
        IsError,
        IsReception: Boolean;
        ReceptionSize,
        FileSize: Int64;
        Stream: TFileStream;

      function GetTempFileName(): String;
      procedure ThreadReceive();  // Процедура получения данных
      procedure ThreadCallBack(); // Процедура обратного вызова
      procedure CompleteReceive(SaveFile: Boolean = True);
    protected
      procedure Start(Callback: TSharedMemoryServer.TProcessCallBack); override;
    public
      constructor Create(Callback: TSharedMemoryServer.TProcessCallBack);
      destructor Destroy(); override;
      procedure Terminated(); override;

      property DirName: String read DirName_;
  end;

implementation

uses Vcl.Forms, Winapi.Windows, System.SysUtils, System.StrUtils,
     System.IniFiles, System.Math, uCommon;

constructor
    TSharedMemoryServer.Create(Callback: TSharedMemoryServer.TProcessCallBack);

procedure LoadSettings();
var
  Settings: TIniFile;
  AppDirName: String;
begin
  AppDirName := ExtractFilePath(Application.ExeName);
  try
    Settings := TIniFile.Create(Format('%s\server.ini', [AppDirName]));
    try
      DirName_ := Settings.ReadString('Server', 'DirName', AppDirName);
    finally
      FreeAndNil(Settings);
    end;
  except
  end;
  if DirName_ = '' then
    DirName_ := AppDirName;
  if not DirectoryExists(DirName_) then
    raise Exception.Create(Format('Указанный путь (%s) не существует',
                                  [DirName_]));
end;

begin
  try
    LoadSettings();
    inherited Create();
    Start(Callback);
  except
    on E: EGetSharedMemoryName do
      raise Exception.Create('Не удалось подключиться к COM-серверу!');
    on E: EExistSharedMemoryPoint do
      raise Exception.Create(Format('Сервер для объекта "%s" уже запущен!',
                                    [SharedMemoryName]));
    on E: Exception do
      raise Exception.Create(Format('Не удалось запустить сервер: "%s"!',
                                    [E.Message]));
  end;
end;

destructor TSharedMemoryServer.Destroy();
begin
  if Assigned(Thread) then
  begin
    Thread.Terminate();
    Thread.WaitFor();
    FreeAndNil(Thread);
  end;
  if hWrite <> 0 then
    CloseHandle(hWrite);
  if hRead <> 0 then
    CloseHandle(hRead);
  CompleteReceive(False);
  inherited Destroy();
end;

procedure TSharedMemoryServer.Terminated();
begin
  if Assigned(Thread) then
    Thread.Terminate();
end;

procedure
    TSharedMemoryServer.Start(Callback: TSharedMemoryServer.TProcessCallBack);
begin
  if Assigned(Callback) then
  begin
    CallBack_ := CallBack;
    hRead := CreateEvent(NIL, False, False, PChar(Format('%s.read',
                                                         [SharedMemoryName])));
    hWrite := CreateEvent(NIL, False, True, PChar(Format('%s.write',
                                                         [SharedMemoryName])));
    Thread := TServerThread.Create(ThreadReceive, ThreadCallBack);
  end;
end;

function TSharedMemoryServer.GetTempFileName(): String;
begin
  Result := Format('%s\%s.temp', [DirName_, SharedMemoryName]);
end;

procedure TSharedMemoryServer.ThreadReceive();

procedure ReadMetaData();
var
  Memory: TMemoryStream;
  FileNameLength: Integer;
begin
  Memory := TMemoryStream.Create();
  try
    Memory.WriteBuffer(DataPointer, POINT_DATA_SIZE);
    Memory.Position := 0;
    Memory.ReadBuffer(FileSize, SizeOf(FileSize));
    Memory.ReadBuffer(FileNameLength, SizeOf(FileNameLength));
    SetLength(FileName, FileNameLength);
    Memory.ReadBuffer(FileName[1], FileNameLength*SizeOf(WideChar));
  finally
    FreeAndNil(Memory);
  end;
end;

procedure ReadData();
var
  Memory: TMemoryStream;
  DataSize: Integer;
begin
  if Assigned(Stream) then
  begin
    Memory := TMemoryStream.Create();
    try
      Memory.WriteBuffer(DataPointer, POINT_DATA_SIZE);
      Memory.Position := 0;
      Memory.ReadBuffer(DataSize, SizeOf(DataSize));
      try
        Stream.CopyFrom(Memory, DataSize);
      except
        on E: EWriteError do
          raise Exception.Create('Не удалось сохранить данные!');
      end;
      Inc(ReceptionSize, DataSize);
    finally
      FreeAndNil(Memory);
    end;
  end;
end;

procedure CreateEmptyFile();
var
  EmptyFile: TextFile;
begin
  AssignFile(EmptyFile, GetTempFileName());
  try
    Rewrite(EmptyFile);
  finally
    Close(EmptyFile);
  end;
end;

begin
  try
    case WaitForSingleObject(hRead, POINT_WAIT_TIMEOUT) of
      WAIT_TIMEOUT:
        begin
          if IsReception then
          begin
            Inc(Attempts);
            if Attempts >= POINT_ATTEPMTS_COUNT then
            begin
              CompleteReceive(False);
              SetEvent(hWrite);
              Msg := 'Клиент не доступен!';
            end;
          end;
        end;
      WAIT_OBJECT_0:
        begin
          if not IsReception then
          begin
            ReadMetaData();
            if FileSize = 0 then
            begin
              CreateEmptyFile();
              CompleteReceive();
              Msg := Format('Принят файл нулевого размера' +
                            ' (Сохранён как: "%s")', [FileName]);
            end else
            begin
              IsReception := True;
              Stream := TFileStream.Create(GetTempFileName(),
                                           fmCreate or fmShareDenyNone);
              Msg := Format('Начат прием файла (Файл: "%s", Размер: %s)',
                            [FileName, FileSizeToStr(FileSize)]);
            end;
          end else
          begin
            Attempts := 0;
            ReadData();
            if ReceptionSize = FileSize then
            begin
              CompleteReceive();
              Msg := Format('Завершён прием файла (Сохранён как: "%s")',
                            [FileName]);
              FileName := '';
            end;
          end;
          SetEvent(hWrite);
        end;
    else
      raise Exception.Create(SysErrorMessage(GetLastError()));
    end;
  except
    on E: Exception do
    begin
      CompleteReceive(False);
      Msg := E.Message;
      IsError := True;
    end;
  end;
end;

procedure TSharedMemoryServer.ThreadCallBack();
begin
  try
    if FileSize <> 0 then
      Percents := Floor(100*ReceptionSize/FileSize);
    if (Msg <> '') or (PrevPercents <> Percents)  then
    begin
      CallBack_(Msg, Percents, IsError);
      PrevPercents := Percents;
    end;
  except
  end;
  Msg := '';
  IsError := False;
end;

procedure TSharedMemoryServer.CompleteReceive(SaveFile: Boolean);
var
  FileIndex: Integer;
  FileNameToSave: String;
begin
  PrevPercents := 0;
  Percents := 0;
  Attempts := 0;
  IsReception := False;
  ReceptionSize := 0;
  FileSize := 0;
  if Assigned(Stream) then
    FreeAndNil(Stream);
  if not SaveFile then
    DeleteFile(GetTempFileName())
  else
  begin
    FileIndex := 1;
    FileNameToSave := FileName;
    while FileExists(Format('%s\%s', [DirName_, FileNameToSave])) do
    begin
      FileNameToSave := Format('%s (%d)%s', [ChangeFileExt(FileName, ''),
                                             FileIndex,
                                             ExtractFileExt(FileName)]);
      Inc(FileIndex)
    end;
    FileName := FileNameToSave;
    if not RenameFile(Format('%s', [GetTempFileName()]),
                      Format('%s\%s', [DirName_, FileName])) then
      raise Exception.Create('Не удалось переименовать файл!');
  end;
end;

constructor TSharedMemoryServer.TServerThread.Create(OnReceive,
    OnCallback: TServerThreadEvent);
begin
  OnReceive_ := OnReceive;
  OnCallBack_ := OnCallback;
  inherited Create();
end;

procedure TSharedMemoryServer.TServerThread.Execute();
begin
  while not Terminated do
  begin
    OnReceive_();
    Synchronize(OnCallBack_);
  end;
end;

end.
