library DemoExplorerView;

{$R *.res}

uses
  apiPlugin,
  ExplorerViewMain in 'ExplorerViewMain.pas';

  function AIMPPluginGetHeader(out Header: IAIMPPlugin): HRESULT; stdcall;
  begin
    Header := TDemoExplorerViewPlugin.Create;
    Result := S_OK;
  end;

exports
  AIMPPluginGetHeader;

begin
end.
