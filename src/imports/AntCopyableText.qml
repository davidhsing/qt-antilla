import QtQuick
import Antilla.Basic

TextEdit {
    id: control

    property bool copyable: true
    property var themeSource: AntTheme.AntCopyableText

    objectName: '__AntCopyableText__'
    readOnly: true
    renderType: AntTheme.textRenderType
    color: control.themeSource.colorText
    selectByMouse: control.copyable
    selectByKeyboard: control.copyable
    selectedTextColor: control.themeSource.colorTextSelected
    selectionColor: control.themeSource.colorSelection
    font {
        family: control.themeSource.fontFamily
        pixelSize: control.themeSource.fontSize
    }
}
