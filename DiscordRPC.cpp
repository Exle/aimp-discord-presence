#include "DiscordRPC.h"

DiscordRPC::DiscordRPC()
	: b_init(false)
{
	rich = { 0 };
}

DiscordRPC::~DiscordRPC()
{
	ClearPresence();
	Shutdown();
}

VOID DiscordRPC::Initialise(const char *AppId)
{
	if (b_init == false)
	{
		Discord_Initialize(AppId, {}, 1, NULL);
		b_init = true;
	}
}

VOID DiscordRPC::Shutdown()
{
	if (b_init == true)
	{
		Discord_Shutdown();
		b_init = false;
	}
}

BOOL DiscordRPC::Update(DiscordRichPresence *richPresence)
{
	if (b_init == true)
	{
		rich.state			= richPresence->state;
		rich.details		= richPresence->details;
		rich.startTimestamp	= richPresence->startTimestamp;
		rich.endTimestamp	= richPresence->endTimestamp;
		rich.largeImageKey	= richPresence->largeImageKey;
		rich.largeImageText	= richPresence->largeImageText;
		rich.smallImageKey	= richPresence->smallImageKey;
		rich.smallImageText	= richPresence->smallImageText;
		rich.partyId		= richPresence->partyId;
		rich.partySize		= richPresence->partySize;
		rich.partyMax		= richPresence->partyMax;
		rich.matchSecret	= richPresence->matchSecret;
		rich.joinSecret		= richPresence->joinSecret;
		rich.spectateSecret	= richPresence->spectateSecret;
		rich.instance		= richPresence->instance;

		Discord_UpdatePresence(&rich);
		return true;
	}

	return false;
}

BOOL DiscordRPC::FastUpdate()
{
	if (b_init == true)
	{
		Discord_UpdatePresence(&rich);
		return true;
	}

	return false;
}

VOID DiscordRPC::UpdateRP(DiscordRichPresence *richPresence)
{
	rich.state			= richPresence->state;
	rich.details		= richPresence->details;
	rich.startTimestamp	= richPresence->startTimestamp;
	rich.endTimestamp	= richPresence->endTimestamp;
	rich.largeImageKey	= richPresence->largeImageKey;
	rich.largeImageText	= richPresence->largeImageText;
	rich.smallImageKey	= richPresence->smallImageKey;
	rich.smallImageText	= richPresence->smallImageText;
	rich.partyId		= richPresence->partyId;
	rich.partySize		= richPresence->partySize;
	rich.partyMax		= richPresence->partyMax;
	rich.matchSecret	= richPresence->matchSecret;
	rich.joinSecret		= richPresence->joinSecret;
	rich.spectateSecret	= richPresence->spectateSecret;
	rich.instance		= richPresence->instance;
}

VOID DiscordRPC::ClearPresence()
{
	Discord_ClearPresence();
}