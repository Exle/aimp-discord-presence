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

#ifndef AIMPDISCORDPRESENCE_SRC_AIMP_DISCORD_PRESENCE_H_
#define AIMPDISCORDPRESENCE_SRC_AIMP_DISCORD_PRESENCE_H_

#include <string>

#include "aimp_implements.h"
#include "aimp_plugin.h"
#include "aimp_core.h"

class AimpDiscordPresence :
  public Aimp::Implements<Aimp::Plugin, Aimp::ExternalSettingsDialog> {
 public:
  PWCHAR GetInfo(int index) override;
  DWORD GetCategory() override;
  bool Load() override;
  bool Unload() override;
  void Notification(int id, IUnknown* data) override;
  void ShowSettings(HWND parent_wnd) override;

 private:
  void OnStreamStartSubtrack();
  void OnPlayerState(DWORD message, int param1 = NULL);
  void OnPropertyValue(DWORD message, int param1 = NULL);

 private:
  void InitializeMessageDispatcher();

 private:
  void SetInfo();
  void SetSmallImage(int state = -1);
  void SetTimestamp();

 private:
  void LoadConfig();

  template <typename T>
  void LoadConfigValue(Aimp::Core::Service::Config config, const std::wstring& key, T value);

  struct Properties {
    int64_t application_id = 429559336982020107LL;
    bool timestamp = false;
    bool use_albumart = true;
    struct State {
      bool use_play = false;
      std::wstring play_image = L"aimp_play";
      bool use_pause = false;
      std::wstring pause_image = L"aimp_pause";
      bool use_radio = true;
      std::wstring radio_image = L"https://raw.githubusercontent.com/Exle/aimp-discord-presence/main/"
                           L".github/aimp_icons/animated/aimp_radio.gif";
    };
    State status;
  };

  Properties settings;
};

#endif  // AIMPDISCORDPRESENCE_SRC_AIMP_DISCORD_PRESENCE_H_
