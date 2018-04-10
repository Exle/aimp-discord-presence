unit CustomServiceDemoPublicIntf;

// This file contains a public interfaces, which will be available for another developers

interface

const
  SID_IMyCustomExtension = '{04D04C1E-6B29-4889-AD00-39CEE4BC56E7}';
  IID_IMyCustomExtension: TGUID = SID_IMyCustomExtension;

  SID_IMyCustomService = '{5CD9EF89-2725-4541-A935-6030BA060D2F}';
  IID_IMyCustomService: TGUID = SID_IMyCustomService;

  SID_IMyCustomObject = '{2A2D5095-4B52-4C34-8BC8-62D79ABB1A4B}';
  IID_IMyCustomObject: TGUID = SID_IMyCustomObject;

  SID_IMyCustomObjectv2 = '{2A2D5095-4B52-4C34-8BC8-62D79ABB1A4C}';
  IID_IMyCustomObjectv2: TGUID = SID_IMyCustomObjectv2;

type

  { IMyCustomExtension }

  IMyCustomExtension = interface
  [SID_IMyCustomExtension]
    procedure SomeNotification; stdcall;
  end;

  { IMyCustomService }

  IMyCustomService = interface
  [SID_IMyCustomService]
    function SomeMethod: HRESULT; stdcall;
  end;

  { IMyCustomObject }

  IMyCustomObject = interface
  [SID_IMyCustomObject]
    function SomeMethod: HRESULT; stdcall;
  end;

  { IMyCustomObjectv2 }

  // This is second version of IMyCustomObject interface, which introduce some new functionality for the object,
  // Make sure that it has a different GUID!
  IMyCustomObjectv2 = interface(IMyCustomObject)
  [SID_IMyCustomObjectv2]
    function SomeNewMethod: HRESULT; stdcall;
  end;

implementation

end.
