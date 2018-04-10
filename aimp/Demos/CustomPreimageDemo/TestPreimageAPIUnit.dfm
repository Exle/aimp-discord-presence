object frmTestPreimage: TfrmTestPreimage
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  BorderWidth = 6
  Caption = 'frmTestPreimage'
  ClientHeight = 345
  ClientWidth = 579
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 573
    Height = 283
    Align = alClient
    Caption = 'Loaded Playlists'
    Padding.Left = 3
    Padding.Right = 3
    Padding.Bottom = 3
    TabOrder = 0
    object lbPlaylists: TListBox
      AlignWithMargins = True
      Left = 8
      Top = 18
      Width = 557
      Height = 208
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbPlaylistsClick
    end
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 8
      Top = 232
      Width = 557
      Height = 43
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lbPreimageInfo: TLabel
        Left = 0
        Top = 0
        Width = 72
        Height = 13
        Align = alTop
        Caption = 'lbPreimageInfo'
      end
      object btnReload: TButton
        Left = 0
        Top = 19
        Width = 75
        Height = 25
        Caption = 'Reload'
        TabOrder = 0
        OnClick = btnReloadClick
      end
      object btnRelease: TButton
        Left = 81
        Top = 19
        Width = 75
        Height = 25
        Caption = 'Release'
        TabOrder = 1
        OnClick = btnReleaseClick
      end
      object btnSetCustom: TButton
        Left = 162
        Top = 19
        Width = 75
        Height = 25
        Caption = 'Set Custom'
        TabOrder = 2
        OnClick = btnSetCustomClick
      end
      object btnTestIO: TButton
        Left = 243
        Top = 19
        Width = 75
        Height = 25
        Caption = 'Test IO'
        TabOrder = 3
        OnClick = btnTestIOClick
      end
    end
  end
  object GroupBox2: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 292
    Width = 573
    Height = 50
    Align = alBottom
    Caption = 'Custom Preimage Factory'
    TabOrder = 1
    object btnDataChanged: TButton
      Left = 8
      Top = 16
      Width = 105
      Height = 25
      Caption = 'Reload Data'
      TabOrder = 0
      OnClick = btnDataChangedClick
    end
  end
end
