//  Copyright (c) 2024 Exle
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.

#include "aimp_discord_presence.h"

#include <chrono>

#include "aimp_core.h"
#include "aimp_player.h"
#include "aimp_messages.h"

#include "utils.h"

#include "discord_rpc.h"
DiscordRichPresence discordPresence;

__declspec(dllexport) HRESULT WINAPI AIMPPluginGetHeader(void** Header) {
  *Header = new AimpDiscordPresence();
  return S_OK;
}

PWCHAR AimpDiscordPresence::GetInfo(int index) {
  switch (index) {
  case Info::kName:
    return L"Discord Presence";
  case Info::kAuthor:
    return L"Exle";
  case Info::Description::kShort:
    return L"Update your discord status with the rich presence";
  }

  return nullptr;
}

DWORD AimpDiscordPresence::GetCategory() {
  return Category::kAddons;
}

bool AimpDiscordPresence::Load() {
  // plugin only for player
  if (!Aimp::Player::Service::Player()) {
    return false;
  }

  Aimp::Service::Config config;
  settings.application_id = config.Get<INT64>(L"DiscordPresence\\ApplicationID", settings.application_id);
  settings.timestamp      = config.Get<int>(L"DiscordPresence\\Timestamp", settings.timestamp);

  Aimp::Messages::Service::MessageDispatcher message_dispatcher;
  message_dispatcher.Hook(AIMP_MSG_EVENT_STREAM_START,
    [&](DWORD message, int param1, void* param2, HRESULT* result) {
      OnStreamStart(message, param1, param2, result);
    }
  );
  message_dispatcher.Hook(AIMP_MSG_EVENT_STREAM_END,
    [&](DWORD message, int param1, void* param2, HRESULT* result ) {
      OnStreamEnd(message, param1, param2, result);
    }
  );
  message_dispatcher.Hook(AIMP_MSG_EVENT_PLAYER_STATE,
    [&](DWORD message, int param1, void* param2, HRESULT* result) {
      OnPlayerState(message, param1, param2, result);
    }
  );
  message_dispatcher.Hook(AIMP_MSG_EVENT_PROPERTY_VALUE,
    [&](DWORD message, int param1, void* param2, HRESULT* result) {
      OnPropertyValue(message, param1, param2, result);
    }
  );

  Discord_Initialize(std::to_string(settings.application_id).c_str(), nullptr, 1, nullptr);

  return true;
}

bool AimpDiscordPresence::Unload() {
  Aimp::Messages::Service::MessageDispatcher().UnhookAll();

  Discord_Shutdown();

  return true;
}

void AimpDiscordPresence::Notification(int, IUnknown*) {}

void AimpDiscordPresence::ShowSettings(HWND) {}

void AimpDiscordPresence::OnStreamStart(DWORD, int, void*, HRESULT*) {
  static std::string artist;
  static std::string title;
  static std::string album;
  static std::string album_art;

  Aimp::FileManager::FileInfo fileinfo = Aimp::Player::Service::Player().GetInfo();

  artist = Utils::Resize(Utils::ToString(Utils::Crop(
        fileinfo.Get<std::wstring>(Aimp::FileManager::FileInfo::Props::kArtist), 128)));
  title = Utils::Resize(Utils::ToString(Utils::Crop(
        fileinfo.Get<std::wstring>(Aimp::FileManager::FileInfo::Props::kTitle), 128)));
  album = Utils::Resize(Utils::ToString(Utils::Crop(
        fileinfo.Get<std::wstring>(Aimp::FileManager::FileInfo::Props::kAlbum), 128)));
  album_art = "https://a-n.vercel.app/" + Utils::UriEncode(artist) + "/" + Utils::UriEncode(album);

  discordPresence.state = artist.c_str();
  discordPresence.details = title.c_str();
  discordPresence.largeImageText = album.c_str();
  discordPresence.largeImageKey = album_art.c_str();
  Discord_UpdatePresence(&discordPresence);
}

void AimpDiscordPresence::OnStreamEnd(DWORD, int param1, void*, HRESULT*) {
  if (param1 == 0 || param1 == AIMP_MES_END_OF_PLAYLIST) {
    Discord_ClearPresence();
  }
}

void AimpDiscordPresence::OnPlayerState(DWORD, int param1, void*, HRESULT*) {
  if (param1 == 1) {
    Discord_ClearPresence();
  } else if (param1 == 2) {
    OnPropertyValue(AIMP_MSG_EVENT_PROPERTY_VALUE, AIMP_MSG_PROPERTY_PLAYER_POSITION);
  }
}

void AimpDiscordPresence::OnPropertyValue(DWORD, int param1, void*, HRESULT*) {
  if (param1 == AIMP_MSG_PROPERTY_PLAYER_POSITION) {
    Aimp::Player::Service::Player player;
    if (player.State() == 2) {
      int position = static_cast<int>(round(player.Position()));

      discordPresence.startTimestamp = std::chrono::duration_cast<std::chrono::seconds>(
        std::chrono::system_clock::now().time_since_epoch()
      ).count();

      if (settings.timestamp) {
        int duration = static_cast<int>(round(player.Duration()));
        discordPresence.endTimestamp = discordPresence.startTimestamp + duration - position;
      } else {
        discordPresence.startTimestamp -= position;
      }

      Discord_UpdatePresence(&discordPresence);
    }
  }

  Discord_RunCallbacks();
}
