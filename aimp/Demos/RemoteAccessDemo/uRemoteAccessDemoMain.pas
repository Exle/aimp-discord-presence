unit uRemoteAccessDemoMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  apiRemote;

const
  sCaption = 'Remote Access Demo';
  sCaptionWithVersion = 'Remote Access Demo - AIMP v%s Build %d is running';

type

  { TfrmRemoteAccessDemo }

  TfrmRemoteAccessDemo = class(TForm)
    btnNext: TButton;
    btnPause: TButton;
    btnPlay: TButton;
    btnPrev: TButton;
    btnStop: TButton;
    imAlbumArt: TImage;
    lbDetails: TLabel;
    lbTitle: TLabel;
    pnlInfo: TPanel;
    tbSeekBar: TTrackBar;
    tmUpdate: TTimer;
    lbPlayerState: TLabel;

    procedure btnNextClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmUpdateTimer(Sender: TObject);
    procedure tbSeekBarChange(Sender: TObject);
  private
    FAIMPRemoteHandle: HWND;
    FChangeLockCount: Integer;

    procedure SetAIMPRemoteHandle(const Value: HWND);
  protected
    procedure WMAIMPNotify(var Message: TMessage); message WM_AIMP_NOTIFY;
    procedure WMCopyData(var Message: TWMCopyData); message WM_COPYDATA;
  public
    procedure AIMPExecuteCommand(ACommand: Integer);
    function AIMPGetPropertyValue(APropertyID: Integer): Integer;
    function AIMPSetPropertyValue(APropertyID, AValue: Integer): Boolean;
    procedure UpdatePlayerState;
    procedure UpdateTrackInfo;
    procedure UpdateTrackPositionInfo;
    procedure UpdateVersionInfo;
    //
    property AIMPRemoteHandle: HWND read FAIMPRemoteHandle write SetAIMPRemoteHandle;
  end;

var
  frmRemoteAccessDemo: TfrmRemoteAccessDemo;

implementation

uses
  // Built-in in D2010 or newer
  // For old Delphi versions you can download it from: http://pngdelphi.sourceforge.net/
  PngImage;

{$R *.dfm}

{ TfrmRemoteAccessDemo }

function TfrmRemoteAccessDemo.AIMPGetPropertyValue(APropertyID: Integer): Integer;
begin
  if AIMPRemoteHandle <> 0 then
    Result := SendMessage(AIMPRemoteHandle, WM_AIMP_PROPERTY, APropertyID or AIMP_RA_PROPVALUE_GET, 0)
  else
    Result := 0;
end;

function TfrmRemoteAccessDemo.AIMPSetPropertyValue(APropertyID, AValue: Integer): Boolean;
begin
  if AIMPRemoteHandle <> 0 then
    Result := SendMessage(AIMPRemoteHandle, WM_AIMP_PROPERTY, APropertyID or AIMP_RA_PROPVALUE_SET, AValue) <> 0
  else
    Result := False
end;

procedure TfrmRemoteAccessDemo.AIMPExecuteCommand(ACommand: Integer);
begin
  if AIMPRemoteHandle <> 0 then
    SendMessage(AIMPRemoteHandle, WM_AIMP_COMMAND, ACommand, 0);
end;

procedure TfrmRemoteAccessDemo.SetAIMPRemoteHandle(const Value: HWND);
begin
  if FAIMPRemoteHandle <> Value then
  begin
    if FAIMPRemoteHandle <> 0 then
    begin
      // Unregister notification listener from old window
      SendMessage(FAIMPRemoteHandle, WM_AIMP_COMMAND, AIMP_RA_CMD_UNREGISTER_NOTIFY, Handle);
      FAIMPRemoteHandle := 0;
    end;
    if Value <> 0then
    begin
      FAIMPRemoteHandle := Value;
      // Register notification listener to new window
      SendMessage(FAIMPRemoteHandle, WM_AIMP_COMMAND, AIMP_RA_CMD_REGISTER_NOTIFY, Handle);
    end;
    UpdatePlayerState;
    UpdateTrackInfo;
    UpdateTrackPositionInfo;
    UpdateVersionInfo;
  end;
end;

procedure TfrmRemoteAccessDemo.FormDestroy(Sender: TObject);
begin
  AIMPRemoteHandle := 0; // unregister
end;

procedure TfrmRemoteAccessDemo.UpdatePlayerState;
begin
  case AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_STATE) of
    0: lbPlayerState.Caption := 'Stopped';
    1: lbPlayerState.Caption := 'Paused';
    2: lbPlayerState.Caption := '';
  end;
end;

procedure TfrmRemoteAccessDemo.UpdateTrackInfo;

  function ExtractString(var B: PByte; ALength: Integer): WideString;
  begin
    SetString(Result, PWideChar(B), ALength);
    Inc(B, SizeOf(WideChar) * ALength);
  end;

var
  AAlbum: WideString;
  AArtist: WideString;
  ABuffer: PByte;
  ADate: WideString;
  AFile: THandle;
  AFileName: WideString;
  AGenre: WideString;
  AInfo: PAIMPRemoteFileInfo;
  ATitle: WideString;
begin
  lbTitle.Caption := '';
  lbDetails.Caption := '';

  // Load info about playable file from shared memory-mapped file
  AFile := OpenFileMapping(FILE_MAP_READ, True, AIMPRemoteAccessClass);
  try
    AInfo := MapViewOfFile(AFile, FILE_MAP_READ, 0, 0, AIMPRemoteAccessMapFileSize);
    if AInfo <> nil then
    try
      if AInfo <> nil then
      begin
        ABuffer := Pointer(NativeUInt(AInfo) + SizeOf(TAIMPRemoteFileInfo));

        // Extract data from the buffer
        AAlbum := ExtractString(ABuffer, AInfo^.AlbumLength);
        AArtist := ExtractString(ABuffer, AInfo^.ArtistLength);
        ADate := ExtractString(ABuffer, AInfo^.DateLength);
        AFileName := ExtractString(ABuffer, AInfo^.FileNameLength);
        AGenre := ExtractString(ABuffer, AInfo^.GenreLength);
        ATitle := ExtractString(ABuffer, AInfo^.TitleLength);

        // Show the information
        lbTitle.Caption := ATitle;
        lbDetails.Caption := AAlbum + #13#10 + AArtist + #13#10 + ADate + #13#10 + AGenre + #13#10 +
          Format('%d Hz, %d kbps, %d chans', [AInfo^.SampleRate, AInfo^.BitRate, AInfo^.Channels]) + #13#10 +
          Format('%d seconds, %d bytes', [AInfo^.Duration div 1000, AInfo^.FileSize]);
      end;
    finally
      UnmapViewOfFile(AInfo);
    end;
  finally
    CloseHandle(AFile);
  end;

  // Send request for AlbumArt image, answer will be send in WM_COPYDATA
  if SendMessage(AIMPRemoteHandle, WM_AIMP_COMMAND, AIMP_RA_CMD_GET_ALBUMART, Handle) = 0 then
    imAlbumArt.Picture.Graphic := nil;
end;

procedure TfrmRemoteAccessDemo.UpdateTrackPositionInfo;
begin
  Inc(FChangeLockCount);
  try
    tbSeekBar.Max := AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_DURATION) div 1000;
    tbSeekBar.Position := AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_POSITION) div 1000;
  finally
    Dec(FChangeLockCount);
  end;
end;

procedure TfrmRemoteAccessDemo.UpdateVersionInfo;
var
  AVersion: Cardinal;
begin
  AVersion := AIMPGetPropertyValue(AIMP_RA_PROPERTY_VERSION);
  if AVersion <> 0 then
    Caption := Format(sCaptionWithVersion, [FormatFloat('0.00', HiWord(AVersion) / 100), LoWord(AVersion)])
  else
    Caption := sCaption;
end;

procedure TfrmRemoteAccessDemo.WMAIMPNotify(var Message: TMessage);
begin
  case Message.WParam of
    AIMP_RA_NOTIFY_TRACK_INFO:
      UpdateTrackInfo;
    AIMP_RA_NOTIFY_PROPERTY:
      case Message.LParam of
        AIMP_RA_PROPERTY_PLAYER_STATE:
          UpdatePlayerState;
        AIMP_RA_PROPERTY_PLAYER_POSITION, AIMP_RA_PROPERTY_PLAYER_DURATION:
          UpdateTrackPositionInfo;
      end;
  end;
end;

procedure TfrmRemoteAccessDemo.WMCopyData(var Message: TWMCopyData);
var
  AImage: TPngImage;
  AStream: TMemoryStream;
begin
  if Message.CopyDataStruct^.dwData = WM_AIMP_COPYDATA_ALBUMART_ID then
  begin
    AStream := TMemoryStream.Create;
    try
      AStream.WriteBuffer(Message.CopyDataStruct^.lpData^, Message.CopyDataStruct^.cbData);
      AStream.Position := 0;

      AImage := TPngImage.Create;
      try
        AImage.LoadFromStream(AStream);
        imAlbumArt.Picture.Graphic := AImage;
      except
        imAlbumArt.Picture.Graphic := nil;
        AImage.Free;
      end;
    finally
      AStream.Free;
    end;
  end;
end;

procedure TfrmRemoteAccessDemo.tbSeekBarChange(Sender: TObject);
begin
  if FChangeLockCount = 0 then
    AIMPSetPropertyValue(AIMP_RA_PROPERTY_PLAYER_POSITION, tbSeekBar.Position * 1000);
end;

procedure TfrmRemoteAccessDemo.tmUpdateTimer(Sender: TObject);
begin
  // Update AIMP Handle
  AIMPRemoteHandle := FindWindow(AIMPRemoteAccessClass, AIMPRemoteAccessClass);
end;

procedure TfrmRemoteAccessDemo.btnNextClick(Sender: TObject);
begin
  AIMPExecuteCommand(AIMP_RA_CMD_NEXT);
end;

procedure TfrmRemoteAccessDemo.btnPauseClick(Sender: TObject);
begin
  AIMPExecuteCommand(AIMP_RA_CMD_PAUSE);
end;

procedure TfrmRemoteAccessDemo.btnPlayClick(Sender: TObject);
begin
  AIMPExecuteCommand(AIMP_RA_CMD_PLAY);
end;

procedure TfrmRemoteAccessDemo.btnPrevClick(Sender: TObject);
begin
  AIMPExecuteCommand(AIMP_RA_CMD_PREV);
end;

procedure TfrmRemoteAccessDemo.btnStopClick(Sender: TObject);
begin
  AIMPExecuteCommand(AIMP_RA_CMD_STOP);
end;

end.
