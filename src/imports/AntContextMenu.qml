import QtQuick
import Antilla.Basic

AntPopup {
    id: control

    signal menuClicked(deep: int, key: string, keyPath: var, data: var)

    property bool animationEnabled: AntTheme.animationEnabled
    property int defaultMenuIconSize: control.themeSource.fontIconSize
    property int defaultMenuIconSpacing: 8
    property int defaultMenuTextSize: control.themeSource.fontTextSize
    property int defaultMenuWidth: 140
    property int defaultMenuHeight: 30
    property int defaultMenuSpacing: 4
    property int subMenuOffset: -4
    property var initModel: []
    property bool keepIconPlace: true
    property bool tooltipVisible: false
    property AntRadius radiusMenuBg: AntRadius { all: AntTheme.Primary.radiusPrimary }
    property var themeSource: AntTheme.AntMenu

    objectName: '__AntContextMenu__'
    implicitWidth: defaultMenuWidth
    implicitHeight: implicitContentHeight
    enter: Transition {
        NumberAnimation {
            property: 'opacity'
            from: 0.0
            to: 1.0
            easing.type: Easing.InOutQuad
            duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        }
        NumberAnimation {
            target: control.contentItem
            property: 'scale'
            from: 0.01
            to: 1.0
            easing.type: Easing.OutCubic
            duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        }
    }
    exit: Transition {
        NumberAnimation {
            property: 'opacity'
            from: 1.0
            to: 0.0
            easing.type: Easing.InOutQuad
            duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        }
        NumberAnimation {
            target: control.contentItem
            property: 'scale'
            to: 0.01
            easing.type: Easing.InCubic
            duration: control.animationEnabled ? AntTheme.Primary.durationFast : 0
        }
    }
    contentItem: AntMenu {
        clip: true
        transformOrigin: Item.Top
        scale: 1.0
        initModel: control.initModel
        tooltipVisible: control.tooltipVisible
        popupMode: true
        popupWidth: control.defaultMenuWidth
        popupOffset: control.subMenuOffset
        defaultMenuIconSize: control.defaultMenuIconSize
        defaultMenuIconSpacing: control.defaultMenuIconSpacing
        defaultMenuTextSize：control.defaultMenuTextSize
        defaultMenuWidth: control.defaultMenuWidth
        defaultMenuHeight: control.defaultMenuHeight
        defaultMenuSpacing: control.defaultMenuSpacing
        keepIconPlace: control.keepIconPlace
        onMenuClicked:
            (deep, key, keyPath, data) => {
                control.menuClicked(deep, key, keyPath, data);
                if (!data.hasOwnProperty('children')) {
                    close();
                }
            }
        menuIconDelegate: AntIconText {
            iconSize: menuButton.iconSize
            iconSource: menuButton.iconSource
            colorIcon: !menuButton.isGroup && menuButton.enabled ? control.themeSource.colorText : control.themeSource.colorTextDisabled
            verticalAlignment: Text.AlignVCenter

            Behavior on x {
                enabled: control.animationEnabled
                NumberAnimation { easing.type: Easing.OutCubic; duration: AntTheme.Primary.durationMid }
            }
            Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
        }
        menuLabelDelegate: AntText {
            text: menuButton.text
            font: menuButton.font
            color: !menuButton.isGroup && menuButton.enabled ? control.themeSource.colorText : control.themeSource.colorTextDisabled
            elide: Text.ElideRight

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
        }
        menuContentDelegate: Item {
            id: __menuContentItem

            property var __menuButton: menuButton
            property var model: menuButton.model
            property bool isGroup: menuButton.isGroup
            property bool hovered: menuButton.hovered

            Loader {
                id: __iconLoader
                x: menuButton.iconStart
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: menuButton.iconDelegate
                active: control.keepIconPlace || __private.hasDirectIcon
                visible: active
                property var model: __menuButton.model
                property alias menuButton: __menuContentItem.__menuButton
            }

            Loader {
                id: __labelLoader
                anchors.left: (control.keepIconPlace || __private.hasDirectIcon) ? __iconLoader.right : parent.left
                anchors.leftMargin: (control.keepIconPlace || __private.hasDirectIcon) ? menuButton.iconSpacing : 0
                anchors.right: menuButton.expandedVisible ? __expandedIcon.left : parent.right
                anchors.rightMargin: menuButton.iconSpacing
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: menuButton.labelDelegate
                property var model: __menuButton.model
                property alias menuButton: __menuContentItem.__menuButton
            }

            AntIconText {
                id: __expandedIcon
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: menuButton.expandedVisible
                iconSource: AntIcon.RightOutlined
                colorIcon: !isGroup && menuButton.enabled ? control.themeSource.colorText : control.themeSource.colorTextDisabled

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
            }
        }
        menuBgDelegate: AntRectangleInternal {
            radius: control.radiusMenuBg.all
            topLeftRadius: control.radiusMenuBg.topLeft
            topRightRadius: control.radiusMenuBg.topRight
            bottomLeftRadius: control.radiusMenuBg.bottomLeft
            bottomRightRadius: control.radiusMenuBg.bottomRight
            color: {
                if (enabled) {
                    if (menuButton.isGroup) return control.themeSource.colorBgDisabled;
                    else if (menuButton.pressed) return control.themeSource.colorBgActive;
                    else if (menuButton.hovered) return control.themeSource.colorBgHover;
                    else return control.themeSource.colorBg;
                } else {
                    return control.themeSource.colorBgDisabled;
                }
            }
            border.color: menuButton.colorBorder
            border.width: 1

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
        }
    }

    onInitModelChanged: {
        if (!control.keepIconPlace) {
            __private.hasDirectIcon = __private.checkDirectIcon(control.initModel);
        }
    }

    Item {
        id: __private
        property var window: Window.window
        property bool hasDirectIcon: false

        // 检查直接下级菜单项是否有图标的函数（不递归）
        function checkDirectIcon(model) {
            if (!model || !Array.isArray(model)) {
                return false;
            }
            for (let i = 0; i < model.length; i++) {
                const item = model[i];
                const icon = item.iconSource !== 0 && ((typeof item.iconSource === 'string' && item.iconSource !== '') || (typeof item.iconSource === 'object' && item.iconSource.toString() !== ''));
                if (icon) {
                    return true;
                }
            }
            return false;
        }
    }

    function open() {
        visible = true;
        if (parent && parent instanceof Item) {
            const pos = parent.mapToItem(null, x, y);
            if ((pos.x + implicitWidth + 6) > __private.window.width) {
                x = parent.mapFromItem(null, __private.window.width - 6, 0).x - implicitWidth;
            }
            if ((pos.y + implicitHeight + 6) > __private.window.height) {
                y = parent.mapFromItem(null, 0, __private.window.height - 6).y - implicitHeight;
            }
        }
    }
}
