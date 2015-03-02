object ClientForm: TClientForm
  Left = 0
  Top = 0
  ActiveControl = btnClose
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Shared Memory - '#1050#1083#1080#1077#1085#1090
  ClientHeight = 271
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object labelUniqueName: TLabel
    Left = 5
    Top = 8
    Width = 132
    Height = 13
    Caption = #1059#1085#1080#1082#1072#1083#1100#1085#1086#1077' '#1080#1084#1103' '#1086#1073#1098#1077#1082#1090#1072':'
  end
  object editUniqueName: TEdit
    Left = 5
    Top = 29
    Width = 265
    Height = 21
    Align = alCustom
    ReadOnly = True
    TabOrder = 0
  end
  object gbClient: TGroupBox
    Left = 0
    Top = 56
    Width = 274
    Height = 215
    Align = alBottom
    Caption = #1050#1083#1080#1077#1085#1090
    TabOrder = 1
    object labelFileName: TLabel
      Left = 5
      Top = 16
      Width = 30
      Height = 13
      Caption = #1060#1072#1081#1083':'
    end
    object editFileName: TEdit
      Left = 5
      Top = 36
      Width = 265
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object btnFileName: TButton
      Left = 240
      Top = 60
      Width = 30
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = btnFileNameClick
    end
    object pbProgress: TProgressBar
      Left = 5
      Top = 88
      Width = 265
      Height = 21
      TabOrder = 2
    end
    object btnSend: TButton
      Left = 46
      Top = 187
      Width = 75
      Height = 25
      Caption = #1055#1077#1088#1077#1076#1072#1090#1100
      TabOrder = 4
      OnClick = btnSendClick
    end
    object btnClose: TButton
      Left = 147
      Top = 187
      Width = 75
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 5
      OnClick = btnCloseClick
    end
    object mLog: TMemo
      Left = 5
      Top = 115
      Width = 265
      Height = 66
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 3
    end
  end
  object dlgFileName: TOpenDialog
    Filter = 'All Files (*.*)|*.*'
    Left = 240
    Top = 8
  end
end
