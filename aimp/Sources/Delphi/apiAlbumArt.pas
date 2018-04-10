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

unit apiAlbumArt;

{$I apiConfig.inc}

interface

uses
  Windows, apiObjects, apiFileManager;

const
  SID_IAIMPExtensionAlbumArtCatalog = '{41494D50-4578-7441-6C62-417274436174}';
  IID_IAIMPExtensionAlbumArtCatalog: TGUID = SID_IAIMPExtensionAlbumArtCatalog;

  SID_IAIMPExtensionAlbumArtCatalog2 = '{41494D50-4578-416C-6241-727443617432}';
  IID_IAIMPExtensionAlbumArtCatalog2: TGUID = SID_IAIMPExtensionAlbumArtCatalog2;

  SID_IAIMPExtensionAlbumArtProvider = '{41494D50-4578-7441-6C62-417274507276}';
  IID_IAIMPExtensionAlbumArtProvider: TGUID = SID_IAIMPExtensionAlbumArtProvider;

  SID_IAIMPExtensionAlbumArtProvider2 = '{41494D50-4578-416C-6241-727450727632}';
  IID_IAIMPExtensionAlbumArtProvider2: TGUID = SID_IAIMPExtensionAlbumArtProvider2;

  SID_IAIMPServiceAlbumArt = '{41494D50-5372-7641-6C62-417274000000}';
  IID_IAIMPServiceAlbumArt: TGUID = SID_IAIMPServiceAlbumArt;

  SID_IAIMPServiceAlbumArtCache = '{4941494D-5053-7276-416C-624172744368}';
  IID_IAIMPServiceAlbumArtCache: TGUID = SID_IAIMPServiceAlbumArtCache;

  AIMP_ALBUMART_PROVIDER_CATEGORY_MASK     = $F;
  // Providers Categories
  AIMP_ALBUMART_PROVIDER_CATEGORY_TAGS     = 0;
  AIMP_ALBUMART_PROVIDER_CATEGORY_FILE     = 1;
  AIMP_ALBUMART_PROVIDER_CATEGORY_INTERNET = 2;

  // PropIDs for IAIMPPropertyList in IAIMPExtensionAlbumArtLocalFinder.Get
  AIMP_SERVICE_ALBUMART_PROPID_FIND_IN_FILES                  = 1;
  AIMP_SERVICE_ALBUMART_PROPID_FIND_IN_FILES_MASKS            = 2;
  AIMP_SERVICE_ALBUMART_PROPID_FIND_IN_FILES_EXTS             = 3;
  AIMP_SERVICE_ALBUMART_PROPID_FIND_IN_INTERNET               = 4;
  AIMP_SERVICE_ALBUMART_PROPID_FIND_IN_INTERNET_MAX_FILE_SIZE = 5;

  // Flags for IAIMPServiceAlbumArt.Get
  AIMP_SERVICE_ALBUMART_FLAGS_NOCACHE  = 1;
  AIMP_SERVICE_ALBUMART_FLAGS_ORIGINAL = 2;
  AIMP_SERVICE_ALBUMART_FLAGS_WAITFOR  = 4;

type

  { IAIMPExtensionAlbumArtCatalog }

  IAIMPExtensionAlbumArtCatalog = interface(IUnknown)
  [SID_IAIMPExtensionAlbumArtCatalog]
    function GetIcon(out Icon: HICON): HRESULT; stdcall;
    function GetName(out Name: IAIMPString): HRESULT; stdcall;
    function Show(FileURI, Artist, Album: IAIMPString; out Image: IAIMPImageContainer): HRESULT; stdcall;
  end;

  { IAIMPExtensionAlbumArtCatalog2 }

  IAIMPExtensionAlbumArtCatalog2 = interface(IAIMPExtensionAlbumArtCatalog)
  [SID_IAIMPExtensionAlbumArtCatalog2]
    function Show2(FileInfo: IAIMPFileInfo; out Image: IAIMPImageContainer): HRESULT; stdcall;
  end;

  { IAIMPExtensionAlbumArtProvider }

  IAIMPExtensionAlbumArtProvider = interface(IUnknown)
  [SID_IAIMPExtensionAlbumArtProvider]
    function Get(FileURI, Artist, Album: IAIMPString; Options: IAIMPPropertyList; out Image: IAIMPImageContainer): HRESULT; stdcall;
    function GetCategory: DWORD; stdcall;
  end;

  { IAIMPExtensionAlbumArtProvider2 }

  IAIMPExtensionAlbumArtProvider2 = interface(IAIMPExtensionAlbumArtProvider)
  [SID_IAIMPExtensionAlbumArtProvider2]
    function Get2(FileInfo: IAIMPFileInfo; Options: IAIMPPropertyList; out Image: IAIMPImageContainer): HRESULT; stdcall;
  end;

  { IAIMPServiceAlbumArt }

  TAIMPServiceAlbumArtReceiveProc = procedure (Image: IAIMPImage; ImageContainer: IAIMPImageContainer; UserData: Pointer); stdcall;

  IAIMPServiceAlbumArt = interface(IUnknown)
  [SID_IAIMPServiceAlbumArt]
    function Get(FileURI, Artist, Album: IAIMPString; Flags: DWORD;
      CallbackProc: TAIMPServiceAlbumArtReceiveProc; UserData: Pointer; out TaskID: Pointer): HRESULT; stdcall;
    function Get2(FileInfo: IAIMPFileInfo; Flags: DWORD;
      CallbackProc: TAIMPServiceAlbumArtReceiveProc; UserData: Pointer; out TaskID: Pointer): HRESULT; stdcall;
    function Cancel(TaskID: Pointer; Flags: DWORD): HRESULT; stdcall;
  end;

  { IAIMPServiceAlbumArtCache }

  IAIMPServiceAlbumArtCache = interface(IUnknown)
  [SID_IAIMPServiceAlbumArtCache]
    function Flush(Album, Artist: IAIMPString): HRESULT; stdcall;
    function Flush2(FileURI: IAIMPString): HRESULT; stdcall;
    function FlushAll: HRESULT; stdcall;
  end;

implementation

end.
