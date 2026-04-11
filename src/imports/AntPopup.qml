import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

T.Popup {
    id: control

    property bool animationEnabled: AntTheme.animationEnabled
    property bool movable: false
    property bool resizable: false
    property real minimumX: Number.NaN
    property real maximumX: Number.NaN
    property real minimumY: Number.NaN
    property real maximumY: Number.NaN
    property real minimumWidth: 0
    property real maximumWidth: Number.NaN
    property real minimumHeight: 0
    property real maximumHeight: Number.NaN
    property color colorShadow: control.themeSource.colorShadow
    property color colorBg: AntTheme.isDark ? control.themeSource.colorBgDark : control.themeSource.colorBg
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }
    property var themeSource: AntTheme.AntPopup

    objectName: '__AntPopup__'
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    enter: Transition {
        NumberAnimation {
            property: 'opacity'
            from: 0.0
            to: 1.0
            easing.type: Easing.OutQuad
            duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        }
    }
    exit: Transition {
        NumberAnimation {
            property: 'opacity'
            from: 1.0
            to: 0
            easing.type: Easing.InQuad
            duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        }
    }
    background: Item {
        AntShadow {
            anchors.fill: __popupRect
            source: __popupRect
            shadowColor: control.colorShadow
        }
        AntRectangleInternal {
            id: __popupRect
            anchors.fill: parent
            color: control.colorBg
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
        }
        Loader {
            active: control.movable || control.resizable
            sourceComponent: AntMouseResizeArea {
                anchors.fill: parent
                target: control
                movable: control.movable
                resizable: control.resizable
                minimumX: control.minimumX
                maximumX: control.maximumX
                minimumY: control.minimumY
                maximumY: control.maximumY
                minimumWidth: control.minimumWidth
                maximumWidth: control.maximumWidth
                minimumHeight: control.minimumHeight
                maximumHeight: control.maximumHeight
            }
        }
    }

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
}
