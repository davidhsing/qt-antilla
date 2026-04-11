import QtQuick
import Antilla.Basic

AntRectangle {
    id: control

    property bool animationEnabled: AntTheme.animationEnabled
    property bool closable: false
    property var themeSource: AntTheme.AntMaskOverlay

    objectName: '__AntMaskOverlay__'
    anchors.fill: parent
    color: control.themeSource.colorBg
    visible: false

    signal clicked()

    Behavior on opacity {
        enabled: control.animationEnabled
        NumberAnimation {
            duration: AntTheme.Primary.durationMid
            easing.type: Easing.OutQuad
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (control.closable) {
                control.visible = false;
            }
            control.clicked();
        }
    }
}
