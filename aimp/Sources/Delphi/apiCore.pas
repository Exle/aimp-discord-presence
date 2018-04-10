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

unit apiCore;

{$I apiConfig.inc}

interface

uses
  Windows, apiObjects;

const
  SID_IAIMPCore = '{41494D50-436F-7265-0000-000000000000}';
  IID_IAIMPCore: TGUID = SID_IAIMPCore;

  SID_IAIMPServiceAttrExtendable = '{41494D50-5372-7641-7474-724578740000}';
  IID_IAIMPServiceAttrExtendable: TGUID = SID_IAIMPServiceAttrExtendable;

  SID_IAIMPServiceAttrObjects = '{41494D50-5372-7641-7474-724F626A7300}';
  IID_IAIMPServiceAttrObjects: TGUID = SID_IAIMPServiceAttrObjects;

  SID_IAIMPServiceConfig = '{41494D50-5372-7643-6667-000000000000}';
  IID_IAIMPServiceConfig: TGUID = SID_IAIMPServiceConfig;

  SID_IAIMPServiceShutdown = '{41494D50-5372-7653-6875-74646F776E00}';
  IID_IAIMPServiceShutdown: TGUID = SID_IAIMPServiceShutdown;

  SID_IAIMPServiceVersionInfo = '{41494D50-5372-7656-6572-496E666F0000}';
  IID_IAIMPServiceVersionInfo: TGUID = SID_IAIMPServiceVersionInfo;

  // Flags for IAIMPServiceShutdown.Shutdown
  AIMP_SERVICE_SHUTDOWN_FLAGS_HIBERNATE  = $1;
  AIMP_SERVICE_SHUTDOWN_FLAGS_POWEROFF   = $2;
  AIMP_SERVICE_SHUTDOWN_FLAGS_SLEEP      = $3;
  AIMP_SERVICE_SHUTDOWN_FLAGS_REBOOT     = $4;
  AIMP_SERVICE_SHUTDOWN_FLAGS_LOGOFF     = $5;
  AIMP_SERVICE_SHUTDOWN_FLAGS_CLOSE_APP  = $10;
  AIMP_SERVICE_SHUTDOWN_FLAGS_NO_CONFIRM = $20;

  // IAIMPServiceVersionInfo.GetBuildState
  AIMP_SERVICE_VERSION_STATE_RELEASE           = 0;
  AIMP_SERVICE_VERSION_STATE_RELEASE_CANDIDATE = 1;
  AIMP_SERVICE_VERSION_STATE_BETA              = 2;
  AIMP_SERVICE_VERSION_STATE_ALPHA             = 3;

  // IAIMPCore.GetPath
  AIMP_CORE_PATH_AUDIOLIBRARY = 6;
  AIMP_CORE_PATH_ENCODERS     = 8;
  AIMP_CORE_PATH_HELP         = 9;
  AIMP_CORE_PATH_ICONS        = 5;
  AIMP_CORE_PATH_LANGS        = 2;
  AIMP_CORE_PATH_PLAYLISTS    = 1;
  AIMP_CORE_PATH_PLUGINS      = 4;
  AIMP_CORE_PATH_PROFILE      = 0;
  AIMP_CORE_PATH_SKINS        = 3;
  AIMP_CORE_PATH_SKINS_COMMON = 11;

type

  { IAIMPCore }

  IAIMPCore = interface(IUnknown)
  [SID_IAIMPCore]
    // Creating Simple Objects
    function CreateObject(const IID: TGUID; out Obj): HRESULT; stdcall;
    // System Paths
    function GetPath(PathID: Integer; out Value: IAIMPString): HRESULT; stdcall;
    // Registration
    function RegisterExtension(const ServiceIID: TGUID; Extension: IUnknown): HRESULT; stdcall; 
    function RegisterService(Service: IUnknown): HRESULT; stdcall;
    function UnregisterExtension(Extension: IUnknown): HRESULT; stdcall;
  end;

  { IAIMPServiceAttrExtendable }

  IAIMPServiceAttrExtendable = interface(IUnknown)
  [SID_IAIMPServiceAttrExtendable]
    procedure RegisterExtension(Extension: IUnknown); stdcall;
    procedure UnregisterExtension(Extension: IUnknown); stdcall;
  end;
  
  { IAIMPServiceAttrObjects }

  IAIMPServiceAttrObjects = interface(IUnknown)
  [SID_IAIMPServiceAttrObjects]
    function CreateObject(const IID: TGUID; out Obj): HRESULT; stdcall;
  end;
  
  { IAIMPServiceConfig }

  IAIMPServiceConfig = interface(IAIMPConfig)
  [SID_IAIMPServiceConfig]
    function FlushCache: HRESULT; stdcall;
  end;

  { IAIMPServiceShutdown }

  IAIMPServiceShutdown = interface(IUnknown)
  [SID_IAIMPServiceShutdown]
    function Restart(Params: IAIMPString): HRESULT; stdcall;
    function Shutdown(Flags: DWORD): HRESULT; stdcall;
  end;

  { IAIMPServiceVersionInfo }

  IAIMPServiceVersionInfo = interface(IUnknown)
  [SID_IAIMPServiceVersionInfo]
    function FormatInfo(out S: IAIMPString): HRESULT; stdcall;
    function GetBuildDate: Integer; stdcall;
    function GetBuildState: Integer; stdcall; 
    function GetBuildNumber: Integer; stdcall;
    function GetVersionID: Integer; stdcall;
  end;

implementation

end.
