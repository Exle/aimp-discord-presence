#include <apiRemote.h>

#define AIMPREMOTE_PLAYER_STATE_STOPPED		0
#define AIMPREMOTE_PLAYER_STATE_PAUSED		1
#define AIMPREMOTE_PLAYER_STATE_PLAYING		2

CONST WCHAR AIMPRemoteClassName[] = L"AIMPRemoteApp";

typedef struct AIMPVersion
{
	FLOAT Version;
	INT Build;
} *PAIMPVersion;

typedef struct AIMPTrackInfo
{
	BOOL Active;

	DWORD BitRate;
	DWORD Channels;
	DWORD Duration;
	INT64 FileSize;
	DWORD FileMark;
	DWORD SampleRate;
	DWORD TrackNumber;

	DWORD AlbumLength;
	DWORD ArtistLength;
	DWORD DateLength;
	DWORD FileNameLength;
	DWORD GenreLength;
	DWORD TitleLength;

	CHAR Album[256];
	CHAR Artist[256];
	CHAR Date[256];
	CHAR FileName[256];
	CHAR Genre[256];
	CHAR Title[256];
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

	static VOID AIMPExecuteCommand(INT ACommand);
	static INT AIMPGetPropertyValue(INT APropertyID);
	static BOOL AIMPSetPropertyValue(INT APropertyID, INT AValue);
	static VOID AIMPSetEvents(AIMPEvents *Events);
	static BOOL AIMPSetRemoteHandle(const HWND *Value);
protected:
	static LRESULT CALLBACK WMAIMPNotify(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
private:
	BOOL InfoUpdatePlayerState();
	BOOL InfoUpdateTrackPositionInfo();
	BOOL InfoUpdateVersionInfo();
	BOOL InfoUpdateTrackInfo();

	HWND FAIMPRemoteHandle;
	HWND MyWnd;

	static AIMPRemote *PAIMPRemote;
	AIMPTrackInfo ARTrackInfo;
	AIMPVersion ARVersion;
	AIMPPosition ARPosition;
	AIMPEvents AREvents;
	int ARState;
};
