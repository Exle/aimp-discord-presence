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

unit apiOptions;

{$I apiConfig.inc}

interface

uses
  Windows, apiObjects;

const
  SID_IAIMPServiceOptionsDialog = '{41494D50-5372-764F-7074-446C67000000}';
  IID_IAIMPServiceOptionsDialog: TGUID = SID_IAIMPServiceOptionsDialog;

  SID_IAIMPOptionsDialogFrame = '{41494D50-4F70-7444-6C67-4672616D6500}';
  IID_IAIMPOptionsDialogFrame: TGUID = SID_IAIMPOptionsDialogFrame;

  SID_IAIMPOptionsDialogFrameKeyboardHelper = '{41494D50-4F70-7444-6C67-46726D4B4870}';
  IID_IAIMPOptionsDialogFrameKeyboardHelper: TGUID = SID_IAIMPOptionsDialogFrameKeyboardHelper;

  SID_IAIMPOptionsDialogFrameKeyboardHelper2 = '{41494D50-4F70-7444-6C67-46726D4B4832}';
  IID_IAIMPOptionsDialogFrameKeyboardHelper2: TGUID = SID_IAIMPOptionsDialogFrameKeyboardHelper2;

  AIMP_SERVICE_OPTIONSDIALOG_NOTIFICATION_LOAD         = $1;
  AIMP_SERVICE_OPTIONSDIALOG_NOTIFICATION_LOCALIZATION = $2;
  AIMP_SERVICE_OPTIONSDIALOG_NOTIFICATION_SAVE         = $3;
  AIMP_SERVICE_OPTIONSDIALOG_NOTIFICATION_CAN_SAVE     = $4;

type

  { IAIMPOptionsDialogFrame }

  IAIMPOptionsDialogFrame = interface(IUnknown)
  [SID_IAIMPOptionsDialogFrame]
    function GetName(out S: IAIMPString): HRESULT; stdcall;
    function CreateFrame(ParentWnd: HWND): HWND; stdcall;
    procedure DestroyFrame; stdcall;
    procedure Notification(ID: Integer); stdcall;
  end;

  { IAIMPOptionsDialogFrameKeyboardHelper }

  IAIMPOptionsDialogFrameKeyboardHelper = interface(IUnknown)
  [SID_IAIMPOptionsDialogFrameKeyboardHelper]
    function DialogChar(CharCode: WideChar; Unused: Integer): LongBool; stdcall;
    function DialogKey(CharCode: Word; Unused: Integer): LongBool; stdcall;
    function SelectFirstControl: LongBool; stdcall;
    function SelectNextControl(FindForward, CheckTabStop: LongBool): LongBool; stdcall;
  end;

  { IAIMPOptionsDialogFrameKeyboardHelper2 }

  IAIMPOptionsDialogFrameKeyboardHelper2 = interface(IUnknown)
  [SID_IAIMPOptionsDialogFrameKeyboardHelper2]
    function SelectLastControl: LongBool; stdcall;
  end;

  { IAIMPServiceOptionsDialog }

  IAIMPServiceOptionsDialog = interface(IUnknown)
  [SID_IAIMPServiceOptionsDialog]
    function FrameModified(Frame: IAIMPOptionsDialogFrame): HRESULT; stdcall;
    function FrameShow(Frame: IAIMPOptionsDialogFrame; ForceShow: LongBool): HRESULT; stdcall;
  end;

implementation

end.
