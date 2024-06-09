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

#ifndef AIMPDISCORDPRESENCE_SRC_VERSION_H_
#define AIMPDISCORDPRESENCE_SRC_VERSION_H_

#define PL_MANUAL_MAJOR         1
#define PL_MANUAL_MINOR         1
#define PL_MANUAL_RELEASE       0
#define PL_MANUAL_BUILD         0

#ifndef V_MAJOR
#  define V_MAJOR               PL_MANUAL_MAJOR
#endif
#ifndef V_MINOR
#  define V_MINOR               PL_MANUAL_MINOR
#endif
#ifndef V_RELEASE
#  define V_RELEASE             PL_MANUAL_RELEASE
#endif
#ifndef V_BUILD
#  define V_BUILD               PL_MANUAL_BUILD
#endif

#define PL_VERSION_MAJOR        V_MAJOR
#define PL_VERSION_MINOR        V_MINOR
#define PL_VERSION_RELEASE      V_RELEASE
#define PL_VERSION_BUILD        V_BUILD

#define STR(x) #x
#define STRNAME(name) STR(name)

#define PL_VERSION_MAJOR_S      STRNAME(PL_VERSION_MAJOR)
#define PL_VERSION_MINOR_S      STRNAME(PL_VERSION_MINOR)
#define PL_VERSION_RELEASE_S    STRNAME(PL_VERSION_RELEASE)
#if PL_VERSION_BUILD == 0
#  define PL_VERSION_BUILD_S    "manual"
#else
#  define PL_VERSION_BUILD_S    "git" STRNAME(PL_VERSION_BUILD)
#endif

#define PL_VERSION_STRING       PL_VERSION_MAJOR_S "." PL_VERSION_MINOR_S "." PL_VERSION_RELEASE_S "-" PL_VERSION_BUILD_S
#define PL_VERSION_FILE         PL_VERSION_MAJOR,PL_VERSION_MINOR,PL_VERSION_RELEASE,PL_VERSION_BUILD

#endif  // AIMPDISCORDPRESENCE_SRC_VERSION_H_
