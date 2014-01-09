program Client;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {ClientForm},
  uClient in 'uClient.pas',
  uSharedMemoryPoint in '..\common\uSharedMemoryPoint.pas',
  SharedMemoryName_TLB in '..\com\SharedMemoryName_TLB.pas',
  uCommon in '..\common\uCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
