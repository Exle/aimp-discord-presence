object frmRemoteAccessDemo: TfrmRemoteAccessDemo
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Remote Access Demo'
  ClientHeight = 194
  ClientWidth = 497
  Color = clBtnFace
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnPrev: TButton
    Left = 72
    Top = 159
    Width = 65
    Height = 26
    Caption = '<< Prev'
    TabOrder = 0
    OnClick = btnPrevClick
  end
  object btnNext: TButton
    Left = 356
    Top = 159
    Width = 65
    Height = 25
    Caption = 'Next >>'
    TabOrder = 1
    OnClick = btnNextClick
  end
  object btnPlay: TButton
    Left = 143
    Top = 159
    Width = 65
    Height = 26
    Caption = 'Play'
    TabOrder = 2
    OnClick = btnPlayClick
  end
  object btnPause: TButton
    Left = 214
    Top = 159
    Width = 65
    Height = 25
    Caption = 'Pause'
    TabOrder = 3
    OnClick = btnPauseClick
  end
  object btnStop: TButton
    Left = 285
    Top = 159
    Width = 65
    Height = 25
    Caption = 'Stop'
    TabOrder = 4
    OnClick = btnStopClick
  end
  object pnlInfo: TPanel
    Left = 8
    Top = 8
    Width = 481
    Height = 113
    BevelOuter = bvLowered
    BorderWidth = 4
    Color = clBlack
    ParentBackground = False
    TabOrder = 5
    object imAlbumArt: TImage
      Left = 5
      Top = 5
      Width = 103
      Height = 103
      Align = alLeft
      Center = True
      Proportional = True
      Stretch = True
    end
    object lbTitle: TLabel
      Left = 114
      Top = 5
      Width = 359
      Height = 13
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbDetails: TLabel
      Left = 114
      Top = 24
      Width = 359
      Height = 84
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object lbPlayerState: TLabel
      Left = 376
      Top = 94
      Width = 97
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object tbSeekBar: TTrackBar
    Left = 8
    Top = 123
    Width = 481
    Height = 30
    TabOrder = 6
    ThumbLength = 25
    TickMarks = tmBoth
    TickStyle = tsNone
    OnChange = tbSeekBarChange
  end
  object tmUpdate: TTimer
    OnTimer = tmUpdateTimer
    Left = 456
    Top = 13
  end
end