object frmOptionFrameDemo: TfrmOptionFrameDemo
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 410
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 31
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 8
    Width = 177
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 1
    OnClick = CheckBox1Click
  end
end
