library MenuAndActionsDemo;

uses
  apiPlugin,
  MenuAndActionsDemoUnit in 'MenuAndActionsDemoUnit.pas';

{$R *.res}

function AIMPPluginGetHeader(out Header: IAIMPPlugin): HRESULT; stdcall;
begin
  try
    Header := TAIMPMenuAndActionsPlugin.Create;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

exports
  AIMPPluginGetHeader;

begin
end.
