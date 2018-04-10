{************************************************}
{*                                              *}
{*          AIMP Programming Interface          *}
{*                  UI Wrappers                 *}
{*                                              *}
{*                Artem Izmaylov                *}
{*                (C) 2006-2017                 *}
{*                 www.aimp.ru                  *}
{*            Mail: support@aimp.ru             *}
{*                                              *}
{************************************************}

unit apiWrappersUI;

{$I apiConfig.inc}

interface

uses
  Windows, Classes, Controls, Forms,
  // API
  apiObjects, apiOptions, apiWrappers;

type

  { TAIMPCustomOptionsFrame }

  TAIMPCustomOptionsFrame = class(TInterfacedObject,
    IAIMPOptionsDialogFrameKeyboardHelper,
    IAIMPOptionsDialogFrameKeyboardHelper2,
    IAIMPOptionsDialogFrame)
  private
    FForm: TForm;

    function FindNextControl(OwnerControl, CurControl: TWinControl; GoForward, CheckTabStop, CheckParent: Boolean): TWinControl;
    function SelectControl(Control: TWinControl): LongBool;
    // IAIMPOptionsDialogFrame
    function CreateFrame(ParentWnd: HWND): HWND; stdcall;
    procedure DestroyFrame; stdcall;
    // IAIMPOptionsDialogFrameKeyboardHelper
    function DialogChar(CharCode: WideChar; Unused: Integer): LongBool; stdcall;
    function DialogKey(CharCode: Word; Unused: Integer): LongBool; stdcall;
    function SelectFirstControl: LongBool; stdcall;
    function SelectNextControl(FindForward: LongBool; CheckTabStop: LongBool): LongBool; stdcall;
    // IAIMPOptionsDialogFrameKeyboardHelper2
    function SelectLastControl: LongBool; stdcall;
  protected
    function CreateForm(ParentWnd: HWND): TForm; virtual; abstract;
    function GetName(out S: IAIMPString): HRESULT; overload; virtual; stdcall;
    function GetName: UnicodeString; overload; virtual;
    procedure Notification(ID: Integer); virtual; stdcall;
    //
    property Form: TForm read FForm;
  end;

  { TAIMPCustomOptionsFrameForm }

  TAIMPCustomOptionsFrameForm = class(TForm)
  public
    constructor CreateParented(ParentWND: HWND);
  end;

procedure LangLocalizeForm(AFormComponent: TComponent; const ALangRoot: string);
implementation

uses
  TypInfo, SysUtils, Math, ActiveX, Menus;

type
  TWinControlAccess = class(TWinControl);

procedure LangLocalizeForm(AFormComponent: TComponent; const ALangRoot: string);

  procedure SetPropertyValue(AObject: TObject; const APropName, AValueName: string);
  var
    AProp: PPropInfo;
  begin
    AProp := GetPropInfo(AObject, APropName);
    if AProp <> nil then
      SetPropValue(AObject, AProp, LangLoadString(ALangRoot + AValueName));
  end;

var
  AComponent: TComponent;
  I: Integer;
begin
  SetPropertyValue(AFormComponent, 'Caption', 'Caption');
  for I := 0 to AFormComponent.ComponentCount - 1 do
  begin
    AComponent := AFormComponent.Components[I];
    if (AComponent.Name <> '') and not ((AComponent is TMenuItem) and TMenuItem(AComponent).IsLine) then
    begin
      SetPropertyValue(AComponent, 'Caption', AComponent.Name);
      SetPropertyValue(AComponent, 'Hint', AComponent.Name + '.h');
    end;
  end;
end;

{ TAIMPCustomOptionsFrame }

function TAIMPCustomOptionsFrame.GetName(out S: IAIMPString): HRESULT;
begin
  try
    S := MakeString(GetName);
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TAIMPCustomOptionsFrame.GetName: UnicodeString;
begin
  Result := '-';
end;

procedure TAIMPCustomOptionsFrame.Notification(ID: Integer);
begin
  // do nothing
end;

function TAIMPCustomOptionsFrame.SelectControl(Control: TWinControl): LongBool;
begin
  //#AI: for plugins that has been assembled with AIMP.Runtime.dll
  if Form.Parent = nil then
    Form.ActiveControl := Control;
  if Control <> nil then
    Control.SetFocus;
  Result := Control <> nil;
end;

function TAIMPCustomOptionsFrame.FindNextControl(OwnerControl, CurControl: TWinControl;
  GoForward, CheckTabStop, CheckParent: Boolean): TWinControl;
var
  AIndex: Integer;
  AList: TList;
begin
  Result := nil;

  AList := TList.Create;
  try
    TWinControlAccess(OwnerControl).GetTabOrderList(AList);
    if AList.Count > 0 then
    begin
      AIndex := AList.IndexOf(CurControl);
      if (AIndex = -1) and not GoForward then
        AIndex := AList.Count;

      repeat
        if GoForward then
          Inc(AIndex)
        else
          Dec(AIndex);

        if InRange(AIndex, 0, AList.Count - 1) then
        begin
          CurControl := TWinControl(AList[AIndex]);
          if CurControl.CanFocus and
            (not CheckTabStop or CurControl.TabStop) and
            (not CheckParent or (CurControl.Parent = OwnerControl))
          then
            Result := CurControl;
        end
        else
          Break;
      until Result <> nil;
    end;
  finally
    AList.Free;
  end;
end;

function TAIMPCustomOptionsFrame.CreateFrame(ParentWnd: HWND): HWND;
var
  R: Trect;
begin
  FForm := CreateForm(ParentWnd);
  FForm.Visible := True; // before BoundsRect initialization
  GetWindowRect(ParentWnd, R);
  OffsetRect(R, -R.Left, -R.Top);
  FForm.BoundsRect := R;
  Result := FForm.Handle;
end;

procedure TAIMPCustomOptionsFrame.DestroyFrame;
begin
  FreeAndNil(FForm);
end;

function TAIMPCustomOptionsFrame.DialogChar(CharCode: WideChar; Unused: Integer): LongBool;
begin
  Result := Form.Perform(CM_DIALOGCHAR, WPARAM(CharCode), 0) <> 0;
end;

function TAIMPCustomOptionsFrame.DialogKey(CharCode: Word; Unused: Integer): LongBool; stdcall;
begin
  Result := Form.Perform(CM_DIALOGKEY, CharCode, 0) <> 0;
end;

function TAIMPCustomOptionsFrame.SelectFirstControl: LongBool; stdcall;
var
  AControl: TWinControl;
begin
  try
    AControl := FindNextControl(Form, nil, True, True, False);
    if AControl = nil then
      AControl := FindNextControl(Form, nil, True, False, False);
    Result := SelectControl(AControl);
  except
    Result := False;
  end;
end;

function TAIMPCustomOptionsFrame.SelectLastControl: LongBool;
var
  AControl: TWinControl;
begin
  try
    AControl := FindNextControl(Form, nil, False, True, False);
    if AControl = nil then
      AControl := FindNextControl(Form, nil, False, False, False);
    Result := SelectControl(AControl);
  except
    Result := False;
  end;
end;

function TAIMPCustomOptionsFrame.SelectNextControl(FindForward: LongBool; CheckTabStop: LongBool): LongBool; stdcall;
var
  AActiveControl: TWinControl;
  AControl: TWinControl;
begin
  try
    AActiveControl := GetParentForm(Form).ActiveControl;
    if CheckTabStop then
      AControl := FindNextControl(Form, AActiveControl, FindForward, True, False)
    else
      if AActiveControl <> nil then
        AControl := FindNextControl(AActiveControl.Parent, AActiveControl, FindForward, False, True)
      else
        AControl := nil;

    if AControl = AActiveControl then
      AControl := nil;
    Result := SelectControl(AControl);
  except
    Result := False;
  end;
end;

{ TAIMPCustomOptionsFrameForm }

constructor TAIMPCustomOptionsFrameForm.CreateParented(ParentWND: HWND);
var
  AParentControl: TWinControl;
begin
  AParentControl := FindControl(ParentWND);
  //#AI: for plugins that has been assembled with AIMP.Runtime.dll
  if AParentControl <> nil then
  begin
    inherited Create(nil);
    Parent := AParentControl;
  end
  else
    inherited CreateParented(ParentWND);
end;

end.
