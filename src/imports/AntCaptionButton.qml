import QtQuick
import Antilla.Basic

AntIconButton {
    id: control

    property var themeSource: AntTheme.AntCaptionButton

    objectName: '__AntCaptionButton__'
    leftPadding: 12
    rightPadding: 12
    radiusBg.all: 0
    hoverCursorShape: Qt.ArrowCursor
    type: AntButton.TypeText
    iconSize: control.themeSource.fontSize
    effectEnabled: false
    colorIcon: {
        if (control.enabled || control.forceState) {
            return checked ? control.themeSource.colorIconChecked : control.themeSource.colorIcon;
        }
        return control.themeSource.colorIconDisabled;
    }
    colorBg: {
        if (control.enabled || control.forceState) {
            if (danger) {
                return control.down ? control.themeSource.colorErrorBgActive: (control.hovered ? control.themeSource.colorErrorBgHover : control.themeSource.colorErrorBg);
            }
            return control.down ? control.themeSource.colorBgActive: (control.hovered ? control.themeSource.colorBgHover : control.themeSource.colorBg);
        }
        return control.themeSource.colorBgDisabled;
    }
}
