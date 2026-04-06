import QtQuick
import Antilla.Basic

AntButton {
    id: control

    enum IconPosition {
        PositionLeft = 0,
        PositionRight = 1
    }

    property bool loading: false
    property var iconSource: 0 ?? ''
    property int iconSize: AntTheme.AntButton.fontSize
    property int iconSpacing: 5
    property int iconPosition: AntIconButton.PositionLeft
    property color colorIcon: colorText

    objectName: '__AntIconButton__'

    contentItem: Item {
        implicitWidth: __row.implicitWidth
        implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight)

        Behavior on implicitWidth { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }

        Row {
            id: __row
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: control.iconSpacing
            layoutDirection: control.iconPosition === AntIconButton.PositionLeft ? Qt.LeftToRight : Qt.RightToLeft

            AntIconText {
                id: __icon
                anchors.verticalCenter: parent.verticalCenter
                color: control.colorIcon
                iconSize: control.iconSize
                iconSource: control.loading ? AntIcon.LoadingOutlined : control.iconSource
                verticalAlignment: Text.AlignVCenter
                visible: control.loading || (control.iconSource !== 0 && control.iconSource !== '')

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

                NumberAnimation on rotation {
                    running: control.loading
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1000
                    onRunningChanged: {
                        if (!running && !control.loading) {
                            __icon.rotation = 0;
                        }
                    }
                }
            }

            AntText {
                id: __text
                anchors.verticalCenter: parent.verticalCenter
                text: control.text
                font: control.font
                lineHeight: AntTheme.AntButton.fontLineHeight
                color: control.colorText
                elide: Text.ElideRight
                visible: !!control.text

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
            }
        }
    }
}
