import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

T.Label {
    id: control

    readonly property bool hovered: __mouseArea.containsMouse
    property real borderWidth: 1
    property color colorText: control.themeSource.colorText
    property color colorTextDisabled: control.themeSource.colorTextDisabled
    property color colorTextHover: control.themeSource.colorTextHover
    property color colorBg: control.themeSource.colorBg
    property color colorBgDisabled: control.themeSource.colorBgDisabled
    property color colorBgHover: control.themeSource.colorBgHover
    property color colorBorder: control.themeSource.colorBorder
    property color colorBorderDisabled: control.themeSource.colorBorderDisabled
    property color colorBorderHover: control.themeSource.colorBorderHover
    property AntRadius radiusBg: AntRadius { all: 4 }
    property alias cursorShape: __mouseArea.cursorShape
    property var themeSource: AntTheme.AntLabel

    objectName: '__AntLabel__'
    renderType: AntTheme.textRenderType
    color: !control.enabled ? control.colorTextDisabled : (control.hovered ? control.colorTextHover : control.colorText)
    linkColor: !control.enabled ? control.themeSource.colorTextDisabled : control.themeSource.colorLinkText
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
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
