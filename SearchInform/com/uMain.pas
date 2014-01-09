unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, SharedMemoryName_TLB;

type
  TUniqueNameForm = class(TForm)
    labelUniqueName: TLabel;
    editUniqueName: TEdit;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UniqueNameForm: TUniqueNameForm;

implementation

{$R *.dfm}

uses System.UITypes;

procedure TUniqueNameForm.FormCreate(Sender: TObject);
var
  UniqueName: IUniqueName;
begin
  try
    UniqueName := CoUniqueName.Create();
    editUniqueName.Text := UniqueName.GetSharedMemoryName();
  except
    on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOk], 0);
      Application.Terminate();
    end;
  end;
end;

procedure TUniqueNameForm.btnCloseClick(Sender: TObject);
begin
  Close();
end;

end.
