#pragma once

#include <string>
#include <locale>
#include <codecvt>

static std::wstring_convert<std::codecvt_utf8<wchar_t>> toUTF8;