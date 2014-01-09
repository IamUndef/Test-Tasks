program Server;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {ServerForm},
  uServer in 'uServer.pas',
  uSharedMemoryPoint in '..\common\uSharedMemoryPoint.pas',
  SharedMemoryName_TLB in '..\com\SharedMemoryName_TLB.pas',
  uCommon in '..\common\uCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
