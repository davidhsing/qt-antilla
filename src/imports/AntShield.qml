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
        family: control.themeSource.leftFontFamily,
        pixelSize: control.themeSource.leftFontSize
    })
    property font rightFont: Qt.font({
        family: control.themeSource.rightFontFamily,
        pixelSize: control.themeSource.rightFontSize
    })
    property color colorLeftBg: control.themeSource.colorLeftBg
    property color colorLeftText: control.themeSource.colorLeftText
    property color colorRightBg: control.themeSource.colorRightBg
    property color colorRightText: control.themeSource.colorRightText
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }
    property Component leftDelegate: __defaultLeftDelegate
    property Component rightDelegate: __defaultRightDelegate
    property var themeSource: AntTheme.AntShield

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
