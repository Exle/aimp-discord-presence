unit uDemoForm;

interface

{$R uDemoForm.res}

{$MESSAGE 'TODO - Constraints'}

uses
  Windows, Types, apiGUI, apiObjects, apiWrappersGUI, apiMenu;

const
  NullRect: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);

type

  { TDemoForm }

  TDemoForm = class(TInterfacedObject,
    IAIMPUIChangeEvents,
    IAIMPUIKeyboardEvents,
    IAIMPUIMouseEvents,
    IAIMPUIMouseWheelEvents,
    IAIMPUIPageControlEvents,
    IAIMPUIFormEvents)
  private
    FSkipMouseEvents: Boolean;

    // Custom Handlers
    procedure HandlerAddCustom(const Sender: IUnknown);
    procedure HandlerAddFiles(const Sender: IUnknown);
    procedure HandlerAddFolders(const Sender: IUnknown);
    procedure HandlerCloseButton(const Sender: IUnknown);
    procedure HandlerCustomDrawSlider(const Sender: IUnknown; DC: HDC; const R: TRect);
    procedure HandlerEditButton(const Sender: IUnknown);
    procedure HandlerSkipMouseEvents(const Sender: IUnknown);

    // IAIMPUIChangeEvents
    procedure OnChanged(Sender: IInterface); stdcall;

    // IAIMPUIKeyboardEvents
    procedure OnEnter(Sender: IInterface); stdcall;
    procedure OnExit(Sender: IInterface); stdcall;
    procedure OnKeyDown(Sender: IInterface; var Key: Word; Modifiers: Word); stdcall;
    procedure OnKeyPress(Sender: IInterface; var Key: Char); stdcall;
    procedure OnKeyUp(Sender: IInterface; var Key: Word; Modifiers: Word); stdcall;

    // IAIMPUIMouseEvents
    procedure OnMouseDoubleClick(Sender: IInterface; Button: TAIMPUIMouseButton; X, Y: Integer; Modifiers: Word); stdcall;
    procedure OnMouseDown(Sender: IInterface; Button: TAIMPUIMouseButton; X, Y: Integer; Modifiers: Word); stdcall;
    procedure OnMouseMove(Sender: IInterface; X, Y: Integer; Modifiers: Word); stdcall;
    procedure OnMouseUp(Sender: IInterface; Button: TAIMPUIMouseButton; X, Y: Integer; Modifiers: Word); stdcall;
    procedure OnMouseLeave(Sender: IInterface); stdcall;

    // IAIMPUIMouseWheelEvents
    function OnMouseWheel(Sender: IInterface; WheelDelta: Integer; X, Y: Integer; Modifiers: Word): LongBool; stdcall;

    // IAIMPUIPageControlEvents
    procedure OnActivated(Sender: IAIMPUIPageControl; Page: IAIMPUITabSheet); overload; stdcall;
    procedure OnActivating(Sender: IAIMPUIPageControl; Page: IAIMPUITabSheet; var Allow: LongBool); stdcall;

    // IAIMPUIFormEvents
    procedure OnActivated(Sender: IAIMPUIForm); overload; stdcall;
    procedure OnCloseQuery(Sender: IAIMPUIForm; var CanClose: LongBool); stdcall;
    procedure OnCreated(Sender: IAIMPUIForm); stdcall;
    procedure OnDeactivated(Sender: IAIMPUIForm); stdcall;
    procedure OnDestroyed(Sender: IAIMPUIForm); stdcall;
    procedure OnLocalize(Sender: IAIMPUIForm); stdcall;
    procedure OnShortCut(Sender: IAIMPUIForm; Key: Word; Modifiers: Word; var Handled: LongBool); stdcall;
  protected
    FForm: IAIMPUIForm;
    FImages: IAIMPUIImageList;
    FLog: IAIMPUITreeList;
    FService: IAIMPServiceUI;
    FTreeList: IAIMPUITreeList;

    procedure AddPathToTreeList(const Name, ParentFolder, Notes: string; AImageIndex: Integer);
    procedure Log(const Sender: IUnknown; const S: string);
  protected
    procedure CreateBottomBar(AParent: IAIMPUIWinControl);
    procedure CreateControls(AParent: IAIMPUIWinControl);
    procedure CreateLog(AParent: IAIMPUIWinControl);
    procedure CreatePageControl(AParent: IAIMPUIWinControl);

    procedure CreateBBCBox(AParent: IAIMPUIWinControl);
    procedure CreateEditors(AParent: IAIMPUIWinControl);
    procedure CreateGraphics(AParent: IAIMPUIWinControl);
    procedure CreateGroups(AParent: IAIMPUIWinControl);
    procedure CreateIndicators(AParent: IAIMPUIWinControl);
    procedure CreateTreeList(AParent: IAIMPUIWinControl);
  public
    constructor Create(AService: IAIMPServiceUI);
    function ShowModal: Integer;
  end;

implementation

uses
  apiWrappers, SysUtils;

const
  ButtonNames: array[TAIMPUIMouseButton] of string = ('LMB', 'RMB', 'MMB');

function CenterRect(const ABounds: TRect; AWidth, AHeight: Integer): TRect;
begin
  Result.Left := (ABounds.Left + ABounds.Right - AWidth) div 2;
  Result.Top := (ABounds.Top + ABounds.Bottom - AHeight) div 2;
  Result.Right := Result.Left + AWidth;
  Result.Bottom := Result.Top + AHeight;
end;

{ TDemoForm }

constructor TDemoForm.Create(AService: IAIMPServiceUI);
var
  ABounds: TRect;
begin
  FService := AService;
  FSkipMouseEvents := True;

  CheckResult(AService.CreateForm(0, 0, MakeString('DemoForm'), Self, FForm));
  CheckResult(FForm.SetValueAsInt32(AIMPUI_FORM_PROPID_CLOSEBYESCAPE, 1));

  // Center the Form on screen
  SystemParametersInfo(SPI_GETWORKAREA, 0, ABounds, 0);
  CheckResult(FForm.SetPlacement(TAIMPUIControlPlacement.Create(CenterRect(ABounds, 1024, 600))));

  // Create ImageList for children controls
  CheckResult(AService.CreateObject(FForm, nil, IAIMPUIImageList, FImages));
  CheckResult(FImages.LoadFromResource(HInstance, 'IMAGES', 'PNG'));

  // Create children controls
  CreateControls(FForm);
end;

procedure TDemoForm.CreateControls(AParent: IAIMPUIWinControl);
begin
  CreateBottomBar(AParent);
  CreateLog(AParent);
  CreatePageControl(AParent);
end;

procedure TDemoForm.CreateBottomBar(AParent: IAIMPUIWinControl);
var
  AButton: IAIMPUIButton;
  APanel: IAIMPUIWinControl;
begin
  // Create the panel for Bar
  CheckResult(FService.CreateControl(FForm, AParent, nil, nil, IID_IAIMPUIPanel, APanel));
  CheckResult(APanel.SetPlacement(TAIMPUIControlPlacement.Create(ualBottom, Bounds(0, MaxWord, 0, 28))));
  CheckResult(APanel.SetValueAsInt32(AIMPUI_PANEL_PROPID_BORDERS, 0));

  // Create the Button
  CheckResult(FService.CreateControl(FForm, APanel, MakeString('B1'),
    TAIMPUINotifyEventAdapter.Create(HandlerCloseButton), IID_IAIMPUIButton, AButton));
  CheckResult(AButton.SetPlacement(TAIMPUIControlPlacement.Create(ualRight, 96)));
end;

procedure TDemoForm.CreateLog(AParent: IAIMPUIWinControl);
var
  AColumn: IAIMPUITreeListColumn;
  AControl: IAIMPUIControl;
  APanel: IAIMPUIWinControl;
begin
  CheckResult(FService.CreateControl(FForm, AParent, nil, nil, IID_IAIMPUIPanel, APanel));
  CheckResult(APanel.SetPlacement(TAIMPUIControlPlacement.Create(ualLeft, 400, Rect(6, 6, 0, 0))));
  CheckResult(APanel.SetValueAsInt32(AIMPUI_PANEL_PROPID_BORDERS, 0));

  // The Treelist control will be used for loging all events
  CheckResult(FService.CreateControl(FForm, APanel, MakeString('Log'), Self, IAIMPUITreeList, FLog));
  CheckResult(FLog.SetPlacement(TAIMPUIControlPlacement.Create(ualClient, 0, NullRect)));
  CheckResult(FLog.SetValueAsInt32(AIMPUI_TL_PROPID_COLUMN_AUTOWIDTH, 1));
  CheckResult(FLog.AddColumn(IAIMPUITreeListColumn, AColumn)); // Create the Sender column
  CheckResult(AColumn.SetValueAsInt32(AIMPUI_TL_COLUMN_PROPID_CAN_RESIZE, 0));
  CheckResult(FLog.AddColumn(IAIMPUITreeListColumn, AColumn)); // Create the Action column

  // Create the SkipMouseEvents option
  CheckResult(FService.CreateControl(FForm, APanel, MakeString('cbSkipMouseEvents'),
    TAIMPUINotifyEventAdapter.Create(HandlerSkipMouseEvents), IAIMPUICheckBox, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualBottom, 0, Rect(0, 6, 0, 0))));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_CHECKBOX_PROPID_STATE, Ord(FSkipMouseEvents)));

  // Create the splitter
  CheckResult(FService.CreateControl(FForm, AParent, nil, Self, IAIMPUISplitter, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualLeft, 3, NullRect)));
  CheckResult(AControl.SetValueAsObject(AIMPUI_SPLITTER_PROPID_CONTROL, APanel));
end;

procedure TDemoForm.CreatePageControl(AParent: IAIMPUIWinControl);
var
  APageControl: IAIMPUIPageControl;
  ATabSheet: IAIMPUITabSheet;
begin
  // Create the PageControl
  CheckResult(FService.CreateControl(FForm, AParent, MakeString('PageControl'), Self, IAIMPUIPageControl, APageControl));
  CheckResult(APageControl.SetPlacement(TAIMPUIControlPlacement.Create(ualClient, 0, Rect(6, 6, 6, 0))));

  // Create the TabSheet with editors
  CheckResult(APageControl.Add(MakeString('tsEditors'), ATabSheet));
  CreateEditors(ATabSheet);

  // Create the TabSheet with groups
  CheckResult(APageControl.Add(MakeString('tsGroups'), ATabSheet));
  CreateGroups(ATabSheet);

  // Create the TabSheet with graphic objects
  CheckResult(APageControl.Add(MakeString('tsGraphics'), ATabSheet));
  CreateGraphics(ATabSheet);

  // Create the TabSheet with sliders and progress bars
  CheckResult(APageControl.Add(MakeString('tsIndicators'), ATabSheet));
  CreateIndicators(ATabSheet);

  // Create the TabSheet with BBCode Box
  CheckResult(APageControl.Add(MakeString('tsBBC'), ATabSheet));
  CreateBBCBox(ATabSheet);

  // Create the TabSheet with TreeList
  CheckResult(APageControl.Add(MakeString('tsTreeList'), ATabSheet));
  CreateTreeList(ATabSheet);
end;

procedure TDemoForm.CreateBBCBox(AParent: IAIMPUIWinControl);
const
  BBCText =
    'Today, on the 9th birthday of AIMP project, we are pleased ' +
    'to announce the launch of a public beta testing of two major ' +
    'version of our products - [url=http://www.aimp.ru/index.php?do=features]AIMP v4[/url] and ' +
    '[url=http://www.aimp.ru/index.php?do=features&os=android]AIMP for Android v2[/url]' +
    #13#10 +
    #13#10 +
    '[b]Warning![/b]' + #13#10 +
    'Note that both version are [u]test[/u], they [u]may contains a lot of bugs[/u]!';

var
  AControl: IAIMPUIWinControl;
begin
  CheckResult(FService.CreateControl(FForm, AParent, MakeString('bbcBox'), Self, IAIMPUIBBCBox, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualClient, 0)));
  CheckResult(AControl.SetValueAsObject(AIMPUI_BBCBOX_PROPID_TEXT, MakeString(BBCText)));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_BBCBOX_PROPID_TRANSPARENT, 1));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_BBCBOX_PROPID_BORDERS, 0));
end;

procedure TDemoForm.CreateEditors(AParent: IAIMPUIWinControl);
var
  AComboBox: IAIMPUIBaseComboBox;
  AControl: IAIMPUIWinControl;
  AEdit: IAIMPUIEdit;
  AEditButton: IAIMPUIEditButton;
  ALeftSidePane: IAIMPUIWinControl;
  I: Integer;
begin
  CheckResult(FService.CreateControl(FForm, AParent, MakeString('pnlLeftSide'), Self, IAIMPUIPanel, ALeftSidePane));
  CheckResult(ALeftSidePane.SetPlacement(TAIMPUIControlPlacement.Create(ualLeft, 300, NullRect)));
  CheckResult(ALeftSidePane.SetValueAsInt32(AIMPUI_PANEL_PROPID_TRANSPARENT, 1));
  CheckResult(ALeftSidePane.SetValueAsInt32(AIMPUI_PANEL_PROPID_BORDERS, 0));

  // Create the ButtonedEdit
  CheckResult(FService.CreateControl(FForm, ALeftSidePane, MakeString('edText'), Self, IAIMPUIEdit, AEdit));
  CheckResult(AEdit.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));
  CheckResult(AEdit.SetValueAsObject(AIMPUI_BUTTONEDEDIT_PROPID_BUTTONSIMAGES, FImages));
  CheckResult(AEdit.AddButton(TAIMPUINotifyEventAdapter.Create(HandlerEditButton), AEditButton));
  CheckResult(AEditButton.SetValueAsInt32(AIMPUI_EDITBUTTON_PROPID_WIDTH, 50));
  CheckResult(AEdit.AddButton(TAIMPUINotifyEventAdapter.Create(HandlerEditButton), AEditButton));
  CheckResult(AEditButton.SetValueAsInt32(AIMPUI_EDITBUTTON_PROPID_IMAGEINDEX, 6));

  // Create ComboBox
  CheckResult(FService.CreateControl(FForm, ALeftSidePane, MakeString('cbbSimple'), Self, IAIMPUIComboBox, AComboBox));
  CheckResult(AComboBox.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));
  CheckResult(AComboBox.SetValueAsInt32(AIMPUI_COMBOBOX_PROPID_STYLE, 1));
  for I := 0 to 2 do
    CheckResult(AComboBox.Add(nil, 0));

  // Create CheckComboBox
  CheckResult(FService.CreateControl(FForm, ALeftSidePane, MakeString('ccbCheck'), Self, IAIMPUICheckComboBox, AComboBox));
  CheckResult(AComboBox.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));
  for I := 0 to 2 do
    CheckResult(AComboBox.Add(MakeString('Check' + IntToStr(I + 1)), Ord(I = 1))); // 2nd item will be checked

  // Create ImageComboBox
  CheckResult(FService.CreateControl(FForm, ALeftSidePane, MakeString('icbImages'), Self, IAIMPUIImageComboBox, AComboBox));
  CheckResult(AComboBox.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));
  CheckResult(AComboBox.SetValueAsObject(AIMPUI_IMAGECOMBOBOX_PROPID_IMAGELIST, FImages));
  for I := 0 to 5 do
    CheckResult(AComboBox.Add(MakeString('Image ' + IntToStr(I + 1)), I));

  // Create SpinEdit
  CheckResult(FService.CreateControl(FForm, ALeftSidePane, MakeString('seSpin'), Self, IAIMPUISpinEdit, AControl));
  CheckResult(AControl.SetValueAsObject(AIMPUI_SPINEDIT_PROPID_DISPLAYMASK, MakeString('Delta: %s px')));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_SPINEDIT_PROPID_INCREMENT, 2));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_SPINEDIT_PROPID_MAXVALUE, 6));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_SPINEDIT_PROPID_MINVALUE, -2));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualBottom, 0)));

  // Create TimeEdit
  CheckResult(FService.CreateControl(FForm, ALeftSidePane, MakeString('teTime'), Self, IAIMPUITimeEdit, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualBottom, 0)));

  // Create Memo
  CheckResult(FService.CreateControl(FForm, AParent, MakeString('edMemo'), Self, IAIMPUIMemo, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualClient, 0)));
end;

procedure TDemoForm.CreateGraphics(AParent: IAIMPUIWinControl);

  function CreateLabel(const AName: UnicodeString; AParent: IAIMPUIWinControl): IAIMPUIControl;
  begin
    CheckResult(FService.CreateControl(FForm, AParent, MakeString(AName), Self, IAIMPUILabel, Result));
    CheckResult(Result.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));
    CheckResult(Result.SetValueAsInt32(AIMPUI_LABEL_PROPID_AUTOSIZE, 1));
  end;

  function CreateImage(const ResName: UnicodeString;
    AParent: IAIMPUIWinControl; AAlignment: TAIMPUIControlAlignment): IAIMPUIControl;
  var
    AImage: IAIMPImage2;
    AImageSize: TSize;
  begin
    CoreCreateObject(IAIMPImage2, AImage);
    CheckResult(AImage.LoadFromResource(HInstance, PWideChar(ResName), 'PNG'));
    CheckResult(AImage.GetSize(AImageSize));
    CheckResult(FService.CreateControl(FForm, AParent, nil, Self, IAIMPUIImage, Result));
    CheckResult(Result.SetPlacement(TAIMPUIControlPlacement.Create(AAlignment, Bounds(0, 0, AImageSize.cx, AImageSize.cy))));
    CheckResult(Result.SetValueAsObject(AIMPUI_IMAGE_PROPID_IMAGE, AImage));
  end;

var
  AControl: IAIMPUIControl;
  AContainer: IAIMPUIWinControl;
begin
  // Create the description label
  CheckResult(CreateLabel('lbDescription', AParent).SetValueAsInt32(AIMPUI_LABEL_PROPID_LINE, 1));

  // Create the ScrollBox with large image
  CheckResult(FService.CreateControl(FForm, AParent, nil, Self, IAIMPUIScrollBox, AContainer));
  CheckResult(AContainer.SetPlacement(TAIMPUIControlPlacement.Create(ualClient, 0)));
  CreateImage('PREVIEW', AContainer, ualNone);

  // Create the left side panel
  CheckResult(FService.CreateControl(FForm, AParent, nil, Self, IAIMPUIPanel, AContainer));
  CheckResult(AContainer.SetPlacement(TAIMPUIControlPlacement.Create(ualLeft, 150, NullRect)));
  CheckResult(AContainer.SetValueAsInt32(AIMPUI_PANEL_PROPID_TRANSPARENT, 1));
  CheckResult(AContainer.SetValueAsInt32(AIMPUI_PANEL_PROPID_BORDERS, 0));

  // Create the image
  AControl := CreateImage('LOGO', AContainer, ualTop);
  CheckResult(AControl.SetValueAsInt32(AIMPUI_IMAGE_PROPID_IMAGESTRETCHMODE, AIMP_IMAGE_DRAW_STRETCHMODE_FIT));

  // Create labels
  AControl := CreateLabel('lbRAT', AContainer);
  CheckResult(AControl.SetValueAsInt32(AIMPUI_LABEL_PROPID_TEXTALIGN, 1)); // Right
  CheckResult(AControl.SetValueAsInt32(AIMPUI_LABEL_PROPID_TEXTCOLOR, $FF0000)); //Blue
  CheckResult(AControl.SetValueAsInt32(AIMPUI_LABEL_PROPID_TEXTSTYLE, AIMPUI_FLAGS_FONT_STRIKEOUT));

  AControl := CreateLabel('lbCT', AContainer);
  CheckResult(AControl.SetValueAsInt32(AIMPUI_LABEL_PROPID_TEXTALIGN, 2)); // Center
  CheckResult(AControl.SetValueAsInt32(AIMPUI_LABEL_PROPID_TEXTCOLOR, $00AA00)); // Green
  CheckResult(AControl.SetValueAsInt32(AIMPUI_LABEL_PROPID_TEXTSTYLE, AIMPUI_FLAGS_FONT_BOLD));

  AControl := CreateLabel('lbLAT', AContainer);
  CheckResult(AControl.SetValueAsInt32(AIMPUI_LABEL_PROPID_TEXTCOLOR, $0000FF)); // Red
  CheckResult(AControl.SetValueAsInt32(AIMPUI_LABEL_PROPID_TEXTSTYLE, AIMPUI_FLAGS_FONT_ITALIC));

  AControl := CreateLabel('lbWEB', AContainer);
  CheckResult(AControl.SetValueAsInt32(AIMPUI_LABEL_PROPID_TEXTALIGN, 2)); // Center
  CheckResult(AControl.SetValueAsObject(AIMPUI_LABEL_PROPID_URL, MakeString('http://aimp.ru'))); //Blue

  // Create the separator line
  CheckResult(FService.CreateControl(FForm, AContainer, nil, Self, IAIMPUIBevel, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 2)));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_BEVEL_PROPID_BORDERS, AIMPUI_FLAGS_BORDER_TOP));
end;

procedure TDemoForm.CreateGroups(AParent: IAIMPUIWinControl);
var
  AChildControl: IAIMPUIWinControl;
  AControl: IAIMPUIWinControl;
begin
  // Create the Category
  CheckResult(FService.CreateControl(FForm, AParent, MakeString('catMain'), Self, IID_IAIMPUICategory, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualClient, 0)));
  AParent := AControl; // It will be a parent for all other groups

  // Create the GroupBox
  CheckResult(FService.CreateControl(FForm, AParent, MakeString('gbSimple'), Self, IID_IAIMPUIGroupBox, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 200)));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_GROUPBOX_PROPID_AUTOSIZE, 1));

  // Create the CheckBoxes and place in at GroupBox
  CheckResult(FService.CreateControl(FForm, AControl, MakeString('cbItem1'), Self, IID_IAIMPUICheckBox, AChildControl));
  CheckResult(AChildControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));
  CheckResult(FService.CreateControl(FForm, AControl, MakeString('cbItem2'), Self, IID_IAIMPUICheckBox, AChildControl));
  CheckResult(AChildControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));

  // Create the Validation Label
  CheckResult(FService.CreateControl(FForm, AControl, MakeString('vlWarning'), Self, IID_IAIMPUIValidationLabel, AChildControl));
  CheckResult(AChildControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));
  CheckResult(AChildControl.SetValueAsInt32(AIMPUI_VALIDATIONLABEL_PROPID_GLYPH, 0));

  // Create the GroupBox with check mark
  CheckResult(FService.CreateControl(FForm, AParent, MakeString('gbChecked'), Self, IID_IAIMPUIGroupBox, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 200)));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_GROUPBOX_PROPID_AUTOSIZE, 1));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_GROUPBOX_PROPID_CHECKMODE, 2));

  // Create the RadioBoxes and place in at GroupBox
  CheckResult(FService.CreateControl(FForm, AControl, MakeString('rbItem1'), Self, IID_IAIMPUIRadioBox, AChildControl));
  CheckResult(AChildControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));
  CheckResult(FService.CreateControl(FForm, AControl, MakeString('rbItem2'), Self, IID_IAIMPUIRadioBox, AChildControl));
  CheckResult(AChildControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));

  // Create the Validation Label
  CheckResult(FService.CreateControl(FForm, AControl, MakeString('vlWarning2'), Self, IID_IAIMPUIValidationLabel, AChildControl));
  CheckResult(AChildControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));
  CheckResult(AChildControl.SetValueAsInt32(AIMPUI_VALIDATIONLABEL_PROPID_GLYPH, 2));
end;

procedure TDemoForm.CreateIndicators(AParent: IAIMPUIWinControl);
var
  AControl: IAIMPUIWinControl;
begin
  CheckResult(FService.CreateControl(FForm, AParent, MakeString('pbProgress'), Self, IAIMPUIProgressBar, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_PROGRESSBAR_PROPID_MAX, 100));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_PROGRESSBAR_PROPID_MIN, 10));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_PROGRESSBAR_PROPID_PROGRESS, 50));

  CheckResult(FService.CreateControl(FForm, AParent, MakeString('pbIndeterminate'), Self, IAIMPUIProgressBar, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 0)));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_PROGRESSBAR_PROPID_INDETERMINATE, 1));

  CheckResult(FService.CreateControl(FForm, AParent, MakeString('slSlider'), Self, IAIMPUISlider, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualTop, 30)));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_SLIDER_PROPID_HORIZONTAL, 1));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_SLIDER_PROPID_PAGESIZE, 10));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_SLIDER_PROPID_TRANSPARENT, 1));

  CheckResult(FService.CreateControl(FForm, AParent, MakeString('slCustomDrawSlider'),
    TAIMPUIDrawEventAdapter.Create(HandlerCustomDrawSlider, Self), IAIMPUISlider, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualLeft, 30, Rect(30, 30, 30, 30))));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_SLIDER_PROPID_PAGESIZE, 10));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_SLIDER_PROPID_TRANSPARENT, 1));
end;

procedure TDemoForm.CreateTreeList(AParent: IAIMPUIWinControl);

  procedure AddMenuItem(ADropDownMenu: IAIMPUIPopupMenu; const ID: string;
    EventHandler: TAIMPUINotifyEvent; Default: Boolean = False);
  var
    AMenuItem: IAIMPUIMenuItem;
  begin
    CheckResult(ADropDownMenu.Add(MakeString(ID), AMenuItem));
    CheckResult(AMenuItem.SetValueAsObject(AIMP_MENUITEM_PROPID_EVENT, TAIMPUINotifyEventAdapter.Create(EventHandler)));
    CheckResult(AMenuItem.SetValueAsInt32(AIMP_MENUITEM_PROPID_DEFAULT, Ord(Default)));
  end;

var
  AColumn: IAIMPUITreeList;
  AControl: IAIMPUIWinControl;
  ADropDownMenu: IAIMPUIPopupMenu;
begin
  // Create the TreeList
  CheckResult(FService.CreateControl(FForm, AParent, MakeString('tlPaths'), Self, IAIMPUITreeList, FTreeList));
  CheckResult(FTreeList.SetPlacement(TAIMPUIControlPlacement.Create(ualClient, 0)));
  CheckResult(FTreeList.SetValueAsInt32(AIMPUI_TL_PROPID_CHECKBOXES, 1));
  CheckResult(FTreeList.SetValueAsObject(AIMPUI_TL_PROPID_NODE_IMAGES, FImages));

  CheckResult(FTreeList.AddColumn(IAIMPUITreeListColumn, AColumn));
  CheckResult(FTreeList.AddColumn(IAIMPUITreeListColumn, AColumn));
  CheckResult(AColumn.SetValueAsInt32(AIMPUI_TL_COLUMN_PROPID_WIDTH, 300));
  CheckResult(FTreeList.AddColumn(IAIMPUITreeListColumn, AColumn));
  CheckResult(AColumn.SetValueAsInt32(AIMPUI_TL_COLUMN_PROPID_WIDTH, 300));

  // Create panel for buttons
  CheckResult(FService.CreateControl(FForm, AParent, MakeString('pnlTreeListButtonsBar'), Self, IAIMPUIPanel, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualBottom, 31, NullRect)));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_PANEL_PROPID_TRANSPARENT, 1));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_PANEL_PROPID_BORDERS, 0));
  AParent := AControl;

  // Create the drop down menu
  CheckResult(FService.CreateObject(FForm, nil, IAIMPUIPopupMenu, ADropDownMenu));
  AddMenuItem(ADropDownMenu, 'ru.aimp.guidemo.addcustom', HandlerAddCustom, True);
  AddMenuItem(ADropDownMenu, 'ru.aimp.guidemo.addfolders', HandlerAddFolders);
  AddMenuItem(ADropDownMenu, 'ru.aimp.guidemo.addfiles', HandlerAddFiles);

  // Create button with drop down menu
  CheckResult(FService.CreateControl(FForm, AParent, MakeString('btnAdd'),
    TAIMPUINotifyEventAdapter.Create(HandlerAddCustom, Self), IAIMPUIButton, AControl));
  CheckResult(AControl.SetPlacement(TAIMPUIControlPlacement.Create(ualLeft, 96)));
  CheckResult(AControl.SetValueAsInt32(AIMPUI_BUTTON_PROPID_STYLE, AIMPUI_FLAGS_BUTTON_STYLE_DROPDOWNBUTTON));
  CheckResult(AControl.SetValueAsObject(AIMPUI_BUTTON_PROPID_DROPDOWNMENU, ADropDownMenu));
end;

procedure TDemoForm.AddPathToTreeList(const Name, ParentFolder, Notes: string; AImageIndex: Integer);
var
  ANode: IAIMPUITreeListNode;
  ARootNode: IAIMPUITreeListNode;
begin
  // Query RootNode
  CheckResult(FTreeList.GetRootNode(IID_IAIMPUITreeListNode, ARootNode));

  // Add entry
  CheckResult(ARootNode.Add(ANode));
  CheckResult(ANode.SetValueAsInt32(AIMPUI_TL_NODE_PROPID_IMAGEINDEX, AImageIndex));
  CheckResult(ANode.SetValue(0, MakeString(Name)));
  CheckResult(ANode.SetValue(1, MakeString(ParentFolder)));
  CheckResult(ANode.SetValue(2, MakeString(Notes)));
end;

procedure TDemoForm.Log(const Sender: IUnknown; const S: string);
var
  AIntf: IAIMPUIControl;
  AName: IAIMPString;
  ANode: IAIMPUITreeListNode;
  ARootNode: IAIMPUITreeListNode;
begin
  AName := nil;
  if Supports(Sender, IAIMPUIControl, AIntf) then
    CheckResult(AIntf.GetValueAsObject(AIMPUI_CONTROL_PROPID_NAME, IID_IAIMPString, AName));

  // Query RootNode
  CheckResult(FLog.GetRootNode(IID_IAIMPUITreeListNode, ARootNode));

  // Add entry to log
  CheckResult(ARootNode.Add(ANode));
  CheckResult(ANode.SetValue(0, AName));
  CheckResult(ANode.SetValue(1, MakeString(S)));

  // Focus the entry
  CheckResult(FLog.SetFocused(ANode));
end;

procedure TDemoForm.HandlerAddCustom(const Sender: IInterface);
var
  ADialog: IAIMPUIInputDialog;
  ATextForValues: IAIMPObjectList;
  AValues: array [0..2] of OleVariant;
begin
  CoreCreateObject(IAIMPObjectList, ATextForValues);
  CheckResult(ATextForValues.Add(LangLoadStringEx('InputBox\L1')));
  CheckResult(ATextForValues.Add(LangLoadStringEx('InputBox\L2')));
  CheckResult(ATextForValues.Add(LangLoadStringEx('InputBox\L3')));

  CheckResult(FService.QueryInterface(IAIMPUIInputDialog, ADialog));
  if Succeeded(ADialog.Execute2(FForm.GetHandle, LangLoadStringEx('InputBox\Caption'), nil,
    ATextForValues, @AValues[0], Length(AValues)))
  then
    AddPathToTreeList(AValues[0], AValues[1], AValues[2], 9);
end;

procedure TDemoForm.HandlerAddFiles(const Sender: IInterface);
var
  ADialog: IAIMPUIFileDialogs;
  APath: string;
  APathInf: IAIMPString;
  ASelection: IAIMPObjectList;
  I: Integer;
begin
  CheckResult(FService.QueryInterface(IAIMPUIFileDialogs, ADialog));
  if Succeeded(ADialog.ExecuteOpenDialog2(FForm.GetHandle, nil, MakeString('All Files|*.*'), ASelection)) then
  begin
    for I := 0 to ASelection.GetCount - 1 do
      if Succeeded(ASelection.GetObject(I, IAIMPString, APathInf)) then
      begin
        APath := IAIMPStringToString(APathInf);
        AddPathToTreeList(ExtractFileName(APath), ExtractFilePath(APath), 'Just a file', 7);
      end;
  end;
end;

procedure TDemoForm.HandlerAddFolders(const Sender: IInterface);
var
  ADialog: IAIMPUIBrowseFolderDialog;
  APath: string;
  APathInf: IAIMPString;
  ASelection: IAIMPObjectList;
  I: Integer;
begin
  CheckResult(FService.QueryInterface(IAIMPUIBrowseFolderDialog, ADialog));
  if Succeeded(ADialog.Execute(FForm.GetHandle, AIMPUI_FLAGS_BROWSEFOLDER_MULTISELECT, nil, ASelection)) then
  begin
    for I := 0 to ASelection.GetCount - 1 do
      if Succeeded(ASelection.GetObject(I, IAIMPString, APathInf)) then
      begin
        APath := IAIMPStringToString(APathInf);
        AddPathToTreeList(ExtractFileName(ExtractFileDir(APath)), ExtractFilePath(ExtractFileDir(APath)), 'Just a folder', 8);
      end;
  end;
end;

procedure TDemoForm.HandlerCloseButton(const Sender: IUnknown);
begin
  FForm.Close;
end;

procedure TDemoForm.HandlerCustomDrawSlider(const Sender: IInterface; DC: HDC; const R: TRect);
var
  ABrush: HBRUSH;
  AValue: Integer;
begin
  // Get value and convert it to Byte range
  CheckResult((Sender as IAIMPUISlider).GetValueAsInt32(AIMPUI_SLIDER_PROPID_VALUE, AValue));
  AValue := MulDiv(MaxByte, AValue, 100);

  // Fill the background
  ABrush := CreateSolidBrush(RGB(MaxByte - AValue, AValue, 0));
  FillRect(DC, R, ABrush);
  DeleteObject(ABrush);

  // Draw the rectanble for track bar
  FrameRect(DC, R, GetStockObject(BLACK_BRUSH));
end;

procedure TDemoForm.HandlerEditButton(const Sender: IInterface);
var
  ADialog: IAIMPUIMessageDialog;
  AIndex: Integer;
begin
  CheckResult((Sender as IAIMPUIEditButton).GetValueAsInt32(AIMPUI_EDITBUTTON_PROPID_INDEX, AIndex));
  CheckResult(FService.QueryInterface(IAIMPUIMessageDialog, ADialog));
  CheckResult(ADialog.Execute(FForm.GetHandle, MakeString(''),
    MakeString(Format('EditButton%d clicked!', [AIndex])), MB_ICONINFORMATION));
end;

procedure TDemoForm.HandlerSkipMouseEvents(const Sender: IInterface);
var
  AState: Integer;
begin
  CheckResult((Sender as IAIMPUICheckBox).GetValueAsInt32(AIMPUI_CHECKBOX_PROPID_STATE, AState));
  FSkipMouseEvents := AState = 1;
end;

procedure TDemoForm.OnChanged(Sender: IInterface);
begin
  Log(Sender, 'Changed');
end;

procedure TDemoForm.OnEnter(Sender: IInterface);
begin
  Log(Sender, 'OnEnter');
end;

procedure TDemoForm.OnExit(Sender: IInterface);
begin
  Log(Sender, 'OnExit');
end;

procedure TDemoForm.OnKeyDown(Sender: IInterface; var Key: Word; Modifiers: Word);
begin
  Log(Sender, Format('OnKeyDown(%d, %d)', [Key, Modifiers]));
end;

procedure TDemoForm.OnKeyPress(Sender: IInterface; var Key: Char);
begin
  Log(Sender, Format('OnKeyPress(%s)', [Key]));
end;

procedure TDemoForm.OnKeyUp(Sender: IInterface; var Key: Word; Modifiers: Word);
begin
  Log(Sender, Format('OnKeyUp(%d, %d)', [Key, Modifiers]));
end;

procedure TDemoForm.OnMouseDoubleClick(Sender: IInterface; Button: TAIMPUIMouseButton; X, Y: Integer; Modifiers: Word);
begin
  if not FSkipMouseEvents then
    Log(Sender, Format('Double click via %s at %d,%d (Mods: %d)', [ButtonNames[Button], X, Y, Modifiers]));
end;

procedure TDemoForm.OnMouseDown(Sender: IInterface; Button: TAIMPUIMouseButton; X, Y: Integer; Modifiers: Word);
begin
  if not FSkipMouseEvents then
    Log(Sender, Format('Mouse down via %s at %d,%d (Mods: %d)', [ButtonNames[Button], X, Y, Modifiers]));
end;

procedure TDemoForm.OnMouseLeave(Sender: IInterface);
begin
  // do nothing
end;

procedure TDemoForm.OnMouseMove(Sender: IInterface; X, Y: Integer; Modifiers: Word);
begin
  if not FSkipMouseEvents then
    Log(Sender, Format('Mouse move at %d,%d (Mods: %d)', [X, Y, Modifiers]));
end;

procedure TDemoForm.OnMouseUp(Sender: IInterface; Button: TAIMPUIMouseButton; X, Y: Integer; Modifiers: Word);
begin
  if not FSkipMouseEvents then
    Log(Sender, Format('Mouse up via %s at %d,%d (Mods: %d)', [ButtonNames[Button], X, Y, Modifiers]));
end;

function TDemoForm.OnMouseWheel(Sender: IInterface; WheelDelta, X, Y: Integer; Modifiers: Word): LongBool;
begin
  if not FSkipMouseEvents then
    Log(Sender, Format('Mouse Wheel at %d,%d (Mods: %d, Delta: %d)', [X, Y, Modifiers, WheelDelta]));
  Result := False; // not handled, we just log the event
end;

procedure TDemoForm.OnShortCut(Sender: IAIMPUIForm; Key, Modifiers: Word; var Handled: LongBool);
begin
  // do nothing
end;

function TDemoForm.ShowModal: Integer;
begin
  Result := FForm.ShowModal;
end;

procedure TDemoForm.OnActivated(Sender: IAIMPUIPageControl; Page: IAIMPUITabSheet);
begin
  Log(Sender, PropListGetStr(Page, AIMPUI_TABSHEET_PROPID_CAPTION) + ' was activated');
end;

procedure TDemoForm.OnActivating(Sender: IAIMPUIPageControl; Page: IAIMPUITabSheet; var Allow: LongBool);
begin
  Log(Sender, PropListGetStr(Page, AIMPUI_TABSHEET_PROPID_CAPTION) + ' is activating');
end;

procedure TDemoForm.OnActivated(Sender: IAIMPUIForm);
begin
  Log(Sender, 'OnActivated');
end;

procedure TDemoForm.OnCloseQuery(Sender: IAIMPUIForm; var CanClose: LongBool);
var
  ADialog: IAIMPUIMessageDialog;
begin
  CheckResult(FService.QueryInterface(IAIMPUIMessageDialog, ADialog));
  CanClose := ADialog.Execute(FForm.GetHandle, LangLoadStringEx('GUIDemo.MSG\1'),
    LangLoadStringEx('GUIDemo.MSG\2'), MB_ICONQUESTION or MB_OKCANCEL or MB_DEFBUTTON2) = ID_OK;
end;

procedure TDemoForm.OnCreated(Sender: IAIMPUIForm);
begin
  // do nothing
end;

procedure TDemoForm.OnDeactivated(Sender: IAIMPUIForm);
begin
  Log(Sender, 'OnDeactivated');
end;

procedure TDemoForm.OnDestroyed(Sender: IAIMPUIForm);
begin
  // Release all variables
  FLog := nil;
  FTreeList := nil;
  FImages := nil;
  FForm := nil;
end;

procedure TDemoForm.OnLocalize(Sender: IAIMPUIForm);
begin
  Log(Sender, 'OnLocalize');
end;

end.
