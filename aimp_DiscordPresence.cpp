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

	// Discord init
	DiscordEventHandlers handlers = { 0 };
	handlers.ready = this->DiscordReady;

	Discord_Initialize(DISCORD_APPID, &handlers, 1, NULL);
	discordPresence.smallImageKey = "aimp";
	discordPresence.smallImageText = "AIMP";
	discordPresence.largeImageKey = "defaultcover";
	Discord_UpdatePresence(&discordPresence);

	aimpRemote = new AIMPRemote();

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
	{
		std::size_t length = AIMPRemote_TrackInfo->Artist.length();
		if (length >= 128) AIMPRemote_TrackInfo->Artist.replace(length - 3, length, "...");
		else if (length == 1) AIMPRemote_TrackInfo->Artist.append(" ");
	}
	{
		std::size_t length = AIMPRemote_TrackInfo->Title.length();
		if (length >= 128) AIMPRemote_TrackInfo->Title.replace(length - 3, length, "...");
		else if (length == 1) AIMPRemote_TrackInfo->Title.append(" ");
	}
	{
		std::size_t length = AIMPRemote_TrackInfo->Album.length();
		if (length >= 128) AIMPRemote_TrackInfo->Album.replace(length - 3, length, "...");
		else if (length == 1) AIMPRemote_TrackInfo->Album.append(" ");
	}

	discordPresence.details = AIMPRemote_TrackInfo->Title.c_str();
	discordPresence.state = AIMPRemote_TrackInfo->Artist.c_str();
	discordPresence.largeImageText = AIMPRemote_TrackInfo->Album.c_str();

	discordPresence.startTimestamp = 0;
	discordPresence.endTimestamp = 0;

	if (aimpRemote->AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_STATE) == AIMPREMOTE_PLAYER_STATE_PLAYING)
	{
		int Duration =
			aimpRemote->AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_DURATION) / 1000;
		if (Duration != 0)
		{
			discordPresence.startTimestamp = time(0);
			discordPresence.endTimestamp =
				discordPresence.startTimestamp +
				Duration -
				aimpRemote->AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_POSITION) / 1000;
		}
		discordPresence.smallImageKey = "aimp_play";
	}
	else
	{
		discordPresence.smallImageKey = "aimp_pause";
	}

	if (AIMPRemote_TrackInfo->FileName.compare(0, 7, "http://") == 0 || AIMPRemote_TrackInfo->FileName.compare(0, 8, "https://") == 0)
	{
		if (!AIMPRemote_TrackInfo->Album[0])
		{
			discordPresence.largeImageText = "Listening to URL";
		}

		discordPresence.largeImageKey = "aimp_radio";
	}
	else discordPresence.largeImageKey ="defaultcover";

	Discord_UpdatePresence(&discordPresence);
}

VOID Plugin::UpdateTrackPosition(PAIMPPosition AIMPRemote_Position)
{
	Discord_RunCallbacks();
}