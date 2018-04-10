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

unit apiThreading;

{$I apiConfig.inc}

interface

uses
  Windows;

const
  SID_IAIMPTask = '{41494D50-5461-736B-0000-000000000000}';
  IID_IAIMPTask: TGUID = SID_IAIMPTask;

  SID_IAIMPTaskOwner = '{41494D50-5461-736B-4F77-6E6572000000}';
  IID_IAIMPTaskOwner: TGUID = SID_IAIMPTaskOwner;
  
  SID_IAIMPTaskPriority = '{41494D50-5461-736B-5072-696F72697479}';
  IID_IAIMPTaskPriority: TGUID = SID_IAIMPTaskPriority;

  SID_IAIMPServiceSynchronizer = '{41494D50-5372-7653-796E-637200000000}';
  IID_IAIMPServiceSynchronizer: TGUID = SID_IAIMPServiceSynchronizer;

  SID_IAIMPServiceThreadPool = '{41494D50-5372-7654-6872-64506F6F6C00}';
  IID_IAIMPServiceThreadPool: TGUID = SID_IAIMPServiceThreadPool;

  // Flags for IAIMPServiceThreadPool.Cancel
  AIMP_SERVICE_THREADPOOL_FLAGS_WAITFOR = $1;
  
  // IAIMPTaskPriority.GetPriority
  AIMP_TASK_PRIORITY_NORMAL = 0;
  AIMP_TASK_PRIORITY_LOW    = 1;
  AIMP_TASK_PRIORITY_HIGH   = 2;

type
  IAIMPTaskOwner = interface;

  { IAIMPTask }

  IAIMPTask = interface(IUnknown)
  [SID_IAIMPTask]
    procedure Execute(Owner: IAIMPTaskOwner); stdcall;
  end;
  
  { IAIMPTaskPriority }
  
  IAIMPTaskPriority = interface(IUnknown)
  [SID_IAIMPTaskPriority]
    function GetPriority: Integer; stdcall;
  end;

  { IAIMPTaskOwner }

  IAIMPTaskOwner = interface(IUnknown)
  [SID_IAIMPTaskOwner]
    function IsCanceled: LongBool;
  end;

  { IAIMPServiceSynchronizer }

  IAIMPServiceSynchronizer = interface(IUnknown)
  [SID_IAIMPServiceSynchronizer]
    function ExecuteInMainThread(Task: IAIMPTask; ExecuteNow: LongBool): HRESULT; stdcall;
  end;

  { IAIMPServiceThreadPool }

  IAIMPServiceThreadPool = interface(IUnknown)
  [SID_IAIMPServiceThreadPool]
    function Cancel(TaskHandle: THandle; Flags: DWORD): HRESULT; stdcall;
    function Execute(Task: IAIMPTask; out TaskHandle: THandle): HRESULT; stdcall;
    function WaitFor(TaskHandle: THandle): HRESULT; stdcall;
  end;

implementation

end.
