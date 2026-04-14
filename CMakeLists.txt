cmake_minimum_required(VERSION 3.16)

project(Qt-Antilla)

option(BUILD_ANTILLA_GALLERY "Build Antilla Gallery." ON)
option(BUILD_ANTILLA_STATIC_LIBS "Build Antilla as a static library." OFF)
option(BUILD_ANTILLA_DESKTOP_PLATFORM "Build Antilla on desktop platform (mobile platform set OFF)." ON)
option(BUILD_ANTILLA_DEFAULT_LOCATION "Build Antilla in default location[QtSDK Dir]." ON)

#Set Antilla output dir
set(ANTILLA_HEADER_OUTPUT_DIR "" CACHE PATH "Antilla header output dir.")
set(ANTILLA_LIB_OUTPUT_DIR "" CACHE PATH "Antilla library output dir.")
set(ANTILLA_PLUGIN_OUTPUT_DIR "" CACHE PATH "Antilla plugin output dir (Must end with [Antilla/Basic]).")

set(MACOS FALSE)
if(APPLE)
    if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
        set(MACOS TRUE)
    else()
        set(MACOS FALSE)
    endif()
endif()

if(WIN32 OR MACOS OR LINUX)
    set(BUILD_ANTILLA_DESKTOP_PLATFORM ON)
else()
    set(BUILD_ANTILLA_DESKTOP_PLATFORM OFF)
endif()

if(BUILD_ANTILLA_DESKTOP_PLATFORM)
    #Build QWindowKit
    set(QWINDOWKIT_BUILD_STATIC ON)
    set(QWINDOWKIT_BUILD_WIDGETS OFF)
    set(QWINDOWKIT_BUILD_QUICK ON)
    set(QWINDOWKIT_INSTALL OFF)
    add_subdirectory(3rdparty/qwindowkit)
endif()

# Set default install prefix
# Note: Use --prefix option when running cmake --install to specify custom install location
# Example: cmake --install build/make/Debug --prefix build/install/Debug
if(ANTILLA_INSTALL_DIRECTORY)
    set(CMAKE_INSTALL_PREFIX "${ANTILLA_INSTALL_DIRECTORY}" CACHE PATH "Install prefix" FORCE)
elseif(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    # Default to build/install/<BuildType> using relative path from build directory
    if(CMAKE_BUILD_TYPE MATCHES "Debug")
        set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../../install/Debug" CACHE PATH "Install prefix" FORCE)
    else()
        set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../../install/Release" CACHE PATH "Install prefix" FORCE)
    endif()
endif()

add_subdirectory(src)

if(BUILD_ANTILLA_GALLERY)
    add_subdirectory(gallery)
endif()
