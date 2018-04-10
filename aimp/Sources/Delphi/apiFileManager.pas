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

unit apiFileManager;

{$I apiConfig.inc}

interface

uses
  Windows, apiObjects;
  
const
  SID_IAIMPFileInfo = '{41494D50-4669-6C65-496E-666F00000000}';
  IID_IAIMPFileInfo: TGUID = SID_IAIMPFileInfo;

  SID_IAIMPExtensionFileExpander = '{41494D50-4578-7446-696C-654578706472}';
  IID_IAIMPExtensionFileExpander: TGUID = SID_IAIMPExtensionFileExpander;

  SID_IAIMPExtensionFileFormat = '{41494D50-4578-7446-696C-65466D740000}';
  IID_IAIMPExtensionFileFormat: TGUID = SID_IAIMPExtensionFileFormat;

  SID_IAIMPExtensionFileInfoProvider = '{41494D50-4578-7446-696C-65496E666F00}';
  IID_IAIMPExtensionFileInfoProvider: TGUID = SID_IAIMPExtensionFileInfoProvider;

  SID_IAIMPExtensionFileInfoProviderEx = '{41494D50-4578-7446-696C-65496E666F45}';
  IID_IAIMPExtensionFileInfoProviderEx: TGUID = SID_IAIMPExtensionFileInfoProviderEx;

  SID_IAIMPVirtualFile = '{41494D50-5669-7274-7561-6C46696C6500}';
  IID_IAIMPVirtualFile: TGUID = SID_IAIMPVirtualFile;

  SID_IAIMPServiceFileManager = '{41494D50-5372-7646-696C-654D616E0000}';
  IID_IAIMPServiceFileManager: TGUID = SID_IAIMPServiceFileManager;

  SID_IAIMPServiceFileFormats =  '{41494D50-5372-7646-696C-65466D747300}';
  IID_IAIMPServiceFileFormats: TGUID = SID_IAIMPServiceFileFormats;

  SID_IAIMPServiceFileInfo = '{41494D50-5372-7646-696C-65496E666F00}';
  IID_IAIMPServiceFileInfo: TGUID = SID_IAIMPServiceFileInfo;

  SID_IAIMPServiceFileInfoFormatter = '{41494D50-5372-7646-6C49-6E66466D7400}';
  IID_IAIMPServiceFileInfoFormatter: TGUID = SID_IAIMPServiceFileInfoFormatter;

  SID_IAIMPServiceFileInfoFormatterUtils = '{41494D50-5372-7646-6C49-6E66466D7455}';
  IID_IAIMPServiceFileInfoFormatterUtils: TGUID = SID_IAIMPServiceFileInfoFormatterUtils;

  SID_IAIMPServiceFileStreaming = '{41494D50-5372-7646-696C-655374726D00}';
  IID_IAIMPServiceFileStreaming: TGUID = SID_IAIMPServiceFileStreaming;

  SID_IAIMPServiceFileURI = '{41494D50-5372-7646-696C-655552490000}';
  IID_IAIMPServiceFileURI: TGUID = SID_IAIMPServiceFileURI;

  SID_IAIMPServiceFileURI2 = '{41494D50-5372-7646-696C-655552493200}';
  IID_IAIMPServiceFileURI2: TGUID = SID_IAIMPServiceFileURI2;

  SID_IAIMPExtensionFileSystem = '{41494D50-4578-7446-5300-000000000000}';
  IID_IAIMPExtensionFileSystem: TGUID = SID_IAIMPExtensionFileSystem;

  SID_IAIMPServiceFileSystems = '{41494D50-5372-7646-5300-000000000000}';
  IID_IAIMPServiceFileSystems: TGUID = SID_IAIMPServiceFileSystems;

  SID_IAIMPFileSystemCommandCopyToClipboard = '{41465343-6D64-436F-7079-32436C706264}';
  IID_IAIMPFileSystemCommandCopyToClipboard: TGUID = SID_IAIMPFileSystemCommandCopyToClipboard;

  SID_IAIMPFileSystemCommandOpenFileFolder = '{41465343-6D64-4669-6C65-466C64720000}';
  IID_IAIMPFileSystemCommandOpenFileFolder: TGUID = SID_IAIMPFileSystemCommandOpenFileFolder;

  SID_IAIMPFileSystemCommandDelete = '{41465343-6D64-4465-6C65-746500000000}';
  IID_IAIMPFileSystemCommandDelete: TGUID = SID_IAIMPFileSystemCommandDelete;

  SID_IAIMPFileSystemCommandFileExists = '{41465343-6D64-4669-6C65-457869737470}';
  IID_IAIMPFileSystemCommandFileExists: TGUID = SID_IAIMPFileSystemCommandFileExists;

  SID_IAIMPFileSystemCommandStreaming = '{41465343-6D64-5374-7265-616D696E6700}';
  IID_IAIMPFileSystemCommandStreaming: TGUID = SID_IAIMPFileSystemCommandStreaming;

  SID_IAIMPFileSystemCommandDropSource = '{41465343-6D64-4472-6F70-537263000000}';
  IID_IAIMPFileSystemCommandDropSource: TGUID = SID_IAIMPFileSystemCommandDropSource;

  // PropertyID for the IAIMPFileInfo
  AIMP_FILEINFO_PROPID_CUSTOM            = 0;
  AIMP_FILEINFO_PROPID_ALBUM             = 1;
  AIMP_FILEINFO_PROPID_ALBUMART          = 2;
  AIMP_FILEINFO_PROPID_ALBUMARTIST       = 3;
  AIMP_FILEINFO_PROPID_ALBUMGAIN         = 4;
  AIMP_FILEINFO_PROPID_ALBUMPEAK         = 5;
  AIMP_FILEINFO_PROPID_ARTIST            = 6;
  AIMP_FILEINFO_PROPID_BITRATE           = 7;
  AIMP_FILEINFO_PROPID_BPM               = 8;
  AIMP_FILEINFO_PROPID_CHANNELS          = 9;
  AIMP_FILEINFO_PROPID_COMMENT           = 10;
  AIMP_FILEINFO_PROPID_COMPOSER          = 11;
  AIMP_FILEINFO_PROPID_COPYRIGHT         = 12;
  AIMP_FILEINFO_PROPID_CUESHEET          = 13;
  AIMP_FILEINFO_PROPID_DATE              = 14;
  AIMP_FILEINFO_PROPID_DISKNUMBER        = 15;
  AIMP_FILEINFO_PROPID_DISKTOTAL         = 16;
  AIMP_FILEINFO_PROPID_DURATION          = 17;
  AIMP_FILEINFO_PROPID_FILENAME          = 18;
  AIMP_FILEINFO_PROPID_FILESIZE          = 19;
  AIMP_FILEINFO_PROPID_GENRE             = 20;
  AIMP_FILEINFO_PROPID_LYRICS            = 21;
  AIMP_FILEINFO_PROPID_PUBLISHER         = 23;
  AIMP_FILEINFO_PROPID_SAMPLERATE        = 24;
  AIMP_FILEINFO_PROPID_TITLE             = 25;
  AIMP_FILEINFO_PROPID_TRACKGAIN         = 26;
  AIMP_FILEINFO_PROPID_TRACKNUMBER       = 27;
  AIMP_FILEINFO_PROPID_TRACKPEAK         = 28;
  AIMP_FILEINFO_PROPID_TRACKTOTAL        = 29;
  AIMP_FILEINFO_PROPID_URL               = 30;
  AIMP_FILEINFO_PROPID_BITDEPTH          = 31;
  AIMP_FILEINFO_PROPID_CODEC             = 32;
  AIMP_FILEINFO_PROPID_CONDUCTOR         = 33;
  AIMP_FILEINFO_PROPID_MOOD              = 34;
  AIMP_FILEINFO_PROPID_CATALOG           = 35;
  AIMP_FILEINFO_PROPID_ISRC              = 36;
  AIMP_FILEINFO_PROPID_LYRICIST          = 37;
  AIMP_FILEINFO_PROPID_ENCODEDBY         = 38;
  AIMP_FILEINFO_PROPID_RATING            = 39;
  AIMP_FILEINFO_PROPID_STAT_ADDINGDATE      = 40;
  AIMP_FILEINFO_PROPID_STAT_LASTPLAYDATE    = 41;
  AIMP_FILEINFO_PROPID_STAT_MARK            = 42;
  AIMP_FILEINFO_PROPID_STAT_PLAYCOUNT       = 43;
  AIMP_FILEINFO_PROPID_STAT_RATING          = 44;
  AIMP_FILEINFO_PROPID_STAT_DISPLAYING_MARK = 22;

  // PropertyID for the IAIMPVirtualFile
  AIMP_VIRTUALFILE_PROPID_FILEURI          = 0;
  AIMP_VIRTUALFILE_PROPID_AUDIOSOURCEFILE  = 1;
  AIMP_VIRTUALFILE_PROPID_CLIPSTART        = 2;
  AIMP_VIRTUALFILE_PROPID_CLIPFINISH       = 3;
  AIMP_VIRTUALFILE_PROPID_INDEXINSET       = 4;
  AIMP_VIRTUALFILE_PROPID_FILEFORMAT       = 5;  

  // Flags for the IAIMPServiceFileFormats and IAIMPExtensionFileFormat
  AIMP_SERVICE_FILEFORMATS_CATEGORY_AUDIO     = 1;
  AIMP_SERVICE_FILEFORMATS_CATEGORY_PLAYLISTS = 2;

  // Flags for the IAIMPServiceFileStreaming.CreateStreamForFile
  AIMP_SERVICE_FILESTREAMING_FLAG_CREATENEW   = 1;
  AIMP_SERVICE_FILESTREAMING_FLAG_READ        = 0;
  AIMP_SERVICE_FILESTREAMING_FLAG_READWRITE   = 2;
  AIMP_SERVICE_FILESTREAMING_FLAG_MAPTOMEMORY = 4;
  
  // Flags for the IAIMPServiceFileInfo.GetFileInfoXXX
  AIMP_SERVICE_FILEINFO_FLAG_DONTUSEAUDIODECODERS = 1;

  // Flags for the IAIMPServiceFileURI.ChangeFileExt and IAIMPServiceFileURI.ExtractFileExt
  AIMP_SERVICE_FILEURI_FLAG_DOUBLE_EXTS = 1;
  AIMP_SERVICE_FILEURI_FLAG_PART_EXT    = 2;

  // Property IDs for IAIMPExtensionFileSystem
  AIMP_FILESYSTEM_PROPID_SCHEME   = 1;
  AIMP_FILESYSTEM_PROPID_READONLY = 2;

type

//----------------------------------------------------------------------------------------------------------------------
// Common
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPFileInfo }

  IAIMPFileInfo = interface(IAIMPPropertyList)
  [SID_IAIMPFileInfo]
    function Assign(Source: IAIMPFileInfo): HRESULT; stdcall;
    function Clone(out Info: IAIMPFileInfo): HRESULT; stdcall;
  end;

  { IAIMPVirtualFile }

  IAIMPVirtualFile = interface(IAIMPPropertyList)
  [SID_IAIMPVirtualFile]
    function CreateStream(out Stream: IAIMPStream): HRESULT; stdcall;
    function GetFileInfo(Info: IAIMPFileInfo): HRESULT; stdcall;
    function IsExists: LongBool; stdcall; 
    function IsInSameStream(VirtualFile: IAIMPVirtualFile): HRESULT; stdcall;
    function Synchronize: HRESULT; stdcall;
  end;

  { TAIMPFileAttributes }

  TAIMPFileAttributes = packed record
    Attributes: DWORD;
    TimeCreation: TDateTime;
    TimeLastAccess: TDateTime;
    TimeLastWrite: TDateTime;
    Reserved0: Int64;
    Reserved1: Int64;
    Reserved2: Int64;
  end;

//----------------------------------------------------------------------------------------------------------------------
// FileSystem Commands
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPFileSystemCustomFileCommand }

  IAIMPFileSystemCustomFileCommand = interface(IUnknown)
    function CanProcess(FileName: IAIMPString): HRESULT; stdcall;
    function Process(FileName: IAIMPString): HRESULT; stdcall;
  end;

  { IAIMPFileSystemCommandCopyToClipboard }

  IAIMPFileSystemCommandCopyToClipboard = interface
  [SID_IAIMPFileSystemCommandCopyToClipboard]
    function CopyToClipboard(Files: IAIMPObjectList): HRESULT; stdcall;
  end;

  { IAIMPFileSystemCommandDelete }

  IAIMPFileSystemCommandDelete = interface(IAIMPFileSystemCustomFileCommand)
  [SID_IAIMPFileSystemCommandDelete]
  end;

  { IAIMPFileSystemCommandDropSource }

  IAIMPFileSystemCommandDropSource = interface(IUnknown)
  [SID_IAIMPFileSystemCommandDropSource]
    function CreateStream(FileName: IAIMPString; out Stream: IAIMPStream): HRESULT; stdcall;
  end;

  { IAIMPFileSystemCommandFileInfo }

  IAIMPFileSystemCommandFileInfo = interface(IUnknown)
  [SID_IAIMPFileSystemCommandFileExists]
    function GetFileAttrs(FileName: IAIMPString; out Attrs: TAIMPFileAttributes): HRESULT; stdcall;
    function GetFileSize(FileName: IAIMPString; out Size: Int64): HRESULT; stdcall;
    function IsFileExists(FileName: IAIMPString): HRESULT; stdcall;
  end;

  { IAIMPFileSystemCommandOpenFileFolder }

  IAIMPFileSystemCommandOpenFileFolder = interface(IAIMPFileSystemCustomFileCommand)
  [SID_IAIMPFileSystemCommandOpenFileFolder]
  end;

  { IAIMPFileSystemCommandStreaming }

  IAIMPFileSystemCommandStreaming = interface(IUnknown)
  [SID_IAIMPFileSystemCommandStreaming]
    function CreateStream(FileName: IAIMPString; const Offset, Size: Int64; Flags: DWORD; out Stream: IAIMPStream): HRESULT; stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Extensions
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPExtensionFileExpander }

  IAIMPExtensionFileExpander = interface
  [SID_IAIMPExtensionFileExpander]
    function Expand(FileName: IAIMPString; out List: IAIMPObjectList; ProgressCallback: IAIMPProgressCallback): HRESULT; stdcall;
  end;

  { IAIMPExtensionFileFormat }

  IAIMPExtensionFileFormat = interface
  [SID_IAIMPExtensionFileFormat]
    function GetDescription(out S: IAIMPString): HRESULT; stdcall;
    function GetExtList(out S: IAIMPString): HRESULT; stdcall;
    function GetFlags(out Flags: DWORD): HRESULT; stdcall;
  end;

  { IAIMPExtensionFileInfoProvider }

  IAIMPExtensionFileInfoProvider = interface
  [SID_IAIMPExtensionFileInfoProvider]
    function GetFileInfo(FileURI: IAIMPString; Info: IAIMPFileInfo): HRESULT; stdcall;
  end;

  { IAIMPExtensionFileInfoProviderEx }

  IAIMPExtensionFileInfoProviderEx = interface
  [SID_IAIMPExtensionFileInfoProviderEx]
    function GetFileInfo(Stream: IAIMPStream; Info: IAIMPFileInfo): HRESULT; stdcall;
  end;

  { IAIMPExtensionFileSystem }

  IAIMPExtensionFileSystem = interface(IAIMPPropertyList)
  [SID_IAIMPExtensionFileSystem]
  end;

//----------------------------------------------------------------------------------------------------------------------
// Services
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPServiceFileManager }

  IAIMPServiceFileManager = interface
  [SID_IAIMPServiceFileManager]
  end;

  { IAIMPServiceFileFormats }

  IAIMPServiceFileFormats = interface
  [SID_IAIMPServiceFileFormats]
    function GetFormats(Flags: DWORD; out S: IAIMPString): HRESULT; stdcall;
  	function IsSupported(FileName: IAIMPString; Flags: DWORD): HRESULT; stdcall;
  end;

  { IAIMPServiceFileInfo }

  IAIMPServiceFileInfo = interface
  [SID_IAIMPServiceFileInfo]
    // File Info
    function GetFileInfoFromFileURI(FileURI: IAIMPString; Flags: DWORD; Info: IAIMPFileInfo): HRESULT; stdcall;
    function GetFileInfoFromStream(Stream: IAIMPStream; Flags: DWORD; Info: IAIMPFileInfo): HRESULT; stdcall;
    // Virtual Files
    function GetVirtualFile(FileURI: IAIMPString; Flags: DWORD; out Info: IAIMPVirtualFile): HRESULT; stdcall;
  end;

  { IAIMPServiceFileInfoFormatter }

  IAIMPServiceFileInfoFormatter = interface
  [SID_IAIMPServiceFileInfoFormatter]
    function Format(Template: IAIMPString; FileInfo: IAIMPFileInfo; Reserved: Integer;
      AdditionalInfo: IUnknown; out FormattedResult: IAIMPString): HRESULT; stdcall;
  end;

  { IAIMPServiceFileInfoFormatterUtils }

  IAIMPServiceFileInfoFormatterUtils = interface
  [SID_IAIMPServiceFileInfoFormatterUtils]
    function ShowMacrosLegend(ScreenTarget: TRect; Reserved: Integer; EventsHandler: IUnknown): HRESULT; stdcall;
  end;

  { IAIMPServiceFileStreaming }

  IAIMPServiceFileStreaming = interface
  [SID_IAIMPServiceFileStreaming]
    function CreateStreamForFile(FileName: IAIMPString; Flags: DWORD;
      const Offset, Size: Int64; out Stream: IAIMPStream): HRESULT; stdcall;
    function CreateStreamForFileURI(FileURI: IAIMPString;
      out VirtualFile: IAIMPVirtualFile; out Stream: IAIMPStream): HRESULT; stdcall;
  end;

  { IAIMPServiceFileSystems }

  IAIMPServiceFileSystems = interface
  [SID_IAIMPServiceFileSystems]
    function Get(FileURI: IAIMPString; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetDefault(const IID: TGUID; out Obj): HRESULT; stdcall;
  end;

  { IAIMPServiceFileURI }

  IAIMPServiceFileURI = interface
  [SID_IAIMPServiceFileURI]
    function Build(ContainerFileName, PartName: IAIMPString; out FileURI: IAIMPString): HRESULT; stdcall;
    function Parse(FileURI: IAIMPString; out ContainerFileName, PartName: IAIMPString): HRESULT; stdcall;

    function ChangeFileExt(var FileURI: IAIMPString; NewExt: IAIMPString; Flags: DWORD): HRESULT; stdcall;
    function ExtractFileExt(FileURI: IAIMPString; out S: IAIMPString; Flags: DWORD): HRESULT; stdcall;
    function ExtractFileName(FileURI: IAIMPString; out S: IAIMPString): HRESULT; stdcall;
    function ExtractFileParentDirName(FileURI: IAIMPString; out S: IAIMPString): HRESULT; stdcall;
    function ExtractFileParentName(FileURI: IAIMPString; out S: IAIMPString): HRESULT; stdcall;
    function ExtractFilePath(FileURI: IAIMPString; out S: IAIMPString): HRESULT; stdcall;
    function IsURL(FileURI: IAIMPString): HRESULT; stdcall;
  end;

  { IAIMPServiceFileURI2 }

  IAIMPServiceFileURI2 = interface(IAIMPServiceFileURI)
  [SID_IAIMPServiceFileURI2]
    function GetScheme(FileURI: IAIMPString; out Scheme: IAIMPString): HRESULT; stdcall;
  end;

implementation

end.
