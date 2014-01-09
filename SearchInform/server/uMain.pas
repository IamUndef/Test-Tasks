unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, uServer, Vcl.ComCtrls;

type
  TServerForm = class(TForm)
    labelUniqueName: TLabel;
    editUniqueName: TEdit;
    gbServer: TGroupBox;
    labelDirName: TLabel;
    editDirName: TEdit;
    pbProgress: TProgressBar;
    mLog: TMemo;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    Server: TSharedMemoryServer;

    procedure ServerCallback(const Msg: String; Percents: Integer;
        IsError: Boolean);
  public
    { Public declarations }
    destructor Destroy(); override;
  end;

var
  ServerForm: TServerForm;

implementation

{$R *.dfm}

uses System.UITypes;

destructor TServerForm.Destroy();
begin
  if Assigned(Server) then
    FreeAndNil(Server);
  inherited Destroy();
end;

procedure TServerForm.FormCreate(Sender: TObject);
begin
  try
    Server := TSharedMemoryServer.Create(ServerCallback);
    editUniqueName.Text := Server.SharedMemoryName;
    editDirName.Text := Server.DirName;
  except
    on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOk], 0);
      Application.Terminate()
    end;
  end;
end;

procedure TServerForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Server.Terminated();
end;

procedure TServerForm.btnCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TServerForm.ServerCallback(const Msg: String; Percents: Integer;
    IsError: Boolean);
begin
  if IsError then
  begin
    MessageDlg(Format('Приложение будет завершено,' +
                      ' так как произошла критическая ошибка: "%s"',
                      [Msg]), mtError, [mbOk], 0);
    Close();
  end else
  begin
    pbProgress.Position := Percents;
    if Msg <> '' then
      mLog.Lines.Add(Msg);
  end;
  Application.ProcessMessages();
end;

end.
