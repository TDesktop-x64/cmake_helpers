# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

add_library(external_ffmpeg INTERFACE IMPORTED GLOBAL)
add_library(desktop-app::external_ffmpeg ALIAS external_ffmpeg)

if (DESKTOP_APP_USE_PACKAGED)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(DESKTOP_APP_FFMPEG REQUIRED IMPORTED_TARGET
        libavcodec
        libavfilter
        libavformat
        libavutil
        libswresample
        libswscale
    )
    target_link_libraries(external_ffmpeg INTERFACE PkgConfig::DESKTOP_APP_FFMPEG)
    return()
endif()

set(ffmpeg_lib_list)

if (LINUX)
    list(APPEND ffmpeg_lib_list
        -lavfilter
        -lavformat
        -lavcodec
        -lswresample
        -lswscale
        -lavutil
    )
else()
    set(ffmpeg_lib_loc ${libs_loc}/ffmpeg)

    target_include_directories(external_ffmpeg SYSTEM
    INTERFACE
        ${ffmpeg_lib_loc}
    )

    list(APPEND ffmpeg_lib_list
        ${ffmpeg_lib_loc}/libavfilter/libavfilter.a
        ${ffmpeg_lib_loc}/libavformat/libavformat.a
        ${ffmpeg_lib_loc}/libavcodec/libavcodec.a
        ${ffmpeg_lib_loc}/libswresample/libswresample.a
        ${ffmpeg_lib_loc}/libswscale/libswscale.a
        ${ffmpeg_lib_loc}/libavutil/libavutil.a
    )
endif()

list(APPEND ffmpeg_lib_list
    $<TARGET_FILE:desktop-app::external_opus>
    $<TARGET_FILE:desktop-app::external_vpx>
)

if (WIN32)
    list(APPEND ffmpeg_lib_list
        ${libs_loc}/dav1d/builddir-$<IF:$<CONFIG:Debug>,debug,release>/src/libdav1d.a
    )
elseif (APPLE)
    list(APPEND ffmpeg_lib_list
        bz2
    )
elseif (LINUX)
    list(APPEND ffmpeg_lib_list
        -ldav1d
        -llzma
        $<TARGET_FILE:implib_vdpau>
        $<TARGET_FILE:implib_va_x11>
        $<TARGET_FILE:implib_va_drm>
        $<TARGET_FILE:implib_va>
        $<TARGET_FILE:implib_drm>
        -lXv
        -lXext
    )
endif()

# Workaround cmake's random order on Linux...
if (LINUX)
    generate_implib(
        vdpau
        va-x11
        va-drm
        va
        drm
    )
    list(JOIN ffmpeg_lib_list , ffmpeg_lib_link)
    target_link_libraries(external_ffmpeg
    INTERFACE
        -Wl,--push-state,-Bstatic,${ffmpeg_lib_link},--pop-state
        $<LINK_ONLY:implib_vdpau>
        $<LINK_ONLY:implib_va_x11>
        $<LINK_ONLY:implib_va_drm>
        $<LINK_ONLY:implib_va>
        $<LINK_ONLY:implib_drm>
        X11
    )
else()
    target_link_libraries(external_ffmpeg
    INTERFACE
        ${ffmpeg_lib_list}
    )
endif()

target_link_libraries(external_ffmpeg
INTERFACE
    $<LINK_ONLY:desktop-app::external_openh264>
    $<LINK_ONLY:desktop-app::external_opus>
    $<LINK_ONLY:desktop-app::external_vpx>
)
