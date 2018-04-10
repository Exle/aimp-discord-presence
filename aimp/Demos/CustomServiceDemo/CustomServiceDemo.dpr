library CustomServiceDemo;

uses
  apiPlugin,
  CustomServiceDemoMain in 'CustomServiceDemoMain.pas',
  CustomServiceDemoPublicIntf in 'CustomServiceDemoPublicIntf.pas';

{$R *.res}

function AIMPPluginGetHeader(out Header: IAIMPPlugin): HRESULT; stdcall;
begin
  try
    Header := TAIMPCustomServicePlugin.Create;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

exports
  AIMPPluginGetHeader;

begin
end.
