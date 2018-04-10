unit uPlugin;

interface

uses
  Windows, AIMPCustomPlugin, apiPlugin;

type

  { TAIMPGuiDemoPlugin }

  TAIMPGuiDemoPlugin = class(TAIMPCustomPlugin, IAIMPExternalSettingsDialog)
  public
    function InfoGet(Index: Integer): PWideChar; override;
    function InfoGetCategories: DWORD; override;
    // IAIMPExternalSettingsDialog
    procedure Show(ParentWindow: HWND); stdcall;
  end;

implementation

uses
  uDemoForm, apiGUI, apiWrappers;

{ TAIMPGuiDemoPlugin }

function TAIMPGuiDemoPlugin.InfoGet(Index: Integer): PWideChar;
begin
  case Index of
    AIMP_PLUGIN_INFO_NAME:
      Result := 'GUI Demo';
    AIMP_PLUGIN_INFO_AUTHOR:
      Result := 'Artem Izmaylov';
    AIMP_PLUGIN_INFO_SHORT_DESCRIPTION:
      Result := 'Demo shows how to use GUI API';
  else
    Result := nil;
  end;
end;

function TAIMPGuiDemoPlugin.InfoGetCategories: DWORD;
begin
  Result := AIMP_PLUGIN_CATEGORY_ADDONS;
end;

procedure TAIMPGuiDemoPlugin.Show(ParentWindow: HWND);
var
  AService: IAIMPServiceUI;
begin
  if CoreGetService(IAIMPServiceUI, AService) then
    TDemoForm.Create(AService).ShowModal;
end;

end.
