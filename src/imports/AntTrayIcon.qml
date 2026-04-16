import QtQuick
import Qt.labs.platform as Platform
import Antilla.Basic

Item {
    id: control
    visible: false

    signal activated(int reason)

    // ---- Tray Icon ----
    property alias iconVisible: __trayIcon.visible
    property var iconSource: 0 ?? ''
    property alias tooltip: __trayIcon.tooltip

    // ---- Icon Animation ----
    property bool iconAnimationEnabled: false
    property var iconFrames: []
    property int iconFrameInterval: 500
    property int iconFrameLoops: -1    // -1 = infinite

    // ---- Popup Menu ----
    property AntMenu menu: null
    property bool menuAnimationEnabled: AntTheme.animationEnabled
    property bool menuShadowVisible: false
    property color colorBg: AntTheme.isDark ? AntTheme.AntPopup.colorBgDark : AntTheme.AntPopup.colorBg
    property color colorShadow: AntTheme.AntPopup.colorShadow
    property AntRadius radiusBg: AntRadius { all: AntTheme.AntPopup.radiusBg }
    readonly property bool menuVisible: __menuWindow.visible

    objectName: '__AntTrayIcon__'

    // ---- Internal: System Tray Icon ----
    Platform.SystemTrayIcon {
        id: __trayIcon
        visible: true
        icon.source: (typeof control.iconSource === 'object') ? control.iconSource.toString() : control.iconSource
        onActivated: (reason) => {
            control.activated(reason);
            if (reason === Platform.SystemTrayIcon.Context || reason === Platform.SystemTrayIcon.Trigger) {
                if (control.menu) {
                    __private.toggleMenu();
                }
            }
        }
    }

    // ---- Internal: Icon Animation Timer ----
    Timer {
        id: __iconAnimTimer
        interval: control.iconFrameInterval
        repeat: true
        running: control.iconAnimationEnabled && control.iconFrames.length > 1
        onTriggered: {
            __private.currentFrame++;
            if (__private.currentFrame >= control.iconFrames.length) {
                if (control.iconFrameLoops !== -1) {
                    __private.loopCount++;
                    if (__private.loopCount >= control.iconFrameLoops) {
                        control.iconAnimationEnabled = false;
                        __private.currentFrame = 0;
                        __private.loopCount = 0;
                        // Restore original icon
                        if (__private.originalIcon !== '') {
                            control.iconSource = __private.originalIcon;
                        }
                        return;
                    }
                }
                __private.currentFrame = 0;
            }
            control.iconSource = control.iconFrames[__private.currentFrame];
        }
        onRunningChanged: {
            if (running) {
                // Save original icon before animation starts
                __private.originalIcon = control.iconSource;
                __private.currentFrame = 0;
                __private.loopCount = 0;
                if (control.iconFrames.length > 0) {
                    control.iconSource = control.iconFrames[0];
                }
            } else {
                // Restore original icon when stopped
                if (__private.originalIcon !== '') {
                    control.iconSource = __private.originalIcon;
                }
                __private.currentFrame = 0;
                __private.loopCount = 0;
            }
        }
    }

    // ---- Internal: Menu Window ----
    Window {
        id: __menuWindow
        flags: Qt.FramelessWindowHint | Qt.Popup
        color: 'transparent'
        width: __menuContainer.implicitWidth
        height: __menuContainer.implicitHeight
        visible: false
        onActiveChanged: {
            if (!active && visible) {
                __private.closeMenu();
            }
        }
        onVisibleChanged: {
            if (!visible) {
                __private.menuOpacity = 0;
                __private.menuScale = 0.01;
            }
        }

        Item {
            id: __menuContainer
            property int __shadowMargin: 6  // 仅为阴影留空间

            implicitWidth: (control.menu ? control.menu.implicitWidth : 0) + __shadowMargin * 2
            implicitHeight: (control.menu ? control.menu.implicitHeight : 0) + __shadowMargin * 2
            opacity: __private.menuOpacity
            scale: __private.menuScale
            transformOrigin: Item.BottomRight

            AntShadow {
                anchors.fill: parent
                source: __bgRect
                shadowEnabled: control.menuShadowVisible
                shadowColor: control.colorShadow
            }

            AntRectangleInternal {
                id: __bgRect
                x: __menuContainer.__shadowMargin
                y: __menuContainer.__shadowMargin
                width: control.menu ? control.menu.width : 0
                height: control.menu ? control.menu.height : 0
                color: control.colorBg
                radius: control.radiusBg.all
                topLeftRadius: control.radiusBg.topLeft
                topRightRadius: control.radiusBg.topRight
                bottomLeftRadius: control.radiusBg.bottomLeft
                bottomRightRadius: control.radiusBg.bottomRight
            }
        }

        // ---- Open Animation ----
        ParallelAnimation {
            id: __openAnim
            NumberAnimation {
                target: __private
                property: 'menuOpacity'
                from: 0.0; to: 1.0
                easing.type: Easing.OutCubic
                duration: control.menuAnimationEnabled ? AntTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                target: __private
                property: 'menuScale'
                from: 0.01; to: 1.0
                easing.type: Easing.OutCubic
                duration: control.menuAnimationEnabled ? AntTheme.Primary.durationMid : 0
            }
            ScriptAction {
                script: {
                    __menuContainer.transformOrigin = Item.Bottom;
                }
            }
        }

        // ---- Close Animation ----
        SequentialAnimation {
            id: __closeAnim
            ParallelAnimation {
                NumberAnimation {
                    target: __private
                    property: 'menuOpacity'
                    from: 1.0; to: 0.0
                    easing.type: Easing.InCubic
                    duration: control.menuAnimationEnabled ? AntTheme.Primary.durationFast : 0
                }
                NumberAnimation {
                    target: __private
                    property: 'menuScale'
                    from: 1.0; to: 0.01
                    easing.type: Easing.InCubic
                    duration: control.menuAnimationEnabled ? AntTheme.Primary.durationFast : 0
                }
                ScriptAction {
                    script: {
                        __menuContainer.transformOrigin = Item.Top;
                    }
                }
            }
            ScriptAction {
                script: {
                    __menuWindow.visible = false;
                }
            }
        }
    }

    onIconVisibleChanged: {
        if (!iconVisible && __menuWindow.visible) {
            __private.closeMenu();
        }
    }
    onMenuChanged: {
        if (menu) {
            menu.parent = __menuContainer;
            menu.x = Qt.binding(() => __menuContainer.__shadowMargin);
            menu.y = Qt.binding(() => __menuContainer.__shadowMargin);
            menu.popupMode = true;
        }
    }

    function open() {
        __private.openMenu();
    }

    function close() {
        __private.closeMenu();
    }

    // ---- Internal: Private State ----
    QtObject {
        id: __private
        property int currentFrame: 0
        property int loopCount: 0
        property url originalIcon: ''
        property real menuOpacity: 0
        property real menuScale: 0.01

        function toggleMenu() {
            if (__menuWindow.visible) {
                closeMenu();
            } else {
                openMenu();
            }
        }

        function openMenu() {
            if (!control.menu) {
                return;
            }
            const pos = AntApi.cursorPos();
            const screen = __menuWindow.screen;
            const menuW = __menuWindow.width;
            const menuH = __menuWindow.height;
            // Position: try to show above-left of cursor (typical tray behavior)
            let wx = pos.x;
            let wy = pos.y - menuH;
            // Screen bounds check
            if (wx + menuW > screen.virtualX + screen.width) {
                wx = screen.virtualX + screen.width - menuW;
            }
            if (wx < screen.virtualX) {
                wx = screen.virtualX;
            }
            if (wy < screen.virtualY) {
                wy = pos.y;
            }
            if (wy + menuH > screen.virtualY + screen.height) {
                wy = screen.virtualY + screen.height - menuH;
            }
            __menuWindow.x = wx;
            __menuWindow.y = wy;
            __menuWindow.visible = true;
            __menuWindow.requestActivate();
            __openAnim.restart();
        }

        function closeMenu() {
            if (__closeAnim.running) {
                return;
            }
            __closeAnim.restart();
        }
    }
}
