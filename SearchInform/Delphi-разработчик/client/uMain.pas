unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, uClient;

type
  TClientForm = class(TForm)
    labelUniqueName: TLabel;
    editUniqueName: TEdit;
    gbClient: TGroupBox;
    labelFileName: TLabel;
    editFileName: TEdit;
    btnFileName: TButton;
    pbProgress: TProgressBar;
    mLog: TMemo;
    btnSend: TButton;
    btnClose: TButton;
    dlgFileName: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFileNameClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    Client: TSharedMemoryClient;

    procedure ClientCallback(const Msg: String; Percents: Integer;
        IsError: Boolean);
  public
    { Public declarations }
    destructor Destroy(); override;
  end;

var
  ClientForm: TClientForm;

implementation

{$R *.dfm}

uses System.UITypes;

destructor TClientForm.Destroy();
begin
  if Assigned(Client) then
    FreeAndNil(Client);
  inherited Destroy();
end;

procedure TClientForm.FormCreate(Sender: TObject);
begin
  try
    Client := TSharedMemoryClient.Create();
    editUniqueName.Text := Client.SharedMemoryName;
    editFileName.Text := Client.FileName;
  except
    on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOk], 0);
      Application.Terminate()
    end;
  end;
end;

procedure TClientForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Client.Terminated();
end;

procedure TClientForm.btnFileNameClick(Sender: TObject);
begin
  if dlgFileName.Execute() then
    editFileName.Text := dlgFileName.FileName;
end;

procedure TClientForm.btnSendClick(Sender: TObject);
begin
  btnFileName.Enabled := False;
  btnSend.Enabled := False;
  try
    try
      Client.Send(editFileName.Text, ClientCallback);
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbOk], 0);
    end;
  finally
    btnFileName.Enabled := True;
    btnSend.Enabled := True;
  end;
end;

procedure TClientForm.btnCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TClientForm.ClientCallback(const Msg: String; Percents: Integer;
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
