#include <cmath>
#include "AIMPRemote.h"
#include <process.h>

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
	AIMPSetRemoteHandle(NULL);

	if (MyWnd != NULL)
	{
		DestroyWindow(MyWnd);
		MyWnd = NULL;
	}

	delete PAIMPRemote;
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

BOOL AIMPRemote::AIMPSetRemoteHandle(const HWND Value)
{
	if (PAIMPRemote->FAIMPRemoteHandle != Value)
	{
		if (PAIMPRemote->FAIMPRemoteHandle != NULL)
		{
			SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_COMMAND, AIMP_RA_CMD_UNREGISTER_NOTIFY, (LPARAM)PAIMPRemote->MyWnd);
			PAIMPRemote->FAIMPRemoteHandle = NULL;
		}

		if (Value != NULL)
		{
			if (PAIMPRemote->MyWnd == NULL)
			{
				WNDCLASSEX wx		= {};
				wx.cbSize			= sizeof(WNDCLASSEX);
				wx.lpfnWndProc		= WMAIMPNotify;
				wx.hInstance		= GetModuleHandle(NULL);
				wx.lpszClassName	= AIMPRemoteClassName;
				if (RegisterClassEx(&wx))
				{
					PAIMPRemote->MyWnd = CreateWindowEx(WS_EX_CLIENTEDGE, AIMPRemoteClassName, AIMPRemoteClassName, NULL, NULL, NULL, NULL, NULL, HWND_MESSAGE, NULL, NULL, NULL);
				}
			}

			if (PAIMPRemote->MyWnd == NULL)
			{
				return false;
			}

			PAIMPRemote->FAIMPRemoteHandle = Value;

			PAIMPRemote->InfoUpdateVersionInfo();
			PAIMPRemote->InfoUpdatePlayerState();
			PAIMPRemote->InfoUpdateTrackInfo();
			PAIMPRemote->InfoUpdateTrackPositionInfo();

			SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_COMMAND, AIMP_RA_CMD_REGISTER_NOTIFY, (LPARAM)PAIMPRemote->MyWnd);

			_beginthread(ThreadStart, 0, NULL);
		}
	}

	return true;
}

VOID AIMPRemote::ThreadStart(PVOID)
{
	MSG msg;
	do
	{
		while (PeekMessage(&msg, 0, 0, 0, PM_REMOVE))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
			Sleep(1000L);
		}
	}
	while (WaitForSingleObject(NULL, 75L) == WAIT_TIMEOUT);

	_endthread();
}

BOOL AIMPRemote::InfoUpdateTrackInfo()
{
	HANDLE hFile;
	PAIMPRemoteFileInfo AIMPRemote_TrackInfo;
	LPWSTR offset;
	WCHAR buffer[256];

	hFile = OpenFileMappingA(FILE_MAP_READ, true, AIMPRemoteAccessClass);
	if (hFile == NULL)
	{
		return false;
	}

	AIMPRemote_TrackInfo = (PAIMPRemoteFileInfo)MapViewOfFile(hFile, FILE_MAP_READ, NULL, NULL, AIMPRemoteAccessMapFileSize);
	if (AIMPRemote_TrackInfo == NULL)
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

	if (AREvents.TrackInfo != NULL)
	{
		AREvents.TrackInfo(&ARTrackInfo);
	}

	return true;
}

BOOL AIMPRemote::InfoUpdatePlayerState()
{
	int AIMPRemote_State = AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_STATE);
	if (ARState == AIMPRemote_State)
	{
		return false;
	}

	ARState = AIMPRemote_State;

	if (AREvents.State != NULL)
	{
		AREvents.State(ARState);
	}

	return true;
}

BOOL AIMPRemote::InfoUpdateTrackPositionInfo()
{
	int AIMPRemote_PositionDur = (int)round(AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_DURATION) / 1000);
	int AIMPRemote_PositionPos = (int)round(AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_POSITION) / 1000);

	if (ARPosition.Duration == AIMPRemote_PositionDur
		&& ARPosition.Position == AIMPRemote_PositionPos)
	{
		return false;
	}

	ARPosition.Duration = AIMPRemote_PositionDur;
	ARPosition.Position = AIMPRemote_PositionPos;

	if (AREvents.TrackPosition != NULL)
	{
		AREvents.TrackPosition(&ARPosition);
	}

	return true;
}

BOOL AIMPRemote::InfoUpdateVersionInfo()
{
	int AIMPRemote_Version = AIMPGetPropertyValue(AIMP_RA_PROPERTY_VERSION);
	if (AIMPRemote_Version != 0)
	{
		ARVersion.Version = static_cast<float>(HIWORD(AIMPRemote_Version)) / 100;
		ARVersion.Build = LOWORD(AIMPRemote_Version);

		if (AREvents.Version != NULL)
		{
			AREvents.Version(&ARVersion);
		}

		return true;
	}

	return false;
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