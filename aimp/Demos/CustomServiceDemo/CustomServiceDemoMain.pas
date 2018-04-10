unit CustomServiceDemoMain;

interface

uses
  Classes, apiPlugin, AIMPCustomPlugin, apiCore, CustomServiceDemoPublicIntf;

type

  { TMyCustomObject }

  TMyCustomObject = class(TInterfacedObject,
    IMyCustomObject,
    IMyCustomObjectv2)
  protected
    // IMyCustomObject
    function SomeMethod: HRESULT; stdcall;
    // IMyCustomObjectv2
    function SomeNewMethod: HRESULT; stdcall;
  end;

  { TMyCustomService }

  TMyCustomService = class(TInterfacedObject,
    IMyCustomService, // Main interface of custom service
    IAIMPServiceAttrExtendable, // Our service has extensions support
    IAIMPServiceAttrObjects // Our service has custom objects
  )
  private
    FExtensions: TInterfaceList;
  protected
    // IAIMPServiceAttrExtendable
    procedure RegisterExtension(Extension: IInterface); stdcall;
    procedure UnregisterExtension(Extension: IInterface); stdcall;
    // IAIMPServiceAttrObjects
    function CreateObject(const IID: TGUID; out Obj): HRESULT; stdcall;
    // IMyCustomService
    function SomeMethod: HRESULT; stdcall;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure NotifyExtensions;
  end;

  { TAIMPCustomServicePlugin }

  TAIMPCustomServicePlugin = class(TAIMPCustomPlugin)
  protected
    function InfoGet(Index: Integer): PWideChar; override; stdcall;
    function InfoGetCategories: Cardinal; override; stdcall;
    function Initialize(Core: IAIMPCore): HRESULT; override; stdcall;
  end;

implementation

uses
  ActiveX, SysUtils;

{ TMyCustomObject }

function TMyCustomObject.SomeMethod: HRESULT;
begin
  Result := S_OK;
end;

function TMyCustomObject.SomeNewMethod: HRESULT;
begin
  Result := S_OK;
end;

{ TMyCustomService }

constructor TMyCustomService.Create;
begin
  inherited Create;
  FExtensions := TInterfaceList.Create;
end;

destructor TMyCustomService.Destroy;
begin
  FreeAndNil(FExtensions);
  inherited Destroy;
end;

procedure TMyCustomService.NotifyExtensions;
var
  I: Integer;
begin
  // send notification to our extensions
  FExtensions.Lock;
  try
    for I := FExtensions.Count - 1 downto 0 do
      IMyCustomExtension(FExtensions[I]).SomeNotification;
  finally
    FExtensions.Unlock;
  end;
end;

function TMyCustomService.CreateObject(const IID: TGUID; out Obj): HRESULT;
begin
  Result := S_OK;
  if IsEqualGUID(IID, IID_IMyCustomObject) then
    IMyCustomObject(Obj) := TMyCustomObject.Create
  else
    if IsEqualGUID(IID, IID_IMyCustomObjectv2) then
      IMyCustomObjectv2(Obj) := TMyCustomObject.Create
    else
      Result := E_NOINTERFACE;
end;

procedure TMyCustomService.RegisterExtension(Extension: IInterface);
var
  AIntf: IMyCustomExtension;
begin
  // if it our extension put it into the FExtensions list
  if Supports(Extension, IMyCustomExtension, AIntf) then
    FExtensions.Add(AIntf);
end;

procedure TMyCustomService.UnregisterExtension(Extension: IInterface);
var
  AIntf: IMyCustomExtension;
begin
  // if it our extension remove it from the FExtensions list
  if Supports(Extension, IMyCustomExtension, AIntf) then
    FExtensions.Remove(AIntf);
end;

function TMyCustomService.SomeMethod: HRESULT;
begin
  Result := S_OK;
end;

{ TAIMPCustomServicePlugin }

function TAIMPCustomServicePlugin.InfoGet(Index: Integer): PWideChar;
begin
  case Index of
    AIMP_PLUGIN_INFO_NAME:
      Result := 'Custom service demo plugin';
    AIMP_PLUGIN_INFO_AUTHOR:
      Result := 'Artem Izmaylov';
    AIMP_PLUGIN_INFO_SHORT_DESCRIPTION:
      Result := 'Single line short description';
  else
    Result := nil;
  end;
end;

function TAIMPCustomServicePlugin.InfoGetCategories: Cardinal;
begin
  Result := AIMP_PLUGIN_CATEGORY_ADDONS;
end;

function TAIMPCustomServicePlugin.Initialize(Core: IAIMPCore): HRESULT;
begin
  Result := inherited Initialize(Core);
  if Succeeded(Result) then
    // Register the custom service
    Core.RegisterService(TMyCustomService.Create);
end;

end.
