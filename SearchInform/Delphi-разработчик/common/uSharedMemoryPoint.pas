unit uSharedMemoryPoint;

interface

uses System.SysUtils, Winapi.Windows;

type
  TSharedMemoryPoint = class(TObject)
    protected
      const
        POINT_DATA_SIZE = 4096;
        POINT_WAIT_TIMEOUT: Cardinal = 300;
        POINT_ATTEPMTS_COUNT = 10;

      type
        EGetSharedMemoryName = class(Exception);
        EExistSharedMemoryPoint = class(Exception);
        ECreateSharedMemoryMapped = class(Exception);
        EOpenSharedMemoryMapped = class(Exception);
    public
      type
        TProcessCallBack = procedure(const Msg: String; Percents: Integer;
                                     IsError: Boolean) of object;
    private
      Id: TAtom;
      SharedMemoryName_: String;
      hMapping: THandle;
      pView: Pointer;

      procedure CreateOrOpenResource(IsServer: Boolean);
    protected
      procedure Start(Callback: TSharedMemoryPoint.TProcessCallBack); virtual;
                                                                      abstract;

      property DataPointer: Pointer read pView;
    public
      constructor Create(IsServer: Boolean = True);
      destructor Destroy(); override;
      procedure Terminated(); virtual; abstract;

      property SharedMemoryName: String read SharedMemoryName_;
  end;

implementation

uses SharedMemoryName_TLB;

constructor TSharedMemoryPoint.Create(IsServer: Boolean);
const
  PointRoles: array[Boolean] of String = ('client', 'server');
var
  UniqueName: IUniqueName;
  IdStr: String;
begin
  inherited Create();
  try
    UniqueName := CoUniqueName.Create();
    SharedMemoryName_ := UniqueName.GetSharedMemoryName();
  except
    raise EGetSharedMemoryName.Create('');
  end;
  IdStr := Format('%s.%s', [SharedMemoryName_, PointRoles[IsServer]]);
  if GlobalFindAtom(PChar(IdStr)) = 0 then
    Id := GlobalAddAtom(PChar(IdStr))
  else
    raise EExistSharedMemoryPoint.Create('');
  CreateOrOpenResource(IsServer);
end;

destructor TSharedMemoryPoint.Destroy();
begin
  if Assigned(pView) then
    UnMapViewOfFile(pView);
  if hMapping <> 0 then
    CloseHandle(hMapping);
  GlobalDeleteAtom(Id);
  inherited Destroy();
end;

procedure TSharedMemoryPoint.CreateOrOpenResource(IsServer: Boolean);
begin
  if IsServer then
  begin
    hMapping := CreateFileMapping(INVALID_HANDLE_VALUE, NIL, PAGE_READWRITE, 0,
                                  POINT_DATA_SIZE, PChar(SharedMemoryName_));
    if hMapping = 0 then
      raise ECreateSharedMemoryMapped.Create(SysErrorMessage(GetLastError()));
    pView := MapViewOfFile(hMapping, FILE_MAP_READ, 0, 0, 0);
    if not Assigned(pView) then
      raise ECreateSharedMemoryMapped.Create(SysErrorMessage(GetLastError()));
  end else
  begin
    hMapping := OpenFileMapping(FILE_MAP_WRITE, False,
                                PChar(SharedMemoryName_));
    if hMapping = 0 then
      raise EOpenSharedMemoryMapped.Create(SysErrorMessage(GetLastError()));
    pView := MapViewOfFile(hMapping, FILE_MAP_WRITE, 0, 0, 0);
    if not Assigned(pView) then
      raise EOpenSharedMemoryMapped.Create(SysErrorMessage(GetLastError()));
  end;
end;

end.
