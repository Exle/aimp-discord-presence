#pragma once

#include <apiPlugin.h>
#include "aimpSettings.h"
#include "IUnknownInterface.h"

#include "aimpRemote.h"
#include "discord_rpc.h"

class Plugin : 
	public IUnknownInterface<IAIMPPlugin>
{
public:
	Plugin(){ AddRef(); }

	~Plugin() { Finalize(); }

	HRESULT WINAPI Initialize(IAIMPCore* Core);
	HRESULT WINAPI Finalize();

	PWCHAR WINAPI InfoGet(INT Index)
	{
		switch (Index)
		{
		case AIMP_PLUGIN_INFO_NAME:					return const_cast<PWCHAR>(AIMPPLUGIN_NAME);
		case AIMP_PLUGIN_INFO_AUTHOR:				return const_cast<PWCHAR>(AIMPPLUGIN_AUTHOR);
		case AIMP_PLUGIN_INFO_SHORT_DESCRIPTION:	return const_cast<PWCHAR>(AIMPPLUGIN_SHORT_DESC);
		case AIMP_PLUGIN_INFO_FULL_DESCRIPTION:		return const_cast<PWCHAR>(AIMPPLUGIN_FULL_DESC);
		}

		return nullptr;
	}

	DWORD WINAPI InfoGetCategories()
	{
		return AIMPPLUGIN_CATEGORY;
	}

	VOID WINAPI SystemNotification(INT NotifyID, IUnknown* Data) {}
public:
	static VOID DiscordReady(const DiscordUser* connectedUser);
public:
	static VOID UpdatePlayerState(INT AIMPRemote_State);
	static VOID UpdateTrackInfo(PAIMPTrackInfo AIMPRemote_TrackInfo);
	static VOID UpdateTrackPosition(PAIMPPosition AIMPRemote_Position);
};