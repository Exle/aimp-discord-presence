{************************************************}
{*                                              *}
{*          AIMP Programming Interface          *}
{*               v4.50 build 2000               *}
{*                                              *}
{*                Artem Izmaylov                *}
{*                (C) 2006-2017                 *}
{*                 www.aimp.ru                  *}
{*                                              *}
{*            Mail: support@aimp.ru             *}
{*                                              *}
{************************************************}

unit apiMenu;

{$I apiConfig.inc}

interface

uses
  Windows, apiObjects, apiActions;

const
  SID_IAIMPMenuItem = '{41494D50-4D65-6E75-4974-656D00000000}';
  IID_IAIMPMenuItem: TGUID = SID_IAIMPMenuItem;

  SID_IAIMPServiceMenuManager = '{41494D50-5372-764D-656E-754D6E677200}';
  IID_IAIMPServiceMenuManager: TGUID = SID_IAIMPServiceMenuManager;

  // IAIMPMenuItem Properties
  AIMP_MENUITEM_PROPID_CUSTOM       = 0;
  AIMP_MENUITEM_PROPID_ACTION       = 1;
  AIMP_MENUITEM_PROPID_ID           = 2;
  AIMP_MENUITEM_PROPID_NAME         = 3;
  AIMP_MENUITEM_PROPID_ENABLED      = 4;
  AIMP_MENUITEM_PROPID_STYLE        = 5; // Refer to the AIMP_MENUITEM_STYLE_XXX
  AIMP_MENUITEM_PROPID_EVENT        = 6;
  AIMP_MENUITEM_PROPID_EVENT_ONSHOW = 7;
  AIMP_MENUITEM_PROPID_GLYPH        = 10;
  AIMP_MENUITEM_PROPID_PARENT       = 11;
  AIMP_MENUITEM_PROPID_VISIBLE      = 12;
  AIMP_MENUITEM_PROPID_CHECKED      = 13;
  AIMP_MENUITEM_PROPID_DEFAULT      = 14;
  AIMP_MENUITEM_PROPID_SHORTCUT     = 15;

  // Styles for the AIMP_MENUITEM_PROPID_STYLE property
  AIMP_MENUITEM_STYLE_NORMAL   = 0;
  AIMP_MENUITEM_STYLE_CHECKBOX = 1;
  AIMP_MENUITEM_STYLE_RADIOBOX = 2;

  // Built-in menu ids
  AIMP_MENUID_COMMON_UTILITIES                  = 0;
  AIMP_MENUID_PLAYER_MAIN_FUNCTIONS             = 10;
  AIMP_MENUID_PLAYER_MAIN_OPEN                  = 11;
  AIMP_MENUID_PLAYER_MAIN_OPTIONS               = 12;
  AIMP_MENUID_PLAYER_PLAYLIST_ADDING            = 20;
  AIMP_MENUID_PLAYER_PLAYLIST_DELETION          = 21;
  AIMP_MENUID_PLAYER_PLAYLIST_SORTING           = 22;
  AIMP_MENUID_PLAYER_PLAYLIST_MISCELLANEOUS     = 23;
  AIMP_MENUID_PLAYER_PLAYLIST_MANAGE            = 24;
  AIMP_MENUID_PLAYER_PLAYLIST_CONTEXT_ADDING    = 30;
  AIMP_MENUID_PLAYER_PLAYLIST_CONTEXT_QUEUE     = 31;
  AIMP_MENUID_PLAYER_PLAYLIST_CONTEXT_FUNCTIONS = 32;
  AIMP_MENUID_PLAYER_PLAYLIST_CONTEXT_SENDING   = 33;
  AIMP_MENUID_PLAYER_PLAYLIST_CONTEXT_DELETION  = 34;  
  AIMP_MENUID_PLAYER_TRAY                       = 40;
  AIMP_MENUID_PLAYER_EQ_LIB                     = 41;
  AIMP_MENUID_PLAYER_STOP_OPTIONS               = 42; // v4.00.1690
  AIMP_MENUID_ML_MISCELLANEOUS                  = 50; // v4.10
  AIMP_MENUID_ML_DELETION                       = 51; // v4.10
  AIMP_MENUID_ML_MAIN_DB                        = 60; // v4.10
  AIMP_MENUID_ML_MAIN_FUNCTIONS                 = 61; // v4.10
  AIMP_MENUID_ML_MAIN_OPEN                      = 62; // v4.10
  AIMP_MENUID_ML_MAIN_OPTIONS                   = 63; // v4.10
  AIMP_MENUID_ML_TABLE_CONTEXT_ADDING           = 70; // v4.10
  AIMP_MENUID_ML_TABLE_CONTEXT_FUNCTIONS        = 71; // v4.10
  AIMP_MENUID_ML_TABLE_CONTEXT_SENDING          = 72; // v4.10
  AIMP_MENUID_ML_TABLE_CONTEXT_DELETION         = 73; // v4.10
  AIMP_MENUID_ML_TREE_CONTEXT_FUNCTIONS         = 80; // v4.10
  AIMP_MENUID_ML_TREE_CONTEXT_DELETION          = 81; // v4.10


type

  { IAIMPMenuItem }

  IAIMPMenuItem = interface(IAIMPPropertyList)
  [SID_IAIMPMenuItem]
    function DeleteChildren: HRESULT; stdcall;
  end;

  { IAIMPServiceMenuManager }

  IAIMPServiceMenuManager = interface(IUnknown)
  [SID_IAIMPServiceMenuManager]
    function GetBuiltIn(ID: Integer; out MenuItem: IAIMPMenuItem): HRESULT; stdcall;
    function GetByID(ID: IAIMPString; out MenuItem: IAIMPMenuItem): HRESULT; stdcall;
  end;

implementation

end.
