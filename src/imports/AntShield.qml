import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Item {
    id: control

    property bool animationEnabled: AntTheme.animationEnabled
    property bool leftEnabled: true
    property bool rightEnabled: true
    property string leftText: ''
    property string rightText: ''
    property font leftFont: Qt.font({
        family: AntTheme.AntShield.leftFontFamily,
        pixelSize: AntTheme.AntShield.leftFontSize
    })
    property font rightFont: Qt.font({
        family: AntTheme.AntShield.rightFontFamily,
        pixelSize: AntTheme.AntShield.rightFontSize
    })
    property color colorLeftBg: AntTheme.AntShield.colorLeftBg
    property color colorLeftText: AntTheme.AntShield.colorLeftText
    property color colorRightBg: AntTheme.AntShield.colorRightBg
    property color colorRightText: AntTheme.AntShield.colorRightText
    property AntRadius radiusBg: AntRadius { all: AntTheme.AntShield.radiusBg }

    // Delegate 属性
    property Component leftDelegate: __defaultLeftDelegate
    property Component rightDelegate: __defaultRightDelegate

    objectName: '__AntShield__'
    implicitWidth: __row.width
    implicitHeight: __row.height
    visible: leftEnabled || rightEnabled

    // 默认左侧 delegate
    Component {
        id: __defaultLeftDelegate
        AntText {
            text: control.leftText
            font: control.leftFont
            color: control.colorLeftText

            Behavior on color {
                enabled: control.animationEnabled
                ColorAnimation { duration: AntTheme.Primary.durationMid }
            }
        }
    }

    // 默认右侧 delegate
    Component {
        id: __defaultRightDelegate
        AntText {
            text: control.rightText
            font: control.rightFont
            color: control.colorRightText

            Behavior on color {
                enabled: control.animationEnabled
                ColorAnimation { duration: AntTheme.Primary.durationMid }
            }
        }
    }

    Row {
        id: __row
        spacing: 0

        // 左侧部分
        Loader {
            id: __leftLoader
            active: control.leftEnabled
            sourceComponent: AntRectangleInternal {
                implicitWidth: __leftContent.implicitWidth + 16
                implicitHeight: __leftContent.implicitHeight + 8
                color: control.colorLeftBg
                radius: control.radiusBg.all
                topLeftRadius: control.radiusBg.topLeft
                topRightRadius: control.rightEnabled ? 0 : control.radiusBg.topRight
                bottomLeftRadius: control.radiusBg.bottomLeft
                bottomRightRadius: control.rightEnabled ? 0 : control.radiusBg.bottomRight

                Behavior on color {
                    enabled: control.animationEnabled
                    ColorAnimation { duration: AntTheme.Primary.durationMid }
                }

                Loader {
                    id: __leftContent
                    anchors.centerIn: parent
                    sourceComponent: control.leftDelegate
                }
            }
        }

        // 右侧部分
        Loader {
            id: __rightLoader
            active: control.rightEnabled
            sourceComponent: AntRectangleInternal {
                implicitWidth: __rightContent.implicitWidth + 16
                implicitHeight: __rightContent.implicitHeight + 8
                color: control.colorRightBg
                radius: control.radiusBg.all
                topLeftRadius: control.leftEnabled ? 0 : control.radiusBg.topLeft
                topRightRadius: control.radiusBg.topRight
                bottomLeftRadius: control.leftEnabled ? 0 : control.radiusBg.bottomLeft
                bottomRightRadius: control.radiusBg.bottomRight

                Behavior on color {
                    enabled: control.animationEnabled
                    ColorAnimation { duration: AntTheme.Primary.durationMid }
                }

                Loader {
                    id: __rightContent
                    anchors.centerIn: parent
                    sourceComponent: control.rightDelegate
                }
            }
        }
    }
}
