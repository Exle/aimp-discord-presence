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

struct Utils {
  template <typename T>
  static typename std::enable_if<std::is_same<T, std::string>::value ||
                            std::is_same<T, std::wstring>::value, T>::type
  [[nodiscard]] Crop(T input, size_t maxlength) {
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

  [[nodiscard]] static std::string Resize(std::string input) {
    if (input.size() < 4) {
      return input + std::string(4 - input.size(), ' ');
    }

    return input;
  }

  [[nodiscard]] static std::string UriEncode(const std::string& input) {
    std::ostringstream escaped;
    escaped.fill('0');
    escaped << std::hex;

    for (char c : input) {
      if (isalnum(c) || c == '-' || c == '_' || c == '.' || c == '~') {
        escaped << c;
        continue;
      }

      escaped << std::uppercase;
      escaped << '%' << std::setw(2) << static_cast<int>(static_cast<unsigned char>(c));
      escaped << std::nouppercase;
    }

    return escaped.str();
  }

};

#endif  // AIMPDISCORDPRESENCE_SRC_UTILS_H_
