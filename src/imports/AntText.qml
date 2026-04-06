import QtQuick
import Antilla.Basic

Text {
    id: control

    readonly property bool hovered: __mouseArea.containsMouse
    property color colorText: themeSource.colorText
    property color colorTextDisabled: themeSource.colorTextDisabled
    property color colorTextHover: themeSource.colorTextHover
    property alias cursorShape: __mouseArea.cursorShape
    property var themeSource: AntTheme.AntText

    objectName: '__AntText__'
    renderType: AntTheme.textRenderType
    color: !control.enabled ? control.colorTextDisabled : (control.hovered ? control.colorTextHover : control.colorText)
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize)
    }

    MouseArea {
        id: __mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton    // 不接收任何鼠标按钮事件，只用于悬停检测
        z: -1
    }
}
