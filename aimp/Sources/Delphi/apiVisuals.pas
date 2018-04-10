{************************************************}
{*                                              *}
{*          AIMP Programming Interface          *}
{*               v4.50 build 2000               *}
{*                                              *}
{*                Artem Izmaylov                *}
{*                (C) 2006-2017                 *}
{*                 www.aimp.ru                  *}
{*            Mail: support@aimp.ru             *}
{*                                              *}
{************************************************}

unit apiVisuals;

{$I apiConfig.inc}

interface

uses
  Windows, apiObjects, apiCore;

const
  SID_IAIMPExtensionEmbeddedVisualization = '{41494D50-4578-7445-6D62-645669730000}';
  IID_IAIMPExtensionEmbeddedVisualization: TGUID = SID_IAIMPExtensionEmbeddedVisualization;

  SID_IAIMPExtensionCustomVisualization = '{41494D50-4578-7443-7374-6D5669730000}';
  IID_IAIMPExtensionCustomVisualization: TGUID = SID_IAIMPExtensionCustomVisualization;

  SID_IAIMPServiceVisualizations = '{41494D50-5372-7656-6973-75616C000000}';
  IID_IAIMPServiceVisualizations: TGUID = SID_IAIMPServiceVisualizations;

  // Button ID for IAIMPExtensionEmbeddedVisualization.Click
  AIMP_VISUAL_CLICK_BUTTON_LEFT   = 0;
  AIMP_VISUAL_CLICK_BUTTON_MIDDLE = 1;

  // flags for IAIMPExtensionEmbeddedVisualization.GetFlags and IAIMPExtensionCustomVisualization.GetFlags
  AIMP_VISUAL_FLAGS_RQD_DATA_WAVE       = 1;
  AIMP_VISUAL_FLAGS_RQD_DATA_SPECTRUM   = 2;
  AIMP_VISUAL_FLAGS_NOT_SUSPEND         = 4;

  AIMP_VISUAL_SPECTRUM_SIZE = 256;
  AIMP_VISUAL_WAVEFORM_SIZE = 512;

type
  TAIMPVisualDataSpectrum = array[0..AIMP_VISUAL_SPECTRUM_SIZE - 1] of Single;
  TAIMPVisualDataWaveform = array[0..AIMP_VISUAL_WAVEFORM_SIZE - 1] of Single;

  PAIMPVisualData = ^TAIMPVisualData;
  TAIMPVisualData = packed record
    Peaks: array[0..1] of Single;
    Spectrum: array[0..2] of TAIMPVisualDataSpectrum;
    Waveform: array[0..1] of TAIMPVisualDataWaveform;
    Reserved: Integer;
  end;

  { IAIMPExtensionCustomVisualization }

  IAIMPExtensionCustomVisualization = interface(IUnknown)
  [SID_IAIMPExtensionCustomVisualization]
    // Common information
    function GetFlags: Integer; stdcall;
    // Basic functionality
    procedure Draw(Data: PAIMPVisualData); stdcall;
  end;

  { IAIMPExtensionEmbeddedVisualization }

  IAIMPExtensionEmbeddedVisualization = interface(IUnknown)
  [SID_IAIMPExtensionEmbeddedVisualization]
    // Common information
    function GetFlags: Integer; stdcall;
    function GetMaxDisplaySize(out Width, Height: Integer): HRESULT; stdcall;
    function GetName(out S: IAIMPString): HRESULT; stdcall;
    // Initialization / Finalization
    function Initialize(Width, Height: Integer): HRESULT; stdcall;
    procedure Finalize; stdcall;
    // Basic functionality
    procedure Click(X, Y: Integer; Button: Integer); stdcall;
    procedure Draw(DC: HDC; Data: PAIMPVisualData); stdcall;
    procedure Resize(NewWidth, NewHeight: Integer); stdcall;
  end;

  { IAIMPServiceVisualizations }

  IAIMPServiceVisualizations = interface(IUnknown)
  [SID_IAIMPServiceVisualizations]
  end;

implementation

end.

