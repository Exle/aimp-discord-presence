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

unit apiScheduler;

{$I apiConfig.inc}

interface

uses
  apiObjects;

const
  SID_IAIMPSchedulerEvent = '{41494D50-5363-6865-6475-6C6572457674}';
  IID_IAIMPSchedulerEvent: TGUID = SID_IAIMPSchedulerEvent;

  SID_IAIMPServiceScheduler = '{41494D50-5372-7653-6368-6564756C6572}';
  IID_IAIMPServiceScheduler: TGUID = SID_IAIMPServiceScheduler;

const
  // IAIMPServiceScheduler.GetEvent
  AIMP_SCHEDULER_EVENT_ALARM_ID    = 0;
  AIMP_SCHEDULER_EVENT_SHUTDOWN_ID = 1;

  // PropertyID for the IAIMPSchedulerEvent
  AIMP_SCHEDULER_EVENT_PROPID_ID                       = 1;
  AIMP_SCHEDULER_EVENT_PROPID_ACTIVE                   = 2;
  AIMP_SCHEDULER_EVENT_PROPID_TIME                     = 3;
  AIMP_SCHEDULER_EVENT_PROPID_SHUTDOWN_ACTION          = 4;
  AIMP_SCHEDULER_EVENT_PROPID_SHUTDOWN_SOURCE_EVENT    = 5;
  AIMP_SCHEDULER_EVENT_PROPID_SHUTDOWN_TRACKCOUNT      = 6;
  AIMP_SCHEDULER_EVENT_PROPID_ALARM_SOURCE             = 7;
  AIMP_SCHEDULER_EVENT_PROPID_ALARM_SOURCE_TYPE        = 8;
  AIMP_SCHEDULER_EVENT_PROPID_ALARM_VOLUME             = 9;
  AIMP_SCHEDULER_EVENT_PROPID_ALARM_VOLUME_FADING      = 10;
  AIMP_SCHEDULER_EVENT_PROPID_ALARM_VOLUME_FADING_TIME = 11;

  // Values for the AIMP_SCHEDULER_EVENT_PROPID_SOURCE_TYPE property
  AIMP_ALARM_EVENT_SOURCE_TYPE_FILE                = 0;
  AIMP_ALARM_EVENT_SOURCE_TYPE_PLAYLIST            = 1;

  // Values for the AIMP_SCHEDULER_EVENT_PROPID_SHUTDOWN_SOURCE_EVENT property
  AIMP_SHUTDOWN_EVENT_SOURCE_EVENT_BY_TIME         = 0;
  AIMP_SHUTDOWN_EVENT_SOURCE_EVENT_END_OF_PLAYLIST = 1;
  AIMP_SHUTDOWN_EVENT_SOURCE_EVENT_END_OF_QUEUE    = 2;
  AIMP_SHUTDOWN_EVENT_SOURCE_EVENT_END_OF_TRACK    = 3;

  // Values for the AIMP_SCHEDULER_EVENT_PROPID_SHUTDOWN_ACTION property
  AIMP_SHUTDOWN_EVENT_ACTION_PAUSE_PLAYBACK             = 1;
  AIMP_SHUTDOWN_EVENT_ACTION_SHUTDOWN_PLAYER            = 2;
  AIMP_SHUTDOWN_EVENT_ACTION_SHUTDOWN_WINDOWS           = 4;
  AIMP_SHUTDOWN_EVENT_ACTION_SHUTDOWN_WINDOWS_HIBERNATE = 8;
  AIMP_SHUTDOWN_EVENT_ACTION_SHUTDOWN_WINDOWS_SLEEP     = 16;

  // Custom Messages for IAIMPServiceMessageDispatcher
  AIMP_SCHEDULER_MSG_EVENT_COUNTDOWN = 'AIMP.Scheduler.MSG.Countdown';
  AIMP_SCHEDULER_MSG_EVENT_STATE = 'AIMP.Scheduler.MSG.State';

type

  { IAIMPSchedulerEvent }

  IAIMPSchedulerEvent = interface(IAIMPPropertyList)
  [SID_IAIMPSchedulerEvent]
  end;

  { IAIMPServiceScheduler }

  IAIMPServiceScheduler = interface
  [SID_IAIMPServiceScheduler]
    function GetEvent(ID: Integer; out Event: IAIMPSchedulerEvent): HRESULT; stdcall;
    function GetNearestEvent(out Event: IAIMPSchedulerEvent): HRESULT; stdcall;
    function GetRemainingTimeBeforeAction(out Value: Double): HRESULT; stdcall;
  end;

implementation

end.
