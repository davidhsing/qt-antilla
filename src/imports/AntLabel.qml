import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

T.Label {
    id: control

    readonly property bool hovered: __mouseArea.containsMouse
    property real borderWidth: 1
    property color colorText: themeSource.colorText
    property color colorTextDisabled: themeSource.colorTextDisabled
    property color colorTextHover: themeSource.colorTextHover
    property color colorBg: themeSource.colorBg
    property color colorBgDisabled: themeSource.colorBgDisabled
    property color colorBgHover: themeSource.colorBgHover
    property color colorBorder: themeSource.colorBorder
    property color colorBorderDisabled: themeSource.colorBorderDisabled
    property color colorBorderHover: themeSource.colorBorderHover
    property AntRadius radiusBg: AntRadius { all: 4 }
    property alias cursorShape: __mouseArea.cursorShape
    property var themeSource: AntTheme.AntLabel

    objectName: '__AntLabel__'
    renderType: AntTheme.textRenderType
    color: !control.enabled ? control.colorTextDisabled : (control.hovered ? control.colorTextHover : control.colorText)
    linkColor: !control.enabled ? themeSource.colorTextDisabled : themeSource.colorLinkText
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize)
    }
    background: AntRectangleInternal {
        color: !control.enabled ? control.colorBgDisabled : (control.hovered ? control.colorBgHover : control.colorBg)
        border.color: !control.enabled ? control.colorBorderDisabled : (control.hovered ? control.colorBorderHover : control.colorBorder)
        border.width: control.borderWidth
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }

    MouseArea {
        id: __mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton    // 不接收任何鼠标按钮事件，只用于悬停检测
        z: -1
    }
}
