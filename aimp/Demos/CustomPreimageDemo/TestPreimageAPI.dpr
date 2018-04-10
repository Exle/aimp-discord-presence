library TestPreimageAPI;

uses
  apiPlugin,
  TestPreimageAPIUnit in 'TestPreimageAPIUnit.pas' {frmTestPreimage};

{$R *.res}

  function AIMPPluginGetHeader(out Header: IAIMPPlugin): HRESULT; stdcall;
  begin
    try
      Header := TTestPreimageAPIPlugin.Create;
      Result := S_OK;
    except
      Result := E_UNEXPECTED;
    end;
  end;

exports
  AIMPPluginGetHeader;
begin
end.
