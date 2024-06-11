object FPrincipal: TFPrincipal
  Left = 402
  Top = 147
  Width = 488
  Height = 317
  Caption = 'FPrincipal'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 13
    Top = 250
    Width = 35
    Height = 13
    Caption = 'TOKEN'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 341
    Top = 250
    Width = 63
    Height = 13
    Caption = 'EXPIRA EM:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblTokenExpira: TLabel
    Left = 412
    Top = 250
    Width = 35
    Height = 13
    Caption = 'TOKEN'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnGerarToken: TButton
    Left = 8
    Top = 2
    Width = 148
    Height = 25
    Caption = 'Gerar Token'
    TabOrder = 0
    OnClick = btnGerarTokenClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 28
    Width = 461
    Height = 209
    TabOrder = 1
  end
  object editToken: TEdit
    Left = 61
    Top = 246
    Width = 257
    Height = 21
    TabOrder = 2
  end
end
