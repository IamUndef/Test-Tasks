object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'GetDDLForObject'
  ClientHeight = 400
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object gbOutput: TGroupBox
    Left = 185
    Top = 0
    Width = 415
    Height = 400
    Align = alClient
    Caption = #1042#1099#1074#1086#1076
    TabOrder = 1
    object mOutput: TMemo
      Left = 2
      Top = 15
      Width = 411
      Height = 383
      Align = alClient
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object gbSettings: TGroupBox
    Left = 0
    Top = 0
    Width = 185
    Height = 400
    Align = alLeft
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
    TabOrder = 0
    object lObjectName: TLabel
      Left = 10
      Top = 277
      Width = 69
      Height = 13
      Caption = #1048#1084#1103' '#1086#1073#1098#1077#1082#1090#1072':'
    end
    object gbConnection: TGroupBox
      Left = 2
      Top = 22
      Width = 181
      Height = 220
      Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077
      TabOrder = 0
      object lServer: TLabel
        Left = 8
        Top = 20
        Width = 41
        Height = 13
        Caption = #1057#1077#1088#1074#1077#1088':'
      end
      object lDB: TLabel
        Left = 8
        Top = 60
        Width = 69
        Height = 13
        Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093':'
      end
      object lUserName: TLabel
        Left = 8
        Top = 105
        Width = 97
        Height = 13
        Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
      end
      object lPassword: TLabel
        Left = 8
        Top = 145
        Width = 41
        Height = 13
        Caption = #1055#1072#1088#1086#1083#1100':'
      end
      object bConnect: TButton
        Left = 38
        Top = 187
        Width = 105
        Height = 25
        Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103
        TabOrder = 4
        OnClick = bConnectClick
      end
      object editServer: TEdit
        Left = 8
        Top = 36
        Width = 163
        Height = 21
        TabOrder = 0
      end
      object editDB: TEdit
        Left = 8
        Top = 76
        Width = 163
        Height = 21
        TabOrder = 1
      end
      object editUserName: TEdit
        Left = 8
        Top = 121
        Width = 163
        Height = 21
        TabOrder = 2
      end
      object editPassword: TEdit
        Left = 8
        Top = 160
        Width = 163
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
      end
    end
    object editObjectName: TEdit
      Left = 10
      Top = 292
      Width = 163
      Height = 21
      TabOrder = 1
    end
    object chkbAllDatabase: TCheckBox
      Left = 10
      Top = 319
      Width = 163
      Height = 17
      Caption = #1044#1083#1103' '#1074#1089#1077#1081' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
      TabOrder = 2
      OnClick = chkbAllDatabaseClick
    end
    object bFind: TButton
      Left = 55
      Top = 352
      Width = 75
      Height = 25
      Caption = #1055#1086#1083#1091#1095#1080#1090#1100
      Enabled = False
      TabOrder = 3
      OnClick = bFindClick
    end
  end
  object ibExtract: TIBExtract
    Database = ibDatabase
    Transaction = ibTransaction
    Left = 456
    Top = 56
  end
  object ibDatabase: TIBDatabase
    LoginPrompt = False
    DefaultTransaction = ibTransaction
    Left = 456
    Top = 24
  end
  object ibTransaction: TIBTransaction
    Left = 488
    Top = 24
  end
end
