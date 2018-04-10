unit uOptionFrameDemo;

interface

uses
  Windows, AIMPCustomPlugin, Forms, uOptionFrameDemoForm,  apiOptions, apiObjects, apiCore;

type

  { TAIMPDemoPluginOptionFrame }

  TAIMPDemoPluginOptionFrame = class(TInterfacedObject, IAIMPOptionsDialogFrame)
  strict private
    FFrame: TfrmOptionFrameDemo;
    procedure HandlerModified(Sender: TObject);
  protected
    // IAIMPOptionsDialogFrame
    function CreateFrame(ParentWnd: HWND): HWND; stdcall;
    procedure DestroyFrame; stdcall;
    function GetName(out S: IAIMPString): HRESULT; stdcall;
    procedure Notification(ID: Integer); stdcall;
  end;

  { TAIMPDemoPlugin }

  TAIMPDemoPlugin = class(TAIMPCustomPlugin)
  protected
    function InfoGet(Index: Integer): PWideChar; override; stdcall;
    function InfoGetCategories: Cardinal; override; stdcall;
    function Initialize(Core: IAIMPCore): HRESULT; override; stdcall;
  end;

implementation

uses
  apiWrappers, SysUtils, apiPlugin;

{ TAIMPDemoPluginOptionFrame }

function TAIMPDemoPluginOptionFrame.CreateFrame(ParentWnd: HWND): HWND;
var
  R: Trect;
begin
  FFrame := TfrmOptionFrameDemo.CreateParented(ParentWnd);
  FFrame.OnModified := HandlerModified;
  GetWindowRect(ParentWnd, R);
  OffsetRect(R, -R.Left, -R.Top);
  FFrame.BoundsRect := R;
  FFrame.Visible := True;
  Result := FFrame.Handle;
end;

procedure TAIMPDemoPluginOptionFrame.DestroyFrame;
begin
  FreeAndNil(FFrame);
end;

function TAIMPDemoPluginOptionFrame.GetName(out S: IAIMPString): HRESULT;
begin
  try
    S := MakeString('Custom Frame');
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

procedure TAIMPDemoPluginOptionFrame.Notification(ID: Integer);
begin
  if FFrame <> nil then
    case ID of
      AIMP_SERVICE_OPTIONSDIALOG_NOTIFICATION_LOCALIZATION:
        TfrmOptionFrameDemo(FFrame).ApplyLocalization;
      AIMP_SERVICE_OPTIONSDIALOG_NOTIFICATION_LOAD:
        TfrmOptionFrameDemo(FFrame).ConfigLoad;
      AIMP_SERVICE_OPTIONSDIALOG_NOTIFICATION_SAVE:
        TfrmOptionFrameDemo(FFrame).ConfigSave;
    end;
end;

procedure TAIMPDemoPluginOptionFrame.HandlerModified(Sender: TObject);
var
  AServiceOptions: IAIMPServiceOptionsDialog;
begin
  if Supports(CoreIntf, IAIMPServiceOptionsDialog, AServiceOptions) then
    AServiceOptions.FrameModified(Self);
end;

{ TAIMPDemoPlugin }

function TAIMPDemoPlugin.InfoGet(Index: Integer): PWideChar;
begin
  case Index of
    AIMP_PLUGIN_INFO_NAME:
      Result := 'OptionFrame Demo';
    AIMP_PLUGIN_INFO_AUTHOR:
      Result := 'Artem Izmaylov';
    AIMP_PLUGIN_INFO_SHORT_DESCRIPTION:
      Result := 'This plugin show how to use Options API';
  else
    Result := nil;
  end;
end;

function TAIMPDemoPlugin.InfoGetCategories: Cardinal;
begin
  Result := AIMP_PLUGIN_CATEGORY_ADDONS;
end;

function TAIMPDemoPlugin.Initialize(Core: IAIMPCore): HRESULT;
begin
  Result := inherited Initialize(Core);
  if Succeeded(Result) then
    Core.RegisterExtension(IID_IAIMPServiceOptionsDialog, TAIMPDemoPluginOptionFrame.Create);
end;

end.
