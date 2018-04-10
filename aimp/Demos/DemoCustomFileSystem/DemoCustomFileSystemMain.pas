unit DemoCustomFileSystemMain;

interface

uses
  Windows, Classes, ShlObj, Types,
  // API
  apiPlugin, apiFileManager, apiMenu, apiCore, apiActions, apiPlaylists, apiObjects,
  // Wrappers
  AIMPCustomPlugin, apiWrappers;

type

  { TMenuItemHandler }

  TMenuItemHandler = class(TInterfacedObject, IAIMPActionEvent)
  strict private
    FEvent: TNotifyEvent;
  public
    constructor Create(AEvent: TNotifyEvent);
    procedure OnExecute(Data: IInterface); stdcall;
  end;

  { TMyMusicFileSystem }

  (*
    Common idea of the TMyMusicFileSystem:
    1. Replace path to "My Music" system folder with the "mymusic" scheme when adding it to playlist
    2. Implement all file system commands that will be replace "mymusic" scheme by real path of the "MyMusic"
       folder and forward call to the "default" file system handler
  *)

  TMyMusicFileSystem = class(TAIMPPropertyList,
    IAIMPFileSystemCommandCopyToClipboard,
    IAIMPFileSystemCommandDelete,
    IAIMPFileSystemCommandDropSource,
    IAIMPFileSystemCommandFileInfo,
    IAIMPFileSystemCommandOpenFileFolder,
    IAIMPFileSystemCommandStreaming,
    IAIMPExtensionFileSystem)
  strict private
    FRootPath: UnicodeString;

    function GetCommandForDefaultFileSystem(const IID: TGUID; out Obj): Boolean;
    function TranslateFileName(const AFileName: IAIMPString): IAIMPString;
  protected
    // IAIMPExtensionFileSystem
    procedure DoGetValueAsInt32(PropertyID: Integer; out Value: Integer; var Result: HRESULT); override;
    function DoGetValueAsObject(PropertyID: Integer): IInterface; override;
    // IAIMPFileSystemCommandCopyToClipboard
    function CopyToClipboard(Files: IAIMPObjectList): HRESULT; stdcall;
    // IAIMPFileSystemCommandDropSource
    function CreateStream(FileName: IAIMPString; out Stream: IAIMPStream): HRESULT; overload; stdcall;
    // IAIMPFileSystemCommandDelete
    function IAIMPFileSystemCommandDelete.CanProcess = CanDelete;
    function IAIMPFileSystemCommandDelete.Process = Delete;
    function CanDelete(FileName: IAIMPString): HRESULT; stdcall;
    function Delete(FileName: IAIMPString): HRESULT; stdcall;
    // IAIMPFileSystemCommandFileInfo
    function GetFileAttrs(FileName: IAIMPString; out Attrs: TAIMPFileAttributes): HRESULT; stdcall;
    function GetFileSize(FileName: IAIMPString; out Size: Int64): HRESULT; stdcall;
    function IsFileExists(FileName: IAIMPString): HRESULT; stdcall;
    // IAIMPFileSystemCommandOpenFileFolder
    function IAIMPFileSystemCommandOpenFileFolder.CanProcess = CanOpenFileFolder;
    function IAIMPFileSystemCommandOpenFileFolder.Process = OpenFileFolder;
    function CanOpenFileFolder(FileName: IAIMPString): HRESULT; stdcall;
    function OpenFileFolder(FileName: IAIMPString): HRESULT; stdcall;
    // IAIMPFileSystemCommandStreaming
    function CreateStream(FileName: IAIMPString; const Offset, Size: Int64; Flags: Cardinal; out Stream: IAIMPStream): HRESULT; overload; stdcall;
  public
    constructor Create; virtual;
  end;

  { TDemoCustomFileSystemPlugin }

  TDemoCustomFileSystemPlugin = class(TAIMPCustomPlugin)
  strict private
    procedure HandlerMenuItemClick(Sender: TObject);
  protected
    function InfoGet(Index: Integer): PWideChar; override; stdcall;
    function InfoGetCategories: Cardinal; override; stdcall;
    function Initialize(Core: IAIMPCore): HRESULT; override; stdcall;
  end;

implementation

uses
  ActiveX, SysUtils, IOUtils;

const
  sMyScheme = 'mymusic';
  sMySchemePrefix = sMyScheme + ':\\';

function ShellGetSystemFolder(AFolder: Integer): UnicodeString;
var
  ABuf: array[0..MAX_PATH] of WideChar;
begin
  if SHGetSpecialFolderPathW(0, @ABuf[0], AFolder, False) then
    Result := IncludeTrailingPathDelimiter(ABuf)
  else
    Result := '';
end;

function ShellGetMyMusic: UnicodeString;
begin
  Result := ShellGetSystemFolder(CSIDL_MYMUSIC);
end;

{ TMenuItemHandler }

constructor TMenuItemHandler.Create(AEvent: TNotifyEvent);
begin
  FEvent := AEvent;
end;

procedure TMenuItemHandler.OnExecute(Data: IInterface);
begin
  FEvent(nil);
end;

{ TMyMusicFileSystem }

constructor TMyMusicFileSystem.Create;
begin
  FRootPath := ShellGetMyMusic;
end;

procedure TMyMusicFileSystem.DoGetValueAsInt32(PropertyID: Integer; out Value: Integer; var Result: HRESULT);
begin
  if PropertyID = AIMP_FILESYSTEM_PROPID_READONLY then
  begin
    Result := S_OK;
    Value := 0;
  end
  else
    inherited DoGetValueAsInt32(PropertyID, Value, Result);
end;

function TMyMusicFileSystem.DoGetValueAsObject(PropertyID: Integer): IInterface;
begin
  if PropertyID = AIMP_FILESYSTEM_PROPID_SCHEME then
    Result := MakeString(sMyScheme)
  else
    Result := inherited DoGetValueAsObject(PropertyID);
end;

function TMyMusicFileSystem.CopyToClipboard(Files: IAIMPObjectList): HRESULT;
var
  AFileName: IAIMPString;
  AIntf: IAIMPFileSystemCommandCopyToClipboard;
  AList: IAIMPObjectList;
  I: Integer;
begin
  if GetCommandForDefaultFileSystem(IAIMPFileSystemCommandCopyToClipboard, AIntf) then
  begin
    CoreCreateObject(IAIMPObjectList, AList);
    for I := 0 to Files.GetCount - 1 do
    begin
      if Succeeded(Files.GetObject(I, IAIMPString, AFileName)) then
        AList.Add(TranslateFileName(AFileName));
    end;
    Result := AIntf.CopyToClipboard(AList);
  end
  else
    Result := E_NOTIMPL;
end;

function TMyMusicFileSystem.CreateStream(FileName: IAIMPString; out Stream: IAIMPStream): HRESULT;
begin
  Result := CreateStream(FileName, -1, -1, 0, Stream);
end;

function TMyMusicFileSystem.GetFileAttrs(FileName: IAIMPString; out Attrs: TAIMPFileAttributes): HRESULT;
var
  AIntf: IAIMPFileSystemCommandFileInfo;
begin
  if GetCommandForDefaultFileSystem(IAIMPFileSystemCommandFileInfo, AIntf) then
    Result := AIntf.GetFileAttrs(TranslateFileName(FileName), Attrs)
  else
    Result := E_NOTIMPL;
end;

function TMyMusicFileSystem.GetFileSize(FileName: IAIMPString; out Size: Int64): HRESULT;
var
  AIntf: IAIMPFileSystemCommandFileInfo;
begin
  if GetCommandForDefaultFileSystem(IAIMPFileSystemCommandFileInfo, AIntf) then
    Result := AIntf.GetFileSize(TranslateFileName(FileName), Size)
  else
    Result := E_NOTIMPL;
end;

function TMyMusicFileSystem.IsFileExists(FileName: IAIMPString): HRESULT;
var
  AIntf: IAIMPFileSystemCommandFileInfo;
begin
  if GetCommandForDefaultFileSystem(IAIMPFileSystemCommandFileInfo, AIntf) then
    Result := AIntf.IsFileExists(TranslateFileName(FileName))
  else
    Result := E_NOTIMPL;
end;

function TMyMusicFileSystem.CanDelete(FileName: IAIMPString): HRESULT;
var
  AIntf: IAIMPFileSystemCommandDelete;
begin
  if GetCommandForDefaultFileSystem(IAIMPFileSystemCommandDelete, AIntf) then
    Result := AIntf.CanProcess(TranslateFileName(FileName))
  else
    Result := E_NOTIMPL;
end;

function TMyMusicFileSystem.Delete(FileName: IAIMPString): HRESULT;
var
  AIntf: IAIMPFileSystemCommandDelete;
begin
  if GetCommandForDefaultFileSystem(IAIMPFileSystemCommandDelete, AIntf) then
    Result := AIntf.Process(TranslateFileName(FileName))
  else
    Result := E_NOTIMPL;
end;

function TMyMusicFileSystem.CanOpenFileFolder(FileName: IAIMPString): HRESULT;
var
  AIntf: IAIMPFileSystemCommandOpenFileFolder;
begin
  if GetCommandForDefaultFileSystem(IAIMPFileSystemCommandOpenFileFolder, AIntf) then
    Result := AIntf.CanProcess(TranslateFileName(FileName))
  else
    Result := E_NOTIMPL;
end;

function TMyMusicFileSystem.OpenFileFolder(FileName: IAIMPString): HRESULT;
var
  AIntf: IAIMPFileSystemCommandOpenFileFolder;
begin
  if GetCommandForDefaultFileSystem(IAIMPFileSystemCommandOpenFileFolder, AIntf) then
    Result := AIntf.Process(TranslateFileName(FileName))
  else
    Result := E_NOTIMPL;
end;

function TMyMusicFileSystem.CreateStream(FileName: IAIMPString;
  const Offset, Size: Int64; Flags: Cardinal; out Stream: IAIMPStream): HRESULT;
var
  AIntf: IAIMPFileSystemCommandStreaming;
begin
  if GetCommandForDefaultFileSystem(IAIMPFileSystemCommandStreaming, AIntf) then
    Result := AIntf.CreateStream(TranslateFileName(FileName), Offset, Size, Flags, Stream)
  else
    Result := E_NOTIMPL;
end;

function TMyMusicFileSystem.GetCommandForDefaultFileSystem(const IID: TGUID; out Obj): Boolean;
var
  AService: IAIMPServiceFileSystems;
begin
  Result := CoreGetService(IAIMPServiceFileSystems, AService) and Succeeded(AService.GetDefault(IID, Obj));
end;

function TMyMusicFileSystem.TranslateFileName(const AFileName: IAIMPString): IAIMPString;
begin
  CheckResult(AFileName.Clone(Result));
  Result.Replace(MakeString(sMySchemePrefix), MakeString(FRootPath), AIMP_STRING_FIND_IGNORECASE);
end;

{ TDemoCustomFileSystemPlugin }

function TDemoCustomFileSystemPlugin.InfoGet(Index: Integer): PWideChar;
begin
  case Index of
    AIMP_PLUGIN_INFO_NAME:
      Result := 'MyMusic - Custom File System Demo';
    AIMP_PLUGIN_INFO_AUTHOR:
      Result := 'Artem Izmaylov';
  else
    Result := '';
  end;
end;

function TDemoCustomFileSystemPlugin.InfoGetCategories: Cardinal;
begin
  Result := AIMP_PLUGIN_CATEGORY_ADDONS;
end;

function TDemoCustomFileSystemPlugin.Initialize(Core: IAIMPCore): HRESULT;
var
  AMenuItem: IAIMPMenuItem;
  AMenuServiceIntf: IAIMPServiceMenuManager;
  AParentMenuItem: IAIMPMenuItem;
begin
  Result := inherited Initialize(Core);
  if Succeeded(Result) then
  begin
    // Create Menu item
    if CoreGetService(IAIMPServiceMenuManager, AMenuServiceIntf) then
    begin
      if Succeeded(AMenuServiceIntf.GetBuiltIn(AIMP_MENUID_PLAYER_PLAYLIST_ADDING, AParentMenuItem)) then
      begin
        CoreCreateObject(IAIMPMenuItem, AMenuItem);
        CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_NAME, MakeString('MyMusic: Add All Files')));
        CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_EVENT, TMenuItemHandler.Create(HandlerMenuItemClick)));
        CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_PARENT, AParentMenuItem));
        Core.RegisterExtension(IAIMPServiceMenuManager, AMenuItem);
      end;
    end;

    // Register custom file system
    Core.RegisterExtension(IAIMPServiceFileSystems, TMyMusicFileSystem.Create);
  end;
end;

procedure TDemoCustomFileSystemPlugin.HandlerMenuItemClick(Sender: TObject);
var
  AFileFormatService: IAIMPServiceFileFormats;
  AFileList: IAIMPObjectList;
  AFiles: TStringDynArray;
  APlaylist: IAIMPPlaylist;
  APlaylistService: IAIMPServicePlaylistManager;
  ARootPath: UnicodeString;
  I: Integer;
begin
  if CoreGetService(IAIMPServiceFileFormats, AFileFormatService) then
  begin
    // Get all files from MyMusic folder and sub-folders
    ARootPath := ShellGetMyMusic;
    AFiles := TDirectory.GetFiles(ARootPath, '*', TSearchOption.soAllDirectories, nil);
    if Length(AFiles) = 0 then
      Exit;

    // Check the format type of returned files and replace the path of "My Music" folder by our scheme.
    CoreCreateObject(IAIMPObjectList, AFileList);
    for I := 0 to Length(AFiles) - 1 do
    begin
      if Succeeded(AFileFormatService.IsSupported(MakeString(AFiles[I]), AIMP_SERVICE_FILEFORMATS_CATEGORY_AUDIO)) then
        AFileList.Add(MakeString(sMySchemePrefix + Copy(AFiles[I], Length(ARootPath) + 1, MaxInt)));
    end;

    // Put supported files to the playlist
    if CoreGetService(IAIMPServicePlaylistManager, APlaylistService) then
    begin
      if Succeeded(APlaylistService.GetActivePlaylist(APlaylist)) then
        APlaylist.AddList(AFileList, AIMP_PLAYLIST_ADD_FLAGS_NOCHECKFORMAT, -1);
    end;
  end;
end;

end.
