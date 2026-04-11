import QtQuick
import QtQuick.Shapes
import Antilla.Basic

Item {
    id: control

    enum AlignType {
        AlignLeft = 0,
        AlignCenter = 1,
        AlignRight = 2
    }

    enum LineStyle {
        LineSolid = 0,
        LineDashed = 1
    }

    property bool animationEnabled: AntTheme.animationEnabled
    property bool titleVisible: !!control.titleText
    property string titleText: ''
    property font titleFont: Qt.font({
        family: control.themeSource.fontFamily,
        pixelSize: parseInt(control.themeSource.fontSize)
    })
    property int titleAlign: AntDivider.AlignLeft
    property int titlePadding: 20
    property bool titleSplit: true
    property int lineStyle: AntDivider.LineSolid
    property real lineWidth: 1
    property list<real> dashPattern: [4, 2]
    property int orientation: Qt.Horizontal
    property color colorText: control.themeSource.colorText
    property color colorSplit: control.themeSource.colorSplit
    property var themeSource: AntTheme.AntDivider

    property Component titleDelegate: AntText {
        text: {
            if (control.orientation === Qt.Horizontal || !control.titleSplit) {
                return control.titleText;
            }
            return !control.titleText ? '' : control.titleText.split('').join('\n');
        }
        font: control.titleFont
        color: control.colorText
    }
    property Component splitDelegate: Shape {
        id: __shape

        property real lineX: __titleLoader.x + __titleLoader.implicitWidth / 2
        property real lineY: __titleLoader.y + __titleLoader.implicitHeight / 2

        ShapePath {
            strokeStyle: control.lineStyle === AntDivider.LineSolid ? ShapePath.SolidLine : ShapePath.DashLine
            strokeColor: control.colorSplit
            strokeWidth: control.lineWidth
            dashPattern: control.dashPattern
            fillColor: 'transparent'
            startX: control.orientation === Qt.Horizontal ? 0 : __shape.lineX
            startY: control.orientation === Qt.Horizontal ? __shape.lineY : 0

            PathLine {
                x: {
                    if (control.orientation === Qt.Horizontal) {
                        return control.titleText === '' ? 0 : __titleLoader.x - 10;
                    } else {
                        return __shape.lineX;
                    }
                }
                y: control.orientation === Qt.Horizontal ? __shape.lineY : __titleLoader.y - 10
            }
        }

        ShapePath {
            strokeStyle: control.lineStyle === AntDivider.LineSolid ? ShapePath.SolidLine : ShapePath.DashLine
            strokeColor: control.colorSplit
            strokeWidth: control.lineWidth
            dashPattern: control.dashPattern
            fillColor: 'transparent'
            startX: {
                if (control.orientation === Qt.Horizontal) {
                    return control.titleText === '' ? 0 : (__titleLoader.x + __titleLoader.implicitWidth + 10);
                } else {
                    return __shape.lineX;
                }
            }
            startY: {
                if (control.orientation === Qt.Horizontal) {
                    return __shape.lineY;
                } else {
                    return control.titleText === '' ? 0 : (__titleLoader.y + __titleLoader.implicitHeight + 10);
                }
            }

            PathLine {
                x: control.orientation === Qt.Horizontal ?  control.width : __shape.lineX
                y: control.orientation === Qt.Horizontal ? __shape.lineY : control.height
            }
        }
    }
    property string ariaConstrual: titleText

    objectName: '__AntDivider__'

    Behavior on colorSplit { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

    Loader {
        id: __splitLoader
        sourceComponent: control.splitDelegate
    }

    Loader {
        id: __titleLoader
        z: 1
        anchors.top: (control.orientation !== Qt.Horizontal && control.titleAlign === AntDivider.AlignLeft) ? parent.top : undefined
        anchors.topMargin: (control.orientation !== Qt.Horizontal && control.titleAlign === AntDivider.AlignLeft) ? control.titlePadding : 0
        anchors.bottom: (control.orientation !== Qt.Horizontal && control.titleAlign === AntDivider.AlignRight) ? parent.right : undefined
        anchors.bottomMargin: (control.orientation !== Qt.Horizontal && control.titleAlign === AntDivider.AlignRight) ? control.titlePadding : 0
        anchors.left: (control.orientation === Qt.Horizontal && control.titleAlign === AntDivider.AlignLeft) ? parent.left : undefined
        anchors.leftMargin: (control.orientation === Qt.Horizontal && control.titleAlign === AntDivider.AlignLeft) ? control.titlePadding : 0
        anchors.right: (control.orientation === Qt.Horizontal && control.titleAlign === AntDivider.AlignRight) ? parent.right : undefined
        anchors.rightMargin: (control.orientation === Qt.Horizontal && control.titleAlign === AntDivider.AlignRight) ? control.titlePadding : 0
        anchors.horizontalCenter: (control.orientation !== Qt.Horizontal || control.titleAlign === AntDivider.AlignCenter) ? parent.horizontalCenter : undefined
        anchors.verticalCenter: (control.orientation === Qt.Horizontal || control.titleAlign === AntDivider.AlignCenter) ? parent.verticalCenter : undefined
        sourceComponent: control.titleDelegate
        active: control.titleVisible
        visible: active
    }

    Accessible.role: Accessible.Separator
    Accessible.name: control.titleText
    Accessible.description: control.ariaConstrual
}
