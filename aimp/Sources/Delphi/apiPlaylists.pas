{************************************************}
{*                                              *}
{*          AIMP Programming Interface          *}
{*               v4.50 build 2000               *}
{*                                              *}
{*                Artem Izmaylov                *}
{*                (C) 2006-2017                 *}
{*                 www.aimp.ru                  *}
{*            Mail: support@aimp.ru             *}
{*                                              *}
{************************************************}

unit apiPlaylists;

{$I apiConfig.inc}

interface

uses
  Windows, apiActions, apiObjects, apiThreading;

const
  SID_IAIMPPlaylist = '{41494D50-506C-7300-0000-000000000000}';
  IID_IAIMPPlaylist: TGUID = SID_IAIMPPlaylist;

  SID_IAIMPPlaylistItem = '{41494D50-506C-7349-7465-6D0000000000}';
  IID_IAIMPPlaylistItem: TGUID = SID_IAIMPPlaylistItem;

  SID_IAIMPPlaylistGroup = '{41494D50-506C-7347-726F-757000000000}';
  IID_IAIMPPlaylistGroup: TGUID = SID_IAIMPPlaylistGroup;

  SID_IAIMPPlaylistListener = '{41494D50-506C-734C-7374-6E7200000000}';
  IID_IAIMPPlaylistListener: TGUID = SID_IAIMPPlaylistListener;

  SID_IAIMPPlaylistListener2 = '{41494D50-506C-734C-7374-6E7232000000}';
  IID_IAIMPPlaylistListener2: TGUID = SID_IAIMPPlaylistListener2;

  SID_IAIMPPlaylistQueue = '{41494D50-506C-7351-7565-756500000000}';
  IID_IAIMPPlaylistQueue: TGUID = SID_IAIMPPlaylistQueue;

  SID_IAIMPPlaylistQueue2 = '{41494D50-506C-7351-7565-756532000000}';
  IID_IAIMPPlaylistQueue2: TGUID = SID_IAIMPPlaylistQueue2;

  SID_IAIMPPlaylistQueueListener = '{41494D50-506C-7351-7565-75654C737400}';
  IID_IAIMPPlaylistQueueListener: TGUID = SID_IAIMPPlaylistQueueListener;

  SID_IAIMPExtensionPlaylistManagerListener = '{41494D50-4578-7450-6C73-4D616E4C7472}';
  IID_IAIMPExtensionPlaylistManagerListener: TGUID = SID_IAIMPExtensionPlaylistManagerListener;

  SID_IAIMPExtensionPlaylistPreimageFactory = '{41494D50-4578-7453-6D50-6C7346637400}';
  IID_IAIMPExtensionPlaylistPreimageFactory: TGUID = SID_IAIMPExtensionPlaylistPreimageFactory;

  SID_IAIMPPlaylistPreimage = '{41494D50-536D-504C-5372-630000000000}';
  IID_IAIMPPlaylistPreimage: TGUID = SID_IAIMPPlaylistPreimage;

  SID_IAIMPPlaylistPreimageListener = '{41494D50-536D-504C-4D6E-677200000000}';
  IID_IAIMPPlaylistPreimageListener: TGUID = SID_IAIMPPlaylistPreimageListener;

  SID_IAIMPPlaylistPreimageDataProvider = '{41494D50-536D-506C-7344-617461000000}';
  IID_IAIMPPlaylistPreimageDataProvider: TGUID = SID_IAIMPPlaylistPreimageDataProvider;

  SID_IAIMPPlaylistPreimageFolders = '{41494D50-536D-504C-5372-63466C647273}';
  IID_IAIMPPlaylistPreimageFolders: TGUID = SID_IAIMPPlaylistPreimageFolders;

  SID_IAIMPServicePlaylistManager = '{41494D50-5372-7650-6C73-4D616E000000}';
  IID_IAIMPServicePlaylistManager: TGUID = SID_IAIMPServicePlaylistManager;

  SID_IAIMPServicePlaylistManager2 = '{41494D50-536D-504C-4D6E-677232000000}';
  IID_IAIMPServicePlaylistManager2: TGUID = SID_IAIMPServicePlaylistManager;

  // Property IDs for IAIMPPlaylistItem
  AIMP_PLAYLISTITEM_PROPID_CUSTOM             = 0;
  AIMP_PLAYLISTITEM_PROPID_DISPLAYTEXT        = 1;
  AIMP_PLAYLISTITEM_PROPID_FILEINFO           = 2;
  AIMP_PLAYLISTITEM_PROPID_FILENAME           = 3;
  AIMP_PLAYLISTITEM_PROPID_GROUP              = 4;
  AIMP_PLAYLISTITEM_PROPID_INDEX              = 5;
  AIMP_PLAYLISTITEM_PROPID_MARK               = 6;
  AIMP_PLAYLISTITEM_PROPID_PLAYINGSWITCH      = 7;
  AIMP_PLAYLISTITEM_PROPID_PLAYLIST           = 8;
  AIMP_PLAYLISTITEM_PROPID_SELECTED           = 9;
  AIMP_PLAYLISTITEM_PROPID_PLAYBACKQUEUEINDEX = 10;

  // Property IDs for IAIMPPlaylistGroup
  AIMP_PLAYLISTGROUP_PROPID_NAME      = 1;
  AIMP_PLAYLISTGROUP_PROPID_EXPANDED  = 2;
  AIMP_PLAYLISTGROUP_PROPID_DURATION  = 3;
  AIMP_PLAYLISTGROUP_PROPID_INDEX     = 4;
  AIMP_PLAYLISTGROUP_PROPID_SELECTED  = 5;

  // Property IDs for IAIMPPropertyList from IAIMPPlaylistQueue
  AIMP_PLAYLISTQUEUE_PROPID_SUSPENDED = 1;

  // Property IDs for IAIMPPropertyList from IAIMPPlaylist
  AIMP_PLAYLIST_PROPID_NAME                     = 1;
  AIMP_PLAYLIST_PROPID_READONLY                 = 2;
  AIMP_PLAYLIST_PROPID_FOCUSED_OBJECT           = 3;
  AIMP_PLAYLIST_PROPID_ID                       = 4;
  AIMP_PLAYLIST_PROPID_GROUPPING                = 10;
  AIMP_PLAYLIST_PROPID_GROUPPING_OVERRIDEN      = 11;
  AIMP_PLAYLIST_PROPID_GROUPPING_TEMPLATE       = 12;
  AIMP_PLAYLIST_PROPID_GROUPPING_AUTOMERGING    = 13;
  AIMP_PLAYLIST_PROPID_FORMATING_OVERRIDEN      = 20;
  AIMP_PLAYLIST_PROPID_FORMATING_LINE1_TEMPLATE = 21;
  AIMP_PLAYLIST_PROPID_FORMATING_LINE2_TEMPLATE = 22;
  AIMP_PLAYLIST_PROPID_VIEW_OVERRIDEN           = 30;
  AIMP_PLAYLIST_PROPID_VIEW_DURATION            = 31;
  AIMP_PLAYLIST_PROPID_VIEW_EXPAND_BUTTONS      = 32;
  AIMP_PLAYLIST_PROPID_VIEW_MARKS               = 33;
  AIMP_PLAYLIST_PROPID_VIEW_NUMBERS             = 34;
  AIMP_PLAYLIST_PROPID_VIEW_NUMBERS_ABSOLUTE    = 35;
  AIMP_PLAYLIST_PROPID_VIEW_SECOND_LINE         = 36;
  AIMP_PLAYLIST_PROPID_VIEW_SWITCHES            = 37;
  AIMP_PLAYLIST_PROPID_FOCUSINDEX               = 50;
  AIMP_PLAYLIST_PROPID_PLAYBACKCURSOR           = 51;
  AIMP_PLAYLIST_PROPID_PLAYINGINDEX             = 52;
  AIMP_PLAYLIST_PROPID_SIZE                     = 53;
  AIMP_PLAYLIST_PROPID_DURATION                 = 54;
  AIMP_PLAYLIST_PROPID_PREIMAGE                 = 60;

  // Flags for IAIMPPlaylist.Add & IAIMPPlaylist.AddList
  AIMP_PLAYLIST_ADD_FLAGS_NOCHECKFORMAT = 1;
  AIMP_PLAYLIST_ADD_FLAGS_NOEXPAND      = 2;
  AIMP_PLAYLIST_ADD_FLAGS_NOTHREADING   = 4;
  AIMP_PLAYLIST_ADD_FLAGS_FILEINFO      = 8;

  // Flags for IAIMPPlaylist.Delete3
  AIMP_PLAYLIST_DELETE_FLAGS_PHYSICALLY     = 1;
  AIMP_PLAYLIST_DELETE_FLAGS_NOCONFIRMATION = 2;

  // Flags for IAIMPPlaylist.Sort
  AIMP_PLAYLIST_SORTMODE_TITLE      = 1;
  AIMP_PLAYLIST_SORTMODE_FILENAME   = 2;
  AIMP_PLAYLIST_SORTMODE_DURATION   = 3;
  AIMP_PLAYLIST_SORTMODE_ARTIST     = 4;
  AIMP_PLAYLIST_SORTMODE_INVERSE    = 5;
  AIMP_PLAYLIST_SORTMODE_RANDOMIZE  = 6;

  // Flags for IAIMPPlaylist.Close
  AIMP_PLAYLIST_CLOSE_FLAGS_FORCE_REMOVE = 1;
  AIMP_PLAYLIST_CLOSE_FLAGS_FORCE_UNLOAD = 2;

  // Flags for IAIMPPlaylist.GetFiles:
  AIMP_PLAYLIST_GETFILES_FLAGS_SELECTED_ONLY    = $1;
  AIMP_PLAYLIST_GETFILES_FLAGS_VISIBLE_ONLY     = $2;
  AIMP_PLAYLIST_GETFILES_FLAGS_COLLAPSE_VIRTUAL = $4;

  // Flags for IAIMPPlaylist.ReloadInfo
  AIMP_PLAYLIST_RELOADINFO_FLAGS_DEFAULT  = 0;
  AIMP_PLAYLIST_RELOADINFO_FLAGS_FULL     = 1;
  AIMP_PLAYLIST_RELOADINFO_FLAGS_SELECTED = 2;

  // Flags for IAIMPPlaylistListener.Changed
  AIMP_PLAYLIST_NOTIFY_NAME           = 1;
  AIMP_PLAYLIST_NOTIFY_SELECTION      = 2;
  AIMP_PLAYLIST_NOTIFY_PLAYBACKCURSOR = 4;
  AIMP_PLAYLIST_NOTIFY_READONLY       = 8;
  AIMP_PLAYLIST_NOTIFY_FOCUSINDEX     = 16;
  AIMP_PLAYLIST_NOTIFY_CONTENT        = 32;
  AIMP_PLAYLIST_NOTIFY_FILEINFO       = 64;
  AIMP_PLAYLIST_NOTIFY_STATISTICS     = 128;
  AIMP_PLAYLIST_NOTIFY_PLAYINGSWITCHS = 256;
  AIMP_PLAYLIST_NOTIFY_PREIMAGE       = 512;
  AIMP_PLAYLIST_NOTIFY_MODIFIED       = 1024;
  AIMP_PLAYLIST_NOTIFY_DEADSTATE      = 2048;
  AIMP_PLAYLIST_NOTIFY_MAKEVISIBLE    = 4096;

  // Properties Ids for IAIMPPlaylistPreimage
  AIMP_PLAYLISTPREIMAGE_PROPID_FACTORYID            = 1;
  AIMP_PLAYLISTPREIMAGE_PROPID_AUTOSYNC             = 2;
  AIMP_PLAYLISTPREIMAGE_PROPID_HASDIALOG            = 3;
  AIMP_PLAYLISTPREIMAGE_PROPID_SORTTEMPLATE         = 4;
  AIMP_PLAYLISTPREIMAGE_PROPID_AUTOSYNC_ON_STARTUP  = 5; 

  // Properties Ids for AIMP_PREIMAGEFACTORY_PLAYLIST_ID
  AIMP_PLAYLISTPREIMAGE_PLAYLISTBASED_PROPID_URI    = 100;

  // Flags for IAIMPExtensionPlaylistPreimageFactory.GetFlags
  AIMP_PREIMAGEFACTORY_FLAG_CONTEXTDEPENDENT = 1;

  // Built-in Preimage Factories
  AIMP_PREIMAGEFACTORY_FOLDERS_ID      = 'TAIMPPlaylistFoldersPreimage';
  AIMP_PREIMAGEFACTORY_MUSICLIBRARY_ID = 'TAIMPMLPlaylistPreimage';
  AIMP_PREIMAGEFACTORY_PLAYLIST_ID     = 'TAIMPPlaylistBasedPreimage';

type
  IAIMPPlaylistPreimageListener = interface;

//----------------------------------------------------------------------------------------------------------------------
// Common Classes
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPPlaylistItem }

  IAIMPPlaylistItem = interface(IAIMPPropertyList)
  [SID_IAIMPPlaylistItem]
    function ReloadInfo: HRESULT; stdcall;
  end;

  { IAIMPPlaylistGroup }

  IAIMPPlaylistGroup = interface(IAIMPPropertyList)
  [SID_IAIMPPlaylistGroup]
    function GetItem(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetItemCount: Integer; stdcall;
  end;

  { IAIMPPlaylistListener }

  IAIMPPlaylistListener = interface(IUnknown)
  [SID_IAIMPPlaylistListener]
    procedure Activated; stdcall;
    procedure Changed(Flags: DWORD); stdcall;
    procedure Removed; stdcall;
  end;

  { IAIMPPlaylistListener2 }

  IAIMPPlaylistListener2 = interface(IUnknown)
  [SID_IAIMPPlaylistListener2]
    procedure ScanningBegin; stdcall;
    procedure ScanningProgress(const Progress: Double); stdcall;
    procedure ScanningEnd(HasChanges, Canceled: LongBool); stdcall;
  end;

  { IAIMPPlaylist }

  TAIMPPlaylistCompareProc = function (Item1, Item2: IAIMPPlaylistItem; UserData: Pointer): Integer; stdcall;
  TAIMPPlaylistDeleteProc = function (Item: IAIMPPlaylistItem; UserData: Pointer): LongBool; stdcall;

  IAIMPPlaylist = interface(IUnknown)
  [SID_IAIMPPlaylist]
    // Adding
    function Add(Obj: IUnknown; Flags: DWORD; InsertIn: Integer): HRESULT; stdcall;
    function AddList(ObjList: IAIMPObjectList; Flags: DWORD; InsertIn: Integer): HRESULT; stdcall;
    // Deleting
    function Delete(Item: IAIMPPlaylistItem): HRESULT; stdcall;
    function Delete2(ItemIndex: Integer): HRESULT; stdcall;
    function Delete3(Flags: DWORD; Proc: TAIMPPlaylistDeleteProc; UserData: Pointer): HRESULT; stdcall;
    function DeleteAll: HRESULT; stdcall;
    // Sorting
    function Sort(Mode: Integer): HRESULT; stdcall;
    function Sort2(Template: IAIMPString): HRESULT; stdcall;
    function Sort3(Proc: TAIMPPlaylistCompareProc; UserData: Pointer): HRESULT; stdcall;
    // Locking
    function BeginUpdate: HRESULT; stdcall;
    function EndUpdate: HRESULT; stdcall;
    // Other Commands
    function Close(Flags: DWORD): HRESULT; stdcall;
    function GetFiles(Flags: DWORD; out List: IAIMPObjectList): HRESULT; stdcall;
    function MergeGroup(Group: IAIMPPlaylistGroup): HRESULT; stdcall;
    function ReloadFromPreimage: HRESULT; stdcall;
    function ReloadInfo(Flags: DWORD): HRESULT; stdcall;
    // Items
    function GetItem(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetItemCount: Integer; stdcall;
    // Groups
    function GetGroup(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetGroupCount: Integer; stdcall;
    // Listener
    function ListenerAdd(AListener: IAIMPPlaylistListener): HRESULT; stdcall;
    function ListenerRemove(AListener: IAIMPPlaylistListener): HRESULT; stdcall;
  end;

  { IAIMPPlaylistPreimage }

  IAIMPPlaylistPreimage = interface(IAIMPPropertyList)
  [SID_IAIMPPlaylistPreimage]
    procedure Finalize; stdcall;
    procedure Initialize(Listener: IAIMPPlaylistPreimageListener); stdcall;

    function ConfigLoad(Stream: IAIMPStream): HRESULT; stdcall;
    function ConfigSave(Stream: IAIMPStream): HRESULT; stdcall;
    function ExecuteDialog(OwnerWndHanle: HWND): HRESULT; stdcall;
  end;

  { IAIMPPlaylistPreimageDataProvider }

  IAIMPPlaylistPreimageDataProvider = interface
  [SID_IAIMPPlaylistPreimageDataProvider]
    function GetFiles(Owner: IAIMPTaskOwner; out Flags: DWORD; out List: IAIMPObjectList): HRESULT; stdcall;
  end;

  { IAIMPPlaylistPreimageListener }

  IAIMPPlaylistPreimageListener = interface
  [SID_IAIMPPlaylistPreimageListener]
    function DataChanged: HRESULT; stdcall;
    function SettingsChanged: HRESULT; stdcall;
  end;

  { IAIMPPlaylistPreimageFolders }

  IAIMPPlaylistPreimageFolders = interface(IAIMPPlaylistPreimage)
  [SID_IAIMPPlaylistPreimageFolders]
    function ItemsAdd(Path: IAIMPString; Recursive: LongBool): HRESULT; stdcall;
    function ItemsDelete(Index: Integer): HRESULT; stdcall;
    function ItemsDeleteAll: HRESULT; stdcall;
    function ItemsGet(Index: Integer; out Path: IAIMPString; out Recursive: LongBool): HRESULT; stdcall;
    function ItemsGetCount: Integer; stdcall;
  end;

  { IAIMPPlaylistQueue }

  IAIMPPlaylistQueue = interface(IUnknown)
  [SID_IAIMPPlaylistQueue]
    // Adding
    function Add(Item: IAIMPPlaylistItem; InsertAtBeginning: LongBool): HRESULT; stdcall;
    function AddList(ItemList: IAIMPObjectList; InsertAtBeginning: LongBool): HRESULT; stdcall;
    // Deleting
    function Delete(Item: IAIMPPlaylistItem): HRESULT; stdcall;
    function Delete2(Playlist: IAIMPPlaylist): HRESULT; stdcall;
    // Reordering
    function Move(Item: IAIMPPlaylistItem; TargetIndex: Integer): HRESULT; stdcall;
    function Move2(ItemIndex, TargetIndex: Integer): HRESULT; stdcall;
    // Items
    function GetItem(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetItemCount: Integer; stdcall;
  end;

  { IAIMPPlaylistQueueListener }

  IAIMPPlaylistQueueListener = interface(IUnknown)
  [SID_IAIMPPlaylistQueueListener]
    procedure ContentChanged; stdcall;
    procedure StateChanged; stdcall;
  end;

  { IAIMPPlaylistQueue2 }

  IAIMPPlaylistQueue2 = interface(IAIMPPlaylistQueue)
  [SID_IAIMPPlaylistQueue2]
    // Listener
    function ListenerAdd(AListener: IAIMPPlaylistQueueListener): HRESULT; stdcall;
    function ListenerRemove(AListener: IAIMPPlaylistQueueListener): HRESULT; stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Extensions
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPExtensionPlaylistPreimageFactory }

  IAIMPExtensionPlaylistPreimageFactory = interface
  [SID_IAIMPExtensionPlaylistPreimageFactory]
    function CreatePreimage(out Intf: IAIMPPlaylistPreimage): HRESULT; stdcall;
    function GetID(out ID: IAIMPString): HRESULT; stdcall;
    function GetName(out Name: IAIMPString): HRESULT; stdcall;
    function GetFlags: DWORD; stdcall;
  end;

  { IAIMPExtensionPlaylistManagerListener }

  IAIMPExtensionPlaylistManagerListener = interface(IUnknown)
  [SID_IAIMPExtensionPlaylistManagerListener]
    procedure PlaylistActivated(Playlist: IAIMPPlaylist); stdcall;
    procedure PlaylistAdded(Playlist: IAIMPPlaylist); stdcall;
    procedure PlaylistRemoved(Playlist: IAIMPPlaylist); stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Services
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPServicePlaylistManager }

  IAIMPServicePlaylistManager = interface(IUnknown)
  [SID_IAIMPServicePlaylistManager]
    // Creating Playlist
    function CreatePlaylist(Name: IAIMPString; Activate: LongBool; out Playlist: IAIMPPlaylist): HRESULT; stdcall;
    function CreatePlaylistFromFile(FileName: IAIMPString; Activate: LongBool; out Playlist: IAIMPPlaylist): HRESULT; stdcall;
    // Active Playlist
    function GetActivePlaylist(out Playlist: IAIMPPlaylist): HRESULT; stdcall;
    function SetActivePlaylist(Playlist: IAIMPPlaylist): HRESULT; stdcall;
    // Playable Playlist
    function GetPlayablePlaylist(out Playlist: IAIMPPlaylist): HRESULT; stdcall;
    // Loaded Playlists
    function GetLoadedPlaylist(Index: Integer; out Playlist: IAIMPPlaylist): HRESULT; stdcall;
    function GetLoadedPlaylistByName(Name: IAIMPString; out Playlist: IAIMPPlaylist): HRESULT; stdcall;
    function GetLoadedPlaylistCount: Integer; stdcall;
    function GetLoadedPlaylistByID(ID: IAIMPString; out Playlist: IAIMPPlaylist): HRESULT; stdcall;
  end;

  { IAIMPServicePlaylistManager2 }

  IAIMPServicePlaylistManager2 = interface(IAIMPServicePlaylistManager)
  [SID_IAIMPServicePlaylistManager2]
    function GetPreimageFactory(Index: Integer; out Factory: IAIMPExtensionPlaylistPreimageFactory): HRESULT; stdcall;
    function GetPreimageFactoryByID(ID: IAIMPString; out Factory: IAIMPExtensionPlaylistPreimageFactory): HRESULT; stdcall;
    function GetPreimageFactoryCount: Integer; stdcall;
  end;

implementation

end.
