import QtQuick
import Antilla.Basic

AntText {
    id: control

    readonly property bool empty: iconSource === 0 || (typeof control.iconSource === 'string' && control.iconSource === '') || (typeof control.iconSource === 'object' && control.iconSource.toString() === '')
    property var iconSource: 0 ?? ''
    property alias iconSize: control.font.pixelSize
    property alias colorIcon: control.colorText
    property alias colorIconHover: control.colorTextHover
    property string ariaConstrual: text
    property var themeSource: AntTheme.AntIconText

    objectName: '__AntIconText__'
    width: __iconLoader.active ? (__iconLoader.implicitWidth + leftPadding + rightPadding): implicitWidth
    height: __iconLoader.active ? (__iconLoader.implicitHeight + topPadding + bottomPadding) : implicitHeight
    text: __iconLoader.active ? '' : String.fromCharCode(iconSource)
    font.family: 'Antilla-Icons'
    font.pixelSize: control.themeSource.fontSize

    Loader {
        id: __iconLoader
        anchors.centerIn: parent
        sourceComponent: Image {
            source: control.iconSource
            width: control.iconSize
            height: control.iconSize
            sourceSize: Qt.size(width, height)
        }
        active: control.iconSource !== 0 && ((typeof control.iconSource === 'string' && control.iconSource !== '') || (typeof control.iconSource === 'object' && control.iconSource.toString() !== ''))
        visible: active
    }

    Accessible.role: Accessible.StaticText
    Accessible.name: control.text
    Accessible.description: control.ariaConstrual
}
