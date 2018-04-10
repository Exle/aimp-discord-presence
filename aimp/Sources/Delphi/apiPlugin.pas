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

unit apiPlugin;

{$I apiConfig.inc}

interface

uses
  Windows, apiCore, apiObjects;

const
  // IAIMPPlugin.InfoGetCategories
  AIMP_PLUGIN_CATEGORY_ADDONS   = $1;
  AIMP_PLUGIN_CATEGORY_DECODERS = $2;
  AIMP_PLUGIN_CATEGORY_VISUALS  = $4;
  AIMP_PLUGIN_CATEGORY_DSP	    = $8;

  // IAIMPPlugin.InfoGet
  AIMP_PLUGIN_INFO_NAME              = $0;
  AIMP_PLUGIN_INFO_AUTHOR            = $1;
  AIMP_PLUGIN_INFO_SHORT_DESCRIPTION = $2;
  AIMP_PLUGIN_INFO_FULL_DESCRIPTION  = $3;
  
  // IAIMPPlugin.SystemNotification
  AIMP_SYSTEM_NOTIFICATION_SERVICE_ADDED     = $1;
  AIMP_SYSTEM_NOTIFICATION_SERVICE_REMOVED   = $2;
  AIMP_SYSTEM_NOTIFICATION_EXTENSION_REMOVED = $3;

const
  SID_IAIMPExternalSettingsDialog = '{41494D50-4578-7472-6E4F-7074446C6700}';
  IID_IAIMPExternalSettingsDialog: TGUID = SID_IAIMPExternalSettingsDialog;

type

  { IAIMPExternalSettingsDialog }

  IAIMPExternalSettingsDialog = interface
  [SID_IAIMPExternalSettingsDialog]
    procedure Show(ParentWindow: HWND); stdcall;
  end;

  { IAIMPPlugin }

  IAIMPPlugin = interface(IUnknown)
    // Information about the plugin
    function InfoGet(Index: Integer): PWideChar; stdcall;
    function InfoGetCategories: DWORD; stdcall;
    // Initialization / Finalization
    function Initialize(Core: IAIMPCore): HRESULT; stdcall;
    procedure Finalize; stdcall;
    // System Notifications
    procedure SystemNotification(NotifyID: Integer; Data: IUnknown); stdcall;
  end;
  
  TAIMPPluginGetHeaderProc = function (out Header: IAIMPPlugin): HRESULT; stdcall;

  // Export function name: AIMPPluginGetHeader

implementation

end.
