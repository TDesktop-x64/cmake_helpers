# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

add_library(external_breakpad INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_breakpad ALIAS external_breakpad)

if (LINUX)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(DESKTOP_APP_BREAKPAD REQUIRED breakpad)
    target_include_directories(external_breakpad SYSTEM
    INTERFACE
        ${DESKTOP_APP_BREAKPAD_INCLUDE_DIRS}
    )
else()
    target_include_directories(external_breakpad SYSTEM
    INTERFACE
        ${libs_loc}/breakpad/src
    )
endif()

if (build_winarm)
    set(breakpad_config_add _ARM64)
elseif (build_win64)
    set(breakpad_config_add _x64)
else()
    set(breakpad_config_add "")
endif()

set(breakpad_lib_loc ${libs_loc}/breakpad/src/out/$<IF:$<CONFIG:Debug>,Debug${breakpad_config_add},Release${breakpad_config_add}>/obj/client)

if (WIN32)
    target_link_libraries(external_breakpad
    INTERFACE
        ${breakpad_lib_loc}/windows/common.lib
        ${breakpad_lib_loc}/windows/handler/exception_handler.lib
        ${breakpad_lib_loc}/windows/crash_generation/crash_generation_client.lib
    )
elseif (LINUX)
    target_link_static_libraries(external_breakpad
    INTERFACE
        breakpad_client
    )
endif()
