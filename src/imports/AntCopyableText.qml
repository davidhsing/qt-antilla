import QtQuick
import Antilla.Basic

TextEdit {
    id: control

    property bool copyable: true

    objectName: '__AntCopyableText__'
    readOnly: true
    renderType: AntTheme.textRenderType
    color: AntTheme.AntCopyableText.colorText
    selectByMouse: control.copyable
    selectByKeyboard: control.copyable
    selectedTextColor: AntTheme.AntCopyableText.colorTextSelected
    selectionColor: AntTheme.AntCopyableText.colorSelection
    font {
        family: AntTheme.AntCopyableText.fontFamily
        pixelSize: AntTheme.AntCopyableText.fontSize
    }
}
