# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

add_library(linux_gtk_helper STATIC)
add_library(desktop-app::linux_gtk_helper ALIAS linux_gtk_helper)

nice_target_sources(linux_gtk_helper ${CMAKE_CURRENT_SOURCE_DIR}
PRIVATE
    linux_gtk_helper.cpp
)

target_compile_definitions(linux_gtk_helper PRIVATE G_LOG_DOMAIN="GtkHelper")

target_link_libraries(linux_gtk_helper
PUBLIC
    desktop-app::external_glib
)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK REQUIRED gtk+-3.0)
target_include_directories(linux_gtk_helper PRIVATE ${GTK_INCLUDE_DIRS})
