unit MenuAndActionsDemoUnit;

interface

{$R MenuAndActionsDemoUnit.res}

uses
  Windows, AIMPCustomPlugin, apiCore, apiMenu, apiActions, apiObjects;

type

  { TAIMPMenuAndActionsPlugin }

  TAIMPMenuAndActionsPlugin = class(TAIMPCustomPlugin)
  private
    function CreateGlyph(const ResName: string): IAIMPImage;
    function GetBuiltInMenu(ID: Integer): IAIMPMenuItem;

    procedure CreateMenuWithSubItemsAndWithoutAction;
    procedure CreateSimpleMenuWithAction;
    procedure CreateSimpleMenuWithoutAction;
  protected
    function InfoGet(Index: Integer): PWideChar; override; stdcall;
    function InfoGetCategories: Cardinal; override; stdcall;
    function Initialize(Core: IAIMPCore): HRESULT; override; stdcall;
  end;

  { TAIMPActionEventHandler }

  TAIMPActionEventHandler = class(TInterfacedObject, IAIMPActionEvent)
  public
    procedure OnExecute(Data: IInterface); stdcall;
  end;

  { TAIMPMenuItemEventHandler }

  TAIMPMenuItemEventHandler = class(TInterfacedObject, IAIMPActionEvent)
  public
    procedure OnExecute(Data: IInterface); stdcall;
  end;

implementation

uses
  apiPlugin, Classes, apiWrappers;

{ TAIMPMenuAndActionsPlugin }

function TAIMPMenuAndActionsPlugin.InfoGet(Index: Integer): PWideChar;
begin
  case Index of
    AIMP_PLUGIN_INFO_NAME:
      Result := 'Menu and actions demo plugin';
    AIMP_PLUGIN_INFO_AUTHOR:
      Result := 'Artem Izmaylov';
    AIMP_PLUGIN_INFO_SHORT_DESCRIPTION:
      Result := 'Single line short description';
  else
    Result := nil;
  end;
end;

function TAIMPMenuAndActionsPlugin.InfoGetCategories: Cardinal;
begin
  Result := AIMP_PLUGIN_CATEGORY_ADDONS;
end;

function TAIMPMenuAndActionsPlugin.Initialize(Core: IAIMPCore): HRESULT;
var
  AService: IAIMPServiceMenuManager;
begin
  // Check, if the Menu Service supported by core
  Result := Core.QueryInterface(IID_IAIMPServiceMenuManager, AService);
  if Succeeded(Result) then
  begin
    Result := inherited Initialize(Core);
    if Succeeded(Result) then
    begin
      CreateSimpleMenuWithAction;
      CreateSimpleMenuWithoutAction;
      CreateMenuWithSubItemsAndWithoutAction;
    end;
  end;
end;

function TAIMPMenuAndActionsPlugin.CreateGlyph(const ResName: string): IAIMPImage;
var
  AContainer: IAIMPImageContainer;
  AResStream: TResourceStream;
begin
  CheckResult(CoreIntf.CreateObject(IID_IAIMPImageContainer, AContainer));
  AResStream := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
  try
    CheckResult(AContainer.SetDataSize(AResStream.Size));
    AResStream.ReadBuffer(AContainer.GetData^, AContainer.GetDataSize);
    CheckResult(AContainer.CreateImage(Result));
  finally
    AResStream.Free;
  end;
end;

procedure TAIMPMenuAndActionsPlugin.CreateMenuWithSubItemsAndWithoutAction;
var
  AMenuItem: IAIMPMenuItem;
  AMenuSubItem: IAIMPMenuItem;
begin
  // Create menu item
  CheckResult(CoreIntf.CreateObject(IID_IAIMPMenuItem, AMenuItem));
  // Setup it
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_ID, MakeString('aimp.MenuAndActionsDemo.menuitem.2')));
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_NAME, MakeString('This menu has sub items')));
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_PARENT, GetBuiltInMenu(AIMP_MENUID_PLAYER_MAIN_FUNCTIONS)));
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_GLYPH, CreateGlyph('AIMP3LOGO')));
  // Register the menu item in manager
  CoreIntf.RegisterExtension(IID_IAIMPServiceMenuManager, AMenuItem);


  // Create first menu sub item
  CheckResult(CoreIntf.CreateObject(IID_IAIMPMenuItem, AMenuSubItem));
  CheckResult(AMenuSubItem.SetValueAsObject(AIMP_MENUITEM_PROPID_ID, MakeString('aimp.MenuAndActionsDemo.menuitem.2.subitem.1')));
  CheckResult(AMenuSubItem.SetValueAsObject(AIMP_MENUITEM_PROPID_NAME, MakeString('Sub item 1')));
  CheckResult(AMenuSubItem.SetValueAsObject(AIMP_MENUITEM_PROPID_PARENT, AMenuItem));
  CheckResult(AMenuSubItem.SetValueAsObject(AIMP_MENUITEM_PROPID_EVENT, TAIMPMenuItemEventHandler.Create));
  // Register the menu item in manager
  CoreIntf.RegisterExtension(IID_IAIMPServiceMenuManager, AMenuSubItem);


  // Create second menu sub item
  CheckResult(CoreIntf.CreateObject(IID_IAIMPMenuItem, AMenuSubItem));
  CheckResult(AMenuSubItem.SetValueAsObject(AIMP_MENUITEM_PROPID_ID, MakeString('aimp.MenuAndActionsDemo.menuitem.2.subitem.2')));
  CheckResult(AMenuSubItem.SetValueAsObject(AIMP_MENUITEM_PROPID_NAME, MakeString('Sub item 2')));
  CheckResult(AMenuSubItem.SetValueAsObject(AIMP_MENUITEM_PROPID_PARENT, AMenuItem));
  CheckResult(AMenuSubItem.SetValueAsObject(AIMP_MENUITEM_PROPID_EVENT, TAIMPMenuItemEventHandler.Create));
  // Register the menu item in manager
  CoreIntf.RegisterExtension(IID_IAIMPServiceMenuManager, AMenuSubItem);
end;

procedure TAIMPMenuAndActionsPlugin.CreateSimpleMenuWithAction;
var
  AAction: IAIMPAction;
  AMenuItem: IAIMPMenuItem;
begin
  // Create Action
  CheckResult(CoreIntf.CreateObject(IID_IAIMPAction, AAction));
  // Setup it
  CheckResult(AAction.SetValueAsObject(AIMP_ACTION_PROPID_ID, MakeString('aimp.MenuAndActionsDemo.action.1')));
  CheckResult(AAction.SetValueAsObject(AIMP_ACTION_PROPID_NAME, MakeString('Simple action title')));
  CheckResult(AAction.SetValueAsObject(AIMP_ACTION_PROPID_GROUPNAME, MakeString('Menu And Actions Demo')));
  CheckResult(AAction.SetValueAsObject(AIMP_ACTION_PROPID_EVENT, TAIMPActionEventHandler.Create));
  // Register the action in manager
  CoreIntf.RegisterExtension(IID_IAIMPServiceActionManager, AAction);


  // Create menu item
  CheckResult(CoreIntf.CreateObject(IID_IAIMPMenuItem, AMenuItem));
  // Setup it
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_ID, MakeString('aimp.MenuAndActionsDemo.menuitem.with.action')));
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_NAME, MakeString('Menu item with linked action')));
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_ACTION, AAction));
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_PARENT, GetBuiltInMenu(AIMP_MENUID_PLAYER_MAIN_OPTIONS)));
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_GLYPH, CreateGlyph('AIMP3LOGO')));
  // Register the menu item in manager
  CoreIntf.RegisterExtension(IID_IAIMPServiceMenuManager, AMenuItem);
end;

procedure TAIMPMenuAndActionsPlugin.CreateSimpleMenuWithoutAction;
var
  AMenuItem: IAIMPMenuItem;
begin
  // Create menu item
  CheckResult(CoreIntf.CreateObject(IID_IAIMPMenuItem, AMenuItem));
  // Setup it
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_ID, MakeString('aimp.MenuAndActionsDemo.menuitem.1')));
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_NAME, MakeString('Simple menu title')));
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_EVENT, TAIMPMenuItemEventHandler.Create));
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_PARENT, GetBuiltInMenu(AIMP_MENUID_COMMON_UTILITIES)));
  CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_GLYPH, CreateGlyph('AIMP3LOGO')));
  // Register the menu item in manager
  CoreIntf.RegisterExtension(IID_IAIMPServiceMenuManager, AMenuItem);
end;

function TAIMPMenuAndActionsPlugin.GetBuiltInMenu(ID: Integer): IAIMPMenuItem;
var
  AMenuService: IAIMPServiceMenuManager;
begin
  CheckResult(CoreIntf.QueryInterface(IAIMPServiceMenuManager, AMenuService));
  CheckResult(AMenuService.GetBuiltIn(ID, Result));
end;

{ TAIMPActionEventHandler }

procedure TAIMPActionEventHandler.OnExecute(Data: IInterface);
begin
  MessageBox(0, 'Action executed', 'Demo', 0);
end;

{ TAIMPMenuItemEventHandler }

procedure TAIMPMenuItemEventHandler.OnExecute(Data: IInterface);
begin
  MessageBox(0, 'Menu item clicked', 'Demo', 0);
end;

end.
