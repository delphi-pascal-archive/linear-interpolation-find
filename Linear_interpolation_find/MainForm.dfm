object Form1: TForm1
  Left = 227
  Top = 133
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Linear interpolation find'
  ClientHeight = 560
  ClientWidth = 605
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object Button1: TButton
    Left = 437
    Top = 272
    Width = 157
    Height = 27
    Action = actGeneration
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 10
    Top = 10
    Width = 288
    Height = 254
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 306
    Top = 10
    Width = 288
    Height = 254
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Button2: TButton
    Left = 306
    Top = 272
    Width = 123
    Height = 27
    Action = actFind
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 10
    Top = 272
    Width = 288
    Height = 24
    TabOrder = 4
  end
  object Memo3: TMemo
    Left = 10
    Top = 307
    Width = 584
    Height = 240
    Lines.Strings = (
      'Search History')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 16
    Top = 16
    object actGeneration: TAction
      Caption = 'Randomize and sort'
      OnExecute = actGenerationExecute
    end
    object actFind: TAction
      Caption = 'Find'
      OnExecute = actFindExecute
    end
  end
end
