import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Antilla.Basic

AntPopover {
    id: control

    signal confirmed()
    signal canceled()

    property string confirmText: ''
    property string cancelText: ''
    property Component confirmDelegate: AntButton {
        animationEnabled: control.animationEnabled
        padding: 10
        topPadding: 4
        bottomPadding: 4
        text: control.confirmText
        type: AntButton.TypePrimary
        onClicked: control.confirmed();
    }
    property Component cancelDelegate: AntButton {
        animationEnabled: control.animationEnabled
        padding: 10
        topPadding: 4
        bottomPadding: 4
        text: control.cancelText
        type: AntButton.TypeDefault
        onClicked: control.canceled();
    }

    footerDelegate: Item {
        implicitHeight: __rowLayout.implicitHeight

        RowLayout {
            id: __rowLayout
            anchors.right: parent.right
            spacing: 10
            visible: __confirmLoader.active || __cancelLoader.active

            Loader {
                id: __confirmLoader
                active: !!control.confirmText
                visible: active
                sourceComponent: control.confirmDelegate
            }

            Loader {
                id: __cancelLoader
                active: !!control.cancelText
                visible: active
                sourceComponent: control.cancelDelegate
            }
        }
    }

    objectName: '__AntPopconfirm__'
}
