{************************************************}
{*                                              *}
{*          AIMP Programming Interface          *}
{*               v4.50 build 2000               *}
{*                                              *}
{*                Artem Izmaylov                *}
{*                (C) 2006-2017                 *}
{*                 www.aimp.ru                  *}
{*                                              *}
{*            Mail: support@aimp.ru             *}
{*                                              *}
{************************************************}

unit apiMusicLibrary;

{$I apiConfig.inc}

interface

uses
  Windows, ActiveX, apiObjects, apiActions, apiPlaylists;

const
  SID_IAIMPServiceMusicLibrary = '{41494D50-5372-764D-4C00-000000000000}';
  IID_IAIMPServiceMusicLibrary: TGUID = SID_IAIMPServiceMusicLibrary;

  SID_IAIMPServiceMusicLibraryUI = '{41494D50-5372-764D-4C55-490000000000}';
  IID_IAIMPServiceMusicLibraryUI: TGUID = SID_IAIMPServiceMusicLibraryUI;

  SID_IAIMPMLExtensionDataStorage = '{41494D50-4578-744D-4C44-530000000000}';
  IID_IAIMPMLExtensionDataStorage: TGUID = SID_IAIMPMLExtensionDataStorage;

  SID_IAIMPMLDataProvider = '{41494D50-4D4C-4461-7461-507276000000}';
  IID_IAIMPMLDataProvider: TGUID = SID_IAIMPMLDataProvider;

  SID_IAIMPMLDataProviderSelection = '{41494D50-4D4C-4461-7461-50727653656C}';
  IID_IAIMPMLDataProviderSelection: TGUID = SID_IAIMPMLDataProviderSelection;

  SID_IAIMPMLGroupingTreeDataProvider = '{41494D50-4D4C-4772-7044-617461507276}';
  IID_IAIMPMLGroupingTreeDataProvider: TGUID = SID_IAIMPMLGroupingTreeDataProvider;

  SID_IAIMPMLGroupingTreeDataProviderSelection = '{41494D50-4D4C-4772-4474-50727653656C}';
  IID_IAIMPMLGroupingTreeDataProviderSelection: TGUID = SID_IAIMPMLGroupingTreeDataProviderSelection;

  SID_IAIMPMLGroupingTreeSelection = '{41494D50-4D4C-4770-5472-656553656C00}';
  IID_IAIMPMLGroupingTreeSelection: TGUID = SID_IAIMPMLGroupingTreeSelection;

  SID_IAIMPMLDataField = '{41494D50-4D4C-4461-7461-466C64000000}';
  IID_IAIMPMLDataField: TGUID = SID_IAIMPMLDataField;

  SID_IAIMPMLDataFieldDisplayValue = '{41494D50-4D4C-4461-7461-466C6444566C}';
  IID_IAIMPMLDataFieldDisplayValue: TGUID = SID_IAIMPMLDataFieldDisplayValue;

  SID_IAIMPMLDataFieldFilter = '{41494D50-4D4C-466C-6446-6C7400000000}';
  IID_IAIMPMLDataFieldFilter: TGUID = SID_IAIMPMLDataFieldFilter;

  SID_IAIMPMLDataFieldFilterByArray = '{41494D50-4D4C-466C-6446-6C7441727200}';
  IID_IAIMPMLDataFieldFilterByArray: TGUID = SID_IAIMPMLDataFieldFilterByArray;

  SID_IAIMPMLDataFilter = '{41494D50-4D4C-4669-6C74-657200000000}';
  IID_IAIMPMLDataFilter: TGUID = SID_IAIMPMLDataFilter;

  SID_IAIMPMLDataFilterGroup = '{41494D50-4D4C-466C-7447-727000000000}';
  IID_IAIMPMLDataFilterGroup: TGUID = SID_IAIMPMLDataFilterGroup;

  SID_IAIMPMLDataStorageManager = '{41494D50-4D4C-4453-4D6E-677200000000}';
  IID_IAIMPMLDataStorageManager: TGUID = SID_IAIMPMLDataStorageManager;

  SID_IAIMPMLDataStorageCommandAddFiles = '{41494D50-4D4C-4453-436D-644164640000}';
  IID_IAIMPMLDataStorageCommandAddFiles: TGUID = SID_IAIMPMLDataStorageCommandAddFiles;

  SID_IAIMPMLDataStorageCommandAddFilesDialog = '{41494D50-4D4C-4453-436D-644164644400}';
  IID_IAIMPMLDataStorageCommandAddFilesDialog: TGUID = SID_IAIMPMLDataStorageCommandAddFilesDialog;

  SID_IAIMPMLDataStorageCommandReportDialog = '{41494D50-4D4C-4453-436D-645270727400}';
  IID_IAIMPMLDataStorageCommandReportDialog: TGUID = SID_IAIMPMLDataStorageCommandReportDialog;

  SID_IAIMPMLDataStorageCommandDeleteFiles = '{41494D50-4D4C-4453-436D-6444656C0000}';
  IID_IAIMPMLDataStorageCommandDeleteFiles: TGUID = SID_IAIMPMLDataStorageCommandDeleteFiles;

  SID_IAIMPMLDataStorageCommandDeleteFiles2 = '{41494D50-4D4C-4453-436D-6444656C3200}';
  IID_IAIMPMLDataStorageCommandDeleteFiles2: TGUID = SID_IAIMPMLDataStorageCommandDeleteFiles2;

  SID_IAIMPMLDataStorageCommandDropData = '{41494D50-4D4C-4453-436D-6444726F7000}';
  IID_IAIMPMLDataStorageCommandDropData: TGUID = SID_IAIMPMLDataStorageCommandDropData;

  SID_IAIMPMLDataStorageCommandReloadTags = '{41494D50-4D4C-4453-436D-645570546167}';
  IID_IAIMPMLDataStorageCommandReloadTags: TGUID = SID_IAIMPMLDataStorageCommandReloadTags;

  SID_IAIMPMLDataStorageCommandUserMark = '{41494D50-4D4C-4453-436D-644D61726B00}';
  IID_IAIMPMLDataStorageCommandUserMark: TGUID = SID_IAIMPMLDataStorageCommandUserMark;

  SID_IAIMPMLFileList = '{41494D50-4D4C-4669-6C65-4C6973740000}';
  IID_IAIMPMLFileList: TGUID = SID_IAIMPMLFileList;

  SID_IAIMPMLPlaylistPreimage = '{414D4C53-6D50-6C73-5372-630000000000}';
  IID_IAIMPMLPlaylistPreimage: TGUID = SID_IAIMPMLPlaylistPreimage;

  SID_IAIMPMLGroupingPreset = '{41494D50-4D4C-4772-7050-737400000000}';
  IID_IAIMPMLGroupingPreset: TGUID = SID_IAIMPMLGroupingPreset;

  SID_IAIMPMLGroupingPresets = '{41494D50-4D4C-4772-5072-737473000000}';
  IID_IAIMPMLGroupingPresets: TGUID = SID_IAIMPMLGroupingPresets;

  SID_IAIMPMLGroupingPresetStandard = '{41494D50-4D4C-4772-7050-737453746400}';
  IID_IAIMPMLGroupingPresetStandard: TGUID = SID_IAIMPMLGroupingPresetStandard;

  SID_IAIMPMLDataStorage = '{41494D50-4D4C-4461-7461-537467000000}';
  IID_IAIMPMLDataStorage: TGUID = SID_IAIMPMLDataStorage;

  SID_IAIMPMLSortDirection = '{41494D50-4D4C-536F-7274-446972746E00}';
  IID_IAIMPMLSortDirection: TGUID = SID_IAIMPMLSortDirection;

  // Property ID for IAIMPPropertyList of IAIMPMLExtensionDataStorage and IAIMPMLDataStorage
  AIMPML_DATASTORAGE_PROPID_ID              = 0;
  AIMPML_DATASTORAGE_PROPID_CAPTION         = 1;
  AIMPML_DATASTORAGE_PROPID_CAPABILITIES    = 2;
  AIMPML_DATASTORAGE_PROPID_GROUPINGPRESET  = 20;

  // List of known Capabilities for AIMPML_DATASTORAGE_PROPID_CAPABILITIES
  AIMPML_DATASTORAGE_CAP_FILTERING          = 1; // return it, if plugin has own implementation of data filtering
  AIMPML_DATASTORAGE_CAP_PREIMAGES          = 2;
  AIMPML_DATASTORAGE_CAP_GROUPINGPRESETS    = 4;
  AIMPML_DATASTORAGE_CAP_CUSTOMIZEGROUPS    = 8;

  // Schema Flags for IAIMPMLExtensionDataStorage.GetFields
  AIMPML_FIELDS_SCHEMA_ALL                        = 0;
  AIMPML_FIELDS_SCHEMA_TABLE_GROUPBY              = 2;
  AIMPML_FIELDS_SCHEMA_TABLE_GROUPDETAILS         = 3;
  AIMPML_FIELDS_SCHEMA_TABLE_VIEW_DEFAULT         = 10;
  AIMPML_FIELDS_SCHEMA_TABLE_VIEW_GROUPDETAILS    = 11;
  AIMPML_FIELDS_SCHEMA_TABLE_VIEW_ALBUMTHUMBNAILS = 12;

  // Schema Flags for IAIMPMLExtensionDataStorage.GetGroupingPresets
  AIMPML_GROUPINGPRESETS_SCHEMA_BUILTIN = 1;
  AIMPML_GROUPINGPRESETS_SCHEMA_DEFAULT = 2;

  // Property ID for IAIMPMLGroupingPreset
  AIMPML_GROUPINGPRESET_PROPID_CUSTOM   = 0;
  AIMPML_GROUPINGPRESET_PROPID_ID       = 1;
  AIMPML_GROUPINGPRESET_PROPID_NAME     = 2;

  // Property ID for IAIMPMLGroupingPresetStandard
  AIMPML_GROUPINGPRESETSTD_PROPID_FIELDS = 10;

  // Property ID for IAIMPMLDataField
  AIMPML_FIELD_PROPID_CUSTOM       = 0;
  AIMPML_FIELD_PROPID_NAME         = 1;
  AIMPML_FIELD_PROPID_TYPE         = 2;
  AIMPML_FIELD_PROPID_FLAGS        = 3;
  AIMPML_FIELD_PROPID_IMAGE        = 4;
  AIMPML_FIELD_PROPID_DISPLAYVALUE = 5;

  // ImageIndexes for AIMPML_FIELD_PROPID_IMAGE
  AIMPML_FIELDIMAGE_FOLDER   = 0;
  AIMPML_FIELDIMAGE_ARTIST   = 1;
  AIMPML_FIELDIMAGE_DISK     = 2;
  AIMPML_FIELDIMAGE_NOTE     = 3;
  AIMPML_FIELDIMAGE_STAR     = 4;
  AIMPML_FIELDIMAGE_CALENDAR = 5;
  AIMPML_FIELDIMAGE_LABEL    = 6;

  // Field Types
  AIMPML_FIELDTYPE_INT32       = 1;
  AIMPML_FIELDTYPE_INT64       = 2;
  AIMPML_FIELDTYPE_FLOAT       = 3;
  AIMPML_FIELDTYPE_STRING      = 4;
  AIMPML_FIELDTYPE_DATETIME    = 10;
  AIMPML_FIELDTYPE_DURATION    = 11;
  AIMPML_FIELDTYPE_FILESIZE    = 12;
  AIMPML_FIELDTYPE_FILENAME    = 13;

  // Field Flags
  AIMPML_FIELDFLAG_GROUPING    = 1;
  AIMPML_FIELDFLAG_FILTERING   = 2;
  AIMPML_FIELDFLAG_INTERNAL    = 4;
  AIMPML_FIELDFLAG_REQUIRED    = 8;

  // Built-in Reserved Field Names
  AIMPML_RESERVED_FIELD_ID       = 'ID';       // !REQUIRED! unique record id (Int32, Int64 or String)
  AIMPML_RESERVED_FIELD_FILENAME = 'FileName'; // !REQUIRED! string
  AIMPML_RESERVED_FIELD_FILESIZE = 'FileSize'; // Int64, in bytes
  AIMPML_RESERVED_FIELD_DURATION = 'Duration'; // double, in seconds
  AIMPML_RESERVED_FIELD_USERMARK = 'UserMark'; // integer, 0.0 .. 5.0

  // Property ID for IAIMPMLDataFieldFilter
  AIMPML_FIELDFILTER_FIELD     = 1;
  AIMPML_FIELDFILTER_OPERATION = 2; // Refer to the AIMPML_FIELDFILTER_OPERATION_XXX
  AIMPML_FIELDFILTER_VALUE1    = 3;
  AIMPML_FIELDFILTER_VALUE2    = 4;

  // FieldFilter Operations
  AIMPML_FIELDFILTER_OPERATION_EQUALS = 0;
  AIMPML_FIELDFILTER_OPERATION_NOTEQUALS = 1;
  AIMPML_FIELDFILTER_OPERATION_BETWEEN = 2;
  AIMPML_FIELDFILTER_OPERATION_LESSTHAN = 3;
  AIMPML_FIELDFILTER_OPERATION_LESSTHANOREQUALS = 4;
  AIMPML_FIELDFILTER_OPERATION_GREATERTHAN = 5;
  AIMPML_FIELDFILTER_OPERATION_GREATERTHANOREQUALS = 6;
  AIMPML_FIELDFILTER_OPERATION_CONTAINS = 7;
  AIMPML_FIELDFILTER_OPERATION_BEGINSWITH = 8;
  AIMPML_FIELDFILTER_OPERATION_ENDSWITH = 9;

  // Property ID for IAIMPMLDataFilterGroup
  AIMPML_FILTERGROUP_OPERATION = 1; // Refer to the AIMPML_FILTERGROUP_OPERATION_XXX

  // FilterGroup Operations
  AIMPML_FILTERGROUP_OPERATION_OR = 0;
  AIMPML_FILTERGROUP_OPERATION_AND = 1;
  AIMPML_FILTERGROUP_OPERATION_NOTOR = 2;
  AIMPML_FILTERGROUP_OPERATION_NOTAND = 3;

  // Property ID for IAIMPMLDataFieldFilterByArray
  AIMPML_FIELDFILTERBYARRAY_FIELD = 1;

  // Property ID for IAIMPMLDataFilter
  AIMPML_FILTER_LIMIT           = 11;
  AIMPML_FILTER_OFFSET          = 12;
  AIMPML_FILTER_SORTBY          = 13;
  AIMPML_FILTER_SORTDIRECTION   = 14; // Refer to the AIMPML_SORTDIRECTION_XXX
  AIMPML_FILTER_SEARCHSTRING    = 20; // optional
  AIMPML_FILTER_ALPHABETICINDEX = 21; // optional

  // Sort Direction
  AIMPML_SORTDIRECTION_ASCENDING  = 1;
  AIMPML_SORTDIRECTION_DESCENDING = 2;

  // Flags for IAIMPMLGroupingTreeDataProvider.GetCapabilities
  AIMPML_GROUPINGTREEDATAPROVIDER_CAP_HIDEALLDATA = 1;
  AIMPML_GROUPINGTREEDATAPROVIDER_CAP_DONTSORT    = 2;

  // Flags for IAIMPMLGroupingTreeDataProviderSelection.GetFlags
  AIMPML_GROUPINGTREENODE_FLAG_HASCHILDREN = 1;
  AIMPML_GROUPINGTREENODE_FLAG_STANDALONE  = 2;

  // Flags for IAIMPServiceMusicLibraryUI.GetFiles
  AIMPML_GETFILES_FLAGS_ALL      = 0;
  AIMPML_GETFILES_FLAGS_SELECTED = 1;
  AIMPML_GETFILES_FLAGS_FOCUSED  = 2;

type

//----------------------------------------------------------------------------------------------------------------------
// Common Classes
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPMLDataField }

  IAIMPMLDataField = interface(IAIMPPropertyList)
  [SID_IAIMPMLDataField]
  end;

  { IAIMPMLDataFieldDisplayValue }

  IAIMPMLDataFieldDisplayValue = interface
  [SID_IAIMPMLDataFieldDisplayValue]
    function GetDisplayValue(const Value: OleVariant; out Length: Integer): PWideChar; stdcall;
  end;

  { IAIMPMLDataFieldFilter }

  IAIMPMLDataFieldFilter = interface(IAIMPPropertyList2)
  [SID_IAIMPMLDataFieldFilter]
  end;

  { IAIMPMLDataFieldFilterByArray }

  IAIMPMLDataFieldFilterByArray = interface(IAIMPPropertyList2)
  [SID_IAIMPMLDataFieldFilterByArray]
    function GetData(Values: POleVariant; var Count: Integer): HRESULT; stdcall;
    function SetData(Values: POleVariant; Count: Integer): HRESULT; stdcall;
  end;

  { IAIMPMLDataFilterGroup }

  IAIMPMLDataFilterGroup = interface(IAIMPPropertyList2)
  [SID_IAIMPMLDataFilterGroup]
    function Add(Field: IUnknown; const Value1, Value2: OleVariant;
      Operation: Integer; out Filter: IAIMPMLDataFieldFilter): HRESULT; stdcall;
    function Add2(Field: IUnknown; Values: POleVariant;
      Count: Integer; out Filter: IAIMPMLDataFieldFilterByArray): HRESULT; stdcall;
    function AddGroup(out Group: IAIMPMLDataFilterGroup): HRESULT; stdcall;
    function Clear: HRESULT; stdcall;
    function Delete(Index: Integer): HRESULT; stdcall;
    function GetChild(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetChildCount: Integer; stdcall;
  end;

  { IAIMPMLDataFilter }

  IAIMPMLDataFilter = interface(IAIMPMLDataFilterGroup)
  [SID_IAIMPMLDataFilter]
    function Assign(Source: IAIMPMLDataFilter): HRESULT; stdcall;
    function Clone(out Filter): HRESULT; stdcall;
  end;

  { IAIMPMLFileList }

  IAIMPMLFileList = interface
  [SID_IAIMPMLFileList]
    function Add(const ID: OleVariant; FileName: IAIMPString): HRESULT; stdcall;
    function Clear: HRESULT; stdcall;
    function Delete(Index: Integer): HRESULT; stdcall;
    function Insert(Index: Integer; const ID: OleVariant; FileName: IAIMPString): HRESULT; stdcall;

    function GetCount: Integer; stdcall;
    function GetFileName(Index: Integer; out FileName: IAIMPString): HRESULT; stdcall;
    function SetFileName(Index: Integer; FileName: IAIMPString): HRESULT; stdcall;
    function GetID(Index: Integer; out ID: OleVariant): HRESULT; stdcall;
    function SetID(Index: Integer; const ID: OleVariant): HRESULT; stdcall;

    function Clone(out Obj): HRESULT; stdcall;
  end;

  { IAIMPMLSortDirection }

  IAIMPMLSortDirection = interface
  [SID_IAIMPMLSortDirection]
    function GetValue(out Value: Integer): HRESULT; stdcall;
    function SetValue(Value: Integer): HRESULT; stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Commands
//----------------------------------------------------------------------------------------------------------------------

  IAIMPMLDataStorageCommandAddFiles = interface
  [SID_IAIMPMLDataStorageCommandAddFiles]
    function Add(Files: IAIMPObjectList): HRESULT; stdcall;
  end;

  { IAIMPMLDataStorageCommandAddFilesDialog }

  IAIMPMLDataStorageCommandAddFilesDialog = interface
  [SID_IAIMPMLDataStorageCommandAddFilesDialog]
    function Execute(OwnerHandle: HWND): HRESULT; stdcall;
  end;

  { IAIMPMLDataStorageCommandDeleteFiles }

  IAIMPMLDataStorageCommandDeleteFiles = interface
  [SID_IAIMPMLDataStorageCommandDeleteFiles]
    function CanDelete(Physically: LongBool): LongBool; stdcall;
    function Delete(Files: IAIMPMLFileList; Physically: LongBool): HRESULT; stdcall;
  end;

  { IAIMPMLDataStorageCommandDeleteFiles2 }

  IAIMPMLDataStorageCommandDeleteFiles2 = interface(IAIMPMLDataStorageCommandDeleteFiles)
  [SID_IAIMPMLDataStorageCommandDeleteFiles2]
    function Delete2(Filter: IAIMPMLDataFilter; Physically: LongBool): HRESULT; stdcall;
  end;

  { IAIMPMLDataStorageCommandDropData }

  IAIMPMLDataStorageCommandDropData = interface
  [SID_IAIMPMLDataStorageCommandDropData]
    function DropData: HRESULT; stdcall;
  end;

  { IAIMPMLDataStorageCommandReloadTags }

  IAIMPMLDataStorageCommandReloadTags = interface
  [SID_IAIMPMLDataStorageCommandReloadTags]
    function ReloadTags(Files: IAIMPMLFileList): HRESULT; stdcall;
  end;

  { IAIMPMLDataStorageCommandReportDialog }

  IAIMPMLDataStorageCommandReportDialog = interface
  [SID_IAIMPMLDataStorageCommandReportDialog]
    function Execute(OwnerHandle: HWND): HRESULT; stdcall;
  end;

  { IAIMPMLDataStorageCommandUserMark }

  IAIMPMLDataStorageCommandUserMark = interface
  [SID_IAIMPMLDataStorageCommandUserMark]
    function SetMark(const ID: OleVariant; const Value: Double): HRESULT; stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Preimage
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPMLPlaylistPreimage }

  IAIMPMLPlaylistPreimage = interface(IAIMPPlaylistPreimage)
  [SID_IAIMPMLPlaylistPreimage]
    function GetFilter(out Filter: IAIMPMLDataFilter): HRESULT; stdcall;
    function GetStorage(out Storage: IUnknown): HRESULT; stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Data Providers
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPMLDataProvider }

  IAIMPMLDataProvider = interface
  [SID_IAIMPMLDataProvider]
    function GetData(Fields: IAIMPObjectList; Filter: IAIMPMLDataFilter; out Data: IUnknown): HRESULT; stdcall;
  end;

  { IAIMPMLDataProviderSelection }

  IAIMPMLDataProviderSelection = interface
  [SID_IAIMPMLDataProviderSelection]
    function GetValueAsFloat(FieldIndex: Integer): Double; stdcall;
    function GetValueAsInt32(FieldIndex: Integer): Integer; stdcall;
    function GetValueAsInt64(FieldIndex: Integer): Int64; stdcall;
    function GetValueAsString(FieldIndex: Integer; out Length: Integer): PWideChar; stdcall;
    function NextRow: LongBool; stdcall;
    function HasNextPage: LongBool; stdcall;
  end;

  { IAIMPMLGroupingTreeSelection }

  IAIMPMLGroupingTreeSelection = interface
  [SID_IAIMPMLGroupingTreeSelection]
    function GetCount: Integer; stdcall;
    function GetValue(Index: Integer; out FieldName: IAIMPString; out Value: OleVariant): HRESULT; stdcall;
  end;

  { IAIMPMLGroupingTreeDataProviderSelection }

  IAIMPMLGroupingTreeDataProviderSelection = interface
  [SID_IAIMPMLGroupingTreeDataProviderSelection]
    function GetDisplayValue(out S: IAIMPString): HRESULT; stdcall;
    function GetFlags: DWORD; stdcall;
    function GetImageIndex(out Index: Integer): HRESULT; stdcall;
    function GetValue(out FieldName: IAIMPString; out Value: OleVariant): HRESULT; stdcall;
    function NextRecord: LongBool; stdcall;
  end;

  { IAIMPMLGroupingTreeDataProvider }

  IAIMPMLGroupingTreeDataProvider = interface
  [SID_IAIMPMLGroupingTreeDataProvider]
    function AppendFilter(Filter: IAIMPMLDataFilterGroup; Selection: IAIMPMLGroupingTreeSelection): HRESULT; stdcall;
    function GetCapabilities: DWORD; stdcall;
    function GetData(Selection: IAIMPMLGroupingTreeSelection; out Data: IAIMPMLGroupingTreeDataProviderSelection): HRESULT; stdcall;
    function GetFieldForAlphabeticIndex(out FieldName: IAIMPString): HRESULT; stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Storage
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPMLGroupingPreset }

  IAIMPMLGroupingPreset = interface(IAIMPPropertyList)
  [SID_IAIMPMLGroupingPreset]
  end;

  { IAIMPMLGroupingPresetStandard }

  IAIMPMLGroupingPresetStandard = interface(IAIMPMLGroupingPreset)
  [SID_IAIMPMLGroupingPresetStandard]
    function GetFilter(out Filter: IAIMPMLDataFilterGroup): HRESULT; stdcall;
  end;

  { IAIMPMLGroupingPresets }

  IAIMPMLGroupingPresets = interface
  [SID_IAIMPMLGroupingPresets]
    function BeginUpdate: HRESULT; stdcall;
    function EndUpdate: HRESULT; stdcall;

    function Add(ID, Name: IAIMPString; Reserved: Cardinal;
      Provider: IAIMPMLGroupingTreeDataProvider; out Preset: IAIMPMLGroupingPreset): HRESULT; stdcall;
    function Add2(ID, Name: IAIMPString; Reserved: Cardinal;
      FieldNames: IAIMPObjectList; out Preset: IAIMPMLGroupingPresetStandard): HRESULT; stdcall;
    function Add3(ID, Name: IAIMPString; Reserved: Cardinal;
      FieldName: IAIMPString; out Preset: IAIMPMLGroupingPresetStandard): HRESULT; stdcall;
    function Delete(Index: Integer): HRESULT; stdcall;
    function Get(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetByID(ID: IAIMPString; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetCount: Integer; stdcall;
  end;

  { IAIMPMLDataStorageManager }

  IAIMPMLDataStorageManager = interface
  [SID_IAIMPMLDataStorageManager]
    procedure BackgroundTaskStarted(ID: NativeInt; Caption: IAIMPString; CancelEvent: IAIMPActionEvent); stdcall;
    procedure BackgroundTaskFinished(ID: NativeInt); stdcall;
    procedure Changed; stdcall;
  end;

  IAIMPMLDataStorage = interface(IAIMPPropertyList) // + IAIMPMLGroupingPresets
  [SID_IAIMPMLDataStorage]
  end;

//----------------------------------------------------------------------------------------------------------------------
// Extensions
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPMLExtensionDataStorage }

  IAIMPMLExtensionDataStorage = interface(IAIMPPropertyList) // + IAIMPMLDataProvider
  [SID_IAIMPMLExtensionDataStorage]
    procedure Finalize; stdcall;
    procedure Initialize(Manager: IAIMPMLDataStorageManager); stdcall;
    // Config
    function ConfigLoad(Config: IAIMPConfig; Section: IAIMPString): HRESULT; stdcall;
    function ConfigSave(Config: IAIMPConfig; Section: IAIMPString): HRESULT; stdcall;
    // Schemas
    function GetFields(Schema: Integer; out List: IAIMPObjectList): HRESULT; stdcall;
    function GetGroupingPresets(Schema: Integer; Presets: IAIMPMLGroupingPresets): HRESULT; stdcall;
    // Build-in Commands
    procedure FlushCache(Reserved: Integer = 0); stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Services
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPServiceMusicLibrary }

  IAIMPServiceMusicLibrary = interface
  [SID_IAIMPServiceMusicLibrary]
    function GetActiveStorage(const IID: TGUID; out Obj): HRESULT; stdcall;
    function SetActiveStorage(Storage: IUnknown): HRESULT; stdcall;

    function GetStorage(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetStorageByID(ID: IAIMPString; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetStorageCount: Integer; stdcall;
  end;

  { IAIMPServiceMusicLibraryUI }

  IAIMPServiceMusicLibraryUI = interface
  [SID_IAIMPServiceMusicLibraryUI]
    function GetFiles(Flags: DWORD; out List: IAIMPMLFileList): HRESULT; stdcall;
    function GetGroupingFilter(out Filter: IAIMPMLDataFilter): HRESULT; stdcall;
    function GetGroupingFilterPath(out Path: IAIMPString): HRESULT; stdcall;
    function SetGroupingFilterPath(Path: IAIMPString): HRESULT; stdcall;
  end;

implementation

end.
