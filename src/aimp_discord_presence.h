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

#include "aimp_implements.h"
#include "aimp_plugin.h"

class AimpDiscordPresence :
  public Aimp::Implements<Aimp::Plugin, Aimp::ExternalSettingsDialog> {
 public:
  PWCHAR GetInfo(int index) override;
  DWORD GetCategory() override;
  bool Load() override;
  bool Unload() override;
  void Notification(int id, IUnknown* data) override;
  void ShowSettings(HWND parent_wnd) override;

 public:  // Events
  void OnStreamStart( DWORD message, int param1 = NULL, void* param2 = nullptr, HRESULT* result = nullptr );
  void OnStreamEnd( DWORD message, int param1 = NULL, void* param2 = nullptr, HRESULT* result = nullptr );
  void OnPlayerState( DWORD message, int param1 = NULL, void* param2 = nullptr, HRESULT* result = nullptr );
  void OnPropertyValue( DWORD message, int param1 = NULL, void* param2 = nullptr, HRESULT* result = nullptr );

 private: // cofiguration data
  struct Properties {
    unsigned long long application_id = 429559336982020107LL;
    bool timestamp = false;
  };
 public:
  Properties settings;
};

#endif  // AIMPDISCORDPRESENCE_SRC_AIMP_DISCORD_PRESENCE_H_
