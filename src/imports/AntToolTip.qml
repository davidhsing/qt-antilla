import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

T.ToolTip {
    id: control

    enum Position {
        PositionTop = 0,
        PositionBottom = 1,
        PositionLeft = 2,
        PositionRight = 3
    }

    property bool animationEnabled: AntTheme.animationEnabled
    property bool arrowVisible: false
    property int arrowOffset: 4
    property int position: AntToolTip.PositionTop
    property color colorShadow: AntTheme.AntToolTip.colorShadow
    property color colorText: AntTheme.AntToolTip.colorText
    property color colorBg: AntTheme.isDark ? AntTheme.AntToolTip.colorBgDark : AntTheme.AntToolTip.colorBg
    property AntRadius radiusBg: AntRadius { all: AntTheme.AntToolTip.radiusBg }

    component Arrow: Canvas {
        onWidthChanged: requestPaint();
        onHeightChanged: requestPaint();
        onColorBgChanged: requestPaint();
        onPaint: {
            const ctx = getContext('2d');
            ctx.fillStyle = colorBg;
            ctx.beginPath();
            switch (position) {
                case AntToolTip.PositionTop: {
                    ctx.moveTo(0, 0);
                    ctx.lineTo(width, 0);
                    ctx.lineTo(width / 2, height);
                }
                break;
                case AntToolTip.PositionBottom: {
                    ctx.moveTo(0, height);
                    ctx.lineTo(width, height);
                    ctx.lineTo(width / 2, 0);
                }
                break;
                case AntToolTip.PositionLeft: {
                    ctx.moveTo(0, 0);
                    ctx.lineTo(0, height);
                    ctx.lineTo(width, height / 2);
                }
                break;
                case AntToolTip.PositionRight: {
                    ctx.moveTo(width, 0);
                    ctx.lineTo(width, height);
                    ctx.lineTo(0, height / 2);
                }
                break;
            }
            ctx.closePath();
            ctx.fill();
        }
        property color colorBg: control.colorBg
    }

    x: {
        switch (position) {
            case AntToolTip.PositionTop:
            case AntToolTip.PositionBottom:
                return (__private.controlParentWidth - implicitWidth) / 2;
            case AntToolTip.PositionLeft:
                return -implicitWidth - control.arrowOffset;
            case AntToolTip.PositionRight:
                return __private.controlParentWidth + control.arrowOffset;
        }
    }
    y: {
        switch (position) {
            case AntToolTip.PositionTop:
                return -implicitHeight - control.arrowOffset;
            case AntToolTip.PositionBottom:
                return __private.controlParentHeight + control.arrowOffset;
            case AntToolTip.PositionLeft:
            case AntToolTip.PositionRight:
                return (__private.controlParentHeight - implicitHeight) / 2;
        }
    }

    objectName: '__AntToolTip__'
    implicitWidth: implicitContentWidth
    implicitHeight: implicitContentHeight
    delay: 500
    padding: 0
    font {
        family: AntTheme.AntToolTip.fontFamily
        pixelSize: AntTheme.AntToolTip.fontSize
    }
    enter: Transition {
        NumberAnimation { property: 'opacity'; from: 0.0; to: 1.0; duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0 }
    }
    exit: Transition {
        NumberAnimation { property: 'opacity'; from: 1.0; to: 0.0; duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0 }
    }
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent
    contentItem: Item {
        implicitWidth: __bg.width + (__private.isHorizontal ? 0 : __arrow.width)
        implicitHeight: __bg.height + (__private.isHorizontal ? __arrow.height : 0)

        AntShadow {
            anchors.fill: __item
            source: __item
            shadowColor: control.colorShadow
        }

        Item {
            id: __item
            anchors.fill: parent

            Arrow {
                id: __arrow
                x: __private.isHorizontal ? (-control.x + (__private.controlParentWidth - width) / 2) : 0
                y: __private.isHorizontal ? 0 : (-control.y + (__private.controlParentHeight - height)) / 2
                width: __private.arrowSize.width
                height: __private.arrowSize.height
                anchors.top: control.position === AntToolTip.PositionBottom ? parent.top : undefined
                anchors.bottom: control.position === AntToolTip.PositionTop ? parent.bottom : undefined
                anchors.left: control.position === AntToolTip.PositionRight ? parent.left : undefined
                anchors.right: control.position === AntToolTip.PositionLeft ? parent.right : undefined

                Connections {
                    target: control
                    function onPositionChanged() {
                        __arrow.requestPaint();
                    }
                }
            }

            AntRectangleInternal {
                id: __bg
                width: __text.implicitWidth + 14
                height: __text.implicitHeight + 12
                anchors.top: control.position === AntToolTip.PositionTop ? parent.top : undefined
                anchors.bottom: control.position === AntToolTip.PositionBottom ? parent.bottom : undefined
                anchors.left: control.position === AntToolTip.PositionLeft ? parent.left : undefined
                anchors.right: control.position === AntToolTip.PositionRight ? parent.right : undefined
                anchors.margins: 1
                color: control.colorBg
                radius: control.radiusBg.all
                topLeftRadius: control.radiusBg.topLeft
                topRightRadius: control.radiusBg.topRight
                bottomLeftRadius: control.radiusBg.bottomLeft
                bottomRightRadius: control.radiusBg.bottomRight

                AntText {
                    id: __text
                    text: control.text
                    font: control.font
                    color: control.colorText
                    wrapMode: Text.Wrap
                    anchors.centerIn: parent
                }
            }
        }
    }
    background: Item { }

    QtObject {
        id: __private
        property bool isHorizontal: control.position === AntToolTip.PositionTop || control.position === AntToolTip.PositionBottom
        property size arrowSize: control.arrowVisible ? (isHorizontal ? Qt.size(12, 6) : Qt.size(6, 12)) : Qt.size(0, 0)
        property real controlParentWidth: control.parent ? control.parent.width : 0
        property real controlParentHeight: control.parent ? control.parent.height : 0
    }
}
