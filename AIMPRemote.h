#pragma once

#include <apiRemote.h>
#include <string>

#define AIMPREMOTE_PLAYER_STATE_STOPPED		0
#define AIMPREMOTE_PLAYER_STATE_PAUSED		1
#define AIMPREMOTE_PLAYER_STATE_PLAYING		2

CONST WCHAR AIMPRemoteClassName[] = L"AIMPRemoteApp";

typedef struct AIMPVersion
{
	float Version;
	int Build;
} *PAIMPVersion;

typedef struct AIMPTrackInfo
{
	int Active;

	unsigned long BitRate;
	unsigned long Channels;
	unsigned long Duration;
	signed long long FileSize;
	unsigned long FileMark;
	unsigned long SampleRate;
	unsigned long TrackNumber;

	unsigned long AlbumLength;
	unsigned long ArtistLength;
	unsigned long DateLength;
	unsigned long FileNameLength;
	unsigned long GenreLength;
	unsigned long TitleLength;

	std::string Album;
	std::string Artist;
	std::string Date;
	std::string FileName;
	std::string Genre;
	std::string Title;
} *PAIMPTrackInfo;

typedef struct AIMPPosition
{
	int Duration;
	int Position;
} *PAIMPPosition;

typedef struct AIMPEvents
{
	void (*State)(int AIMPRemote_State);
	void (*TrackPosition)(PAIMPPosition AIMPRemote_Position);
	void (*Version)(PAIMPVersion AIMPRemote_Version);
	void (*TrackInfo)(PAIMPTrackInfo AIMPRemote_TrackInfo);
} AIMPEvents;

class AIMPRemote
{
public:
	AIMPRemote();
	~AIMPRemote();

	static void AIMPExecuteCommand(int ACommand);
	static int AIMPGetPropertyValue(int APropertyID);
	static bool AIMPSetPropertyValue(int APropertyID, int AValue);
	static void AIMPSetEvents(AIMPEvents* Events);
	static bool AIMPSetRemoteHandle(const HWND* Value);
	static AIMPTrackInfo AIMPGetTrackInfo();
protected:
	static LRESULT CALLBACK WMAIMPNotify(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
private:
	bool InfoUpdatePlayerState();
	bool InfoUpdateTrackPositionInfo();
	bool InfoUpdateVersionInfo();
	bool InfoUpdateTrackInfo();

	HWND FAIMPRemoteHandle;
	HWND MyWnd;

	static AIMPRemote* PAIMPRemote;
	AIMPTrackInfo ARTrackInfo = { 0 };
	AIMPVersion ARVersion = { 0 };
	AIMPPosition ARPosition = { 0 };
	AIMPEvents AREvents = { 0 };
	int ARState = AIMPREMOTE_PLAYER_STATE_STOPPED;
};