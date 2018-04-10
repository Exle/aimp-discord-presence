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

unit AIMPCustomPlugin;

{$I apiConfig.inc}

interface

uses
  Windows, apiCore, apiObjects, apiPlugin, apiWrappers;

type

  { TAIMPCustomPlugin }

  TAIMPCustomPlugin = class(TInterfacedObject, IAIMPPlugin)
  protected
    // IAIMPPlugin
    function InfoGet(Index: Integer): PWideChar; virtual; stdcall; abstract;
    function InfoGetCategories: DWORD; virtual; stdcall; abstract;
    function Initialize(Core: IAIMPCore): HRESULT; virtual; stdcall;
    procedure Finalize; virtual; stdcall;
    procedure SystemNotification(NotifyID: Integer; Data: IUnknown); virtual; stdcall;
  public
    // Services
    function ServiceGetConfig: TAIMPServiceConfig;
  end;

implementation

uses
  SysUtils, apiMUI;

{ TAIMPCustomPlugin }

function TAIMPCustomPlugin.ServiceGetConfig: TAIMPServiceConfig;
begin
  Result := TAIMPServiceConfig.Create;
end;

procedure TAIMPCustomPlugin.Finalize;
begin
  TAIMPAPIWrappers.Finalize;
end;

function TAIMPCustomPlugin.Initialize(Core: IAIMPCore): HRESULT;
begin
  TAIMPAPIWrappers.Initialize(Core);
  Result := S_OK;
end;

procedure TAIMPCustomPlugin.SystemNotification(NotifyID: Integer; Data: IUnknown);
begin
  // do nothing
end;

end.
