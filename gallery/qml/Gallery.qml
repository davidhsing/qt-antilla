pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Antilla.Basic
import Gallery

import './Home'

AntWindow {
    id: galleryWindow
    width: 900
    height: 600
    opacity: 0
    minimumWidth: 900
    minimumHeight: 600
    title: qsTr('Antilla Gallery')
    followThemeSwitch: true
    captionBar.visible: Qt.platform.os === 'windows' || Qt.platform.os === 'linux' || Qt.platform.os === 'osx'
    captionBar.height: captionBar.visible ? 30 : 0
    captionBar.color: AntTheme.Primary.colorFillTertiary
    captionBar.themeButtonVisible: true
    captionBar.topButtonVisible: true
    captionBar.winIconWidth: 22
    captionBar.winIconHeight: 22
    captionBar.winIconDelegate: Item {
        Image {
            width: 16
            height: 16
            anchors.centerIn: parent
            source: 'qrc:/Gallery/images/antilla_icon.svg'
        }
    }
    captionBar.themeCallback: () => {
        themeSwitchLoader.active = true;
    }
    captionBar.topCallback: (checked) => {
        AntApi.setWindowStaysOnTopHint(galleryWindow, checked);
    }
    Component.onCompleted: {
        if (Qt.platform.os === 'windows') {
            if (setSpecialEffect(AntWindow.EffectWinMicaAlt)) return;
            if (setSpecialEffect(AntWindow.EffectWinMica)) return;
            if (setSpecialEffect(AntWindow.EffectWinAcrylicMaterial)) return;
            if (setSpecialEffect(AntWindow.EffectWinDwmBlur)) return;
        } else if (Qt.platform.os === 'osx') {
            if (setSpecialEffect(AntWindow.EffectMacBlurEffect)) return;
        }
    }
    onWidthChanged: {
        galleryMenu.compactMode = width < 800;
    }

    property var galleryGlobal: Global { }

    Behavior on opacity { NumberAnimation { } }

    Timer {
        running: true
        interval: 200
        onTriggered: {
            galleryWindow.opacity = 1;
        }
    }

    MouseArea {
        id: rootFocusArea
        anchors.fill: parent
        onPressed: {
            forceActiveFocus();
        }
        z: -1

        Component.onCompleted: {
            forceActiveFocus();
        }
    }

    Rectangle {
        id: galleryBackground
        anchors.fill: content
        color: '#f5f5f5'
        opacity: 0.7
    }

    Loader {
        id: themeSwitchLoader
        z: 65536
        active: false
        anchors.fill: galleryWindow.contentItem
        sourceComponent: ThemeSwitchItem {
            opacity: galleryWindow.specialEffect === AntWindow.EffectNone ? 1.0 : galleryBackground.opacity
            target: galleryWindow.contentItem
            isDark: AntTheme.isDark
            onSwitchStarted: {
                galleryBackground.color = AntTheme.isDark ? '#f5f5f5' : '#181818';
                themeSwitchLoader.changeDark();
            }
            onAnimationFinished: {
                if (galleryWindow.specialEffect === AntWindow.EffectNone)
                    galleryWindow.color = AntTheme.Primary.colorBgBase;
                themeSwitchLoader.active = false;
            }
            Component.onCompleted: {
                colorBg = AntTheme.isDark ? '#f5f5f5' : '#181818';
                const distance = function(x1, y1, x2, y2) {
                    return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
                }
                const startX = content.width - 170;
                const startY = 0;
                const radius = Math.max(distance(startX, startY, 0, 0),
                                        distance(startX, startY, content.width, 0),
                                        distance(startX, startY, 0, content.height),
                                        distance(startX, startY, content.width, content.height));
                start(width, height, Qt.point(startX, startY), radius);
            }
        }

        function changeDark() {
            AntTheme.darkMode = AntTheme.isDark ? AntTheme.Light : AntTheme.Dark;
        }

        Connections {
            target: AntTheme
            function onIsDarkChanged() {
                if (AntTheme.darkMode === AntTheme.System) {
                    galleryWindow.setWindowMode(AntTheme.isDark);
                    galleryBackground.color = AntTheme.isDark ? '#181818' : '#f5f5f5';
                }
            }
        }
    }

    Item {
        id: content
        anchors.top: galleryWindow.captionBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle {
            id: authorCard
            width: visible ? galleryMenu.defaultMenuWidth : 0
            height: visible ? 80 : 0
            anchors.top: parent.top
            anchors.topMargin: 5
            radius: AntTheme.Primary.radiusPrimary
            color: hovered ? AntTheme.isDark ? '#10ffffff' : '#10000000' : 'transparent'
            visible: !galleryMenu.compactMode
            clip: true

            property bool hovered: authorCardHover.hovered

            Behavior on height { NumberAnimation { duration: AntTheme.Primary.durationFast } }
            Behavior on color { ColorAnimation { duration: AntTheme.Primary.durationFast } }

            Item {
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10

                AntAvatar {
                    id: avatarIcon
                    size: 60
                    anchors.verticalCenter: parent.verticalCenter
                    imageSource: 'https://avatars.githubusercontent.com/u/9333918?v=4'
                }

                Column {
                    anchors.left: avatarIcon.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    AntText {
                        text: 'DavidHsing'
                        font.weight: Font.DemiBold
                        font.italic: true
                        font.pixelSize: AntTheme.Primary.fontPrimarySize + 1
                    }

                    AntText {
                        width: parent.width
                        text: 'https://github.com/davidhsing'
                        font.pixelSize: AntTheme.Primary.fontPrimarySize - 1
                        color: AntTheme.Primary.colorTextSecondary
                        wrapMode: AntText.WrapAnywhere
                    }
                }
            }

            HoverHandler {
                id: authorCardHover
            }

            TapHandler {
                onTapped: {
                    Qt.openUrlExternally('https://github.com/davidhsing/qt-antilla');
                }
            }
        }

        AntAutoComplete {
            id: searchComponent
            property bool expanded: false
            z: 10
            clip: true
            width: (!galleryMenu.compactMode || expanded) ? (galleryMenu.defaultMenuWidth - 20) : 0
            anchors.top: authorCard.bottom
            anchors.left: !galleryMenu.compactMode ? galleryMenu.left : galleryMenu.right
            anchors.margins: 10
            topPadding: 6
            bottomPadding: 6
            rightPadding: 50
            tooltipVisible: true
            placeholderText: qsTr('搜索组件')
            iconSource: AntIcon.SearchOutlined
            colorBg: galleryMenu.compactMode ? AntTheme.AntInput.colorBg : 'transparent'
            options: galleryGlobal.options
            filterOption: function(input, option) {
                return option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1;
            }
            onSelected: function(option) {
                galleryMenu.gotoMenu(option.key);
            }
            labelDelegate: AntText {
                height: implicitHeight + 4
                text: parent.textData
                color: AntTheme.AntAutoComplete.colorItemText
                font {
                    family: AntTheme.AntAutoComplete.fontFamily
                    pixelSize: AntTheme.AntAutoComplete.fontSize
                    weight: parent.highlighted ? Font.DemiBold : Font.Normal
                }
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter

                property var model: parent.modelData
                property string tagState: model.state ?? ''

                AntTag {
                    id: __tag
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: parent.tagState
                    presetColor: parent.tagState === 'New' ? 'red' : 'green'
                    visible: parent.tagState !== ''
                }
            }

            Keys.onEscapePressed: {
                if (expanded) {
                    expanded = false;
                } else {
                    closePopup();
                }
            }

            Behavior on width {
                enabled: galleryMenu.compactMode && galleryMenu.width === galleryMenu.compactWidth
                NumberAnimation { duration: AntTheme.Primary.durationFast }
            }
        }

        AntIconButton {
            id: searchCollapse
            visible: galleryMenu.compactMode
            anchors.top: parent.top
            anchors.left: galleryMenu.left
            anchors.right: galleryMenu.right
            anchors.margins: 10
            type: AntButton.TypeText
            colorText: AntTheme.Primary.colorTextBase
            iconSource: AntIcon.SearchOutlined
            iconSize: searchComponent.iconSize
            onClicked: {
                searchComponent.expanded = !searchComponent.expanded;
                if (searchComponent.expanded) {
                    searchComponent.forceActiveFocus();
                }
            }
            onVisibleChanged: {
                if (visible) {
                    searchComponent.closePopup();
                    searchComponent.expanded = false;
                }
            }
        }

        AntMenu {
            id: galleryMenu
            anchors.left: parent.left
            anchors.top: searchComponent.bottom
            anchors.bottom: creatorButton.top
            borderVisible: true
            tooltipVisible: true
            defaultMenuWidth: 300
            defaultSelectedKey: ['HomePage']
            initModel: galleryGlobal.menus
            menuLabelDelegate: Item {
                property var model: parent.model
                property var menuButton: parent.menuButton
                property string tagState: model.state ?? ''

                AntText {
                    anchors.left: parent.left
                    anchors.leftMargin: menuButton.iconSpacing
                    anchors.right: __tag.left
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: menuButton.text
                    font: menuButton.font
                    color: menuButton.colorText
                    elide: Text.ElideRight
                }

                AntTag {
                    id: __tag
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: parent.tagState
                    presetColor: parent.tagState === 'New' ? 'red' : 'green'
                    visible: parent.tagState !== ''
                }
            }
            menuBgDelegate: Rectangle {
                radius: menuButton.radiusBg
                color: menuButton.colorBg
                border.color: menuButton.colorBorder
                border.width: 1

                property var model: parent.model
                property var menuButton: parent.menuButton
                property string badgeState: model.badgeState ?? ''

                Behavior on color { enabled: galleryMenu.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
                Behavior on border.color { enabled: galleryMenu.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }

                AntBadge {
                    anchors.left: undefined
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: undefined
                    anchors.margins: 1
                    dot: true
                    presetColor: (parent.badgeState === 'New') ? 'red' : 'green'
                    visible: parent.badgeState !== ''
                }
            }
            onMenuClicked: function(deep, key, keyPath, data) {
                if (data) {
                    if (data.hasOwnProperty('children')) {
                        setDataProperty(key, 'badgeState', '');
                    } else {
                        // console.debug('onMenuClicked', deep, key, keyPath, JSON.stringify(data));
                        containerLoader.version = data.addVersion || data.updateVersion || '';
                        containerLoader.desc = data.desc || '';
                        containerLoader.tagState = data.state || '';
                        gallerySwitchEffect.switchToSource(data.source);
                    }
                }
            }
        }

        AntDivider {
            width: galleryMenu.width
            height: 1
            anchors.bottom: creatorButton.top
        }

        Loader {
            id: creatorLoader
            active: false
            visible: false
            sourceComponent: CreatorPage { visible: creatorLoader.visible }
        }

        Loader {
            id: aboutLoader
            active: false
            visible: false
            sourceComponent: AboutPage { visible: aboutLoader.visible }
        }

        Loader {
            id: settingsLoader
            active: false
            visible: false
            sourceComponent: SettingsPage { visible: settingsLoader.visible }
        }

        AntIconButton {
            id: creatorButton
            width: galleryMenu.width
            height: 40
            anchors.bottom: aboutButton.top
            type: AntButton.TypeText
            radiusBg.all: 0
            text: galleryMenu.compactMode ? '' : qsTr('创建')
            colorText: AntTheme.Primary.colorTextBase
            iconSize: galleryMenu.defaultMenuIconSize
            iconSource: AntIcon.PlusCircleOutlined
            onClicked: {
                if (!creatorLoader.active)
                    creatorLoader.active = true;
                creatorLoader.visible = !creatorLoader.visible;
            }
        }

        AntIconButton {
            id: aboutButton
            width: galleryMenu.width
            height: 40
            anchors.bottom: setttingsButton.top
            type: AntButton.TypeText
            radiusBg.all: 0
            text: galleryMenu.compactMode ? '' : qsTr('关于')
            colorText: AntTheme.Primary.colorTextBase
            iconSize: galleryMenu.defaultMenuIconSize
            iconSource: AntIcon.UserOutlined
            onClicked: {
                if (!aboutLoader.active)
                    aboutLoader.active = true;
                aboutLoader.visible = !aboutLoader.visible;
            }
        }

        AntIconButton {
            id: setttingsButton
            width: galleryMenu.width
            height: 40
            anchors.bottom: parent.bottom
            type: AntButton.TypeText
            radiusBg.all: 0
            text: galleryMenu.compactMode ? '' : qsTr('设置')
            colorText: AntTheme.Primary.colorTextBase
            iconSize: galleryMenu.defaultMenuIconSize
            iconSource: AntIcon.SettingOutlined
            onClicked: {
                if (!settingsLoader.active)
                    settingsLoader.active = true;
                settingsLoader.visible = !settingsLoader.visible;
            }
        }

        Item {
            id: container
            anchors.left: galleryMenu.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 5
            clip: true

            property string source: ''

            AntSwitchEffect {
                id: gallerySwitchEffect
                anchors.fill: parent
                duration: 0
                type: AntSwitchEffect.TypeNone
                maskScale: animationTime * 3
                maskRotation: (1.0 - animationTime) * 360
                onFinished: {
                    containerLoader.source = container.source;
                    containerLoader.visible = true;
                }

                function switchToSource(source) {
                    if (container.source !== source) {
                        container.source = source;
                        nextLoader.source = source;
                        containerLoader.visible = false;
                        gallerySwitchEffect.startSwitch(containerLoader, nextLoader);
                    }
                }
            }

            Loader {
                id: nextLoader
                anchors.fill: parent
                visible: false
            }

            Loader {
                id: containerLoader
                anchors.fill: parent
                visible: false
                property string tagState: ''
                property string version: ''
                property string desc: ''
            }
        }
    }
}
