#define _CRT_SECURE_NO_WARNINGS

#include "aimpPlugin.h"
#include <time.h>

AIMPRemote* aimpRemote;
DiscordRichPresence discordPresence;

HRESULT __declspec(dllexport) WINAPI AIMPPluginGetHeader(IAIMPPlugin** Header)
{
	*Header = new Plugin();
	return S_OK;
}

HRESULT WINAPI Plugin::Initialize(IAIMPCore* Core)
{
	HWND AIMPRemoteHandle = FindWindowA(AIMPRemoteAccessClass, AIMPRemoteAccessClass);
	if (AIMPRemoteHandle == NULL)
	{
		return E_ABORT;
	}

	aimpRemote = new AIMPRemote();

	DiscordEventHandlers handlers = { 0 };
	handlers.ready = this->DiscordReady;

	Discord_Initialize(DISCORD_APPID, &handlers, 1, NULL);

	discordPresence.largeImageKey = "defaultcover";
	discordPresence.smallImageKey = "aimp";
	discordPresence.smallImageText = "AIMP";
	discordPresence.instance = false;

	Discord_UpdatePresence(&discordPresence);

	AIMPEvents Events = { 0 };
	Events.State = this->UpdatePlayerState;
	Events.TrackInfo = this->UpdateTrackInfo;
	Events.TrackPosition = this->UpdateTrackPosition;

	aimpRemote->AIMPSetEvents(&Events);
	aimpRemote->AIMPSetRemoteHandle(&AIMPRemoteHandle);

	return S_OK;
}

HRESULT WINAPI Plugin::Finalize()
{
	Discord_Shutdown();

	if (aimpRemote)
	{
		delete aimpRemote;
	}

	return S_OK;
}

VOID Plugin::DiscordReady(const DiscordUser* connectedUser)
{
	UpdateTrackInfo(&aimpRemote->AIMPGetTrackInfo());
}

VOID Plugin::UpdatePlayerState(INT AIMPRemote_State)
{
	if (AIMPRemote_State != AIMPREMOTE_PLAYER_STATE_STOPPED)
	{
		UpdateTrackInfo(&aimpRemote->AIMPGetTrackInfo());
	}
	else
	{
		Discord_ClearPresence();
	}
}

VOID Plugin::UpdateTrackInfo(PAIMPTrackInfo AIMPRemote_TrackInfo)
{
	if (strlen(AIMPRemote_TrackInfo->Artist) >= 128) strcpy(&AIMPRemote_TrackInfo->Artist[125], "...");
	else if (strlen(AIMPRemote_TrackInfo->Artist) == 1) strcat(AIMPRemote_TrackInfo->Artist, " ");

	if (strlen(AIMPRemote_TrackInfo->Title) >= 128) strcpy(&AIMPRemote_TrackInfo->Title[125], "...");
	else if (strlen(AIMPRemote_TrackInfo->Title) == 1) strcat(AIMPRemote_TrackInfo->Title, " ");

	if (strlen(AIMPRemote_TrackInfo->Album) >= 128) strcpy(&AIMPRemote_TrackInfo->Album[125], "...");
	else if (strlen(AIMPRemote_TrackInfo->Album) == 1) strcat(AIMPRemote_TrackInfo->Album, " ");

	discordPresence.state = AIMPRemote_TrackInfo->Artist;
	discordPresence.details = AIMPRemote_TrackInfo->Title;
	discordPresence.largeImageText = AIMPRemote_TrackInfo->Album;

	discordPresence.startTimestamp = 0;
	discordPresence.endTimestamp = 0;

	int state = aimpRemote->AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_STATE);

	if (state == AIMPREMOTE_PLAYER_STATE_PLAYING)
	{
		int Duration = aimpRemote->AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_DURATION) / 1000;
		int Position = aimpRemote->AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_POSITION) / 1000;
		if (Duration != 0)
		{
			discordPresence.startTimestamp = time(0);
			discordPresence.endTimestamp = discordPresence.startTimestamp + Duration - Position;
		}
		discordPresence.smallImageKey = "aimp_play";
	}
	else
	{
		discordPresence.smallImageKey = "aimp_pause";
	}

	if (strncmp(AIMPRemote_TrackInfo->FileName, "http://", 7) == 0 || strncmp(AIMPRemote_TrackInfo->FileName, "https://", 8) == 0)
	{
		if (!AIMPRemote_TrackInfo->Album[0])
		{
			discordPresence.largeImageText = "Listening to URL";
		}

		discordPresence.largeImageKey = "aimp_radio";
	}
	else discordPresence.largeImageKey = "defaultcover";

	Discord_UpdatePresence(&discordPresence);
}

VOID Plugin::UpdateTrackPosition(PAIMPPosition AIMPRemote_Position)
{
	Discord_RunCallbacks();
}