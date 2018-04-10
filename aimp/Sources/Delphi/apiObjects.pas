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

unit apiObjects;

{$I apiConfig.inc}

interface

uses
  Windows;

const
  SID_IAIMPConfig = '{41494D50-436F-6E66-6967-000000000000}';
  IID_IAIMPConfig: TGUID = SID_IAIMPConfig;

  SID_IAIMPErrorInfo = '{41494D50-4572-7249-6E66-6F0000000000}';
  IID_IAIMPErrorInfo: TGUID = SID_IAIMPErrorInfo;

  SID_IAIMPHashCode = '{41494D50-4861-7368-436F-646500000000}';
  IID_IAIMPHashCode: TGUID = SID_IAIMPHashCode;

  SID_IAIMPDPIAware = '{41494D50-4450-4941-7761-726500000000}';
  IID_IAIMPDPIAware: TGUID = SID_IAIMPDPIAware;

  SID_IAIMPFileStream = '{41494D50-4669-6C65-5374-7265616D0000}';
  IID_IAIMPFileStream: TGUID = SID_IAIMPFileStream;

  SID_IAIMPImage = '{41494D50-496D-6167-6500-000000000000}';
  IID_IAIMPImage: TGUID = SID_IAIMPImage;

  SID_IAIMPImage2 = '{41494D50-496D-6167-6532-000000000000}';
  IID_IAIMPImage2: TGUID = SID_IAIMPImage2;

  SID_IAIMPImageContainer = '{41494D50-496D-6167-6543-6F6E746E7200}';
  IID_IAIMPImageContainer: TGUID = SID_IAIMPImageContainer;

  SID_IAIMPMemoryStream = '{41494D50-4D65-6D53-7472-65616D000000}';
  IID_IAIMPMemoryStream: TGUID = SID_IAIMPMemoryStream;

  SID_IAIMPObjectList = '{41494D50-4F62-6A4C-6973-740000000000}';
  IID_IAIMPObjectList: TGUID = SID_IAIMPObjectList;

  SID_IAIMPProgressCallback = '{41494D50-5072-6F67-7265-737343420000}';
  IID_IAIMPProgressCallback: TGUID = SID_IAIMPProgressCallback;

  SID_IAIMPPropertyList = '{41494D50-5072-6F70-4C69-737400000000}';
  IID_IAIMPPropertyList: TGUID = SID_IAIMPPropertyList;

  SID_IAIMPPropertyList2 = '{41494D50-5072-6F70-4C69-737432000000}';
  IID_IAIMPPropertyList2: TGUID = SID_IAIMPPropertyList2;

  SID_IAIMPStream = '{41494D50-5374-7265-616D-000000000000}';
  IID_IAIMPStream: TGUID = SID_IAIMPStream;

  SID_IAIMPString = '{41494D50-5374-7269-6E67-000000000000}';
  IID_IAIMPString: TGUID = SID_IAIMPString;

const
  // IAIMPImage and IAIMPImageContainer FormatID
  AIMP_IMAGE_FORMAT_UNKNOWN = 0;
  AIMP_IMAGE_FORMAT_BMP     = 1;
  AIMP_IMAGE_FORMAT_GIF     = 2;
  AIMP_IMAGE_FORMAT_JPG     = 3;
  AIMP_IMAGE_FORMAT_PNG     = 4;

  // Flags for IAIMPImage.Draw
  AIMP_IMAGE_DRAW_STRETCHMODE_STRETCH = 0;
  AIMP_IMAGE_DRAW_STRETCHMODE_FILL    = 1;
  AIMP_IMAGE_DRAW_STRETCHMODE_FIT     = 2;
  AIMP_IMAGE_DRAW_STRETCHMODE_TILE    = 4;
  AIMP_IMAGE_DRAW_QUALITY_DEFAULT     = 0;
  AIMP_IMAGE_DRAW_QUALITY_LOW         = 8;
  AIMP_IMAGE_DRAW_QUALITY_HIGH        = 16;
  
  // IAIMPPropertyList
  AIMP_PROPERTYLIST_CUSTOM_PROPID_BASE = 1000;

  // Flags for IAIMPString.ChangeCase
  AIMP_STRING_CASE_LOWER                          = 1;
  AIMP_STRING_CASE_UPPER                          = 2;
  AIMP_STRING_CASE_ALL_WORDS_WITH_CAPICAL_LETTER  = 3;
  AIMP_STRING_CASE_FIRST_WORD_WITH_CAPICAL_LETTER = 4;

  // Flags for IAIMPString.Find and IAIMPString.Replace
  AIMP_STRING_FIND_IGNORECASE = 1;
  AIMP_STRING_FIND_WHOLEWORD  = 2;

  // IAIMPStream.Seet Mode
  AIMP_STREAM_SEEKMODE_FROM_BEGINNING = 0;
  AIMP_STREAM_SEEKMODE_FROM_CURRENT   = 1;
  AIMP_STREAM_SEEKMODE_FROM_END       = 2;

type
  IAIMPStream = interface;
  IAIMPString = interface;

  { IAIMPConfig }

  IAIMPConfig = interface(IUnknown)
  [SID_IAIMPConfig]
    // Delete
    function Delete(KeyPath: IAIMPString): HRESULT; stdcall;
    // Read
    function GetValueAsFloat(KeyPath: IAIMPString; out Value: Double): HRESULT; stdcall;
    function GetValueAsInt32(KeyPath: IAIMPString; out Value: Integer): HRESULT; stdcall;
    function GetValueAsInt64(KeyPath: IAIMPString; out Value: Int64): HRESULT; stdcall;
    function GetValueAsStream(KeyPath: IAIMPString; out Value: IAIMPStream): HRESULT; stdcall;
    function GetValueAsString(KeyPath: IAIMPString; out Value: IAIMPString): HRESULT; stdcall;
  	// Write
    function SetValueAsFloat(KeyPath: IAIMPString; const Value: Double): HRESULT; stdcall;
    function SetValueAsInt32(KeyPath: IAIMPString; Value: Integer): HRESULT; stdcall;
    function SetValueAsInt64(KeyPath: IAIMPString; const Value: Int64): HRESULT; stdcall;
    function SetValueAsStream(KeyPath: IAIMPString; Value: IAIMPStream): HRESULT; stdcall;
    function SetValueAsString(KeyPath: IAIMPString; Value: IAIMPString): HRESULT; stdcall;
  end;

  { IAIMPErrorInfo }

  IAIMPErrorInfo = interface(IUnknown)
  [SID_IAIMPErrorInfo]
    function GetInfo(out ErrorCode: Integer; out Message: IAIMPString; out Details: IAIMPString): HRESULT; stdcall;
    function GetInfoFormatted(out S: IAIMPString): HRESULT; stdcall;
    procedure SetInfo(ErrorCode: Integer; Message, Details: IAIMPString); stdcall;
  end;

  { IAIMPHashCode }

  IAIMPHashCode = interface(IUnknown)
  [SID_IAIMPHashCode]
    function GetHashCode: Integer; stdcall;
    procedure Recalculate; stdcall;
  end;

  { IAIMPDPIAware }

  IAIMPDPIAware = interface
  [SID_IAIMPDPIAware]
    function GetDPI: Integer; stdcall;
    function SetDPI(Value: Integer): HRESULT; stdcall;
  end;

  { IAIMPImage }

  IAIMPImage = interface(IUnknown)
  [SID_IAIMPImage]
    // I/O
    function LoadFromFile(FileName: IAIMPString): HRESULT; stdcall;
    function LoadFromStream(Stream: IAIMPStream): HRESULT; stdcall;
    function SaveToFile(FileName: IAIMPString; FormatID: Integer): HRESULT; stdcall;
    function SaveToStream(Stream: IAIMPStream; FormatID: Integer): HRESULT; stdcall;
    // Info
    function GetFormatID: Integer;  stdcall;
    function GetSize(out Size: TSize): HRESULT; stdcall;
    // Methods
    function Clone(out Image: IAIMPImage): HRESULT; stdcall;
    function Draw(DC: HDC; R: TRect; Flags: DWORD; Attrs: IUnknown): HRESULT; stdcall;
    function Resize(Width, Height: Integer): HRESULT; stdcall;
  end;

  { IAIMPImage2 }

  IAIMPImage2 = interface(IAIMPImage)
  [SID_IAIMPImage2]
    // I/O
    function LoadFromResource(ResInstance: THandle; ResName, ResType: PWideChar): HRESULT; stdcall;
    function LoadFromBitmap(Bitmap: HBITMAP): HRESULT; stdcall;
    function LoadFromBits(Bits: PRGBQuad; Width, Height: Integer): HRESULT; stdcall;
    // Clipboard
    function CopyToClipboard: HRESULT; stdcall;
    function CanPasteFromClipboard: HRESULT; stdcall;
    function PasteFromClipboard: HRESULT; stdcall;
  end;

  { IAIMPImageContainer }

  IAIMPImageContainer = interface(IUnknown)
  [SID_IAIMPImageContainer]
    function CreateImage(out Image: IAIMPImage): HRESULT; stdcall;
    function GetInfo(out Size: TSize; out FormatID: Integer): HRESULT; stdcall;
    function GetData: PByte; stdcall;
    function GetDataSize: DWORD; stdcall;
    function SetDataSize(Value: DWORD): HRESULT; stdcall;
  end;

  { IAIMPObjectList }

  IAIMPObjectList = interface(IUnknown)
  [SID_IAIMPObjectList]
    function Add(Obj: IUnknown): HRESULT; stdcall;
    function Clear: HRESULT; stdcall;
    function Delete(Index: Integer): HRESULT; stdcall;
    function Insert(Index: Integer; Obj: IUnknown): HRESULT; stdcall;

    function GetCount: Integer; stdcall;
    function GetObject(Index: Integer; const IID: TGUID; out Obj): HRESULT; stdcall;
    function SetObject(Index: Integer; Obj: IUnknown): HRESULT; stdcall;
  end;

  { IAIMPProgressCallback }

  IAIMPProgressCallback = interface(IUnknown)
  [SID_IAIMPProgressCallback]
    procedure Process(Progress: Single; var Canceled: LongBool); stdcall;
  end;

  { IAIMPPropertyList }

  IAIMPPropertyList = interface(IUnknown)
  [SID_IAIMPPropertyList]
    procedure BeginUpdate; stdcall;
    procedure EndUpdate; stdcall;
    function Reset: HRESULT; stdcall;
    // Read
    function GetValueAsFloat(PropertyID: Integer; out Value: Double): HRESULT; stdcall;
    function GetValueAsInt32(PropertyID: Integer; out Value: Integer): HRESULT; stdcall;
    function GetValueAsInt64(PropertyID: Integer; out Value: Int64): HRESULT; stdcall;
    function GetValueAsObject(PropertyID: Integer; const IID: TGUID; out Value): HRESULT; stdcall;
    // Write
    function SetValueAsFloat(PropertyID: Integer; const Value: Double): HRESULT; stdcall;
    function SetValueAsInt32(PropertyID: Integer; Value: Integer): HRESULT; stdcall;
    function SetValueAsInt64(PropertyID: Integer; const Value: Int64): HRESULT; stdcall;
  	function SetValueAsObject(PropertyID: Integer; Value: IUnknown): HRESULT; stdcall;
  end;

  { IAIMPPropertyList2 }

  IAIMPPropertyList2 = interface(IAIMPPropertyList)
  [SID_IAIMPPropertyList2]
    function GetValueAsVariant(PropertyID: Integer; out Value: OleVariant): HRESULT; stdcall;
    function SetValueAsVariant(PropertyID: Integer; const Value: OleVariant): HRESULT; stdcall;
  end;

  { IAIMPStream }

  IAIMPStream = interface(IUnknown)
  [SID_IAIMPStream]
    function GetSize: Int64; stdcall;
    function SetSize(const Value: Int64): HRESULT; stdcall;
    function GetPosition: Int64; stdcall;
    function Seek(const Offset: Int64; Mode: Integer): HRESULT; stdcall;
    function Read(Buffer: PByte; Count: DWORD): Integer; stdcall;
    function Write(Buffer: PByte; Count: DWORD; Written: PDWORD = nil): HRESULT; stdcall;
  end;

  { IAIMPFileStream }

  IAIMPFileStream = interface(IAIMPStream)
  [SID_IAIMPFileStream]
    function GetClipping(out Offset, Size: Int64): HRESULT; stdcall;
    function GetFileName(out S: IAIMPString): HRESULT; stdcall;
  end;

  { IAIMPMemoryStream }

  IAIMPMemoryStream = interface(IAIMPStream)
  [SID_IAIMPMemoryStream]
    function GetData: PByte; stdcall;
  end;

  { IAIMPString }

  IAIMPString = interface(IUnknown)
  [SID_IAIMPString]
    function GetChar(Index: Integer; out Char: WideChar): HRESULT; stdcall;
    function GetData: PWideChar; stdcall;
    function GetLength: Integer; stdcall;
    function GetHashCode: Integer; stdcall;
    function SetChar(Index: Integer; Char: WideChar): HRESULT; stdcall;
    function SetData(Chars: PWideChar; CharsCount: Integer): HRESULT; stdcall;

    function Add(S: IAIMPString): HRESULT; stdcall;
    function Add2(Chars: PWideChar; Count: Integer): HRESULT; stdcall;

    function ChangeCase(Mode: Integer): HRESULT; stdcall;
    function Clone(out S: IAIMPString): HRESULT; stdcall;

    function Compare(S: IAIMPString; out CompareResult: Integer; IgnoreCase: LongBool): HRESULT; stdcall;
    function Compare2(Chars: PWideChar; CharsCount: Integer; out CompareResult: Integer; IgnoreCase: LongBool): HRESULT; stdcall;

    function Delete(Index, Count: Integer): HRESULT; stdcall;

    function Find(S: IAIMPString; out Index: Integer; Flags: Integer; StartFromIndex: Integer = 0): HRESULT; stdcall;
    function Find2(Chars: PWideChar; CharsCount: Integer; out Index: Integer; Flags: Integer; StartFromIndex: Integer = 0): HRESULT; stdcall;

    function Insert(Index: Integer; S: IAIMPString): HRESULT; stdcall;
    function Insert2(Index: Integer; Chars: PWideChar; CharsCount: Integer): HRESULT; stdcall;

    function Replace(OldPattern, NewPattern: IAIMPString; Flags: Integer): HRESULT; stdcall;
    function Replace2(OldPatternChars: PWideChar; OldPatternCharsCount: Integer;
      NewPatternChars: PWideChar; NewPatternCharsCount: Integer; Flags: Integer): HRESULT; stdcall;

    function SubString(Index, Count: Integer; out S: IAIMPString): HRESULT; stdcall;
  end;

implementation

end.
