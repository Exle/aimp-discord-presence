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

unit apiGUI;

{$MINENUMSIZE 4}

interface

uses
  Windows, Types,
  // API
  apiMenu,
  apiObjects;

const
  SID_IAIMPUIDPIAwareness = '{61756944-5049-4177-6172-656E65737300}';
  IID_IAIMPUIDPIAwareness: TGUID = SID_IAIMPUIDPIAwareness;

  SID_IAIMPServiceUI = '{41494D50-5365-7276-6963-655549000000}';
  IID_IAIMPServiceUI: TGUID = SID_IAIMPServiceUI;

  SID_IAIMPUIImageList = '{61756949-6D67-4C69-7374-000000000000}';
  IID_IAIMPUIImageList: TGUID = SID_IAIMPUIImageList;

  SID_IAIMPUIImageList2 = '{61756949-6D67-4C69-7374-320000000000}';
  IID_IAIMPUIImageList2: TGUID = SID_IAIMPUIImageList2;

  SID_IAIMPUIBaseEdit = '{61756942-6173-6545-6469-740000000000}';
  IID_IAIMPUIBaseEdit: TGUID = SID_IAIMPUIBaseEdit;

  SID_IAIMPUIBBCBox = '{61756942-4243-426F-7800-000000000000}';
  IID_IAIMPUIBBCBox: TGUID = SID_IAIMPUIBBCBox;

  SID_IAIMPUIBevel = '{61756942-6576-656C-0000-000000000000}';
  IID_IAIMPUIBevel: TGUID = SID_IAIMPUIBevel;

  SID_IAIMPUIButton = '{61756942-7574-746F-6E00-000000000000}';
  IID_IAIMPUIButton: TGUID = SID_IAIMPUIButton;

  SID_IAIMPUICategory = '{61756943-6174-6567-6F72-790000000000}';
  IID_IAIMPUICategory: TGUID = SID_IAIMPUICategory;

  SID_IAIMPUICheckBox = '{61756943-6865-636B-426F-780000000000}';
  IID_IAIMPUICheckBox: TGUID = SID_IAIMPUICheckBox;

  SID_IAIMPUIGroupBox = '{61756947-726F-7570-426F-780000000000}';
  IID_IAIMPUIGroupBox: TGUID = SID_IAIMPUIGroupBox;

  SID_IAIMPUIImage = '{61756949-6D61-6765-0000-000000000000}';
  IID_IAIMPUIImage: TGUID = SID_IAIMPUIImage;

  SID_IAIMPUILabel = '{6175694C-6162-656C-0000-000000000000}';
  IID_IAIMPUILabel: TGUID = SID_IAIMPUILabel;

  SID_IAIMPUIMemo = '{6175694D-656D-6F00-0000-000000000000}';
  IID_IAIMPUIMemo: TGUID = SID_IAIMPUIMemo;

  SID_IAIMPUIPaintBox = '{61756950-6169-6E74-426F-780000000000}';
  IID_IAIMPUIPaintBox: TGUID = SID_IAIMPUIPaintBox;

  SID_IAIMPUIPageControl = '{61756950-6167-6543-7472-6C0000000000}';
  IID_IAIMPUIPageControl: TGUID = SID_IAIMPUIPageControl;

  SID_IAIMPUIPageControlEvents = '{61756950-6167-6543-7472-6C45766E7400}';
  IID_IAIMPUIPageControlEvents: TGUID = SID_IAIMPUIPageControlEvents;

  SID_IAIMPUIPanel = '{61756950-616E-656C-0000-000000000000}';
  IID_IAIMPUIPanel: TGUID = SID_IAIMPUIPanel;

  SID_IAIMPUIProgressBar = '{61756950-726F-6772-6573-734261720000}';
  IID_IAIMPUIProgressBar: TGUID = SID_IAIMPUIProgressBar;

  SID_IAIMPUIScrollBox = '{61756953-6372-6F6C-6C42-6F7800000000}';
  IID_IAIMPUIScrollBox: TGUID = SID_IAIMPUIScrollBox;

  SID_IAIMPUISlider = '{61756953-6C69-6465-7200-000000000000}';
  IID_IAIMPUISlider: TGUID = SID_IAIMPUISlider;

  SID_IAIMPUITabControl = '{61756954-6162-4374-726C-000000000000}';
  IID_IAIMPUITabControl: TGUID = SID_IAIMPUITabControl;

  SID_IAIMPUITabControlEvents = '{61756954-6162-4374-726C-45766E747300}';
  IID_IAIMPUITabControlEvents: TGUID = SID_IAIMPUITabControlEvents;

  SID_IAIMPUITabSheet = '{61756954-6162-5368-6565-740000000000}';
  IID_IAIMPUITabSheet: TGUID = SID_IAIMPUITabSheet;

  SID_IAIMPUIRadioBox = '{61756952-6164-696F-426F-780000000000}';
  IID_IAIMPUIRadioBox: TGUID = SID_IAIMPUIRadioBox;

  SID_IAIMPUIValidationLabel = '{61756956-616C-6964-4C61-62656C000000}';
  IID_IAIMPUIValidationLabel: TGUID = SID_IAIMPUIValidationLabel;

  SID_IAIMPUIForm = '{61756946-6F72-6D00-0000-000000000000}';
  IID_IAIMPUIForm: TGUID = SID_IAIMPUIForm;

  SID_IAIMPUIFormEvents = '{61756946-6F72-6D45-7665-6E7473000000}';
  IID_IAIMPUIFormEvents: TGUID = SID_IAIMPUIFormEvents;

  SID_IAIMPUIFormEvents2 = '{61756946-6F72-6D45-7665-6E7473320000}';
  IID_IAIMPUIFormEvents2: TGUID = SID_IAIMPUIFormEvents2;

  SID_IAIMPUISpinEdit = '{61756953-7069-6E45-6469-740000000000}';
  IID_IAIMPUISpinEdit: TGUID = SID_IAIMPUISpinEdit;

  SID_IAIMPUITimeEdit = '{61756954-696D-6545-6469-740000000000}';
  IID_IAIMPUITimeEdit: TGUID = SID_IAIMPUITimeEdit;

  SID_IAIMPUISplitter = '{61756953-706C-6974-7465-720000000000}';
  IID_IAIMPUISplitter: TGUID = SID_IAIMPUISplitter;

  SID_IAIMPUIEditButton = '{61756945-6469-7442-746E-000000000000}';
  IID_IAIMPUIEditButton: TGUID = SID_IAIMPUIEditButton;

  SID_IAIMPUIBaseButtonnedEdit = '{61756942-6173-6542-746E-456469740000}';
  IID_IAIMPUIBaseButtonnedEdit: TGUID = SID_IAIMPUIBaseButtonnedEdit;

  SID_IAIMPUIEdit = '{61756945-6469-7400-0000-000000000000}';
  IID_IAIMPUIEdit: TGUID = SID_IAIMPUIEdit;

  SID_IAIMPUIChangeEvents = '{61756945-766E-7443-6861-6E6765000000}';
  IID_IAIMPUIChangeEvents: TGUID = SID_IAIMPUIChangeEvents;

  SID_IAIMPUIDrawEvents = '{61756945-766E-7444-7261-770000000000}';
  IID_IAIMPUIDrawEvents: TGUID = SID_IAIMPUIDrawEvents;

  SID_IAIMPUIKeyboardEvents = '{61756945-766E-744B-6579-626F61726400}';
  IID_IAIMPUIKeyboardEvents: TGUID = SID_IAIMPUIKeyboardEvents;

  SID_IAIMPUIPopupMenuEvents = '{61756945-766E-7450-6F70-757000000000}';
  IID_IAIMPUIPopupMenuEvents: TGUID = SID_IAIMPUIPopupMenuEvents;

  SID_IAIMPUIMouseEvents = '{61756945-766E-744D-6F75-736500000000}';
  IID_IAIMPUIMouseEvents: TGUID = SID_IAIMPUIMouseEvents;

  SID_IAIMPUIMouseWheelEvents = '{61756945-766E-744D-6F75-736557686C00}';
  IID_IAIMPUIMouseWheelEvents: TGUID = SID_IAIMPUIMouseWheelEvents;

  SID_IAIMPUIPlacementEvents = '{61756945-766E-7442-6F75-6E6473000000}';
  IID_IAIMPUIPlacementEvents: TGUID = SID_IAIMPUIPlacementEvents;

  SID_IAIMPUIControl = '{61756943-6F6E-7472-6F6C-000000000000}';
  IID_IAIMPUIControl: TGUID = SID_IAIMPUIControl;

  SID_IAIMPUIWinControl = '{61756957-696E-4374-726C-000000000000}';
  IID_IAIMPUIWinControl: TGUID = SID_IAIMPUIWinControl;

  SID_IAIMPUIComboBox = '{61756943-6F6D-626F-0000-000000000000}';
  IID_IAIMPUIComboBox: TGUID = SID_IAIMPUIComboBox;

  SID_IAIMPUIBaseComboBox = '{61756942-6173-6543-6F6D-626F00000000}';
  IID_IAIMPUIBaseComboBox: TGUID = SID_IAIMPUIBaseComboBox;

  SID_IAIMPUICheckComboBox = '{61756943-6865-636B-6564-436F6D626F00}';
  IID_IAIMPUICheckComboBox: TGUID = SID_IAIMPUICheckComboBox;

  SID_IAIMPUIImageComboBox = '{61756949-6D61-6765-436F-6D626F000000}';
  IID_IAIMPUIImageComboBox: TGUID = SID_IAIMPUIImageComboBox;

  SID_IAIMPUIPopupMenu = '{61756950-6F70-7570-4D65-6E7500000000}';
  IID_IAIMPUIPopupMenu: TGUID = SID_IAIMPUIPopupMenu;

  SID_IAIMPUIMenuItem = '{6175694D-656E-7549-7465-6D0000000000}';
  IID_IAIMPUIMenuItem: TGUID = SID_IAIMPUIMenuItem;

  SID_IAIMPUITreeListGroup = '{61756954-4C47-726F-7570-000000000000}';
  IID_IAIMPUITreeListGroup: TGUID = SID_IAIMPUITreeListGroup;

  SID_IAIMPUITreeListNode = '{61756954-4C4E-6F64-6500-000000000000}';
  IID_IAIMPUITreeListNode: TGUID = SID_IAIMPUITreeListNode;

  SID_IAIMPUITreeList = '{61756954-4C00-0000-0000-000000000000}';
  IID_IAIMPUITreeList: TGUID = SID_IAIMPUITreeList;

  SID_IAIMPUITreeListEvents = '{61756954-4C45-7665-6E74-730000000000}';
  IID_IAIMPUITreeListEvents: TGUID = SID_IAIMPUITreeListEvents;

  SID_IAIMPUITreeListColumn = '{61756954-4C43-6F6C-756D-6E0000000000}';
  IID_IAIMPUITreeListColumn: TGUID = SID_IAIMPUITreeListColumn;

  SID_IAIMPUITreeListCustomDrawEvents = '{61756954-4C44-7261-7745-766E74730000}';
  IID_IAIMPUITreeListCustomDrawEvents: TGUID = SID_IAIMPUITreeListCustomDrawEvents;

  SID_IAIMPUITreeListInplaceEditingEvents = '{61756954-4C45-6474-4576-6E7473000000}';
  IID_IAIMPUITreeListInplaceEditingEvents: TGUID = SID_IAIMPUITreeListInplaceEditingEvents;

  SID_IAIMPUITreeListDragSortingEvents = '{6169544C-4472-6167-536F-727445766E74}';
  IID_IAIMPUITreeListDragSortingEvents: TGUID = SID_IAIMPUITreeListDragSortingEvents;

  SID_IAIMPUIFileDialogs = '{61756946-696C-6544-6C67-730000000000}';
  IID_IAIMPUIFileDialogs: TGUID = SID_IAIMPUIFileDialogs;

  SID_IAIMPUIBrowseFolderDialog = '{61756942-7277-7346-6C64-72446C670000}';
  IID_IAIMPUIBrowseFolderDialog: TGUID = SID_IAIMPUIBrowseFolderDialog;

  SID_IAIMPUIMessageDialog = '{6175694D-7367-446C-6700-000000000000}';
  IID_IAIMPUIMessageDialog: TGUID = SID_IAIMPUIMessageDialog;

  SID_IAIMPUIInputDialog = '{61756949-6E70-7574-446C-670000000000}';
  IID_IAIMPUIInputDialog: TGUID = SID_IAIMPUIInputDialog;

  SID_IAIMPUIInputDialogEvents = '{61756949-6E70-7574-446C-6745766E7400}';
  IID_IAIMPUIInputDialogEvents: TGUID = SID_IAIMPUIInputDialogEvents;

  SID_IAIMPUIBrandBox = '{61756942-7261-6E64-426F-780000000000}';
  IID_IAIMPUIBrandBox: TGUID = SID_IAIMPUIBrandBox;

  SID_IAIMPUIProgressDialog = '{61756950-726F-6772-6573-73446C670000}';
  IID_IAIMPUIProgressDialog: TGUID = SID_IAIMPUIProgressDialog;

  SID_IAIMPUIProgressDialogEvents = '{61756950-7267-7273-446C-6745766E7400}';
  IID_IAIMPUIProgressDialogEvents: TGUID = SID_IAIMPUIProgressDialogEvents;

  SID_IAIMPUIWndProcEvents = '{61756957-6E64-5072-6F63-45766E747300}';
  IID_IAIMPUIWndProcEvents: TGUID = SID_IAIMPUIWndProcEvents;

const
//----------------------------------------------------------------------------------------------------------------------
// Flags
//----------------------------------------------------------------------------------------------------------------------

  // Modifiers Flags
  AIMPUI_FLAGS_MOD_ALT    = 1;
  AIMPUI_FLAGS_MOD_CTRL   = 2;
  AIMPUI_FLAGS_MOD_SHIFT  = 4;

  // Borders Flags
  AIMPUI_FLAGS_BORDER_LEFT   = 1;
  AIMPUI_FLAGS_BORDER_TOP    = 2;
  AIMPUI_FLAGS_BORDER_RIGHT  = 4;
  AIMPUI_FLAGS_BORDER_BOTTOM = 8;

  // Font Style Flags
  AIMPUI_FLAGS_FONT_BOLD      = 1;
  AIMPUI_FLAGS_FONT_ITALIC    = 2;
  AIMPUI_FLAGS_FONT_UNDERLINE = 4;
  AIMPUI_FLAGS_FONT_STRIKEOUT = 8;

  // Modal Result Flags
  AIMPUI_FLAGS_MODALRESULT_NONE     = 0;
  AIMPUI_FLAGS_MODALRESULT_OK       = 1;
  AIMPUI_FLAGS_MODALRESULT_CANCEL   = 2;
  AIMPUI_FLAGS_MODALRESULT_ABORT    = 3;
  AIMPUI_FLAGS_MODALRESULT_RETRY    = 4;
  AIMPUI_FLAGS_MODALRESULT_IGNORE   = 5;
  AIMPUI_FLAGS_MODALRESULT_YES      = 6;
  AIMPUI_FLAGS_MODALRESULT_NO       = 7;
  AIMPUI_FLAGS_MODALRESULT_CLOSE    = 8;
  AIMPUI_FLAGS_MODALRESULT_HELP     = 9;
  AIMPUI_FLAGS_MODALRESULT_TRYAGAIN = 10;
  AIMPUI_FLAGS_MODALRESULT_CONTINUE = 11;

  // Edit Mask Flags
  AIMPUI_FLAGS_EDITMASK_TEXT    = 0;
  AIMPUI_FLAGS_EDITMASK_INTEGER = 1;
  AIMPUI_FLAGS_EDITMASK_FLOAT   = 2;

  // Form's BorderStyle
  AIMPUI_FLAGS_BORDERSTYLE_SIZEABLE          = 0;
  AIMPUI_FLAGS_BORDERSTYLE_SINGLE            = 1;
  AIMPUI_FLAGS_BORDERSTYLE_DIALOG            = 2;
  AIMPUI_FLAGS_BORDERSTYLE_TOOLWINDOW        = 3;
  AIMPUI_FLAGS_BORDERSTYLE_TOOLWINDOWSIZABLE = 4;
  AIMPUI_FLAGS_BORDERSTYLE_NONE              = 5;

  // Form's BorderIcons
  AIMPUI_FLAGS_BORDERICON_SYSTEMMENU         = 1;
  AIMPUI_FLAGS_BORDERICON_MINIMIZE           = 2;
  AIMPUI_FLAGS_BORDERICON_MAXIMIZE           = 4;

  // Flags for IAIMPUIBrowseFolderDialog
  AIMPUI_FLAGS_BROWSEFOLDER_CUSTOMPATHS = 1;
  AIMPUI_FLAGS_BROWSEFOLDER_MULTISELECT = 2;

  // Button Styles
  AIMPUI_FLAGS_BUTTON_STYLE_NORMAL          = 0;
  AIMPUI_FLAGS_BUTTON_STYLE_DROPDOWN        = 1;
  AIMPUI_FLAGS_BUTTON_STYLE_DROPDOWNBUTTON  = 2;

  // Flags for IAIMPUITreeListNode.Get
  AIMPUI_FLAGS_TL_NODE_GET_PARENT      = -1;
  AIMPUI_FLAGS_TL_NODE_GET_NEXTSIBLING = -2;
  AIMPUI_FLAGS_TL_NODE_GET_PREVSIBLING = -3;

  // Flags for IAIMPUITreeList.SortBy
  AIMPUI_FLAGS_TL_SORTBY_FLAG_AUTO       = 0;
  AIMPUI_FLAGS_TL_SORTBY_FLAG_ASCENDING  = 1;
  AIMPUI_FLAGS_TL_SORTBY_FLAG_DESCENDING = 2;

  // Flags for InsertTo for IAIMPUITreeListDragDropEvents
  AIMPUI_FLAGS_TL_INSERTTO_AFTER  = 0;
  AIMPUI_FLAGS_TL_INSERTTO_BEFORE = 1;
  AIMPUI_FLAGS_TL_INSERTTO_INTO   = 2;

  // Flags for AIMPUI_TL_PROPID_GRID_LINES property
  AIMPUI_FLAGS_TL_GRIDLINE_VERTICAL   = 1;
  AIMPUI_FLAGS_TL_GRIDLINE_HORIZONTAL = 2;

//----------------------------------------------------------------------------------------------------------------------
// Property IDs
//----------------------------------------------------------------------------------------------------------------------

  // PropID for IAIMPUIControl
  AIMPUI_CONTROL_PROPID_CUSTOM     = 0;
  AIMPUI_CONTROL_PROPID_ENABLED    = 1;
  AIMPUI_CONTROL_PROPID_HINT       = 2;
  AIMPUI_CONTROL_PROPID_NAME       = 3;
  AIMPUI_CONTROL_PROPID_PARENT     = 4;
  AIMPUI_CONTROL_PROPID_POPUPMENU  = 5;
  AIMPUI_CONTROL_PROPID_VISIBLE    = 6;
  AIMPUI_CONTROL_MAX_PROPID        = 20;

  // PropID for IAIMPUIWinControl
  AIMPUI_WINCONTROL_PROPID_FOCUSED  = AIMPUI_CONTROL_MAX_PROPID + 1;
  AIMPUI_WINCONTROL_PROPID_TABORDER = AIMPUI_CONTROL_MAX_PROPID + 2;
  AIMPUI_WINCONTROL_MAX_PROPID      = AIMPUI_CONTROL_MAX_PROPID + 10;

  // PropID for IAIMPUIBaseEdit
  AIMPUI_BASEEDIT_PROPID_BORDERS   = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_BASEEDIT_PROPID_MAXLENGTH = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_BASEEDIT_PROPID_READONLY  = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_BASEEDIT_PROPID_SELLENGTH = AIMPUI_WINCONTROL_MAX_PROPID + 4;
  AIMPUI_BASEEDIT_PROPID_SELSTART  = AIMPUI_WINCONTROL_MAX_PROPID + 5;
  AIMPUI_BASEEDIT_PROPID_SELTEXT   = AIMPUI_WINCONTROL_MAX_PROPID + 6;
  AIMPUI_BASEEDIT_PROPID_TEXT      = AIMPUI_WINCONTROL_MAX_PROPID + 7;
  AIMPUI_BASEEDIT_MAX_PROPID       = AIMPUI_WINCONTROL_MAX_PROPID + 10;

  // PropID for IAIMPUIBBCBox
  AIMPUI_BBCBOX_PROPID_BORDERS     = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_BBCBOX_PROPID_TEXT        = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_BBCBOX_PROPID_TRANSPARENT = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_BBCBOX_PROPID_WORDWRAP    = AIMPUI_WINCONTROL_MAX_PROPID + 4;

  // PropID for IAIMPUIBevel
  AIMPUI_BEVEL_PROPID_BORDERS = AIMPUI_CONTROL_MAX_PROPID + 1;

  // PropID for IAIMPUIBrandBox
  AIMPUI_BRANDBOX_PROPID_CAPTION = AIMPUI_WINCONTROL_MAX_PROPID + 1;

  // PropID for IAIMPUIButton
  AIMPUI_BUTTON_PROPID_CAPTION      = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_BUTTON_PROPID_FOCUSONCLICK = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_BUTTON_PROPID_DEFAULT      = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_BUTTON_PROPID_DROPDOWNMENU = AIMPUI_WINCONTROL_MAX_PROPID + 4;
  AIMPUI_BUTTON_PROPID_IMAGEINDEX   = AIMPUI_WINCONTROL_MAX_PROPID + 5;
  AIMPUI_BUTTON_PROPID_IMAGELIST    = AIMPUI_WINCONTROL_MAX_PROPID + 6;
  AIMPUI_BUTTON_PROPID_MODALRESULT  = AIMPUI_WINCONTROL_MAX_PROPID + 7;
  AIMPUI_BUTTON_PROPID_STYLE        = AIMPUI_WINCONTROL_MAX_PROPID + 8;

  // PropID for IAIMPUIBaseButtonnedEdit
  AIMPUI_BUTTONEDEDIT_PROPID_BUTTONSIMAGES = AIMPUI_BASEEDIT_MAX_PROPID + 1;
  AIMPUI_BUTTONEDEDIT_MAX_PROPID           = AIMPUI_BASEEDIT_MAX_PROPID + 10;

  // PropID for IAIMPUIEditButton
  AIMPUI_EDITBUTTON_PROPID_CUSTOM     = 0;
  AIMPUI_EDITBUTTON_PROPID_CAPTION    = 1;
  AIMPUI_EDITBUTTON_PROPID_ENABLED    = 2;
  AIMPUI_EDITBUTTON_PROPID_HINT       = 3;
  AIMPUI_EDITBUTTON_PROPID_INDEX      = 4;
  AIMPUI_EDITBUTTON_PROPID_IMAGEINDEX = 5;
  AIMPUI_EDITBUTTON_PROPID_VISIBLE    = 6;
  AIMPUI_EDITBUTTON_PROPID_WIDTH      = 7;

  // PropID for IAIMPUICategory
  AIMPUI_CATEGORY_PROPID_AUTOSIZE = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_CATEGORY_PROPID_CAPTION  = AIMPUI_WINCONTROL_MAX_PROPID + 2;

  // PropID for IAIMPUICheckBox and IAIMPUIRadioBox
  AIMPUI_CHECKBOX_PROPID_AUTOSIZE = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_CHECKBOX_PROPID_CAPTION  = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_CHECKBOX_PROPID_STATE    = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_CHECKBOX_PROPID_WORDWRAP = AIMPUI_WINCONTROL_MAX_PROPID + 4;

  // PropID for IAIMPUIComboBox
  AIMPUI_COMBOBOX_PROPID_AUTOCOMPLETE   = AIMPUI_BUTTONEDEDIT_MAX_PROPID + 1;
  AIMPUI_COMBOBOX_PROPID_ITEMINDEX      = AIMPUI_BUTTONEDEDIT_MAX_PROPID + 2;
  AIMPUI_COMBOBOX_PROPID_ITEMOBJECT     = AIMPUI_BUTTONEDEDIT_MAX_PROPID + 3;
  AIMPUI_COMBOBOX_PROPID_TEXT           = AIMPUI_BUTTONEDEDIT_MAX_PROPID + 4;
  AIMPUI_COMBOBOX_PROPID_STYLE          = AIMPUI_BUTTONEDEDIT_MAX_PROPID + 5;

  // PropID for IAIMPUICheckComboBox
  AIMPUI_CHECKCOMBO_PROPID_TEXT      = AIMPUI_BUTTONEDEDIT_MAX_PROPID + 1;

  // PropID for IAIMPUIEdit
  AIMPUI_EDIT_PROPID_PASSWORDCHAR    = AIMPUI_BUTTONEDEDIT_MAX_PROPID + 2;
  AIMPUI_EDIT_PROPID_TEXTHINT        = AIMPUI_BUTTONEDEDIT_MAX_PROPID + 3;

  // PropID for IAIMPUIGroupBox
  AIMPUI_GROUPBOX_PROPID_AUTOSIZE    = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_GROUPBOX_PROPID_BORDERS     = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_GROUPBOX_PROPID_TRANSPARENT = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_GROUPBOX_PROPID_CHECKMODE   = AIMPUI_WINCONTROL_MAX_PROPID + 4;
  AIMPUI_GROUPBOX_PROPID_CHECKED     = AIMPUI_WINCONTROL_MAX_PROPID + 5;
  AIMPUI_GROUPBOX_PROPID_CAPTION     = AIMPUI_WINCONTROL_MAX_PROPID + 6;

  // PropID for IAIMPUIImage
  AIMPUI_IMAGE_PROPID_IMAGE            = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_IMAGE_PROPID_IMAGESTRETCHMODE = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_IMAGE_PROPID_IMAGEINDEX       = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_IMAGE_PROPID_IMAGELIST        = AIMPUI_WINCONTROL_MAX_PROPID + 4;

  // PropID for IAIMPUIImageComboBox
  AIMPUI_IMAGECOMBOBOX_PROPID_IMAGELIST = AIMPUI_BUTTONEDEDIT_MAX_PROPID + 1;
  AIMPUI_IMAGECOMBOBOX_PROPID_ITEMINDEX = AIMPUI_BUTTONEDEDIT_MAX_PROPID + 2;

  // PropID for IAIMPUILabel
  AIMPUI_LABEL_PROPID_AUTOSIZE       = AIMPUI_CONTROL_MAX_PROPID + 1;
  AIMPUI_LABEL_PROPID_LINE           = AIMPUI_CONTROL_MAX_PROPID + 2;
  AIMPUI_LABEL_PROPID_TEXT           = AIMPUI_CONTROL_MAX_PROPID + 3;
  AIMPUI_LABEL_PROPID_TEXTALIGN      = AIMPUI_CONTROL_MAX_PROPID + 4;
  AIMPUI_LABEL_PROPID_TEXTALIGNVERT  = AIMPUI_CONTROL_MAX_PROPID + 5;
  AIMPUI_LABEL_PROPID_TEXTCOLOR      = AIMPUI_CONTROL_MAX_PROPID + 6;
  AIMPUI_LABEL_PROPID_TEXTSTYLE      = AIMPUI_CONTROL_MAX_PROPID + 7;
  AIMPUI_LABEL_PROPID_TRANSPARENT    = AIMPUI_CONTROL_MAX_PROPID + 8;
  AIMPUI_LABEL_PROPID_URL            = AIMPUI_CONTROL_MAX_PROPID + 9;
  AIMPUI_LABEL_PROPID_WORDWRAP       = AIMPUI_CONTROL_MAX_PROPID + 10;
  AIMPUI_LABEL_MAX_PROPID            = AIMPUI_CONTROL_MAX_PROPID + 20;

  // PropID for IAIMPUIMemo
  AIMPUI_MEMO_PROPID_CARET_XY = AIMPUI_BASEEDIT_MAX_PROPID + 1;

  // PropID for IAIMPUITabSheet
  AIMPUI_TABSHEET_PROPID_CAPTION   = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_TABSHEET_PROPID_INDEX     = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_TABSHEET_PROPID_VISIBLE   = AIMPUI_WINCONTROL_MAX_PROPID + 3;

  // PropID for IAIMPUIPageControl
  AIMPUI_PAGECONTROL_PROPID_ACTIVE = AIMPUI_WINCONTROL_MAX_PROPID + 1;

  // PropID for IAIMPUIPanel
  AIMPUI_PANEL_PROPID_AUTOSIZE    = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_PANEL_PROPID_BORDERS     = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_PANEL_PROPID_TRANSPARENT = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_PANEL_PROPID_PADDING     = AIMPUI_WINCONTROL_MAX_PROPID + 4;

  // PropID for IAIMPUIProgressBar
  AIMPUI_PROGRESSBAR_PROPID_INDETERMINATE = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_PROGRESSBAR_PROPID_MAX           = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_PROGRESSBAR_PROPID_MIN           = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_PROGRESSBAR_PROPID_PROGRESS      = AIMPUI_WINCONTROL_MAX_PROPID + 4;

  // PropID for IAIMPUIScrollBox
  AIMPUI_SCROLLBOX_PROPID_BORDERS    = AIMPUI_WINCONTROL_MAX_PROPID + 1;

  // PropID for IAIMPUISlider
  AIMPUI_SLIDER_PROPID_HORIZONTAL    = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_SLIDER_PROPID_MARKS         = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_SLIDER_PROPID_PAGESIZE      = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_SLIDER_PROPID_TRANSPARENT   = AIMPUI_WINCONTROL_MAX_PROPID + 4;
  AIMPUI_SLIDER_PROPID_VALUE         = AIMPUI_WINCONTROL_MAX_PROPID + 5;
  AIMPUI_SLIDER_PROPID_VALUEDEFAULT  = AIMPUI_WINCONTROL_MAX_PROPID + 6;
  AIMPUI_SLIDER_PROPID_VALUEMAX      = AIMPUI_WINCONTROL_MAX_PROPID + 7;
  AIMPUI_SLIDER_PROPID_VALUEMIN      = AIMPUI_WINCONTROL_MAX_PROPID + 8;

  // PropID for IAIMPUISplitter
  AIMPUI_SPLITTER_PROPID_CANHIDE     = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_SPLITTER_PROPID_CONTROL     = AIMPUI_WINCONTROL_MAX_PROPID + 2;

  // PropID for IAIMPUISpinEdit
  AIMPUI_SPINEDIT_PROPID_DISPLAYMASK = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_SPINEDIT_PROPID_INCREMENT   = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_SPINEDIT_PROPID_MAXVALUE    = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_SPINEDIT_PROPID_MINVALUE    = AIMPUI_WINCONTROL_MAX_PROPID + 4;
  AIMPUI_SPINEDIT_PROPID_VALUE       = AIMPUI_WINCONTROL_MAX_PROPID + 5;
  AIMPUI_SPINEDIT_PROPID_VALUETYPE   = AIMPUI_WINCONTROL_MAX_PROPID + 6;

  // PropID for IAIMPUITabControl
  AIMPUI_TABCONTROL_PROPID_ACTIVETABINDEX = AIMPUI_WINCONTROL_MAX_PROPID + 1;

  // PropID for IAIMPUITimeEdit
  AIMPUI_TIMEDIT_PROPID_VALUE = AIMPUI_WINCONTROL_MAX_PROPID + 1;

  // PropID for IAIMPUITreeListColumn
  AIMPUI_TL_COLUMN_PROPID_CAN_RESIZE      = 1;
  AIMPUI_TL_COLUMN_PROPID_CAPTION         = 2;
  AIMPUI_TL_COLUMN_PROPID_DRAWINDEX       = 3;
  AIMPUI_TL_COLUMN_PROPID_IMAGEINDEX      = 4;
  AIMPUI_TL_COLUMN_PROPID_INDEX           = 5;
  AIMPUI_TL_COLUMN_PROPID_TEXT_ALIGNMENT  = 6;
  AIMPUI_TL_COLUMN_PROPID_TEXT_VISIBLE    = 7;
  AIMPUI_TL_COLUMN_PROPID_VISIBLE         = 8;
  AIMPUI_TL_COLUMN_PROPID_WIDTH           = 9;

  // PropID for IAIMPUITreeListGroup
  AIMPUI_TL_GROUP_PROPID_CAPTION      = 1;
  AIMPUI_TL_GROUP_PROPID_CHECKSTATE   = 2;
  AIMPUI_TL_GROUP_PROPID_EXPANDED     = 3;
  AIMPUI_TL_GROUP_PROPID_INDEX        = 4;
  AIMPUI_TL_GROUP_PROPID_SELECTED     = 5;

  // PropID for IAIMPUITreeListNode
  AIMPUI_TL_NODE_PROPID_ABS_VISIBLE_INDEX     = 0;
  AIMPUI_TL_NODE_PROPID_CHECK_ENABLED         = 1;
  AIMPUI_TL_NODE_PROPID_CHECKED               = 2;
  AIMPUI_TL_NODE_PROPID_CHILDREN_CHECK_STATE  = 3;
  AIMPUI_TL_NODE_PROPID_EXPANDED              = 4;
  AIMPUI_TL_NODE_PROPID_IMAGEINDEX            = 5;
  AIMPUI_TL_NODE_PROPID_INDEX                 = 6;
  AIMPUI_TL_NODE_PROPID_LEVEL                 = 7;
  AIMPUI_TL_NODE_PROPID_SELECTED              = 8;
  AIMPUI_TL_NODE_PROPID_TAG                   = 9;

  // PropID for IAIMPUITreeList
  AIMPUI_TL_PROPID_ALLOW_DELETING             = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_TL_PROPID_ALLOW_EDITING              = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_TL_PROPID_ALLOW_FOCUS_CELLS          = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_TL_PROPID_ALLOW_MULTISELECT          = AIMPUI_WINCONTROL_MAX_PROPID + 4;
  AIMPUI_TL_PROPID_ALLOW_REORDER_COLUMNS      = AIMPUI_WINCONTROL_MAX_PROPID + 5;
  AIMPUI_TL_PROPID_ALLOW_SHOWWHIDE_COLUMNS    = AIMPUI_WINCONTROL_MAX_PROPID + 6;
  AIMPUI_TL_PROPID_AUTOCHECK_SUBNODES         = AIMPUI_WINCONTROL_MAX_PROPID + 7;
  AIMPUI_TL_PROPID_BORDERS                    = AIMPUI_WINCONTROL_MAX_PROPID + 8;
  AIMPUI_TL_PROPID_CELL_HINTS                 = AIMPUI_WINCONTROL_MAX_PROPID + 9;
  AIMPUI_TL_PROPID_CHECKBOXES                 = AIMPUI_WINCONTROL_MAX_PROPID + 10;
  AIMPUI_TL_PROPID_COLUMN_AUTOWIDTH           = AIMPUI_WINCONTROL_MAX_PROPID + 11;
  AIMPUI_TL_PROPID_COLUMN_HEIGHT              = AIMPUI_WINCONTROL_MAX_PROPID + 12;
  AIMPUI_TL_PROPID_COLUMN_IMAGES              = AIMPUI_WINCONTROL_MAX_PROPID + 13;
  AIMPUI_TL_PROPID_COLUMN_VISIBLE             = AIMPUI_WINCONTROL_MAX_PROPID + 14;
  AIMPUI_TL_PROPID_DRAG_SORTING               = AIMPUI_WINCONTROL_MAX_PROPID + 15;
  AIMPUI_TL_PROPID_DRAG_SORTING_CHANGE_LEVEL  = AIMPUI_WINCONTROL_MAX_PROPID + 16;
  AIMPUI_TL_PROPID_GRID_LINES                 = AIMPUI_WINCONTROL_MAX_PROPID + 20;
  AIMPUI_TL_PROPID_GROUP_HEIGHT               = AIMPUI_WINCONTROL_MAX_PROPID + 21;
  AIMPUI_TL_PROPID_GROUPS                     = AIMPUI_WINCONTROL_MAX_PROPID + 22;
  AIMPUI_TL_PROPID_GROUPS_ALLOW_COLLAPSE      = AIMPUI_WINCONTROL_MAX_PROPID + 23;
  AIMPUI_TL_PROPID_GROUPS_FOCUS_ON_CLICK      = AIMPUI_WINCONTROL_MAX_PROPID + 24;
  AIMPUI_TL_PROPID_HOT_TRACK                  = AIMPUI_WINCONTROL_MAX_PROPID + 25;
  AIMPUI_TL_PROPID_INCSEARCH_COLUMN_INDEX     = AIMPUI_WINCONTROL_MAX_PROPID + 26;
  AIMPUI_TL_PROPID_NODE_HEIGHT                = AIMPUI_WINCONTROL_MAX_PROPID + 27;
  AIMPUI_TL_PROPID_NODE_IMAGE_ALIGNMENT       = AIMPUI_WINCONTROL_MAX_PROPID + 28;
  AIMPUI_TL_PROPID_NODE_IMAGES                = AIMPUI_WINCONTROL_MAX_PROPID + 29;
  AIMPUI_TL_PROPID_SORTING_MODE               = AIMPUI_WINCONTROL_MAX_PROPID + 30;

  // PropID for IAIMPUIValidationLabel
  AIMPUI_VALIDATIONLABEL_PROPID_GLYPH = AIMPUI_LABEL_MAX_PROPID + 1;

  // PropID for IAIMPUIForm
  AIMPUI_FORM_PROPID_BORDERICONS   = AIMPUI_WINCONTROL_MAX_PROPID + 1;
  AIMPUI_FORM_PROPID_BORDERSTYLE   = AIMPUI_WINCONTROL_MAX_PROPID + 2;
  AIMPUI_FORM_PROPID_CAPTION       = AIMPUI_WINCONTROL_MAX_PROPID + 3;
  AIMPUI_FORM_PROPID_CLOSEBYESCAPE = AIMPUI_WINCONTROL_MAX_PROPID + 4;
  AIMPUI_FORM_PROPID_ICON          = AIMPUI_WINCONTROL_MAX_PROPID + 5;
  AIMPUI_FORM_PROPID_PADDING       = AIMPUI_WINCONTROL_MAX_PROPID + 6;
  AIMPUI_FORM_PROPID_SHOWONTASKBAR = AIMPUI_WINCONTROL_MAX_PROPID + 7;

  // PropID for IAIMPUIProgressDialog
  AIMPUI_PROGRESSDLG_PROPID_CAPTION                  = 1;
  AIMPUI_PROGRESSDLG_PROPID_MESSAGE                  = 2;
  AIMPUI_PROGRESSDLG_PROPID_SHOW_PROGRESS_ON_TASKBAR = 3;

type
  TAIMPUIMouseButton   = (umbLeft = 0, umbRight = 1, umbMiddle = 2);
  TAIMPUITextAlignment = (utaLeftJustify = 0, utaRightJustify = 1, utaCenter = 2);
  TAIMPUITextVerticalAlignment = (utvaTop = 0, utvaBottom = 1, utvaCenter = 2);

//----------------------------------------------------------------------------------------------------------------------
// Basic Events Interfaces
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPUIChangeEvents }

  IAIMPUIChangeEvents = interface
  [SID_IAIMPUIChangeEvents]
    procedure OnChanged(Sender: IUnknown); stdcall;
  end;

  { IAIMPUIDrawEvents }

  IAIMPUIDrawEvents = interface
  [SID_IAIMPUIDrawEvents]
    procedure OnDraw(Sender: IUnknown; DC: HDC; const R: TRect); stdcall;
  end;

  { IAIMPUIKeyboardEvents }

  IAIMPUIKeyboardEvents = interface
  [SID_IAIMPUIKeyboardEvents]
    procedure OnEnter(Sender: IUnknown); stdcall;
    procedure OnExit(Sender: IUnknown); stdcall;
    procedure OnKeyDown(Sender: IUnknown; var Key: Word; Modifiers: Word); stdcall;
    procedure OnKeyPress(Sender: IUnknown; var Key: WideChar); stdcall;
    procedure OnKeyUp(Sender: IUnknown; var Key: Word; Modifiers: Word); stdcall;
  end;

  { IAIMPUIPopupMenuEvents }

  IAIMPUIPopupMenuEvents = interface
  [SID_IAIMPUIPopupMenuEvents]
    function OnContextPopup(Sender: IUnknown; X, Y: Integer): LongBool; stdcall;
  end;

  { IAIMPUIMouseEvents }

  IAIMPUIMouseEvents = interface
  [SID_IAIMPUIMouseEvents]
    procedure OnMouseDoubleClick(Sender: IUnknown; Button: TAIMPUIMouseButton; X, Y: Integer; Modifiers: Word); stdcall;
    procedure OnMouseDown(Sender: IUnknown; Button: TAIMPUIMouseButton; X, Y: Integer; Modifiers: Word); stdcall;
    procedure OnMouseLeave(Sender: IUnknown); stdcall;
    procedure OnMouseMove(Sender: IUnknown; X, Y: Integer; Modifiers: Word); stdcall;
    procedure OnMouseUp(Sender: IUnknown; Button: TAIMPUIMouseButton; X, Y: Integer; Modifiers: Word); stdcall;
  end;

  { IAIMPUIMouseWheelEvents }

  IAIMPUIMouseWheelEvents = interface
  [SID_IAIMPUIMouseWheelEvents]
    function OnMouseWheel(Sender: IUnknown; WheelDelta, X, Y: Integer; Modifiers: Word): LongBool; stdcall;
  end;

  { IAIMPUIPlacementEvents }

  IAIMPUIPlacementEvents = interface
  [SID_IAIMPUIPlacementEvents]
    procedure OnBoundsChanged(Sender: IUnknown); stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Basic Controls Interfaces
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPUIDPIAwareness }

  IAIMPUIDPIAwareness = interface
  [SID_IAIMPUIDPIAwareness]
    function IsDPIAware: LongBool; stdcall;
    function SetDPIAware(Value: LongBool): HRESULT; stdcall;
  end;

  { TAIMPUIControlPlacement }

  TAIMPUIControlAlignment = (ualNone = 0, ualTop = 1, ualBottom = 2, ualLeft = 3, ualRight = 4, ualClient = 5);

  TAIMPUIControlPlacement = packed record
    Alignment: TAIMPUIControlAlignment;
    AlignmentMargins: TRect;
    Anchors: TRect;
    Bounds: TRect;
  {$IF CompilerVersion > 20}
    constructor Create(AAlignment: TAIMPUIControlAlignment; ASize: Integer); overload;
    constructor Create(AAlignment: TAIMPUIControlAlignment; ASize: Integer; const AAlignmentMargins: TRect); overload;
    constructor Create(AAlignment: TAIMPUIControlAlignment; const ABounds, AAlignmentMargins: TRect); overload;
    constructor Create(AAlignment: TAIMPUIControlAlignment; const ABounds: TRect); overload;
    constructor Create(const ABounds, AAnchors: TRect); overload;
    constructor Create(const ABounds: TRect); overload;
    procedure Reset;
  {$IFEND}
  end;

  { TAIMPUIControlPlacementConstraints }

  TAIMPUIControlPlacementConstraints = packed record
    MaxHeight: Integer;
    MaxWidth: Integer;
    MinHeight: Integer;
    MinWidth: Integer;

  {$IF CompilerVersion > 20}
    constructor Create(AMinWidth, AMinHeight, AMaxWidth, AMaxHeight: Integer); overload;
    constructor CreateMaxSize(AMaxWidth, AMaxHeight: Integer); overload;
    constructor CreateMinSize(AMinWidth, AMinHeight: Integer); overload;
  {$IFEND}
  end;

  { IAIMPUIControl }

  IAIMPUIControl = interface(IAIMPPropertyList)
  [SID_IAIMPUIControl]
    // Placement
    function GetPlacement(out Placement: TAIMPUIControlPlacement): HRESULT; stdcall;
    function GetPlacementConstraints(out Constraints: TAIMPUIControlPlacementConstraints): HRESULT; stdcall;
    function SetPlacement(Placement: TAIMPUIControlPlacement): HRESULT; stdcall;
    function SetPlacementConstraints(Constraints: TAIMPUIControlPlacementConstraints): HRESULT; stdcall;

    // Coords Translation
    function ClientToScreen(var P: TPoint): HRESULT; stdcall;
    function ScreenToClient(var P: TPoint): HRESULT; stdcall;

    // Drawing
    function PaintTo(DC: HDC; X, Y: Integer): HRESULT; stdcall;
    function Invalidate: HRESULT; stdcall;
  end;

  { IAIMPUIWinControl }

  IAIMPUIWinControl = interface(IAIMPUIControl)
  [SID_IAIMPUIWinControl]
    function GetControl(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetControlCount: Integer; stdcall;
    function GetHandle: HWND; stdcall;
    function HasHandle: LongBool; stdcall;
    function SetFocus: HRESULT; stdcall;
  end;

  { IAIMPUIWndProcEvents }

  IAIMPUIWndProcEvents = interface
  [SID_IAIMPUIWndProcEvents]
    function OnBeforeWndProc(Message: Cardinal; ParamW: WPARAM; ParamL: LPARAM; var Result: LRESULT): LongBool; stdcall;
    procedure OnAfterWndProc(Message: Cardinal; ParamW: WPARAM; ParamL: LPARAM; var Result: LRESULT); stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Non-Visual Components Interfaces
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPUIImageList }

  IAIMPUIImageList = interface
  [SID_IAIMPUIImageList]
    function Add(Image: IAIMPImage): HRESULT; stdcall;
    function Clear: HRESULT; stdcall;
    function Delete(Index: Integer): HRESULT; stdcall;
    function Draw(DC: HDC; Index, X, Y: Integer; Enabled: LongBool): HRESULT; stdcall;
    function LoadFromResource(Instance: THandle; ResName, ResType: PWideChar): HRESULT; stdcall;
    function GetCount: Integer; stdcall;
    function GetSize(out Size: TSize): HRESULT; stdcall;
    function SetSize(Size: TSize): HRESULT; stdcall;
  end;

  { IAIMPUIImageList2 }

  IAIMPUIImageList2 = interface
  [SID_IAIMPUIImageList2]
    function DrawEx(DC: HDC; Index: Integer; const R: TRect; Enabled: LongBool): HRESULT; stdcall;
  end;

  { IAIMPUIMenuItem }

  IAIMPUIMenuItem = interface(IAIMPMenuItem)
  [SID_IAIMPUIMenuItem]
    function Add(ID: IAIMPString; out MenuItem: IAIMPUIMenuItem): HRESULT; stdcall;
    function Delete(Index: Integer): HRESULT; stdcall;
    function Get(Index: Integer; const IID: TGUID; out MenuItem): HRESULT; stdcall;
    function GetCount: Integer; stdcall;
  end;

  { IAIMPUIPopupMenu }

  IAIMPUIPopupMenu = interface
  [SID_IAIMPUIPopupMenu]
    function Add(ID: IAIMPString; out MenuItem: IAIMPUIMenuItem): HRESULT; stdcall;
    function Delete(Index: Integer): HRESULT; stdcall;
    function DeleteChildren: HRESULT; stdcall;
    function Get(Index: Integer; const IID: TGUID; out MenuItem): HRESULT; stdcall;
    function GetCount: Integer; stdcall;
    function Popup(ScreenPoint: TPoint): HRESULT; stdcall;
    function Popup2(ScreenRect: TRect): HRESULT; stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Special Controls and Events Interfaces
//----------------------------------------------------------------------------------------------------------------------

  IAIMPUITabSheet = interface;

  { IAIMPUIBaseEdit }

  IAIMPUIBaseEdit = interface(IAIMPUIWinControl)
  [SID_IAIMPUIBaseEdit]
    function CopyToClipboard: HRESULT; stdcall;
    function CutToClipboard: HRESULT; stdcall;
    function PasteFromClipboard: HRESULT; stdcall;
    function SelectAll: HRESULT; stdcall;
    function SelectNone: HRESULT; stdcall;
  end;

  { IAIMPUIBBCBox }

  IAIMPUIBBCBox = interface(IAIMPUIWinControl)
  [SID_IAIMPUIBBCBox]
  end;

  { IAIMPUIBevel }

  IAIMPUIBevel = interface(IAIMPUIControl)
  [SID_IAIMPUIBevel]
  end;

  { IAIMPUIButton }

  IAIMPUIButton = interface(IAIMPUIWinControl)
  [SID_IAIMPUIButton]
    function ShowDropDownMenu: HRESULT; stdcall;
  end;

  { IAIMPUIEditButton }

  IAIMPUIEditButton = interface(IAIMPPropertyList)
  [SID_IAIMPUIEditButton]
  end;

  { IAIMPUIBaseButtonnedEdit }

  IAIMPUIBaseButtonnedEdit = interface(IAIMPUIBaseEdit)
  [SID_IAIMPUIBaseButtonnedEdit]
    function AddButton(EventsHandler: IUnknown; out Button: IAIMPUIEditButton): HRESULT; stdcall;
    function DeleteButton(Index: Integer): HRESULT; stdcall;
    function DeleteButton2(Button: IAIMPUIEditButton): HRESULT; stdcall;
    function GetButton(Index: Integer; out Button: IAIMPUIEditButton): HRESULT; stdcall;
    function GetButtonCount: Integer; stdcall;
  end;

  { IAIMPUIBaseComboBox }

  IAIMPUIBaseComboBox = interface(IAIMPUIBaseButtonnedEdit)
  [SID_IAIMPUIBaseComboBox]
    function Add(Obj: IUnknown; ExtraData: Integer): HRESULT; stdcall;
    function Add2(List: IAIMPObjectList): HRESULT; stdcall;
    function Clear: HRESULT; stdcall;
    function Delete(Index: Integer): HRESULT; stdcall;
    function GetItem(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetItemCount: Integer; stdcall;
    function SetItem(Index: Integer; Obj: IUnknown): HRESULT; stdcall;
  end;

  { IAIMPUIBrandBox }

  IAIMPUIBrandBox = interface(IAIMPUIWinControl)
  [SID_IAIMPUIBrandBox]
  end;

  { IAIMPUICategory }

  IAIMPUICategory = interface(IAIMPUIWinControl)
  [SID_IAIMPUICategory]
  end;

  { IAIMPUICheckBox }

  IAIMPUICheckBox = interface(IAIMPUIWinControl)
  [SID_IAIMPUICheckBox]
  end;

  { IAIMPUIComboBox }

  IAIMPUIComboBox = interface(IAIMPUIBaseComboBox)
  [SID_IAIMPUIComboBox]
  end;

  { IAIMPUICheckComboBox }

  IAIMPUICheckComboBox = interface(IAIMPUIBaseComboBox)
  [SID_IAIMPUICheckComboBox]
    function GetChecked(Index: Integer): LongBool; stdcall;
    function SetChecked(Index: Integer; Value: LongBool): HRESULT; stdcall;
  end;

  { IAIMPUIEdit }

  IAIMPUIEdit = interface(IAIMPUIBaseButtonnedEdit)
  [SID_IAIMPUIEdit]
  end;

  { IAIMPUIGroupBox }

  IAIMPUIGroupBox = interface(IAIMPUIWinControl)
  [SID_IAIMPUIGroupBox]
  end;

  { IAIMPUIImage }

  IAIMPUIImage = interface(IAIMPUIControl)
  [SID_IAIMPUIImage]
  end;

  { IAIMPUIImageComboBox }

  IAIMPUIImageComboBox = interface(IAIMPUIBaseComboBox)
  [SID_IAIMPUIImageComboBox]
    function GetImageIndex(Index: Integer): Integer; stdcall;
    function SetImageIndex(Index: Integer; Value: Integer): HRESULT; stdcall;
  end;

  { IAIMPUILabel }

  IAIMPUILabel = interface(IAIMPUIControl)
  [SID_IAIMPUILabel]
  end;

  { IAIMPUIMemo }

  IAIMPUIMemo = interface(IAIMPUIBaseEdit)
  [SID_IAIMPUIMemo]
    function AddLine(S: IAIMPString): HRESULT; stdcall;
    function Clear: HRESULT; stdcall;
    function DeleteLine(Index: Integer): HRESULT; stdcall;
    function InsertLine(Index: Integer; S: IAIMPString): HRESULT; stdcall;
    function GetLine(Index: Integer; out S: IAIMPString): HRESULT; stdcall;
    function GetLineCount: Integer; stdcall;
    function SetLine(Index: Integer; S: IAIMPString): HRESULT; stdcall;
    // I/O
    function LoadFromFile(FileName: IAIMPString): HRESULT; stdcall;
    function LoadFromStream(Stream: IAIMPStream): HRESULT; stdcall;
    function SaveToFile(FileName: IAIMPString): HRESULT; stdcall;
    function SaveToStream(Stream: IAIMPStream): HRESULT; stdcall;
  end;

  { IAIMPUIPaintBox }

  IAIMPUIPaintBox = interface(IAIMPUIControl)
  [SID_IAIMPUIPaintBox]
  end;

  { IAIMPUIPageControl }

  IAIMPUIPageControl = interface(IAIMPUIWinControl)
  [SID_IAIMPUIPageControl]
    function Add(Name: IAIMPString; out Page: IAIMPUITabSheet): HRESULT; stdcall;
    function Delete(Index: Integer): HRESULT; stdcall;
    function Delete2(Page: IAIMPUITabSheet): HRESULT; stdcall;
    function Get(Index: Integer; out Page: IAIMPUITabSheet): HRESULT; stdcall;
    function GetCount: Integer; stdcall;
  end;

  { IAIMPUIPageControlEvents }

  IAIMPUIPageControlEvents = interface
  [SID_IAIMPUIPageControlEvents]
    procedure OnActivating(Sender: IAIMPUIPageControl; Page: IAIMPUITabSheet; var Allow: LongBool); stdcall;
    procedure OnActivated(Sender: IAIMPUIPageControl; Page: IAIMPUITabSheet); stdcall;
  end;

  { IAIMPUIPanel }

  IAIMPUIPanel = interface(IAIMPUIWinControl)
  [SID_IAIMPUIPanel]
  end;

  { IAIMPUIProgressBar }

  IAIMPUIProgressBar = interface(IAIMPUIControl)
  [SID_IAIMPUIProgressBar]
  end;

  { IAIMPUIScrollBox }

  IAIMPUIScrollBox = interface(IAIMPUIWinControl)
  [SID_IAIMPUIScrollBox]
    function MakeVisible(Control: IAIMPUIControl): HRESULT; stdcall;
  end;

  { IAIMPUISlider }

  IAIMPUISlider = interface(IAIMPUIWinControl)
  [SID_IAIMPUISlider]
  end;

  { IAIMPUISplitter }

  IAIMPUISplitter = interface(IAIMPUIControl)
  [SID_IAIMPUISplitter]
  end;

  { IAIMPUISpinEdit }

  IAIMPUISpinEdit = interface(IAIMPUIWinControl)
  [SID_IAIMPUISpinEdit]
  end;

  { IAIMPUITabControl }

  IAIMPUITabControl = interface(IAIMPUIWinControl)
  [SID_IAIMPUITabControl]
    function Add(S: IAIMPString): HRESULT; stdcall;
    function Delete(Index: Integer): HRESULT; stdcall;
    function Get(Index: Integer; out Tab: IAIMPString): HRESULT; stdcall;
    function GetCount: Integer; stdcall;
  end;

  { IAIMPUITabControlEvents }

  IAIMPUITabControlEvents = interface(IAIMPUIChangeEvents)
  [SID_IAIMPUITabControlEvents]
    procedure OnActivating(Sender: IAIMPUITabControl; TabIndex: Integer; var Allow: LongBool); stdcall;
    procedure OnActivated(Sender: IAIMPUITabControl; TabIndex: Integer); stdcall;
  end;

  { IAIMPUITabSheet }

  IAIMPUITabSheet = interface(IAIMPUIWinControl)
  [SID_IAIMPUITabSheet]
  end;

  { IAIMPUITimeEdit }

  IAIMPUITimeEdit = interface(IAIMPUIWinControl)
  [SID_IAIMPUITimeEdit]
  end;

  { IAIMPUITreeListColumn }

  IAIMPUITreeListColumn = interface(IAIMPPropertyList)
  [SID_IAIMPUITreeListColumn]
  end;

  { IAIMPUITreeListGroup }

  IAIMPUITreeListGroup = interface(IAIMPPropertyList)
  [SID_IAIMPUITreeListGroup]
    // Nodes
    function Get(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetCount: Integer; stdcall;
  end;

  { IAIMPUITreeListNode }

  IAIMPUITreeListNode = interface(IAIMPPropertyList)
  [SID_IAIMPUITreeListNode]
    // Nodes
    function Add(out Node: IAIMPUITreeListNode): HRESULT; stdcall;
    function ClearChildren: HRESULT; stdcall;
    function FindByTag(Tag: NativeUInt; Recursive: LongBool; const IID: TGUID; out Node): HRESULT; stdcall;
    function FindByValue(ColumnIndex: Integer; Value: IAIMPString; Recursive: LongBool; const IID: TGUID; out Node): HRESULT; stdcall;
    function Get(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetCount: Integer; stdcall;

    // Values
    function ClearValues: HRESULT; stdcall;
    function GetValue(Index: Integer; out Value: IAIMPString): HRESULT; stdcall;
    function SetValue(Index: Integer; Value: IAIMPString): HRESULT; stdcall;

    // Groups
    function GetGroup(const IID: TGUID; out Group): HRESULT; stdcall;
  end;

  { IAIMPUITreeList }

  IAIMPUITreeList = interface(IAIMPUIWinControl)
  [SID_IAIMPUITreeList]
    // Columns
    function AddColumn(const IID: TGUID; out Obj): HRESULT; stdcall;
    function ClearColumns: HRESULT; stdcall;
    function DeleteColumn(Index: Integer): HRESULT; stdcall;
    function GetColumn(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetColumnCount: Integer; stdcall;

    // Nodes
    function Clear: HRESULT; stdcall;
    function Delete(Node: IAIMPUITreeListNode): HRESULT; stdcall;
    function GetPath(Node: IAIMPUITreeListNode; out S: IAIMPString): HRESULT; stdcall;
    function GetRootNode(const IID: TGUID; out Obj): HRESULT; stdcall;
    function MakeTop(Node: IAIMPUITreeListNode): HRESULT; stdcall;
    function MakeVisible(Node: IAIMPUITreeListNode): HRESULT; stdcall;
    function SetPath(S: IAIMPString): HRESULT; stdcall;

    // Nodes - Absolute List
    function GetAbsoluteVisibleNode(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetAbsoluteVisibleNodeCount: Integer; stdcall;

    // Nodes - Selection
    function DeleteSelected: HRESULT; stdcall;
    function SelectAll: HRESULT; stdcall;
    function SelectNone: HRESULT; stdcall;
    function GetFocused(const IID: TGUID; out Obj): HRESULT; stdcall;
    function SetFocused(Obj: IUnknown): HRESULT; stdcall;
    function GetSelected(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetSelectedCount: Integer; stdcall;

    // Inplace Editing
    function GetEditingCell(out ColumnIndex, RowIndex: Integer): HRESULT; stdcall;
    function StartEditing(Column: IAIMPUITreeListColumn = nil): HRESULT; stdcall;
    function StopEditing: HRESULT; stdcall;

    // Grouping
    function GroupBy(Column: IAIMPUITreeListColumn; ResetPrevGroupingParams: LongBool = False): HRESULT; stdcall;
    function GetGroup(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function GetGroupCount: Integer; stdcall;
    function Regroup: HRESULT; stdcall;
    function ResetGrouppingParams: HRESULT; stdcall;

    // Sorting
    function ResetSortingParams: HRESULT; stdcall;
    function Resort: HRESULT; stdcall;
    function SortBy(Column: IAIMPUITreeListColumn; Flags: DWORD; ResetPrevSortingParams: LongBool = False): HRESULT; stdcall;

    // Customized Settings
    function ConfigLoad(Config: IAIMPConfig; Key: IAIMPString): HRESULT; stdcall;
    function ConfigSave(Config: IAIMPConfig; Key: IAIMPString): HRESULT; stdcall;
  end;

  { IAIMPUITreeListDragSortingEvents }

  IAIMPUITreeListDragSortingEvents = interface(IUnknown)
  [SID_IAIMPUITreeListDragSortingEvents]
    procedure OnDragSorting(Sender: IAIMPUITreeList); stdcall;
    procedure OnDragSortingNodeOver(Sender: IAIMPUITreeList; Node: IAIMPUITreeListNode; Flags: DWORD; var Handled: LongBool); stdcall;
  end;

  { IAIMPUITreeListCustomDrawEvents }

  IAIMPUITreeListCustomDrawEvents = interface(IUnknown)
  [SID_IAIMPUITreeListCustomDrawEvents]
    procedure OnCustomDrawNode(Sender: IAIMPUITreeList; DC: HDC; R: TRect;
      Node: IAIMPUITreeListNode; var Handled: LongBool); stdcall;
    procedure OnCustomDrawNodeCell(Sender: IAIMPUITreeList; DC: HDC; R: TRect;
      Node: IAIMPUITreeListNode; Column: IAIMPUITreeListColumn; var Handled: LongBool); stdcall;
    procedure OnGetNodeBackground(Sender: IAIMPUITreeList; Node: IAIMPUITreeListNode; var Color: DWORD); stdcall;
  end;

  { IAIMPUITreeListInplaceEditingEvents }

  IAIMPUITreeListInplaceEditingEvents = interface(IUnknown)
  [SID_IAIMPUITreeListInplaceEditingEvents]
    procedure OnEditing(Sender: IAIMPUITreeList; Node: IAIMPUITreeListNode; ColumnIndex: Integer; var Allow: LongBool); stdcall;
    procedure OnEdited(Sender: IAIMPUITreeList; Node: IAIMPUITreeListNode; ColumnIndex: Integer; var Value: IAIMPString); stdcall;
  end;

  { IAIMPUITreeListEvents }

  IAIMPUITreeListEvents = interface(IUnknown)
  [SID_IAIMPUITreeListEvents]
    procedure OnColumnClick(Sender: IAIMPUITreeList; ColumnIndex: Integer); stdcall;
    procedure OnFocusedColumnChanged(Sender: IAIMPUITreeList); stdcall;
    procedure OnFocusedNodeChanged(Sender: IAIMPUITreeList); stdcall;
    procedure OnNodeChecked(Sender: IAIMPUITreeList; Node: IAIMPUITreeListNode); stdcall;
    procedure OnNodeDblClicked(Sender: IAIMPUITreeList; Node: IAIMPUITreeListNode); stdcall;
    procedure OnSelectionChanged(Sender: IAIMPUITreeList); stdcall;
    procedure OnSorted(Sender: IAIMPUITreeList); stdcall;
    procedure OnStructChanged(Sender: IAIMPUITreeList); stdcall;
  end;

  { IAIMPUIRadioBox }

  IAIMPUIRadioBox = interface(IAIMPUICheckBox)
  [SID_IAIMPUIRadioBox]
  end;

  { IAIMPUIValidationLabel }

  IAIMPUIValidationLabel = interface(IAIMPUILabel)
  [SID_IAIMPUIValidationLabel]
  end;

//----------------------------------------------------------------------------------------------------------------------
// Top-Level Window Interfaces
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPUIForm }

  IAIMPUIForm = interface(IAIMPUIWinControl)
  [SID_IAIMPUIForm]
    function Close: HRESULT; stdcall;
    function GetFocusedControl(out Control: IAIMPUIWinControl): HRESULT; stdcall;
    function Localize: HRESULT; stdcall;
    function Release(Postponed: LongBool): HRESULT; stdcall;
    function ShowModal: Integer; stdcall;
  end;

  { IAIMPUIFormEvents }

  IAIMPUIFormEvents = interface
  [SID_IAIMPUIFormEvents]
    procedure OnActivated(Sender: IAIMPUIForm); stdcall;
    procedure OnDeactivated(Sender: IAIMPUIForm); stdcall;
    procedure OnCreated(Sender: IAIMPUIForm); stdcall;
    procedure OnDestroyed(Sender: IAIMPUIForm); stdcall;
    procedure OnCloseQuery(Sender: IAIMPUIForm; var CanClose: LongBool); stdcall;
    procedure OnLocalize(Sender: IAIMPUIForm); stdcall;
    procedure OnShortCut(Sender: IAIMPUIForm; Key, Modifiers: Word; var Handled: LongBool); stdcall;
  end;

  { IAIMPUIFormEvents2 }

  IAIMPUIFormEvents2 = interface
  [SID_IAIMPUIFormEvents2]
    procedure OnChangeScale(Sender: IAIMPUIForm; Multiplier, Divider: Integer); stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// Dialogs
//----------------------------------------------------------------------------------------------------------------------

  { IAIMPUIBrowseFolderDialog }

  IAIMPUIBrowseFolderDialog = interface
  [SID_IAIMPUIBrowseFolderDialog]
    function Execute(OwnerWnd: HWND; Flags: DWORD; DefaultPath: IAIMPString; out Selection: IAIMPObjectList): HRESULT; stdcall;
  end;

  { IAIMPUIFileDialogs }

  IAIMPUIFileDialogs = interface
  [SID_IAIMPUIFileDialogs]
    function ExecuteOpenDialog(OwnerWnd: HWND; Caption, Filter: IAIMPString; out FileName: IAIMPString): HRESULT; stdcall;
    function ExecuteOpenDialog2(OwnerWnd: HWND; Caption, Filter: IAIMPString; out Files: IAIMPObjectList): HRESULT; stdcall;
    function ExecuteSaveDialog(OwnerWnd: HWND; Caption, Filter: IAIMPString; var FileName: IAIMPString; out FilterIndex: Integer): HRESULT; stdcall;
  end;

  { IAIMPUIInputDialog }

  IAIMPUIInputDialog = interface
  [SID_IAIMPUIInputDialog]
    function Execute(OwnerWnd: HWND; Caption: IAIMPString;
      EventsHandler: IUnknown; Text: IAIMPString; var Value: OleVariant): HRESULT; stdcall;
    function Execute2(OwnerWnd: HWND; Caption: IAIMPString;
      EventsHandler: IUnknown; TextForValues: IAIMPObjectList; Values: POleVariant; ValueCount: Integer): HRESULT; stdcall;
  end;

  { IAIMPUIInputDialogEvents }

  IAIMPUIInputDialogEvents = interface
  [SID_IAIMPUIInputDialogEvents]
    function OnValidate(const Value: OleVariant; ValueIndex: Integer): HRESULT; stdcall;
  end;

  { IAIMPUIMessageDialog }

  IAIMPUIMessageDialog = interface
  [SID_IAIMPUIMessageDialog]
    function Execute(OwnerWnd: HWND; Caption, Text: IAIMPString; Flags: DWORD): HRESULT; stdcall;
  end;

  { IAIMPUIProgressDialog }

  IAIMPUIProgressDialog = interface(IAIMPPropertyList)
  [SID_IAIMPUIProgressDialog]
    function Finished: HRESULT; stdcall;
    function Progress(const Position, Total: Int64; Text: IAIMPString = nil): HRESULT; stdcall;
    function Started: HRESULT; stdcall;
  end;

  { IAIMPUIProgressDialogEvents }

  IAIMPUIProgressDialogEvents = interface
  [SID_IAIMPUIProgressDialogEvents]
    procedure OnCanceled; stdcall;
  end;

//----------------------------------------------------------------------------------------------------------------------
// GUI Service
//----------------------------------------------------------------------------------------------------------------------

const
  AIMPUI_SERVICE_CREATEFORM_FLAGS_CHILD = 1;

type

  { IAIMPServiceUI }

  IAIMPServiceUI = interface
  [SID_IAIMPServiceUI]
    function CreateControl(Owner: IAIMPUIForm; Parent: IAIMPUIWinControl; Name: IAIMPString;
      EventsHandler: IUnknown; const IID: TGUID; out Control): HRESULT; stdcall;
    function CreateForm(OwnerWindow: HWND; Flags: DWORD; Name: IAIMPString;
      EventsHandler: IUnknown; out Form: IAIMPUIForm): HRESULT; stdcall;
    function CreateObject(Owner: IAIMPUIForm; EventsHandler: IUnknown; const IID: TGUID; out Obj): HRESULT; stdcall;
  end;

implementation

{ TAIMPUIControlPlacement }

{$IF CompilerVersion > 20}

constructor TAIMPUIControlPlacement.Create(AAlignment: TAIMPUIControlAlignment; ASize: Integer);
var
  R: TRect;
begin
  R := Rect(0, 0, 0, 0);
  if AAlignment in [ualTop, ualBottom, ualClient] then
    R.Bottom := ASize;
  if AAlignment in [ualLeft, ualRight, ualClient] then
    R.Right := ASize;
  Create(AAlignment, R);
end;

constructor TAIMPUIControlPlacement.Create(AAlignment: TAIMPUIControlAlignment; ASize: Integer; const AAlignmentMargins: TRect);
begin
  Create(AAlignment, ASize);
  AlignmentMargins := AAlignmentMargins;
end;

constructor TAIMPUIControlPlacement.Create(AAlignment: TAIMPUIControlAlignment; const ABounds, AAlignmentMargins: TRect);
begin
  Create(AAlignment, ABounds);
  AlignmentMargins := AAlignmentMargins;
end;

constructor TAIMPUIControlPlacement.Create(AAlignment: TAIMPUIControlAlignment; const ABounds: TRect);
begin
  Reset;
  Alignment := AAlignment;
  Bounds := ABounds;
end;

constructor TAIMPUIControlPlacement.Create(const ABounds, AAnchors: TRect);
begin
  Create(ABounds);
  Anchors := AAnchors;
end;

constructor TAIMPUIControlPlacement.Create(const ABounds: TRect);
begin
  Reset;
  Bounds := ABounds;
end;

procedure TAIMPUIControlPlacement.Reset;
begin
  Alignment := ualNone;
  AlignmentMargins := Rect(3, 3, 3, 3);
  Anchors := Rect(1, 1, 0, 0);
end;

{ TAIMPUIControlPlacementConstraints }

constructor TAIMPUIControlPlacementConstraints.Create(AMinWidth, AMinHeight, AMaxWidth, AMaxHeight: Integer);
begin
  MaxHeight := AMaxHeight;
  MaxWidth := AMaxWidth;
  MinHeight := AMinHeight;
  MinWidth := AMinWidth;
end;

constructor TAIMPUIControlPlacementConstraints.CreateMaxSize(AMaxWidth, AMaxHeight: Integer);
begin
  Create(0, 0, AMaxWidth, AMaxHeight);
end;

constructor TAIMPUIControlPlacementConstraints.CreateMinSize(AMinWidth, AMinHeight: Integer);
begin
  Create(AMinWidth, AMinHeight, 0, 0);
end;

{$IFEND}
end.
