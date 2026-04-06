import QtQuick
import Antilla.Basic

AntIconButton {
    id: control

    objectName: '__AntCaptionButton__'
    leftPadding: 12
    rightPadding: 12
    radiusBg.all: 0
    hoverCursorShape: Qt.ArrowCursor
    type: AntButton.TypeText
    iconSize: AntTheme.AntCaptionButton.fontSize
    effectEnabled: false
    colorIcon: {
        if (control.enabled || control.forceState) {
            return checked ? AntTheme.AntCaptionButton.colorIconChecked : AntTheme.AntCaptionButton.colorIcon;
        }
        return AntTheme.AntCaptionButton.colorIconDisabled;
    }
    colorBg: {
        if (control.enabled || control.forceState) {
            if (danger) {
                return control.down ? AntTheme.AntCaptionButton.colorErrorBgActive: (control.hovered ? AntTheme.AntCaptionButton.colorErrorBgHover : AntTheme.AntCaptionButton.colorErrorBg);
            }
            return control.down ? AntTheme.AntCaptionButton.colorBgActive: (control.hovered ? AntTheme.AntCaptionButton.colorBgHover : AntTheme.AntCaptionButton.colorBg);
        }
        return AntTheme.AntCaptionButton.colorBgDisabled;
    }
}
