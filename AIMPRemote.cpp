#include "aimpRemote.h"
#include "helper.h"

AIMPRemote* AIMPRemote::PAIMPRemote;

AIMPRemote::AIMPRemote()
	: FAIMPRemoteHandle(NULL),
	MyWnd(NULL)
{
	PAIMPRemote = this;
	ARState = AIMPREMOTE_PLAYER_STATE_STOPPED;
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

void AIMPRemote::AIMPExecuteCommand(int Command)
{
	if (PAIMPRemote->FAIMPRemoteHandle != NULL)
	{
		SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_COMMAND, Command, 0);
	}
}

int AIMPRemote::AIMPGetPropertyValue(int PropertyID)
{
	if (PAIMPRemote->FAIMPRemoteHandle != NULL)
	{
		return SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_PROPERTY, PropertyID | AIMP_RA_PROPVALUE_GET, 0);
	}

	return 0;
}

bool AIMPRemote::AIMPSetPropertyValue(int PropertyID, int AValue)
{
	if (PAIMPRemote->FAIMPRemoteHandle != NULL)
	{
		return SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_PROPERTY, PropertyID | AIMP_RA_PROPVALUE_SET, AValue);
	}

	return false;
}

void AIMPRemote::AIMPSetEvents(AIMPEvents* Events)
{
	PAIMPRemote->AREvents = *Events;
}

bool AIMPRemote::AIMPSetRemoteHandle(const HWND* Value)
{
	if (PAIMPRemote->FAIMPRemoteHandle == *Value)
	{
		return true;
	}

	if (PAIMPRemote->FAIMPRemoteHandle && PAIMPRemote->MyWnd)
	{
		SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_COMMAND, AIMP_RA_CMD_UNREGISTER_NOTIFY, reinterpret_cast<LPARAM>(PAIMPRemote->MyWnd));
	}

	if (!Value)
	{
		return true;
	}

	if (!PAIMPRemote->MyWnd)
	{
		WNDCLASSEX wx = {};
		wx.cbSize = sizeof(WNDCLASSEX);
		wx.lpfnWndProc = WMAIMPNotify;
		wx.hInstance = GetModuleHandle(NULL);
		wx.lpszClassName = AIMPRemoteClassName;
		if (RegisterClassEx(&wx))
		{
			PAIMPRemote->MyWnd = CreateWindowExW(WS_EX_CLIENTEDGE, AIMPRemoteClassName, AIMPRemoteClassName, NULL, NULL, NULL, NULL, NULL, HWND_MESSAGE, NULL, NULL, NULL);
		}
		else return false;
	}

	PAIMPRemote->FAIMPRemoteHandle = *Value;

	SendMessage(PAIMPRemote->FAIMPRemoteHandle, WM_AIMP_COMMAND, AIMP_RA_CMD_REGISTER_NOTIFY, reinterpret_cast<LPARAM>(PAIMPRemote->MyWnd));

	PAIMPRemote->InfoUpdateVersionInfo();
	PAIMPRemote->InfoUpdateTrackInfo();
	PAIMPRemote->InfoUpdatePlayerState();
	PAIMPRemote->InfoUpdateTrackPositionInfo();

	return true;
}

bool AIMPRemote::InfoUpdateTrackInfo()
{
	if (!AREvents.TrackInfo)
	{
		return true;
	}

	HANDLE hFile;
	PAIMPRemoteFileInfo AIMPRemote_TrackInfo;
	LPWSTR offset;

	hFile = OpenFileMappingA(FILE_MAP_READ, true, AIMPRemoteAccessClass);
	if (!hFile)
	{
		return false;
	}

	AIMPRemote_TrackInfo = static_cast<PAIMPRemoteFileInfo>(MapViewOfFile(hFile, FILE_MAP_READ, NULL, NULL, AIMPRemoteAccessMapFileSize));
	if (!AIMPRemote_TrackInfo)
	{
		CloseHandle(hFile);
		return false;
	}

	offset = reinterpret_cast<LPWSTR>(reinterpret_cast<PBYTE>(AIMPRemote_TrackInfo) + AIMPRemote_TrackInfo->Deprecated1);

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

	ARTrackInfo.Album.resize(AIMPRemote_TrackInfo->AlbumLength * 2);
	ARTrackInfo.Artist.resize(AIMPRemote_TrackInfo->ArtistLength * 2);
	ARTrackInfo.Date.resize(AIMPRemote_TrackInfo->DateLength * 2);
	ARTrackInfo.FileName.resize(AIMPRemote_TrackInfo->FileNameLength * 2);
	ARTrackInfo.Genre.resize(AIMPRemote_TrackInfo->GenreLength * 2);
	ARTrackInfo.Title.resize(AIMPRemote_TrackInfo->TitleLength * 2);

	ARTrackInfo.Album = toUTF8.to_bytes(std::wstring (offset, AIMPRemote_TrackInfo->AlbumLength));
	ARTrackInfo.Artist = toUTF8.to_bytes(std::wstring (offset += AIMPRemote_TrackInfo->AlbumLength, AIMPRemote_TrackInfo->ArtistLength));
	ARTrackInfo.Date = toUTF8.to_bytes(std::wstring (offset += AIMPRemote_TrackInfo->ArtistLength, AIMPRemote_TrackInfo->DateLength));
	ARTrackInfo.FileName = toUTF8.to_bytes(std::wstring (offset += AIMPRemote_TrackInfo->DateLength, AIMPRemote_TrackInfo->FileNameLength));
	ARTrackInfo.Genre = toUTF8.to_bytes(std::wstring (offset += AIMPRemote_TrackInfo->FileNameLength, AIMPRemote_TrackInfo->GenreLength));
	ARTrackInfo.Title = toUTF8.to_bytes(std::wstring (offset += AIMPRemote_TrackInfo->GenreLength, AIMPRemote_TrackInfo->TitleLength));

	UnmapViewOfFile(AIMPRemote_TrackInfo);
	CloseHandle(hFile);

	AREvents.TrackInfo(&ARTrackInfo);

	return true;
}

bool AIMPRemote::InfoUpdatePlayerState()
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

bool AIMPRemote::InfoUpdateTrackPositionInfo()
{
	if (!AREvents.TrackPosition)
	{
		return true;
	}

	int AIMPRemote_PositionDur = AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_DURATION) / 1000;
	int AIMPRemote_PositionPos = AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_POSITION) / 1000;

	if (ARPosition.Duration == AIMPRemote_PositionDur
		&& ARPosition.Position == AIMPRemote_PositionPos)
	{
		return false;
	}

	ARPosition.Duration = AIMPRemote_PositionDur;
	ARPosition.Position = AIMPRemote_PositionPos;

	AREvents.TrackPosition(&ARPosition);

	return true;
}

bool AIMPRemote::InfoUpdateVersionInfo()
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
		static int th = 0;
		if (++th >= 2) {
			PAIMPRemote->InfoUpdateTrackInfo();
			th = 0;
		}
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