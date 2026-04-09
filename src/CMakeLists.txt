cmake_minimum_required(VERSION 3.16)

set(ANTILLA_VERSION_MAJOR 1)
set(ANTILLA_VERSION_MINOR 0)
set(ANTILLA_VERSION_PATCH 0)
set(ANTILLA_VERSION_TWEAK 0)
set(ANTILLA_VERSION ${ANTILLA_VERSION_MAJOR}.${ANTILLA_VERSION_MINOR}.${ANTILLA_VERSION_PATCH}.${ANTILLA_VERSION_TWEAK})

message(STATUS "Configuring AntillaBasic Version: ${ANTILLA_VERSION}")

project(AntillaBasic VERSION ${ANTILLA_VERSION} LANGUAGES CXX)

#Add AntillaHelper
include(${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/AntillaHelper.cmake)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 6.5 COMPONENTS Quick QuickTemplates2 ShaderTools LabsQmlModels Multimedia REQUIRED)
qt_standard_project_setup(REQUIRES 6.5)

#Determine if there is a private module present
set(QT_NO_PRIVATE_MODULE_WARNING ON)
set(QT_HAS_PRIVATE_MODULES FALSE)
if(Qt6_VERSION VERSION_GREATER_EQUAL "6.10.0")
    find_package(Qt6 6.10 COMPONENTS QuickPrivate QuickTemplates2Private OPTIONAL_COMPONENTS QmlAssetDownloaderPrivate)
    if(Qt6QuickPrivate_FOUND AND Qt6QuickTemplates2Private_FOUND)
        set(QT_HAS_PRIVATE_MODULES TRUE)
    endif()
else()
    get_target_property(QT_HAS_QUICK_PRIVATE Qt6::Quick _qt_module_has_private_headers)
    get_target_property(QT_HAS_QUICKTEMPLATES2_PRIVATE Qt6::QuickTemplates2 _qt_module_has_private_headers)
    get_target_property(QT_HAS_LABSQMLMODEL_PRIVATE Qt6::LabsQmlModels _qt_module_has_private_headers)
    if(QT_HAS_QUICK_PRIVATE AND QT_HAS_QUICKTEMPLATES2_PRIVATE AND QT_HAS_LABSQMLMODEL_PRIVATE)
        set(QT_HAS_PRIVATE_MODULES TRUE)
    endif()
endif()

#Set header output dir.
if(NOT ANTILLA_HEADER_OUTPUT_DIRECTORY)
    if(BUILD_ANTILLA_IN_DEFAULT_LOCATION)
        set(ANTILLA_HEADER_OUTPUT_DIRECTORY ${Qt6_DIR}/../../../include)
    else()
        set(ANTILLA_HEADER_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX}/install/include)
    endif()
endif()

#Set library output dir.
if(NOT ANTILLA_LIBRARY_OUTPUT_DIRECTORY)
    if(BUILD_ANTILLA_IN_DEFAULT_LOCATION)
        set(ANTILLA_LIBRARY_OUTPUT_DIRECTORY ${Qt6_DIR}/../../../)
        if(BUILD_ANTILLA_STATIC_LIBS)
            set(ANTILLA_LIBRARY_OUTPUT_DIRECTORY ${Qt6_DIR}/../../../)
        endif()
    else()
        set(ANTILLA_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX}/install/lib)
    endif()
endif()

#Set plugin output dir.
if(NOT ANTILLA_PLUGIN_OUTPUT_DIRECTORY)
    if(BUILD_ANTILLA_IN_DEFAULT_LOCATION)
        set(ANTILLA_PLUGIN_OUTPUT_DIRECTORY ${Qt6_DIR}/../../../qml/Antilla/Basic)
    else()
        set(ANTILLA_PLUGIN_OUTPUT_DIRECTORY ${CMAKE_INSTALL_PREFIX}/install/plugins/Antilla/Basic)
    endif()
endif()

#Set install dir.
if(INSTALL_ANTILLA_IN_DEFAULT_LOCATION)
    set(CMAKE_INSTALL_PREFIX "${Qt6_DIR}/../../../" CACHE PATH "" FORCE)
elseif(ANTILLA_INSTALL_DIRECTORY)
    set(CMAKE_INSTALL_PREFIX "${ANTILLA_INSTALL_DIRECTORY}" CACHE PATH "" FORCE)
endif()

message(STATUS "The Qt has private module: ${QT_HAS_PRIVATE_MODULES}")
message(STATUS "The Antilla header output dir: ${ANTILLA_HEADER_OUTPUT_DIRECTORY}")
message(STATUS "The Antilla library output dir: ${ANTILLA_LIBRARY_OUTPUT_DIRECTORY}")
message(STATUS "The Antilla plugin output dir: ${ANTILLA_PLUGIN_OUTPUT_DIRECTORY}")
message(STATUS "The Antilla install dir: ${CMAKE_INSTALL_PREFIX}")

if(BUILD_ANTILLA_STATIC_LIBS)
    set(PLUGIN_NAME AntillaBasicPlugin)
    qt_add_library(${PROJECT_NAME} STATIC)
else()
    set(PLUGIN_NAME antillabasicplugin)
    qt_add_library(${PROJECT_NAME} SHARED)
endif()

#Default is desktop platform
if(NOT DEFINED BUILD_ANTILLA_ON_DESKTOP_PLATFORM)
    set(BUILD_ANTILLA_ON_DESKTOP_PLATFORM ON)
endif()

#Add windows RC
set(ANTILLA_RC_FILE "")
if(WIN32)
    set(ANTILLA_RC_FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_Resource.rc)
    set(RC_NAME "")
    if(BUILD_ANTILLA_STATIC_LIBS)
        set(RC_NAME "${PROJECT_NAME}.lib")
    else()
        set(RC_NAME "${PROJECT_NAME}.dll")
    endif()
    ant_add_win_rc(${PROJECT_NAME}
        COMMENTS "Modern UI-Kit for Qml { Design reference Ant-d }"
        NAME ${RC_NAME}
        COMPANY "Antilla"
        DESCRIPTION "https://github.com/davidhsing/qt-antilla"
        VERSION "${PROJECT_VERSION}"
        COPYRIGHT "Copyright (C) 2026 davidhsing. All rights reserved."
        OUTPUT_FILE "${ANTILLA_RC_FILE}"
    )
endif()

if(QT_KNOWN_POLICY_QTP0004)
    qt_policy(SET QTP0004 NEW)
endif()

set(QT_TREEMODEL_SOURCES "")
if(QT_HAS_LABSQMLMODEL_PRIVATE)
    set(QT_TREEMODEL_SOURCES
        cpp/models/qqmltreerow_p.h cpp/models/qqmltreerow.cpp
        cpp/models/qqmltreemodel_p.h cpp/models/qqmltreemodel.cpp
        cpp/models/qqmlabstractcolumnmodel_p.h cpp/models/qqmlabstractcolumnmodel.cpp
    )
endif()

qt_add_qml_module(${PROJECT_NAME}
    URI "Antilla.Basic"
    VERSION 1.0
    DESIGNER_SUPPORTED
    PLUGIN_TARGET ${PLUGIN_NAME}
    #NO_GENERATE_PLUGIN_SOURCE
    RESOURCE_PREFIX "/"
    TYPEINFO "plugins.qmltypes"
    OUTPUT_DIRECTORY ${ANTILLA_PLUGIN_OUTPUT_DIRECTORY}
    QML_FILES
        imports/AntButton.qml imports/AntButtonBlock.qml
        imports/AntIconButton.qml
        imports/AntCaptionButton.qml
        imports/AntTourFocus.qml imports/AntTourStep.qml
        imports/AntIconText.qml
        imports/AntCheckerBoard.qml
        imports/AntColorPicker.qml imports/AntColorPickerPanel.qml
        imports/AntCopyableText.qml
        imports/AntCaptionBar.qml
        imports/AntWindow.qml
        imports/AntMenu.qml
        imports/AntDivider.qml
        imports/AntSwitch.qml
        imports/AntScrollBar.qml
        imports/AntMouseMoveArea.qml
        imports/AntMouseResizeArea.qml
        imports/AntAcrylic.qml
        imports/AntSlider.qml
        imports/AntTabs.qml
        imports/AntToolTip.qml
        imports/AntSelect.qml
        imports/AntInput.qml
        imports/AntInputInteger.qml
        imports/AntInputNumber.qml
        imports/AntInputOnce.qml
        imports/AntRate.qml
        imports/AntRadio.qml imports/AntRadioBlock.qml
        imports/AntCheckBox.qml
        imports/AntDrawer.qml
        imports/AntCollapse.qml
        imports/AntAvatar.qml
        imports/AntCard.qml
        imports/AntPagination.qml
        imports/AntPopup.qml
        imports/AntTimeline.qml
        imports/AntTag.qml
        imports/AntTable.qml
        imports/AntMessage.qml
        imports/AntAutoComplete.qml
        imports/AntText.qml
        imports/AntProgress.qml
        imports/AntBadge.qml
        imports/AntCarousel.qml
        imports/AntSwitchEffect.qml
        imports/AntContextMenu.qml
        imports/AntBreadcrumb.qml
        imports/AntImage.qml
        imports/AntImagePreview.qml
        imports/AntAnimatedImage.qml
        imports/AntMultiSelect.qml
        imports/AntDateTimePicker.qml
        imports/AntLabel.qml
        imports/AntModal.qml
        imports/AntNotification.qml
        imports/AntPopconfirm.qml
        imports/AntShadow.qml
        imports/AntSpace.qml
        imports/AntTextArea.qml
        imports/AntTransfer.qml
        imports/AntTree.qml
        imports/AntAudioDiagnosis.qml
        imports/AntAlert.qml
        imports/AntPopover.qml
        imports/AntEmpty.qml
        imports/AntFileBrowser.qml
        imports/AntSpin.qml
        imports/AntStatusBar.qml
        imports/AntFormItem.qml
        imports/AntGroupBox.qml
        imports/AntMaskOverlay.qml
        imports/AntResult.qml
        imports/AntShield.qml
    SOURCES
        $<$<BOOL:${WIN32}>:${ANTILLA_RC_FILE}>
        cpp/antglobal.h
        cpp/antdefinitions.h
        #cpp/antillaplugin.cpp
        cpp/antapp.h cpp/antapp.cpp
        cpp/theme/anttheme.h cpp/theme/anttheme.cpp cpp/theme/anttheme_p.h
        cpp/theme/antthemefunctions.h cpp/theme/antthemefunctions.cpp
        cpp/theme/antcolorgenerator.h cpp/theme/antcolorgenerator.cpp
        cpp/theme/antsizegenerator.h cpp/theme/antsizegenerator.cpp
        cpp/theme/antradiusgenerator.h cpp/theme/antradiusgenerator.cpp
        cpp/theme/antsystemthemehelper.h cpp/theme/antsystemthemehelper.cpp
        cpp/utils/antapi.h cpp/utils/antapi.cpp
        cpp/utils/antasynchasher.h cpp/utils/antasynchasher.cpp
        cpp/controls/anticonfont.h cpp/controls/anticonfont.cpp
        cpp/controls/antrectangle.h cpp/controls/antrectangle.cpp
        cpp/controls/antwatermark.h cpp/controls/antwatermark.cpp
        cpp/controls/antwindowagent.h cpp/controls/antwindowagent.cpp
        # QR-Code-generator
        cpp/controls/antqrcode.h cpp/controls/antqrcode.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/QR-Code-generator/cpp/qrcodegen.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/QR-Code-generator/cpp/qrcodegen.cpp
        # Multimedia
        cpp/controls/antaudioprobe.h cpp/controls/antaudioprobe.cpp
)

qt_add_resources(${PROJECT_NAME} "theme"
    PREFIX "/Antilla"
    FILES
        theme/Index.json
        theme/AntButton.json
        theme/AntCaptionButton.json
        theme/AntTour.json
        theme/AntIconText.json
        theme/AntColorPicker.json
        theme/AntCopyableText.json
        theme/AntMenu.json
        theme/AntDivider.json
        theme/AntSwitch.json
        theme/AntScrollBar.json
        theme/AntSlider.json
        theme/AntTabs.json
        theme/AntToolTip.json
        theme/AntSelect.json
        theme/AntMultiSelect.json
        theme/AntInput.json
        theme/AntInputInteger.json
        theme/AntInputNumber.json
        theme/AntRate.json
        theme/AntRadio.json
        theme/AntRadioBlock.json
        theme/AntCheckBox.json
        theme/AntDrawer.json
        theme/AntCollapse.json
        theme/AntCard.json
        theme/AntPagination.json
        theme/AntPopup.json
        theme/AntTimeline.json
        theme/AntTag.json
        theme/AntTable.json
        theme/AntMessage.json
        theme/AntAutoComplete.json
        theme/AntProgress.json
        theme/AntCarousel.json
        theme/AntBreadcrumb.json
        theme/AntImage.json
        theme/AntDateTimePicker.json
        theme/AntLabel.json
        theme/AntModal.json
        theme/AntNotification.json
        theme/AntPopconfirm.json
        theme/AntText.json
        theme/AntTextArea.json
        theme/AntTransfer.json
        theme/AntTree.json
        theme/AntAudioDiagnosis.json
        theme/AntAlert.json
        theme/AntPopover.json
        theme/AntEmpty.json
        theme/AntSpin.json
        theme/AntStatusBar.json
        theme/AntFormItem.json
        theme/AntGroupBox.json
        theme/AntMaskOverlay.json
        theme/AntResult.json
        theme/AntShield.json
)

qt_add_resources(${PROJECT_NAME} "resources"
    PREFIX "/Antilla"
    FILES
        resources/images/empty-default.svg
        resources/images/empty-simple.svg
        resources/images/hblinds.png
        resources/images/heart.png
        resources/images/smoke.png
        resources/images/star.png
        resources/images/stripes.png
        resources/font/Antilla-Icons.ttf
)

qt_add_shaders(${PROJECT_NAME} "shaders"
    PREFIX "/Antilla"
    FILES
        shaders/antrate.frag
)

# Antilla library output dir
set_target_properties(${PROJECT_NAME} PROPERTIES
    EXPORT_NAME "Basic"
    VERSION ${ANTILLA_VERSION}
    SOVERSION ${ANTILLA_VERSION_MAJOR}.${ANTILLA_VERSION_MINOR}
    RUNTIME_OUTPUT_DIRECTORY ${ANTILLA_LIBRARY_OUTPUT_DIRECTORY}/bin
    LIBRARY_OUTPUT_DIRECTORY ${ANTILLA_LIBRARY_OUTPUT_DIRECTORY}/lib
    ARCHIVE_OUTPUT_DIRECTORY ${ANTILLA_LIBRARY_OUTPUT_DIRECTORY}/lib
)

if(MINGW)
    set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
    target_compile_options(${PROJECT_NAME} PRIVATE -Wa,-mbig-obj)
elseif(MSVC)
    set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "d")
    target_compile_options(${PROJECT_NAME} PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/utf-8;/Zi>)
endif()

target_compile_definitions(${PROJECT_NAME} PRIVATE
    BUILD_ANTILLA_LIB
    ANTILLA_LIBRARY_VERSION="${ANTILLA_VERSION}"
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
    $<$<BOOL:${BUILD_ANTILLA_STATIC_LIBS}>:BUILD_ANTILLA_STATIC_LIBS>
    $<$<BOOL:${BUILD_ANTILLA_ON_DESKTOP_PLATFORM}>:BUILD_ANTILLA_ON_DESKTOP_PLATFORM>
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::QuickPrivate
    Qt6::QuickTemplates2Private
    Qt6::Multimedia
    $<$<BOOL:${BUILD_ANTILLA_ON_DESKTOP_PLATFORM}>:QWKCore>
    $<$<BOOL:${BUILD_ANTILLA_ON_DESKTOP_PLATFORM}>:QWKQuick>
)

include(GNUInstallDirs)
set(INCLUDE_INSTALL_DIR "install/${CMAKE_INSTALL_INCLUDEDIR}") # include
set(LIB_INSTALL_DIR "install/${CMAKE_INSTALL_LIBDIR}") # lib
set(BIN_INSTALL_DIR "install/${CMAKE_INSTALL_BINDIR}") # bin
set(QML_INSTALL_DIR "install/qml") # qml
set(OBJ_INSTALL_DIR "install/obj") # obj
set(ANTILLA_QML_INSTALL_DIR "${QML_INSTALL_DIR}/Antilla")
set(ANTILLA_CONFIG_INSTALL_DIR "${LIB_INSTALL_DIR}/cmake/Antilla")

target_include_directories(${PROJECT_NAME} PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/cpp>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/cpp/theme>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/cpp/controls>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/cpp/models>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/cpp/utils>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/../3rdparty/qwindowkit/include>
    $<INSTALL_INTERFACE:${INCLUDE_INSTALL_DIR}>
    $<INSTALL_INTERFACE:${INCLUDE_INSTALL_DIR}/Antilla>
)

# < Qt6.10 include QtLabsQmlModels/private
if(QT_HAS_LABSQMLMODEL_PRIVATE)
    get_target_property(_module_name Qt6::LabsQmlModels _qt_module_include_name)
    get_target_property(_module_location Qt6::LabsQmlModels LOCATION)
    get_filename_component(_qt6_prefix "${_module_location}" DIRECTORY)
    get_filename_component(_qt6_prefix "${_qt6_prefix}" DIRECTORY) # strip "lib"
    set(_private_include_dir "${_qt6_prefix}/include/${_module_name}/${Qt6_VERSION_MAJOR}.${Qt6_VERSION_MINOR}.${Qt6_VERSION_PATCH}/${_module_name}/private")
    target_include_directories(${PROJECT_NAME} PRIVATE ${_private_include_dir})
    target_compile_definitions(${PROJECT_NAME} PRIVATE QT_FEATURE_qml_tree_model=1)
    target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::LabsQmlModelsPrivate) # TreeModel
endif()

#Gen Antilla/include
if(ANTILLA_HEADER_OUTPUT_DIRECTORY)
    file(COPY cpp/antglobal.h cpp/antapp.h cpp/antdefinitions.h cpp/controls cpp/models cpp/theme cpp/utils
        DESTINATION ${ANTILLA_HEADER_OUTPUT_DIRECTORY}/Antilla
        FILES_MATCHING PATTERN "*.h"
        PATTERN "*_p.h" EXCLUDE
    )
endif()

#Set CMake config output dir
set(ANTILLA_CMAKE_CONFIG_DIR ${ANTILLA_LIBRARY_OUTPUT_DIRECTORY}/lib/cmake)

include(CMakePackageConfigHelpers)

#Generate Antilla package config file
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/../.cmake/AntillaConfig.cmake.in
    ${ANTILLA_CMAKE_CONFIG_DIR}/AntillaConfig.cmake
    PATH_VARS INCLUDE_INSTALL_DIR LIB_INSTALL_DIR QML_INSTALL_DIR
    INSTALL_DESTINATION ${ANTILLA_CONFIG_INSTALL_DIR}
)

#Generate Antilla package version file
write_basic_package_version_file(
    ${ANTILLA_CMAKE_CONFIG_DIR}/AntillaConfigVersion.cmake
    VERSION ${ANTILLA_VERSION}
    COMPATIBILITY SameMinorVersion #Require target lib must has same Major and Minor version
)

install(TARGETS ${PROJECT_NAME}
    EXPORT AntillaTargets
    RUNTIME DESTINATION ${BIN_INSTALL_DIR}
    ARCHIVE DESTINATION ${LIB_INSTALL_DIR}
    LIBRARY DESTINATION ${LIB_INSTALL_DIR}
)

install(TARGETS ${PLUGIN_NAME}
    EXPORT AntillaTargets
    RUNTIME DESTINATION ${ANTILLA_QML_INSTALL_DIR}/Basic
    ARCHIVE DESTINATION ${ANTILLA_QML_INSTALL_DIR}/Basic
    LIBRARY DESTINATION ${ANTILLA_QML_INSTALL_DIR}/Basic
)

if(BUILD_ANTILLA_STATIC_LIBS)
    install(
        TARGETS ${ANTILLA_QML_OUTPUT_TARGETS} ${ANTILLA_THEME_OUTPUT_TARGETS}
        ${ANTILLA_RES_OUTPUT_TARGETS} ${ANTILLA_SHADERS_OUTPUT_TARGETS}
        EXPORT AntillaTargets
        RUNTIME DESTINATION ${BIN_INSTALL_DIR}
        ARCHIVE DESTINATION ${LIB_INSTALL_DIR}
        LIBRARY DESTINATION ${LIB_INSTALL_DIR}
        OBJECTS DESTINATION ${OBJ_INSTALL_DIR}
    )
endif()

install(
    DIRECTORY ${ANTILLA_HEADER_OUTPUT_DIRECTORY}/Antilla
    DESTINATION ${INCLUDE_INSTALL_DIR}
)

install(
    DIRECTORY ${ANTILLA_PLUGIN_OUTPUT_DIRECTORY}
    DESTINATION ${ANTILLA_QML_INSTALL_DIR}
)

install(
    FILES ${ANTILLA_CMAKE_CONFIG_DIR}/AntillaConfig.cmake
    ${ANTILLA_CMAKE_CONFIG_DIR}/AntillaConfigVersion.cmake
    DESTINATION ${ANTILLA_CONFIG_INSTALL_DIR}
)

#Generate and install Antilla targets file
install(
    EXPORT AntillaTargets
    FILE AntillaTargets.cmake
    NAMESPACE Antilla::
    DESTINATION ${ANTILLA_CONFIG_INSTALL_DIR}
)
