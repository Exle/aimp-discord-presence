{************************************************}
{*                                              *}
{*          AIMP Programming Interface          *}
{*                Menu Wrappers                 *}
{*                                              *}
{*                Artem Izmaylov                *}
{*                (C) 2006-2017                 *}
{*                 www.aimp.ru                  *}
{*            Mail: support@aimp.ru             *}
{*                                              *}
{************************************************}

unit apiWrappersMenus;

{$I apiConfig.inc}

interface

uses
  Classes,
  Generics.Collections,
  // API
  apiActions,
  apiMenu,
  apiMusicLibrary,
  apiObjects,
  apiPlaylists,
  apiWrappers;

const
  RT_PNG = 'PNG';

type
//----------------------------------------------------------------------------------------------------------------------
// Basic
//----------------------------------------------------------------------------------------------------------------------

  TAIMPUICustomMenuItem = class;

  TAIMPUIMenuItemStates = (isEnabled, isVisible);
  TAIMPUIMenuItemState = set of TAIMPUIMenuItemStates;

  { IAIMPUIMenuItemController }

  IAIMPUIMenuItemController = interface(IAIMPActionEvent)
  ['{3F4AA204-E1BC-4EC9-AC70-3F74F5225604}']
    procedure Bind(Handle: IAIMPMenuItem; MenuItem: TAIMPUICustomMenuItem);
    function IsAvailable: Boolean;
  end;

  { TAIMPUICustomMenuItem }

  TAIMPUICustomMenuItem = class abstract(TInterfacedObject, IAIMPActionEvent)
  strict private
    FController: IAIMPUIMenuItemController;
    FID: UnicodeString;
  protected
    function GetGlyphResName: string; virtual;
    function GetState: TAIMPUIMenuItemState; virtual;
    // IAIMPActionEvent
    procedure OnExecute(Sender: IUnknown); virtual; stdcall; abstract;
    //
    procedure UpdateGlyph(AMenuItem: IAIMPMenuItem);
    procedure UpdateState; overload;
    procedure UpdateState(AMenuItem: IAIMPMenuItem); overload; virtual;
    //
    property Controller: IAIMPUIMenuItemController read FController;
  public
    constructor Create(AController: IAIMPUIMenuItemController);
    procedure Register(const ID: UnicodeString; const ParentID: Variant);
  end;

  { TAIMPUICustomMenuItemController }

  TAIMPUICustomMenuItemController = class abstract(TInterfacedObject,
    IAIMPActionEvent,
    IAIMPUIMenuItemController)
  strict private
    FIsAvailable: Boolean;
    FMenuItems: TList;

    // IAIMPUIMenuItemController
    procedure Bind(Handle: IAIMPMenuItem; MenuItem: TAIMPUICustomMenuItem);
    function IsAvailable: Boolean;
    // IAIMPActionEvent
    procedure OnExecute(Data: IInterface); stdcall;
  protected
    function CheckData: Boolean; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Refresh;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Files Providers
//----------------------------------------------------------------------------------------------------------------------

  TAIMPFileListClass = class of TAIMPFileList;
  TAIMPFileList = class(TStringList)
  strict private
    FFocusIndex: Integer;

    function GetFocused: string;
  public
    procedure Add(const FileURI: IAIMPString); reintroduce; overload;
    procedure AfterConstruction; override;
    procedure Clear; override;
    procedure MarkFocused(const FileURI: string); overload; virtual;
    procedure MarkFocused(const FileURI: IAIMPString); overload;
    //
    property Focused: string read GetFocused;
    property FocusIndex: Integer read FFocusIndex write FFocusIndex;
  end;

  IAIMPUIFileBasedMenuItemController = interface
  ['{B9FB51EF-0637-45A8-AF38-21C03C818AE7}']
    function GetFiles: TAIMPFileList;
  end;

  { TAIMPUICustomFileBasedMenuItemController }

  TAIMPUICustomFileBasedMenuItemController = class abstract(TAIMPUICustomMenuItemController,
    IAIMPUIFileBasedMenuItemController)
  strict private
    FFiles: TAIMPFileList;
    // IAIMPUIFileBasedMenuItemController
    function GetFiles: TAIMPFileList;
  protected
    function CheckData: Boolean; override;
    function CheckIsOurStorage: Boolean; virtual;
    procedure QueryFiles(AFiles: TAIMPFileList); virtual; abstract;
  public
    constructor Create; overload;
    constructor Create(AFileListClass: TAIMPFileListClass); overload;
    destructor Destroy; override;
  end;

  { TAIMPUIMusicLibraryBasedMenuItemController }

  TAIMPUIMusicLibraryBasedMenuItemController = class(TAIMPUICustomFileBasedMenuItemController)
  protected
    procedure QueryFiles(AFiles: TAIMPFileList); override;
  end;

  { TAIMPUIPlaylistBasedMenuItemController }

  TAIMPUIPlaylistBasedMenuItemController = class(TAIMPUICustomFileBasedMenuItemController)
  strict private
    function GetFocusedFileName(Playlist: IAIMPPlaylist; out FileURI: IAIMPString): Boolean;
  protected
    procedure QueryFiles(AFiles: TAIMPFileList); override;
  end;

procedure AddSimpleMenuItem(AParent: IAIMPMenuItem; const ATitle: string; AEvent: IUnknown); overload;
procedure AddSimpleMenuItem(AParent: Integer; const ATitle: string; AEvent: IUnknown); overload;
implementation

uses
  Windows, SysUtils, Variants, Math;

const
  sErrorAlreadyRegistered = 'The instance is already registered as handler for %s menu';
  sErrorDuplicateID = 'The %s ID is already registered';
  sErrorNoID = 'Cannot register menu item without ID';

procedure AddSimpleMenuItem(AParent: IAIMPMenuItem; const ATitle: string; AEvent: IUnknown); overload;
var
  ASubItem: IAIMPMenuItem;
begin
  CoreCreateObject(IAIMPMenuItem, ASubItem);
  PropListSetStr(ASubItem, AIMP_MENUITEM_PROPID_NAME, ATitle);
  PropListSetObj(ASubItem, AIMP_MENUITEM_PROPID_PARENT, AParent);
  PropListSetObj(ASubItem, AIMP_MENUITEM_PROPID_EVENT, AEvent);
  CoreIntf.RegisterExtension(IAIMPServiceMenuManager, ASubItem);
end;

procedure AddSimpleMenuItem(AParent: Integer; const ATitle: string; AEvent: IUnknown); overload;
var
  AMenuItem: IAIMPMenuItem;
  AService: IAIMPServiceMenuManager;
begin
  if CoreGetService(IAIMPServiceMenuManager, AService) then
  begin
    if Succeeded(AService.GetBuiltIn(AParent, AMenuItem)) then
      AddSimpleMenuItem(AMenuItem, ATitle, AEvent);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------
// Basic
//----------------------------------------------------------------------------------------------------------------------

{ TAIMPUICustomMenuItem }

constructor TAIMPUICustomMenuItem.Create(AController: IAIMPUIMenuItemController);
begin
  FController := AController;
end;

procedure TAIMPUICustomMenuItem.Register(const ID: UnicodeString; const ParentID: Variant);
var
  AHandle: IAIMPMenuItem;
  AParentHandle: IAIMPMenuItem;
  AService: IAIMPServiceMenuManager;
begin
  if CoreGetService(IAIMPServiceMenuManager, AService) then
  begin
    if FID <> '' then
      raise EInvalidInsert.CreateFmt(sErrorAlreadyRegistered, [FID]);
    if ID = '' then
      raise EInvalidOp.Create(sErrorNoID);
    if Succeeded(AService.GetByID(MakeString(ID), AHandle)) then
      raise EInvalidInsert.CreateFmt(sErrorDuplicateID, [ID]);

    FID := ID;
    if VarIsStr(ParentID) then
      CheckResult(AService.GetByID(MakeString(ParentID), AParentHandle))
    else
      CheckResult(AService.GetBuiltIn(ParentID, AParentHandle));

    CoreCreateObject(IAIMPMenuItem, AHandle);
    if Controller <> nil then
      Controller.Bind(AHandle, Self);
    PropListSetStr(AHandle, AIMP_MENUITEM_PROPID_ID, ID);
    PropListSetObj(AHandle, AIMP_MENUITEM_PROPID_EVENT, Self);
    PropListSetObj(AHandle, AIMP_MENUITEM_PROPID_PARENT, AParentHandle);

    CoreIntf.RegisterExtension(IAIMPServiceMenuManager, AHandle);
  end;
end;

function TAIMPUICustomMenuItem.GetGlyphResName: string;
begin
  Result := '';
end;

function TAIMPUICustomMenuItem.GetState: TAIMPUIMenuItemState;
begin
  if Controller.IsAvailable then
    Result := [isEnabled, isVisible]
  else
    Result := [];
end;

procedure TAIMPUICustomMenuItem.UpdateGlyph(AMenuItem: IAIMPMenuItem);

  function GetActualResName(ATargetDPI: Integer): string;
  const
    SupportedDPI: array[0..3] of Integer = (120, 144, 168, 192);
  var
    AIndex: Integer;
  begin
    for AIndex := Low(SupportedDPI) to High(SupportedDPI) do
      if ATargetDPI >= SupportedDPI[AIndex] then
      begin
        Result := GetGlyphResName + IntToStr(SupportedDPI[AIndex]);
        if FindResource(HInstance, PWideChar(Result), RT_PNG) <> 0 then
          Exit;
      end;
    Result := GetGlyphResName;
  end;

var
  AGlyph: IAIMPImage2;
  AGlyphName: string;
  ASourceDPI: IAIMPDPIAware;
  ATargetDPI: IAIMPDPIAware;
begin
  AGlyphName := GetGlyphResName;
  if AGlyphName <> '' then
  try
    CoreCreateObject(IAIMPImage2, AGlyph);

    if Supports(AMenuItem, IAIMPDPIAware, ASourceDPI) and Supports(AGlyph, IAIMPDPIAware, ATargetDPI) then
    begin
      ATargetDPI.SetDPI(ASourceDPI.GetDPI);
      if ATargetDPI.GetDPI > 96 then
        AGlyphName := GetActualResName(ATargetDPI.GetDPI);
    end;

    CheckResult(AGlyph.LoadFromResource(HInstance, PWideChar(AGlyphName), RT_PNG));
    PropListSetObj(AMenuItem, AIMP_MENUITEM_PROPID_GLYPH, AGlyph);
  except
    // do nothing
  end;
end;

procedure TAIMPUICustomMenuItem.UpdateState;
var
  AMenuItem: IAIMPMenuItem;
  AService: IAIMPServiceMenuManager;
begin
  if FID <> '' then
  begin
    if CoreGetService(IAIMPServiceMenuManager, AService) and Succeeded(AService.GetByID(MakeString(FID), AMenuItem)) then
    begin
      UpdateGlyph(AMenuItem);
      UpdateState(AMenuItem);
    end;
  end;
end;

procedure TAIMPUICustomMenuItem.UpdateState(AMenuItem: IAIMPMenuItem);
var
  AState: TAIMPUIMenuItemState;
begin
  AState := GetState;
  PropListSetInt32(AMenuItem, AIMP_MENUITEM_PROPID_ENABLED, Ord(isEnabled in AState));
  PropListSetInt32(AMenuItem, AIMP_MENUITEM_PROPID_VISIBLE, Ord(isVisible in AState));
end;

{ TAIMPUICustomMenuItemController }

constructor TAIMPUICustomMenuItemController.Create;
begin
  inherited Create;
  FMenuItems := TList.Create;
end;

destructor TAIMPUICustomMenuItemController.Destroy;
begin
  FreeAndNil(FMenuItems);
  inherited Destroy;
end;

procedure TAIMPUICustomMenuItemController.Bind(Handle: IAIMPMenuItem; MenuItem: TAIMPUICustomMenuItem);
begin
  FMenuItems.Add(MenuItem);
  if FMenuItems.Count = 1 then
    PropListSetObj(Handle, AIMP_MENUITEM_PROPID_EVENT_ONSHOW, Self);
end;

function TAIMPUICustomMenuItemController.IsAvailable: Boolean;
begin
  Result := FIsAvailable;
end;

procedure TAIMPUICustomMenuItemController.OnExecute(Data: IInterface);
begin
  Refresh;
end;

procedure TAIMPUICustomMenuItemController.Refresh;
var
  AIndex: Integer;
begin
  FIsAvailable := CheckData;
  for AIndex := 0 to FMenuItems.Count - 1 do
    TAIMPUICustomMenuItem(FMenuItems.List[AIndex]).UpdateState;
end;

{ TAIMPFileList }

procedure TAIMPFileList.Add(const FileURI: IAIMPString);
begin
  Add(IAIMPStringToString(FileURI));
end;

procedure TAIMPFileList.AfterConstruction;
begin
  inherited;
  CaseSensitive := False;
  FocusIndex := -1;
end;

procedure TAIMPFileList.Clear;
begin
  inherited;
  FocusIndex := -1;
end;

procedure TAIMPFileList.MarkFocused(const FileURI: IAIMPString);
begin
  MarkFocused(IAIMPStringToString(FileURI));
end;

procedure TAIMPFileList.MarkFocused(const FileURI: string);
begin
  FocusIndex := IndexOf(FileURI);
end;

function TAIMPFileList.GetFocused: string;
begin
  Result := Strings[FocusIndex];
end;

{ TAIMPUICustomFileBasedMenuItemController }

constructor TAIMPUICustomFileBasedMenuItemController.Create;
begin
  Create(TAIMPFileList);
end;

constructor TAIMPUICustomFileBasedMenuItemController.Create(AFileListClass: TAIMPFileListClass);
begin
  inherited Create;
  FFiles := AFileListClass.Create;
end;

destructor TAIMPUICustomFileBasedMenuItemController.Destroy;
begin
  FreeAndNil(FFiles);
  inherited Destroy;
end;

function TAIMPUICustomFileBasedMenuItemController.CheckData: Boolean;
begin
  FFiles.Clear;
  Result := CheckIsOurStorage;
  if Result then
    QueryFiles(FFiles);
end;

function TAIMPUICustomFileBasedMenuItemController.CheckIsOurStorage: Boolean;
begin
  Result := True;
end;

function TAIMPUICustomFileBasedMenuItemController.GetFiles: TAIMPFileList;
begin
  Result := FFiles;
end;

{ TAIMPUIMusicLibraryBasedMenuItemController }

procedure TAIMPUIMusicLibraryBasedMenuItemController.QueryFiles(AFiles: TAIMPFileList);
var
  AFileURI: IAIMPString;
  AIndex: Integer;
  AList: IAIMPMLFileList;
  AService: IAIMPServiceMusicLibraryUI;
begin
  if CoreGetService(IAIMPServiceMusicLibraryUI, AService) then
  begin
    if Succeeded(AService.GetFiles(AIMPML_GETFILES_FLAGS_SELECTED, AList)) then
    begin
      AFiles.Capacity := AList.GetCount;
      for AIndex := 0 to AList.GetCount - 1 do
      begin
        if Succeeded(AList.GetFileName(AIndex, AFileURI)) then
          AFiles.Add(AFileURI);
      end;
      if Succeeded(AService.GetFiles(AIMPML_GETFILES_FLAGS_FOCUSED, AList)) then
      begin
        if (AList.GetCount > 0) and Succeeded(AList.GetFileName(0, AFileURI)) then
          AFiles.MarkFocused(AFileURI);
      end;
    end;
  end;
end;

{ TAIMPUIPlaylistBasedMenuItemController }

procedure TAIMPUIPlaylistBasedMenuItemController.QueryFiles(AFiles: TAIMPFileList);
var
  AFileURI: IAIMPString;
  AList: IAIMPObjectList;
  APlaylist: IAIMPPlaylist;
  AService: IAIMPServicePlaylistManager;
  AIndex: Integer;
begin
  if CoreGetService(IAIMPServicePlaylistManager, AService) and Succeeded(AService.GetActivePlaylist(APlaylist)) then
  begin
    if Succeeded(APlaylist.GetFiles(AIMP_PLAYLIST_GETFILES_FLAGS_SELECTED_ONLY, AList)) then
    begin
      AFiles.Capacity := AList.GetCount;
      for AIndex := 0 to AList.GetCount - 1 do
      begin
        if Succeeded(AList.GetObject(AIndex, IAIMPString, AFileURI)) then
          AFiles.Add(AFileURI);
      end;
      //TODO - FIXME - This is not ready for duplicates
      if GetFocusedFileName(APlaylist, AFileURI) then
        AFiles.MarkFocused(AFileURI);
    end;
  end;
end;

function TAIMPUIPlaylistBasedMenuItemController.GetFocusedFileName(Playlist: IAIMPPlaylist; out FileURI: IAIMPString): Boolean;
var
  AGroup: IAIMPPlaylistGroup;
  AItem: IAIMPPlaylistItem;
  AProperties: IAIMPPropertyList;
begin
  Result := False;
  if Supports(Playlist, IAIMPPropertyList, AProperties) then
  begin
    if
      Succeeded(AProperties.GetValueAsObject(AIMP_PLAYLIST_PROPID_FOCUSED_OBJECT, IAIMPPlaylistItem, AItem)) or
      Succeeded(AProperties.GetValueAsObject(AIMP_PLAYLIST_PROPID_FOCUSED_OBJECT, IAIMPPlaylistGroup, AGroup)) and
      Succeeded(AGroup.GetItem(0, IAIMPPlaylistItem, AItem))
    then
      if PropListGetInt32(AItem, AIMP_PLAYLISTITEM_PROPID_SELECTED) <> 0 then
        Result := Succeeded(AItem.GetValueAsObject(AIMP_PLAYLISTITEM_PROPID_FILENAME, IAIMPString, FileURI));
  end;
end;

end.
