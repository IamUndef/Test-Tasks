unit uMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, IBDatabase, IBExtract;

type
  TMainForm = class(TForm)
    ibDatabase: TIBDatabase;
    ibTransaction: TIBTransaction;
    ibExtract: TIBExtract;
    gbSettings: TGroupBox;
    gbConnection: TGroupBox;
    bConnect: TButton;
    lServer: TLabel;
    editServer: TEdit;
    lDB: TLabel;
    editDB: TEdit;
    lUserName: TLabel;
    editUserName: TEdit;
    lPassword: TLabel;
    editPassword: TEdit;
    editObjectName: TEdit;
    lObjectName: TLabel;
    chkbAllDatabase: TCheckBox;
    bFind: TButton;
    gbOutput: TGroupBox;
    mOutput: TMemo;
    procedure bConnectClick(Sender: TObject);
    procedure bFindClick(Sender: TObject);
    procedure chkbAllDatabaseClick(Sender: TObject);
  private
    { Private declarations }
    LastObjectName : String;
    procedure GetDDLForObject( const ObjectName : String );
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.bConnectClick(Sender: TObject);
const
  UserNameDB : String = 'user_name=';
  PasswordDB : String = 'password=';
begin
  ibDatabase.Connected := false;
  if ( Trim( editServer.Text ) <> '' ) then
    ibDatabase.DatabaseName := Trim( editServer.Text ) + ':' + Trim( editDB.Text )
  else
    ibDatabase.DatabaseName := Trim( editDB.Text );
  ibDatabase.Params.Add( UserNameDB + Trim( editUserName.Text ) );
  ibDatabase.Params.Add( PasswordDB + Trim( editPassword.Text ) );
  try
    ibDatabase.Connected := true;
    LastObjectName := '';
    mOutput.Lines.Text := '';
    bFind.Enabled := ibDatabase.Connected;
    MessageDlg( 'Подключено!', mtInformation, [mbOk], 0 );
  except
    on E : Exception do
      MessageDlg( Format(
        'Не удалось подключиться к базе данных!%s"%s"',
        [sLineBreak, E.Message] ), mtError, [mbOk], 0 );
  end;
end;

procedure TMainForm.bFindClick(Sender: TObject);
begin
  if ( not chkbAllDatabase.Checked and
      ( Trim( editObjectName.Text ) = '' ) ) then
    MessageDlg( 'Не введено имя объекта!', mtError, [mbOk], 0 )
  else
  if ( ( mOutput.Lines.Text <> '' ) and
      ( ( chkbAllDatabase.Checked and ( LastObjectName = '' ) ) or
        ( LastObjectName = Trim( editObjectName.Text ) ) ) ) then
    MessageDlg( 'Объект уже получен!', mtInformation, [mbOk], 0 )
  else
  begin
    LastObjectName := Trim( editObjectName.Text );
    GetDDLForObject( LastObjectName );
  end;
end;

procedure TMainForm.chkbAllDatabaseClick(Sender: TObject);
begin
  if ( chkbAllDatabase.Checked ) then
    editObjectName.Text := '';
  editObjectName.Enabled := not chkbAllDatabase.Checked;
end;

procedure TMainForm.GetDDLForObject( const ObjectName : String );
var
  ObjectType : TExtractObjectTypes;
begin
  mOutput.Clear();
  if ( ObjectName = '' ) then
  begin
    ibExtract.Items.Clear();
    ibExtract.ExtractObject( eoDatabase, '', [] );
    mOutput.Lines.Add( ibExtract.Items.Text );
  end else
    for ObjectType := Low(TExtractObjectTypes) to High(TExtractObjectTypes) do
      if not ( ObjectType in [eoDatabase, eoRole, eoData] ) then
      begin
        ibExtract.Items.Clear();
        ibExtract.ExtractObject( ObjectType, ObjectName, [] );
        if ( Trim( ibExtract.Items.Text ) <> '' ) then
          mOutput.Lines.Add( ibExtract.Items.Text );
      end;
end;

end.
