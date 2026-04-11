import QtQuick
import Antilla.Basic

Text {
    id: control

    readonly property bool hovered: __mouseArea.containsMouse
    property color colorText: control.themeSource.colorText
    property color colorTextDisabled: control.themeSource.colorTextDisabled
    property color colorTextHover: control.themeSource.colorTextHover
    property alias cursorShape: __mouseArea.cursorShape
    property var themeSource: AntTheme.AntText

    objectName: '__AntText__'
    renderType: AntTheme.textRenderType
    color: !control.enabled ? control.colorTextDisabled : (control.hovered ? control.colorTextHover : control.colorText)
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }

    MouseArea {
        id: __mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton    // 不接收任何鼠标按钮事件，只用于悬停检测
        z: -1
    }
}
