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

unit apiTagEditor;

{$I apiConfig.inc}

interface

uses
  apiObjects, apiFileManager;

const
  SID_IAIMPFileTag = '{41494D50-4669-6C65-5461-670000000000}';
  IID_IAIMPFileTag: TGUID = SID_IAIMPFileTag;

  SID_IAIMPFileTagEditor = '{41494D50-4669-6C65-5461-674564697400}';
  IID_IAIMPFileTagEditor: TGUID = SID_IAIMPFileTagEditor;

  SID_IAIMPServiceFileTagEditor = '{41494D50-5372-7654-6167-456469740000}';
  IID_IAIMPServiceFileTagEditor: TGUID = SID_IAIMPServiceFileTagEditor;

  // PropertyID for the IAIMPFileTag
  AIMP_FILETAG_PROPID_BASE             = 100;
  AIMP_FILETAG_PROPID_TAG_ID           = AIMP_FILETAG_PROPID_BASE + 1;
  AIMP_FILETAG_PROPID_DELETE_ON_SAVING = AIMP_FILETAG_PROPID_BASE + 2;

  // IDs for IAIMPFileTag.AIMP_FILETAG_PROPID_TAG_ID
  AIMP_FILETAG_ID_CUSTOM = 0;
  AIMP_FILETAG_ID_APEv2  = 1;
  AIMP_FILETAG_ID_ID3v1  = 2;
  AIMP_FILETAG_ID_ID3v2  = 3;
  AIMP_FILETAG_ID_MP4    = 4;
  AIMP_FILETAG_ID_VORBIS = 5;
  AIMP_FILETAG_ID_WMA    = 6;

type

  { IAIMPFileTag }

  IAIMPFileTag = interface(IAIMPFileInfo)
  [SID_IAIMPFileTag]
  end;

  { IAIMPFileTagEditor }

  IAIMPFileTagEditor = interface(IUnknown)
  [SID_IAIMPFileTagEditor]
    // Info
    function GetMixedInfo(out Info: IAIMPFileInfo): HRESULT; stdcall;
    function GetTag(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetTagCount: Integer; stdcall;
    function SetToAll(Info: IAIMPFileInfo): HRESULT; stdcall;
    // Save
    function Save: HRESULT; stdcall;
  end;

  { IAIMPServiceFileTagEditor }

  IAIMPServiceFileTagEditor = interface(IUnknown)
  [SID_IAIMPServiceFileTagEditor]
    function EditFile(Source: IUnknown; const IID: TGUID; out Obj): HRESULT; stdcall;
    function EditTag(Source: IUnknown; TagID: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
  end;

implementation

end.
