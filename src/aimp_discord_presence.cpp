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

#include <string>
#include <chrono>

#include "aimp_core.h"
#include "aimp_filemanager.h"
#include "aimp_messages.h"
#include "aimp_player.h"
#include "utils.h"

#include "discord_rpc.h"

DiscordRichPresence discord_presence;

__declspec(dllexport) HRESULT WINAPI AIMPPluginGetHeader(void** Header) {
  *Header = new AimpDiscordPresence();
  return S_OK;
}

LPWSTR AimpDiscordPresence::GetInfo(int index) {
  switch (index) {
    case Info::kName:
      return const_cast<LPWSTR>(L"Discord Presence");
    case Info::kAuthor:
      return const_cast<LPWSTR>(L"Exle");
    case Info::Description::kShort:
      return const_cast<LPWSTR>(L"Update your discord status with the rich presence");
  }

  return nullptr;
}

DWORD AimpDiscordPresence::GetCategory() {
  return Category::kAddons;
}

bool AimpDiscordPresence::Load() {
  if (!Aimp::Player::Service::Player()) {
    return false;
  }

  LoadConfig();
  InitializeMessageDispatcher();

  Discord_Initialize(std::to_string(settings.application_id).c_str(), nullptr, 0, nullptr);

  return true;
}

void AimpDiscordPresence::LoadConfig() {
  Aimp::Core::Service::Config config;

  LoadConfigValue(config, L"DiscordPresence\\ApplicationID", &settings.application_id);
  LoadConfigValue(config, L"DiscordPresence\\Timestamp", &settings.timestamp);
  LoadConfigValue(config, L"DiscordPresence\\UseAlbumArt", &settings.use_albumart);
  LoadConfigValue(config, L"DiscordPresence\\State.UsePlay", &settings.status.use_play);
  LoadConfigValue(config, L"DiscordPresence\\State.PlayImage", &settings.status.play_image);
  LoadConfigValue(config, L"DiscordPresence\\State.UsePause", &settings.status.use_pause);
  LoadConfigValue(config, L"DiscordPresence\\State.PauseImage", &settings.status.pause_image);
  LoadConfigValue(config, L"DiscordPresence\\State.UseRadio", &settings.status.use_radio);
  LoadConfigValue(config, L"DiscordPresence\\State.RadioImage", &settings.status.radio_image);
}

void AimpDiscordPresence::InitializeMessageDispatcher() {
  Aimp::Messages::Service::MessageDispatcher message_dispatcher;

  message_dispatcher.Hook(Aimp::Messages::Events::kPlayerState,
                          [&](DWORD message, int param1, void*, HRESULT*) {
                            OnPlayerState(message, param1);
                          });

  message_dispatcher.Hook(Aimp::Messages::Events::Stream::Start::kSubtrack,
                          [&](DWORD, int, void*, HRESULT*) {
                            OnStreamStartSubtrack();
                          });

  message_dispatcher.Hook(Aimp::Messages::Events::kPropertyValue,
                          [&](DWORD message, int param1, void*, HRESULT*) {
                            OnPropertyValue(message, param1);
                          });
}

template<typename T>
void AimpDiscordPresence::LoadConfigValue(Aimp::Core::Service::Config config, const std::wstring& key, T value) {
  if (!config.Get(key, value)) {
    config.Set(key, *value);
  }
}

bool AimpDiscordPresence::Unload() {
  Aimp::Messages::Service::MessageDispatcher().UnhookAll();

  Discord_ClearPresence();
  Discord_Shutdown();

  return true;
}

void AimpDiscordPresence::Notification(int, IUnknown*) {}
void AimpDiscordPresence::ShowSettings(HWND) {}

void AimpDiscordPresence::OnPlayerState(DWORD, int param1) {
  if (param1 == 0 || param1 == 1 && !settings.status.use_pause) {
    return Discord_ClearPresence();
  }

  if (param1 == 1) {
    discord_presence.startTimestamp = 0;
    discord_presence.endTimestamp = 0;
  } else {
    SetTimestamp();
  }

  SetInfo();
  SetSmallImage(param1);
  Discord_UpdatePresence(&discord_presence);
}

void AimpDiscordPresence::OnStreamStartSubtrack() {
  SetInfo();
  SetSmallImage();
  SetTimestamp();

  Discord_UpdatePresence(&discord_presence);
}

void AimpDiscordPresence::OnPropertyValue(DWORD, int param1) {
  if (param1 == Aimp::Messages::Properties::Player::kPosition) {
    Aimp::Player::Service::Player player;
    if (player.State() == 2) {
      SetTimestamp();

      Discord_UpdatePresence(&discord_presence);
    }
  }

  Discord_RunCallbacks();
}

void AimpDiscordPresence::SetInfo() {
  static std::string artist;
  static std::string title;
  static std::string album;
  static std::string album_art;

  discord_presence.state = nullptr;
  discord_presence.details = nullptr;
  discord_presence.largeImageKey = "aimp";
  discord_presence.largeImageText = nullptr;

  Aimp::Player::Service::Player player;
  Aimp::FileManager::FileInfo fileinfo = player.GetInfo();

  std::wstring wtitle = fileinfo.Get<std::wstring>(Aimp::FileManager::FileInfo::Props::kTitle);
  std::wstring wartist = fileinfo.Get<std::wstring>(Aimp::FileManager::FileInfo::Props::kArtist);
  std::wstring walbum = fileinfo.Get<std::wstring>(Aimp::FileManager::FileInfo::Props::kAlbum);

  if (!wtitle.empty()) {
    title = Utils::Resize(Utils::ToString(Utils::Crop(wtitle, 128)));
    discord_presence.state = title.c_str();
  }
  if (!wartist.empty()) {
    artist = Utils::Resize(Utils::ToString(Utils::Crop(wartist, 128)));
    discord_presence.details = artist.c_str();
  }
  if (!walbum.empty()) {
    album = Utils::Resize(Utils::ToString(Utils::Crop(walbum, 128)));
    discord_presence.largeImageText = album.c_str();

    if (!wartist.empty() && settings.use_albumart) {
      album_art = Utils::Crop("https://a-n.vercel.app/" + Utils::UriEncode(artist) +
                                                    "/" + Utils::UriEncode(album), 256);
      discord_presence.largeImageKey = album_art.c_str();
    }
  }
}

void AimpDiscordPresence::SetSmallImage(int state) {
  static std::string small_image;

  small_image.clear();
  discord_presence.smallImageText = nullptr;
  discord_presence.smallImageKey = nullptr;

  Aimp::Player::Service::Player player;
  Aimp::FileManager::FileInfo fileinfo = player.GetInfo();

  if (state == -1) {
    state = player.State();
  }

  std::wstring url = fileinfo.Get<std::wstring>(Aimp::FileManager::FileInfo::Props::kFileName);
  bool is_url = (url.compare(0, 7, L"http://") == 0 || url.compare(0, 8, L"https://") == 0);

  if (state == 1) {
    if (settings.status.use_pause && !settings.status.pause_image.empty()) {
      small_image = Utils::ToString(settings.status.pause_image);
    }
  } else if (state == 2) {
    if (is_url && settings.status.use_radio && !settings.status.radio_image.empty()) {
      small_image = Utils::ToString(settings.status.radio_image);
      discord_presence.smallImageText = "Listening to URL";
    } else if (settings.status.use_play && !settings.status.play_image.empty()) {
      small_image = Utils::ToString(settings.status.play_image);
    }
  }

  discord_presence.smallImageKey = small_image.c_str();
}

void AimpDiscordPresence::SetTimestamp() {
  discord_presence.startTimestamp = 0;
  discord_presence.endTimestamp = 0;

  Aimp::Player::Service::Player player;
  int position = static_cast<int>(round(player.Position()));

  discord_presence.startTimestamp = std::chrono::duration_cast<std::chrono::seconds>(
                                    std::chrono::system_clock::now().time_since_epoch())
                                    .count();

  std::wstring url = player.GetInfo().Get<std::wstring>(Aimp::FileManager::FileInfo::Props::kFileName);
  bool is_url = (url.compare(0, 7, L"http://") == 0 || url.compare(0, 8, L"https://") == 0);

  if (settings.timestamp && !is_url) {
    int duration = static_cast<int>(round(player.Duration()));
    discord_presence.endTimestamp = discord_presence.startTimestamp + duration - position;
  } else {
    discord_presence.startTimestamp -= position;
  }
}
