# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

target_compile_options(common_options
INTERFACE
    -fPIC
    $<IF:$<CONFIG:Debug>,,-fno-strict-aliasing>
    -pipe
    -Wall
    -W
    -Wno-unused-variable
    -Wno-unused-parameter
    -Wno-unused-function
    -Wno-switch
    -Wno-comment
    -Wno-missing-field-initializers
    -Wno-sign-compare
    -Wno-attributes
    -Wno-parentheses
    $<$<NOT:$<COMPILE_LANGUAGE:C>>:-Wno-register>
)

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(common_options
    INTERFACE
        -Wno-unused-but-set-variable
        -Wno-stringop-overflow
        -Wno-maybe-uninitialized
    -Wno-error=reorder
        -Wno-error=class-memaccess
    )
endif()

if (DESKTOP_APP_SPECIAL_TARGET)
    target_compile_options(common_options
    INTERFACE
        $<IF:$<CONFIG:Debug>,,-Ofast>
        -Werror
    )

    target_link_options(common_options
    INTERFACE
        $<IF:$<CONFIG:Debug>,,-Ofast>
    )

    if (build_linux32)
        target_compile_options(common_options INTERFACE -g0)
        target_link_options(common_options INTERFACE -g0)
    else()
        target_compile_options(common_options INTERFACE $<IF:$<CONFIG:Debug>,,-g0 -s>)
        target_link_options(common_options INTERFACE $<IF:$<CONFIG:Debug>,,-g0 -s>)
        if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
            target_compile_options(common_options INTERFACE $<IF:$<CONFIG:Debug>,,-g0 -s>)
            target_link_options(common_options INTERFACE $<IF:$<CONFIG:Debug>,,-g0 -s -fuse-linker-plugin>)
        endif()
    endif()
endif()

target_link_libraries(common_options
INTERFACE
    desktop-app::external_jemalloc
)

if (DESKTOP_APP_USE_PACKAGED)
    find_library(ATOMIC_LIBRARY atomic)
else()
    find_library(ATOMIC_LIBRARY libatomic.a)
endif()

if (ATOMIC_LIBRARY)
    target_link_libraries(common_options
    INTERFACE
        ${ATOMIC_LIBRARY}
    )
endif()
