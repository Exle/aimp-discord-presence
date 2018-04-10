library aimp_optionFrameDemo;

uses
  Windows,
  apiPlugin,
  uOptionFrameDemoForm in 'uOptionFrameDemoForm.pas' {frmOptionFrameDemo},
  uOptionFrameDemo in 'uOptionFrameDemo.pas';

{$R *.res}

function AIMPPluginGetHeader(out Header: IAIMPPlugin): HRESULT; stdcall;
begin
  try
    Header := TAIMPDemoPlugin.Create;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

exports
  AIMPPluginGetHeader;

begin
end.
