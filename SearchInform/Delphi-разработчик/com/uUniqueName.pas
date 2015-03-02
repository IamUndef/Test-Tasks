unit uUniqueName;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, StdVcl, SharedMemoryName_TLB;

type
  ISelfComObject = interface(IUnknown)
    ['{9BB340CD-9D47-414E-980B-53532641B299}']
    function GetSelf(): TComObject;
  end;

  TUniqueName = class(TTypedComObject, IUniqueName, ISelfComObject)
  private
    Name: String;
  protected
    function GetSelf(): TComObject;
    function GetSharedMemoryName(): WideString; safecall;
  public
    procedure Initialize(); override;
  end;

  TSingletonFactory = class(TTypedComObjectFactory)
  private
    class var Singleton: ISelfComObject;
  public
    function CreateComObject(const Controller: IUnknown): TComObject; override;
  end;

implementation

uses ComServ, SysUtils;

procedure TUniqueName.Initialize();
var
  GUID: TGUID;
begin
  CreateGUID(GUID);
  Name := GUIDToString(GUID);
end;

function TUniqueName.GetSelf(): TComObject;
begin
  Result := Self;
end;

function TUniqueName.GetSharedMemoryName(): WideString;
begin
  Result := Name;
end;

function
    TSingletonFactory.CreateComObject(const Controller: IUnknown): TComObject;
begin
  if Singleton = NIL then
    Singleton := inherited CreateComObject(Controller) as ISelfComObject;
  Result := Singleton.GetSelf();
end;

initialization
  ComServer.UIInteractive := False;
  TSingletonFactory.Create(ComServer, TUniqueName, Class_UniqueName,
    ciMultiInstance, tmApartment);
end.
