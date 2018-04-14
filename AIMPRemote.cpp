#include "AIMPRemote.h"

AIMPRemote *AIMPRemote::PAIMPRemote;

AIMPRemote::AIMPRemote()
	: FAIMPRemoteHandle(NULL),
	  MyWnd(NULL)
{
	PAIMPRemote = this;
	ARTrackInfo = { 0 };
	ARVersion = { 0 };
	ARPosition = { 0 };
	AREvents = { 0 };
}

AIMPRemote::~AIMPRemote()
{
	if (FAIMPRemoteHandle)
	{
		DestroyWindow(FAIMPRemoteHandle);
	}

	if (MyWnd)
	{
		DestroyWindow(MyWnd);
	}
}

VOID AIMPRemote::AIMPExecuteCommand(INT ACommand)
{
	if (PAIMPRemote->FAIMPRemoteHandle != NULL)
	{
		SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_COMMAND, ACommand, 0);
	}
}

INT AIMPRemote::AIMPGetPropertyValue(INT APropertyID)
{
	if (PAIMPRemote->FAIMPRemoteHandle != NULL)
	{
		return SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_PROPERTY, APropertyID | AIMP_RA_PROPVALUE_GET, 0);
	}

	return 0;
}

BOOL AIMPRemote::AIMPSetPropertyValue(INT APropertyID, INT AValue)
{
	if (PAIMPRemote->FAIMPRemoteHandle != NULL)
	{
		return SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_PROPERTY, APropertyID | AIMP_RA_PROPVALUE_SET, AValue);
	}

	return false;
}

VOID AIMPRemote::AIMPSetEvents(AIMPEvents *Events)
{
	PAIMPRemote->AREvents = *Events;
}

BOOL AIMPRemote::AIMPSetRemoteHandle(const HWND *Value)
{
	if (PAIMPRemote->FAIMPRemoteHandle == *Value)
	{
		return true;
	}

	if (PAIMPRemote->FAIMPRemoteHandle && PAIMPRemote->MyWnd)
	{
		SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_COMMAND, AIMP_RA_CMD_UNREGISTER_NOTIFY, (LPARAM)PAIMPRemote->MyWnd);
	}

	if (!Value)
	{
		return true;
	}

	if (!PAIMPRemote->MyWnd)
	{
		WNDCLASSEX wx		= {};
		wx.cbSize			= sizeof(WNDCLASSEX);
		wx.lpfnWndProc		= WMAIMPNotify;
		wx.hInstance		= GetModuleHandle(NULL);
		wx.lpszClassName	= AIMPRemoteClassName;
		if (RegisterClassEx(&wx))
		{
			PAIMPRemote->MyWnd = CreateWindowExW(WS_EX_CLIENTEDGE, AIMPRemoteClassName, AIMPRemoteClassName, NULL, NULL, NULL, NULL, NULL, HWND_MESSAGE, NULL, NULL, NULL);
		}
	}

	PAIMPRemote->FAIMPRemoteHandle = *Value;

	PAIMPRemote->InfoUpdateVersionInfo();
	PAIMPRemote->InfoUpdatePlayerState();
	PAIMPRemote->InfoUpdateTrackInfo();
	PAIMPRemote->InfoUpdateTrackPositionInfo();

	if (!PAIMPRemote->MyWnd)
	{
		return false;
	}

	SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_COMMAND, AIMP_RA_CMD_REGISTER_NOTIFY, (LPARAM)PAIMPRemote->MyWnd);

	return true;
}

BOOL AIMPRemote::InfoUpdateTrackInfo()
{
	if (!AREvents.TrackInfo)
	{
		return true;
	}

	HANDLE hFile;
	PAIMPRemoteFileInfo AIMPRemote_TrackInfo;
	LPWSTR offset;
	WCHAR buffer[256];

	hFile = OpenFileMappingA(FILE_MAP_READ, true, AIMPRemoteAccessClass);
	if (!hFile)
	{
		return false;
	}

	AIMPRemote_TrackInfo = (PAIMPRemoteFileInfo)MapViewOfFile(hFile, FILE_MAP_READ, NULL, NULL, AIMPRemoteAccessMapFileSize);
	if (!AIMPRemote_TrackInfo)
	{
		CloseHandle(hFile);
		return false;
	}

	offset = (LPWSTR)((PBYTE)AIMPRemote_TrackInfo + AIMPRemote_TrackInfo->Deprecated1);

	ARTrackInfo = { 0 };

	ARTrackInfo.Active = AIMPRemote_TrackInfo->Active;

	ARTrackInfo.BitRate = AIMPRemote_TrackInfo->BitRate;
	ARTrackInfo.Channels = AIMPRemote_TrackInfo->Channels;
	ARTrackInfo.Duration = AIMPRemote_TrackInfo->Duration;
	ARTrackInfo.FileSize = AIMPRemote_TrackInfo->FileSize;
	ARTrackInfo.FileMark = AIMPRemote_TrackInfo->FileMark;
	ARTrackInfo.SampleRate = AIMPRemote_TrackInfo->SampleRate;
	ARTrackInfo.TrackNumber = AIMPRemote_TrackInfo->TrackNumber;

	ARTrackInfo.AlbumLength = AIMPRemote_TrackInfo->AlbumLength;
	ARTrackInfo.ArtistLength = AIMPRemote_TrackInfo->ArtistLength;
	ARTrackInfo.DateLength = AIMPRemote_TrackInfo->DateLength;
	ARTrackInfo.FileNameLength = AIMPRemote_TrackInfo->FileNameLength;
	ARTrackInfo.GenreLength = AIMPRemote_TrackInfo->GenreLength;
	ARTrackInfo.TitleLength = AIMPRemote_TrackInfo->TitleLength;

	memcpy(buffer, offset, AIMPRemote_TrackInfo->AlbumLength * 2);
	buffer[AIMPRemote_TrackInfo->AlbumLength] = 0;
	WideCharToMultiByte(CP_UTF8, NULL, buffer, -1, ARTrackInfo.Album, AIMPRemote_TrackInfo->AlbumLength * 2, NULL, NULL);

	memcpy(buffer, offset += AIMPRemote_TrackInfo->AlbumLength, AIMPRemote_TrackInfo->ArtistLength * 2);
	buffer[AIMPRemote_TrackInfo->ArtistLength] = 0;
	WideCharToMultiByte(CP_UTF8, NULL, buffer, -1, ARTrackInfo.Artist, AIMPRemote_TrackInfo->ArtistLength * 2, NULL, NULL);

	memcpy(buffer, offset += AIMPRemote_TrackInfo->ArtistLength, AIMPRemote_TrackInfo->DateLength * 2);
	buffer[AIMPRemote_TrackInfo->DateLength] = 0;
	WideCharToMultiByte(CP_UTF8, NULL, buffer, -1, ARTrackInfo.Date, AIMPRemote_TrackInfo->DateLength * 2, NULL, NULL);

	memcpy(buffer, offset += AIMPRemote_TrackInfo->DateLength, AIMPRemote_TrackInfo->FileNameLength * 2);
	buffer[AIMPRemote_TrackInfo->FileNameLength] = 0;
	WideCharToMultiByte(CP_UTF8, NULL, buffer, -1, ARTrackInfo.FileName, AIMPRemote_TrackInfo->FileNameLength * 2, NULL, NULL);

	memcpy(buffer, offset += AIMPRemote_TrackInfo->FileNameLength, AIMPRemote_TrackInfo->GenreLength * 2);
	buffer[AIMPRemote_TrackInfo->GenreLength] = 0;
	WideCharToMultiByte(CP_UTF8, NULL, buffer, -1, ARTrackInfo.Genre, AIMPRemote_TrackInfo->GenreLength * 2, NULL, NULL);

	memcpy(buffer, offset += AIMPRemote_TrackInfo->GenreLength, AIMPRemote_TrackInfo->TitleLength * 2);
	buffer[AIMPRemote_TrackInfo->TitleLength] = 0;
	WideCharToMultiByte(CP_UTF8, NULL, buffer, -1, ARTrackInfo.Title, AIMPRemote_TrackInfo->TitleLength * 2, NULL, NULL);

	UnmapViewOfFile(AIMPRemote_TrackInfo);
	CloseHandle(hFile);

	AREvents.TrackInfo(&ARTrackInfo);

	return true;
}

BOOL AIMPRemote::InfoUpdatePlayerState()
{
	if (!AREvents.State)
	{
		return true;
	}

	int AIMPRemote_State = AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_STATE);
	if (ARState == AIMPRemote_State)
	{
		return false;
	}

	ARState = AIMPRemote_State;

	AREvents.State(ARState);

	return true;
}

BOOL AIMPRemote::InfoUpdateTrackPositionInfo()
{
	if (!AREvents.TrackPosition)
	{
		return true;
	}

	int AIMPRemote_PositionDur = AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_DURATION) / 1000;
	int AIMPRemote_PositionPos = AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_POSITION) / 1000;

	if (ARPosition.Duration == AIMPRemote_PositionDur
	&&	ARPosition.Position == AIMPRemote_PositionPos)
	{
		return false;
	}

	ARPosition.Duration = AIMPRemote_PositionDur;
	ARPosition.Position = AIMPRemote_PositionPos;

	AREvents.TrackPosition(&ARPosition);

	return true;
}

BOOL AIMPRemote::InfoUpdateVersionInfo()
{
	if (!AREvents.Version)
	{
		return true;
	}

	int AIMPRemote_Version = AIMPGetPropertyValue(AIMP_RA_PROPERTY_VERSION);
	if (AIMPRemote_Version != 0)
	{
		ARVersion.Version = static_cast<float>(HIWORD(AIMPRemote_Version)) / 100;
		ARVersion.Build = LOWORD(AIMPRemote_Version);

		AREvents.Version(&ARVersion);

		return true;
	}

	return false;
}

AIMPTrackInfo AIMPRemote::AIMPGetTrackInfo()
{
	return PAIMPRemote->ARTrackInfo;
}

LRESULT CALLBACK AIMPRemote::WMAIMPNotify(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	if (wParam == AIMP_RA_NOTIFY_TRACK_INFO)
	{
		PAIMPRemote->InfoUpdateTrackInfo();
	}
	else if (wParam == AIMP_RA_NOTIFY_PROPERTY)
	{
		if (lParam == AIMP_RA_PROPERTY_PLAYER_STATE)
		{
			PAIMPRemote->InfoUpdatePlayerState();
		}
		else if (lParam == AIMP_RA_PROPERTY_PLAYER_POSITION || lParam == AIMP_RA_PROPERTY_PLAYER_DURATION)
		{
			PAIMPRemote->InfoUpdateTrackPositionInfo();
		}
	}

	return DefWindowProc(hwnd, msg, wParam, lParam);
}