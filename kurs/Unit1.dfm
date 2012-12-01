object Form1: TForm1
  Left = 467
  Top = 9
  Width = 600
  Height = 600
  Caption = 'SysDyf'
  Color = clActiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 544
    Align = alClient
    TabOrder = 1
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 582
      Height = 112
      Align = alTop
      TabOrder = 0
      Visible = False
    end
    object Memo2: TMemo
      Left = 1
      Top = 335
      Width = 582
      Height = 96
      Align = alBottom
      TabOrder = 1
      Visible = False
    end
    object Memo3: TMemo
      Left = 1
      Top = 113
      Width = 582
      Height = 222
      Align = alClient
      TabOrder = 2
      Visible = False
    end
    object Memo4: TMemo
      Left = 1
      Top = 431
      Width = 582
      Height = 112
      Align = alBottom
      TabOrder = 3
      Visible = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 544
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object SynEdit1: TSynEdit
      Left = 1
      Top = 1
      Width = 582
      Height = 402
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Lucida Console'
      Font.Style = []
      TabOrder = 0
      Gutter.AutoSize = True
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.ShowLineNumbers = True
      OnChange = SynEdit1Change
    end
    object SynEdit2: TSynEdit
      Left = 1
      Top = 427
      Width = 582
      Height = 116
      Align = alBottom
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Lucida Console'
      Font.Style = []
      TabOrder = 1
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      ScrollBars = ssNone
    end
    object Panel2: TPanel
      Left = 1
      Top = 403
      Width = 582
      Height = 24
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHotLight
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object MainMenu1: TMainMenu
    Left = 12
    Top = 264
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'New'
        OnClick = Open1Click
      end
      object Open2: TMenuItem
        Caption = 'Open'
        OnClick = Open2Click
      end
      object Save1: TMenuItem
        Caption = 'Save as'
        OnClick = Save1Click
      end
      object Save2: TMenuItem
        Caption = 'Save'
        Enabled = False
        ShortCut = 32851
        OnClick = Save2Click
      end
    end
    object r1: TMenuItem
      Caption = 'Run'
      object Run1: TMenuItem
        Caption = 'Run'
        ShortCut = 120
        OnClick = Run1Click
      end
      object Vievgraph1: TMenuItem
        Caption = 'View graph'
        ShortCut = 116
        OnClick = Vievgraph1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = #1090#1077#1082#1089#1090#1086#1074#1099#1081'(*.txt)|*.txt;'
    Left = 28
    Top = 312
  end
  object SaveDialog1: TSaveDialog
    Filter = #1090#1077#1082#1089#1090#1086#1074#1099#1081'(*.txt)|*.txt'
    Left = 12
    Top = 344
  end
end
