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

#ifndef AIMPDISCORDPRESENCE_SRC_UTILS_H_
#define AIMPDISCORDPRESENCE_SRC_UTILS_H_

#include <string>
#include <type_traits>
#include <iomanip>
#include <sstream>
#include <cwctype>

struct Utils {
  template <typename T>
  [[nodiscard]] static T Crop(const T& input, size_t maxlength) {
    if (input.size() > maxlength) {
      return input.substr(0, maxlength);
    }
    return input;
  }

  [[nodiscard]] static std::string ToString(const std::wstring& input) {
    int count = WideCharToMultiByte(CP_UTF8, 0, input.c_str(), static_cast<int>(input.length()), NULL, 0, NULL, NULL);
    std::string tmp(count, 0);
    WideCharToMultiByte(CP_UTF8, 0, input.c_str(), -1, &tmp[0], count, NULL, NULL);
    return tmp;
  }

  [[nodiscard]] static std::wstring ToWString(const std::string& input) {
    int count = MultiByteToWideChar(CP_UTF8, 0, input.c_str(), static_cast<int>(input.length()), NULL, 0);
    std::wstring tmp(count, L'\0');
    MultiByteToWideChar(CP_UTF8, 0, input.c_str(), -1, &tmp[0], count);
    return tmp;
  }

  template <typename T>
  [[nodiscard]] static T Resize(const T& input) {
    if (input.size() < 4) {
      return input + T(4 - input.size(), ' ');
    }
    return input;
  }

  template<typename T>
  [[nodiscard]] static T UriEncode(const T& input) {
    using CharT = typename T::value_type;
    std::basic_ostringstream<CharT> encoded;

    for (CharT c : input) {
      if (is_safe_alnum(c) || c == static_cast<CharT>('-') || c == static_cast<CharT>('_') ||
                              c == static_cast<CharT>('.') || c == static_cast<CharT>('~')) {
        encoded << c;
      } else {
        encoded << static_cast<CharT>('%') << std::setw(2) << std::setfill(static_cast<CharT>('0')) << std::uppercase
                << std::hex << static_cast<int>(static_cast<unsigned char>(c));
      }
    }

    return encoded.str();
  }

  template<typename T>
  [[nodiscard]] static T UriDecode(const T& input) {
    using CharT = typename T::value_type;
    std::basic_ostringstream<CharT> decoded;

    for (size_t i = 0; i < input.length(); ++i) {
      if (input[i] == static_cast<CharT>('%') && i + 2 < input.length() && is_safe_xdigit(input[i + 1])
                                                                        && is_safe_xdigit(input[i + 2])) {
        std::basic_istringstream<CharT> hexStr(input.substr(i + 1, 2));
        int hexValue;
        hexStr >> std::hex >> hexValue;
        decoded << static_cast<CharT>(hexValue);
        i += 2;
      } else if (input[i] == static_cast<CharT>('+')) {
        decoded << static_cast<CharT>(' ');
      } else {
        decoded << input[i];
      }
    }

    return decoded.str();
  }

 private:
  template<typename CharT>
  [[nodiscard]] static bool is_safe_alnum(CharT c) {
    if constexpr (std::is_same_v<CharT, char>) {
      return std::isalnum(static_cast<unsigned char>(c));
    } else {
      return std::iswalnum(c);
    }
  }

  template<typename CharT>
  [[nodiscard]] static bool is_safe_xdigit(CharT c) {
    if constexpr (std::is_same_v<CharT, char>) {
      return std::isxdigit(static_cast<unsigned char>(c));
    } else {
      return std::iswxdigit(c);
    }
  }
};

#endif  // AIMPDISCORDPRESENCE_SRC_UTILS_H_
