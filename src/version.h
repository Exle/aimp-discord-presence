#pragma once

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
