library GUIDemo;

uses
  apiPlugin,
  uDemoForm in 'uDemoForm.pas',
  uPlugin in 'uPlugin.pas';

{$R *.res}

function AIMPPluginGetHeader(out Header: IAIMPPlugin): HRESULT; stdcall;
begin
  try
    Header := TAIMPGuiDemoPlugin.Create;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

exports
  AIMPPluginGetHeader;

begin
end.
