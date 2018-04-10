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

unit apiSkins;

{$I apiConfig.inc}

interface

uses
  Windows, apiObjects, apiCore;

const
  SID_IAIMPSkinInfo = '{41494D50-536B-696E-496E-666F00000000}';
  IID_IAIMPSkinInfo: TGUID = SID_IAIMPSkinInfo;

  SID_IAIMPServiceSkinsManager = '{41494D50-5372-7653-6B69-6E734D6E6772}';
  IID_IAIMPServiceSkinsManager: TGUID = SID_IAIMPServiceSkinsManager;

  // SkinInfo Properties
  AIMP_SKININFO_PROPID_NAME          = 1;
  AIMP_SKININFO_PROPID_AUTHOR        = 2;
  AIMP_SKININFO_PROPID_DESCRIPTION   = 3;
  AIMP_SKININFO_PROPID_PREVIEW       = 4;

  // SkinsManager Properties
  AIMP_SERVICE_SKINSMAN_PROPID_SKIN          = 1;
  AIMP_SERVICE_SKINSMAN_PROPID_HUE           = 2;
  AIMP_SERVICE_SKINSMAN_PROPID_HUE_INTENSITY = 3;

  // Flags for IAIMPServiceSkinsManager.Install
  AIMP_SERVICE_SKINSMAN_FLAGS_INSTALL_FOR_ALL_USERS = 1;

type

  { IAIMPSkinInfo }

  IAIMPSkinInfo = interface(IAIMPPropertyList)
  [SID_IAIMPSkinInfo]
  end;

  { IAIMPServiceSkinsManager }

  IAIMPServiceSkinsManager = interface(IUnknown)
  [SID_IAIMPServiceSkinsManager]
    function EnumSkins(out List: IAIMPObjectList): HRESULT; stdcall;
    function GetSkinInfo(FileName: IAIMPString; out Info: IAIMPSkinInfo): HRESULT; stdcall;
    function Select(FileName: IAIMPString): HRESULT; stdcall;
    //
    function Install(FileName: IAIMPString; Flags: DWORD): HRESULT; stdcall;
    function Uninstall(FileName: IAIMPString): HRESULT; stdcall;
    // Tools
    function HSLToRGB(H, S, L: Byte; out R, G, B: Byte): HRESULT; stdcall;
    function RGBToHSL(R, G, B: Byte; out H, S, L: Byte): HRESULT; stdcall;
  end;

implementation

end.
