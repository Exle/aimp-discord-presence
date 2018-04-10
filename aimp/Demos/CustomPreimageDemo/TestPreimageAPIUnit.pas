unit TestPreimageAPIUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  // API
  AIMPCustomPlugin, apiCore, apiWrappers, apiPlugin, apiPlaylists, apiObjects, apiMusicLibrary, apiThreading,
  // VCL
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmTestPreimage = class;
  TTestPreimage = class;

  { TTestPreimageAPIPlugin }

  TTestPreimageAPIPlugin = class(TAIMPCustomPlugin)
  strict private
    FForm: TfrmTestPreimage;
  protected
    function InfoGet(Index: Integer): PWideChar; override; stdcall;
    function InfoGetCategories: Cardinal; override; stdcall;
    function Initialize(Core: IAIMPCore): HRESULT; override; stdcall;
    procedure Finalize; override; stdcall;
  end;

  { ITestPreimageFactory }

  ITestPreimageFactory = interface
  ['{5FF0D01D-A956-47AE-80DA-76E10DDEA1C1}']
    procedure DataChanged;
  end;

  { TTestPreimageFactory }

  TTestPreimageFactory = class(TInterfacedObject,
    ITestPreimageFactory,
    IAIMPExtensionPlaylistPreimageFactory)
  protected
    FPreimages: TList<TTestPreimage>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure DataChanged;

    // IAIMPExtensionPlaylistPreimageFactory
    function CreatePreimage(out Intf: IAIMPPlaylistPreimage): HRESULT; stdcall;
    function GetID(out ID: IAIMPString): HRESULT; stdcall;
    function GetName(out Name: IAIMPString): HRESULT; stdcall;
	function GetFlags: DWORD; stdcall;
  end;

  { TTestPreimage }

  TTestPreimage = class(TAIMPPropertyList,
    IAIMPPlaylistPreimageDataProvider,
    IAIMPPlaylistPreimage)
  strict private
    FFactory: TTestPreimageFactory;
    FManager: IAIMPPlaylistPreimageListener;
  protected
    procedure DoGetValueAsInt32(PropertyID: Integer; out Value: Integer; var Result: HRESULT); override;
    function DoGetValueAsObject(PropertyID: Integer): IInterface; override;
  public
    constructor Create(AFactory: TTestPreimageFactory); virtual;
    destructor Destroy; override;
    procedure DataChanged;
    // IAIMPPlaylistPreimage
    procedure Finalize; stdcall;
    procedure Initialize(Manager: IAIMPPlaylistPreimageListener); stdcall;
    function ConfigLoad(Stream: IAIMPStream): HRESULT; stdcall;
    function ConfigSave(Stream: IAIMPStream): HRESULT; stdcall;
    function ExecuteDialog(OwnerWndHanle: HWND): HRESULT; stdcall;
    // IAIMPPlaylistPreimageDataProvider
    function GetFiles(Owner: IAIMPTaskOwner; out Flags: Cardinal; out List: IAIMPObjectList): HRESULT; stdcall;
  end;

  { TfrmTestPreimage }

  TfrmTestPreimage = class(TForm, IAIMPExtensionPlaylistManagerListener)
    btnRelease: TButton;
    btnReload: TButton;
    btnSetCustom: TButton;
    btnTestIO: TButton;
    GroupBox1: TGroupBox;
    lbPlaylists: TListBox;
    lbPreimageInfo: TLabel;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    btnDataChanged: TButton;

    procedure btnDataChangedClick(Sender: TObject);
    procedure btnReleaseClick(Sender: TObject);
    procedure btnReloadClick(Sender: TObject);
    procedure btnSetCustomClick(Sender: TObject);
    procedure btnTestIOClick(Sender: TObject);
    procedure lbPlaylistsClick(Sender: TObject);
  strict private
    FFactory: ITestPreimageFactory;
    FService: IAIMPServicePlaylistManager2;

    function GetSelectedPlaylist(out APlaylist: IAIMPPlaylist): Boolean;
    function GetPlaylistPreimage(APlaylist: IAIMPPlaylist; out APreimage: IAIMPPlaylistPreimage): Boolean;
    procedure SetPlaylistPreimage(APlaylist: IAIMPPlaylist; APreimage: IAIMPPlaylistPreimage);

    // IAIMPExtensionPlaylistManagerListener
    procedure PlaylistActivated(Playlist: IAIMPPlaylist); stdcall;
    procedure PlaylistAdded(Playlist: IAIMPPlaylist); stdcall;
    procedure PlaylistRemoved(Playlist: IAIMPPlaylist); stdcall;
  public
    constructor Create(AService: IAIMPServicePlaylistManager2); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  ShellAPI, ShlObj;

{$R *.dfm}

function ShellGetPathOfMyMusic: UnicodeString;
var
  ABuf: array[0..MAX_PATH] of WideChar;
begin
  if SHGetSpecialFolderPathW(0, @ABuf[0], CSIDL_MYMUSIC, False) then
    Result := IncludeTrailingPathDelimiter(ABuf)
  else
    Result := '';
end;

{ TTestPreimageAPIPlugin }

procedure TTestPreimageAPIPlugin.Finalize;
begin
  FreeAndNil(FForm);
  inherited;
end;

function TTestPreimageAPIPlugin.InfoGet(Index: Integer): PWideChar;
begin
  Result := PChar(ClassName);
end;

function TTestPreimageAPIPlugin.InfoGetCategories: Cardinal;
begin
  Result := AIMP_PLUGIN_CATEGORY_ADDONS;
end;

function TTestPreimageAPIPlugin.Initialize(Core: IAIMPCore): HRESULT;
var
  AService: IAIMPServicePlaylistManager2;
begin
  Result := inherited Initialize(Core);
  if Succeeded(Result) then
  begin
    if CoreGetService(IAIMPServicePlaylistManager2, AService) then
    begin
      FForm := TfrmTestPreimage.Create(AService);
      FForm.Show;
    end;
  end;
end;

{ TTestPreimage }

constructor TTestPreimage.Create(AFactory: TTestPreimageFactory);
begin
  inherited Create;
  FFactory := AFactory;
  FFactory.FPreimages.Add(Self);
end;

destructor TTestPreimage.Destroy;
begin
  FFactory.FPreimages.Remove(Self);
  FManager := nil;
  inherited Destroy;
end;

procedure TTestPreimage.DataChanged;
begin
  if FManager <> nil then
    FManager.DataChanged;
end;

procedure TTestPreimage.Finalize;
begin
  FManager := nil;
end;

procedure TTestPreimage.Initialize(Manager: IAIMPPlaylistPreimageListener);
begin
  FManager := Manager;
end;

function TTestPreimage.ConfigLoad(Stream: IAIMPStream): HRESULT;
begin
  Result := S_OK;
end;

function TTestPreimage.ConfigSave(Stream: IAIMPStream): HRESULT;
begin
  Result := S_OK;
end;

function TTestPreimage.ExecuteDialog(OwnerWndHanle: HWND): HRESULT;
begin
  MessageDlg('Yep!', mtInformation, [mbOK], 0);
  Result := S_OK;
end;

procedure TTestPreimage.DoGetValueAsInt32(PropertyID: Integer; out Value: Integer; var Result: HRESULT);
begin
  case PropertyID of
    AIMP_PLAYLISTPREIMAGE_PROPID_HASDIALOG, AIMP_PLAYLISTPREIMAGE_PROPID_AUTOSYNC:
      begin
        Result := S_OK;
        Value := 1;
      end;

  else
    inherited DoGetValueAsInt32(PropertyID, Value, Result);
  end;
end;

function TTestPreimage.DoGetValueAsObject(PropertyID: Integer): IInterface;
var
  ID: IAIMPString;
begin
  if PropertyID = AIMP_PLAYLISTPREIMAGE_PROPID_FACTORYID then
  begin
    if Succeeded(FFactory.GetID(ID)) then
      Result := ID
    else
      Result := nil;
  end
  else
    Result := inherited DoGetValueAsObject(PropertyID);
end;

function TTestPreimage.GetFiles(Owner: IAIMPTaskOwner; out Flags: Cardinal; out List: IAIMPObjectList): HRESULT;
begin
  Flags := 0; // Combination of AIMP_PLAYLIST_ADD_FLAGS_XXX
  CoreCreateObject(IAIMPObjectList, List);
  CheckResult(List.Add(MakeString(ShellGetPathOfMyMusic)));
  Result := S_OK;
end;

{ TTestPreimageFactory }

constructor TTestPreimageFactory.Create;
begin
  inherited Create;
  FPreimages := TList<TTestPreimage>.Create;
end;

destructor TTestPreimageFactory.Destroy;
begin
  FreeAndNil(FPreimages);
  inherited Destroy;
end;

procedure TTestPreimageFactory.DataChanged;
var
  I: Integer;
begin
  for I := FPreimages.Count - 1 downto 0 do
    FPreimages[I].DataChanged;
end;

function TTestPreimageFactory.CreatePreimage(out Intf: IAIMPPlaylistPreimage): HRESULT;
begin
  Intf := TTestPreimage.Create(Self);
  Result := S_OK;
end;

function TTestPreimageFactory.GetID(out ID: IAIMPString): HRESULT;
begin
  ID := MakeString(ClassName);
  Result := S_OK;
end;

function TTestPreimageFactory.GetName(out Name: IAIMPString): HRESULT;
begin
  Name := MakeString('Test Preimage');
  Result := S_OK;
end;

function TTestPreimageFactory.GetFlags: DWORD; 
begin
  Result := 0;
end;

{ TfrmTestPreimage }

constructor TfrmTestPreimage.Create(AService: IAIMPServicePlaylistManager2);
var
  AIntf: IAIMPPlaylist;
  I: Integer;
begin
  inherited Create(nil);

  FService := AService;
  FFactory := TTestPreimageFactory.Create;

  CoreIntf.RegisterExtension(IAIMPServicePlaylistManager, Self);
  CoreIntf.RegisterExtension(IAIMPServicePlaylistManager, FFactory);

  for I := 0 to AService.GetLoadedPlaylistCount - 1 do
  begin
    if Succeeded(AService.GetLoadedPlaylist(I, AIntf)) then
      PlaylistAdded(AIntf);
  end;
end;

destructor TfrmTestPreimage.Destroy;
begin
  CoreIntf.UnregisterExtension(FFactory);
  CoreIntf.UnregisterExtension(Self);
  FFactory := nil;
  FService := nil;
  inherited Destroy;
end;

function TfrmTestPreimage.GetSelectedPlaylist(out APlaylist: IAIMPPlaylist): Boolean;
begin
  Result := (lbPlaylists.ItemIndex >= 0) and Succeeded(
    FService.GetLoadedPlaylistByID(MakeString(lbPlaylists.Items.Names[lbPlaylists.ItemIndex]), APlaylist))
end;

function TfrmTestPreimage.GetPlaylistPreimage(APlaylist: IAIMPPlaylist; out APreimage: IAIMPPlaylistPreimage): Boolean;
begin
  Result := Succeeded((APlaylist as IAIMPPropertyList).GetValueAsObject(
    AIMP_PLAYLIST_PROPID_PREIMAGE, IAIMPPlaylistPreimage, APreimage));
end;

procedure TfrmTestPreimage.PlaylistActivated(Playlist: IAIMPPlaylist);
begin
  // do nothing
end;

procedure TfrmTestPreimage.PlaylistAdded(Playlist: IAIMPPlaylist);
begin
  lbPlaylists.Items.Add(
    PropListGetStr(Playlist as IAIMPPropertyList, AIMP_PLAYLIST_PROPID_ID) + lbPlaylists.Items.NameValueSeparator +
    PropListGetStr(Playlist as IAIMPPropertyList, AIMP_PLAYLIST_PROPID_NAME));
end;

procedure TfrmTestPreimage.PlaylistRemoved(Playlist: IAIMPPlaylist);
var
  AIndex: Integer;
begin
  AIndex := lbPlaylists.Items.IndexOfName(PropListGetStr(Playlist as IAIMPPropertyList, AIMP_PLAYLIST_PROPID_ID));
  if AIndex >= 0 then
    lbPlaylists.Items.Delete(AIndex);
end;

procedure TfrmTestPreimage.SetPlaylistPreimage(APlaylist: IAIMPPlaylist; APreimage: IAIMPPlaylistPreimage);
begin
  (APlaylist as IAIMPPropertyList).SetValueAsObject(AIMP_PLAYLIST_PROPID_PREIMAGE, APreimage);
end;

procedure TfrmTestPreimage.btnDataChangedClick(Sender: TObject);
begin
  FFactory.DataChanged;
end;

procedure TfrmTestPreimage.btnReleaseClick(Sender: TObject);
var
  APlaylist: IAIMPPlaylist;
begin
  if GetSelectedPlaylist(APlaylist) then
    SetPlaylistPreimage(APlaylist, nil);
end;

procedure TfrmTestPreimage.btnReloadClick(Sender: TObject);
var
  APlaylist: IAIMPPlaylist;
  APreimage: IAIMPPlaylistPreimage;
begin
  if GetSelectedPlaylist(APlaylist) then
  begin
  {$REGION 'Test putting yourself'}
    if GetPlaylistPreimage(APlaylist, APreimage) then
      SetPlaylistPreimage(APlaylist, APreimage);
  {$ENDREGION}
    APlaylist.ReloadFromPreimage;
  end;
end;

procedure TfrmTestPreimage.btnSetCustomClick(Sender: TObject);
var
  AFactory: IAIMPExtensionPlaylistPreimageFactory;
  APlaylist: IAIMPPlaylist;
  APreimage: IAIMPPlaylistPreimage;
  APreimageFolders: IAIMPPlaylistPreimageFolders;
begin
  if GetSelectedPlaylist(APlaylist) then
  begin
    CheckResult(FService.GetPreimageFactoryByID(MakeString(AIMP_PREIMAGEFACTORY_FOLDERS_ID), AFactory));
    CheckResult(AFactory.CreatePreimage(APreimage));
    APreimageFolders := APreimage as IAIMPPlaylistPreimageFolders;
    APreimageFolders.SetValueAsInt32(AIMP_PLAYLISTPREIMAGE_PROPID_AUTOSYNC, 1);
    APreimageFolders.ItemsAdd(MakeString(ShellGetPathOfMyMusic), True);
    SetPlaylistPreimage(APlaylist, APreimageFolders);
  end;
end;

procedure TfrmTestPreimage.btnTestIOClick(Sender: TObject);
var
  APlaylist: IAIMPPlaylist;
  APlaylistPreimage: IAIMPPlaylistPreimage;
  AStream: IAIMPMemoryStream;
begin
  if GetSelectedPlaylist(APlaylist) and GetPlaylistPreimage(APlaylist, APlaylistPreimage) then
  begin
    CoreCreateObject(IAIMPMemoryStream, AStream);
    CheckResult(APlaylistPreimage.ConfigSave(AStream));
    CheckResult(APlaylistPreimage.Reset);
    CheckResult(AStream.Seek(0, AIMP_STREAM_SEEKMODE_FROM_BEGINNING));
    CheckResult(APlaylistPreimage.ConfigLoad(AStream));
  end;
end;

procedure TfrmTestPreimage.lbPlaylistsClick(Sender: TObject);
var
  APlaylist: IAIMPPlaylist;
  APlaylistPreimage: IAIMPPlaylistPreimage;
  APlaylistPreimageType: string;
begin
  if GetSelectedPlaylist(APlaylist) and GetPlaylistPreimage(APlaylist, APlaylistPreimage) then
  begin
    APlaylistPreimageType := PropListGetStr(APlaylistPreimage, AIMP_PLAYLISTPREIMAGE_PROPID_FACTORYID);
  {$REGION 'Test the interface extensions'}
    if Supports(APlaylistPreimage, IAIMPPlaylistPreimageFolders) then
      APlaylistPreimageType := APlaylistPreimageType + '(Folders)';
    if Supports(APlaylistPreimage, IAIMPMLPlaylistPreimage) then
      APlaylistPreimageType := APlaylistPreimageType + '(Music Library)';
  {$ENDREGION}
    lbPreimageInfo.Caption := Format('Preimage: %s [%x]', [APlaylistPreimageType, NativeUInt(APlaylistPreimage)]);
  end
  else
    lbPreimageInfo.Caption := 'Playlist has no preimage';
end;

end.
