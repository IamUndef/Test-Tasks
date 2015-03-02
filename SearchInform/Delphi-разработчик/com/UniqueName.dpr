program UniqueName;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {UniqueNameForm},
  SharedMemoryName_TLB in 'SharedMemoryName_TLB.pas',
  uUniqueName in 'uUniqueName.pas' {UniqueName: CoClass};

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TUniqueNameForm, UniqueNameForm);
  Application.Run;
end.
