import QtQuick
import Antilla.Basic

Window {
    id: window

    enum SpecialEffect {
        EffectNone = 0,
        EffectWinDwmBlur = 1,
        EffectWinAcrylicMaterial = 2,
        EffectWinMica = 3,
        EffectWinMicaAlt = 4,
        EffectMacBlurEffect = 10
    }

    property real contentHeight: height - captionBar.height
    property alias captionBar: __captionBar
    property alias windowAgent: __windowAgent
    property bool followThemeSwitch: true
    property bool initialized: false
    property int specialEffect: AntWindow.EffectNone
    property bool isDesktopPlatform: Qt.platform.os === 'windows' || Qt.platform.os === 'osx' || Qt.platform.os === 'linux'

    visible: true
    objectName: '__AntWindow__'

    Component.onCompleted: {
        initialized = true;
        setWindowMode(AntTheme.isDark);
        if (isDesktopPlatform) {
            __captionBar.windowAgent = __windowAgent;
        }
        if (followThemeSwitch) {
            __connections.onIsDarkChanged();
        }
    }

    AntWindowAgent {
        id: __windowAgent
    }

    AntCaptionBar {
        id: __captionBar
        z: 65535
        width: parent.width
        height: 30
        anchors.top: parent.top
        targetWindow: window
    }

    Connections {
        target: AntTheme
        enabled: Qt.platform.os === 'osx' /*! 需额外为 MACOSX 处理*/
        function onIsDarkChanged() {
            if (window.specialEffect === AntWindow.EffectMacBlurEffect) {
                windowAgent.setWindowAttribute('blur-effect', AntTheme.isDark ? 'dark' : 'light');
            }
        }
    }

    Connections {
        id: __connections
        target: AntTheme
        enabled: window.followThemeSwitch
        function onIsDarkChanged() {
            if (window.specialEffect === AntWindow.EffectNone) {
                window.color = AntTheme.Primary.colorBgBase;
            }
            window.setWindowMode(AntTheme.isDark);
        }
    }

    function setMacSystemButtonsVisible(visible) {
        if (Qt.platform.os === 'osx') {
            windowAgent.setWindowAttribute('no-system-buttons', !visible);
        }
    }

    function setWindowMode(isDark) {
        if (isDesktopPlatform) {
            if (window.initialized) {
                return windowAgent.setWindowAttribute('dark-mode', isDark);
            }
            return false;
        } else {
            return false;
        }
    }

    function setSpecialEffect(specialEffect) {
        if (Qt.platform.os === 'windows') {
            switch (specialEffect)
            {
                case AntWindow.EffectWinDwmBlur:
                    windowAgent.setWindowAttribute('acrylic-material', false);
                    windowAgent.setWindowAttribute('mica', false);
                    windowAgent.setWindowAttribute('mica-alt', false);
                    if (windowAgent.setWindowAttribute('dwm-blur', true)) {
                        window.specialEffect = AntWindow.EffectWinDwmBlur;
                        window.color = 'transparent'
                        return true;
                    } else {
                        return false;
                    }
                case AntWindow.EffectWinAcrylicMaterial:
                    windowAgent.setWindowAttribute('dwm-blur', false);
                    windowAgent.setWindowAttribute('mica', false);
                    windowAgent.setWindowAttribute('mica-alt', false);
                    if (windowAgent.setWindowAttribute('acrylic-material', true)) {
                        window.specialEffect = AntWindow.EffectWinAcrylicMaterial;
                        window.color = 'transparent';
                        return true;
                    } else {
                        return false;
                    }
                case AntWindow.EffectWinMica:
                    windowAgent.setWindowAttribute('dwm-blur', false);
                    windowAgent.setWindowAttribute('acrylic-material', false);
                    windowAgent.setWindowAttribute('mica-alt', false);
                    if (windowAgent.setWindowAttribute('mica', true)) {
                        window.specialEffect = AntWindow.EffectWinMica;
                        window.color = 'transparent';
                        return true;
                    } else {
                        return false;
                    }
                case AntWindow.EffectWinMicaAlt:
                    windowAgent.setWindowAttribute('dwm-blur', false);
                    windowAgent.setWindowAttribute('acrylic-material', false);
                    windowAgent.setWindowAttribute('mica', false);
                    if (windowAgent.setWindowAttribute('mica-alt', true)) {
                        window.specialEffect = AntWindow.EffectWinMicaAlt;
                        window.color = 'transparent';
                        return true;
                    } else {
                        return false;
                    }
                case AntWindow.EffectNone:
                default:
                    windowAgent.setWindowAttribute('dwm-blur', false);
                    windowAgent.setWindowAttribute('acrylic-material', false);
                    windowAgent.setWindowAttribute('mica', false);
                    windowAgent.setWindowAttribute('mica-alt', false);
                    window.specialEffect = AntWindow.EffectNone;
                    window.color = AntTheme.Primary.colorBgBase;
                    return true;
            }
        } else if (Qt.platform.os === 'osx') {
            switch (specialEffect) {
                case AntWindow.EffectMacBlurEffect:
                    if (windowAgent.setWindowAttribute('blur-effect', AntTheme.isDark ? 'dark' : 'light')) {
                        window.specialEffect = AntWindow.EffectMacBlurEffect;
                        window.color = 'transparent'
                        return true;
                    } else {
                        return false;
                    }
                case AntWindow.EffectNone:
                default:
                    windowAgent.setWindowAttribute('blur-effect', 'none');
                    window.specialEffect = AntWindow.EffectNone;
                    window.color = AntTheme.Primary.colorBgBase;
                    return true;
            }
        }
        return false;
    }
}
