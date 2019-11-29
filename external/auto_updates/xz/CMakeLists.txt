# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

add_library(external_xz INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_xz ALIAS external_xz)

if (APPLE AND NOT build_osx)
    target_link_libraries(external_xz
    INTERFACE
        /usr/local/macos/lib/liblzma.a
    )
else()
    target_link_libraries(external_xz
    INTERFACE
        /usr/local/lib/liblzma.a
    )
endif()