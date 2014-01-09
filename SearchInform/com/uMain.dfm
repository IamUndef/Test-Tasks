object UniqueNameForm: TUniqueNameForm
  Left = 0
  Top = 0
  ActiveControl = btnClose
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'COM-'#1089#1077#1088#1074#1077#1088
  ClientHeight = 98
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
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
  object btnClose: TButton
    Left = 100
    Top = 65
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
    OnClick = btnCloseClick
  end
end
