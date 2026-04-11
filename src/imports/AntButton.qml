import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

T.Button {
    id: control

    enum ButtonType {
        TypeDefault = 0,
        TypeOutlined = 1,
        TypeDashed = 2,
        TypePrimary = 3,
        TypeFilled = 4,
        TypeText = 5,
        TypeLink = 6
    }

    enum ButtonShape {
        ShapeDefault = 0,
        ShapeCircle = 1
    }

    property bool animationEnabled: AntTheme.animationEnabled
    property bool active: down || checked
    property bool danger: false
    property bool effectEnabled: true
    property bool forceState: false
    property int hoverCursorShape: Qt.PointingHandCursor
    property int type: AntButton.TypeDefault
    property int shape: AntButton.ShapeDefault
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }
    property color colorText: {
        if (enabled || control.forceState) {
            if (control.danger) {
                switch (control.type) {
                    case AntButton.TypePrimary: return 'white';
                    case AntButton.TypeFilled:
                    case AntButton.TypeDefault:
                    case AntButton.TypeOutlined:
                    case AntButton.TypeDashed:
                    case AntButton.TypeText:
                    case AntButton.TypeLink:
                        return control.active ? control.themeSource.colorErrorTextActive : (control.hovered ? control.themeSource.colorErrorTextHover :  control.themeSource.colorError);
                }
            }
            switch (control.type) {
                case AntButton.TypeDefault:
                    return control.active ? control.themeSource.colorTextActive : (control.hovered ? control.themeSource.colorTextHover : control.themeSource.colorTextDefault);
                case AntButton.TypeOutlined:
                case AntButton.TypeDashed:
                    return control.active ? control.themeSource.colorTextActive : (control.hovered ? control.themeSource.colorTextHover : control.themeSource.colorText);
                case AntButton.TypePrimary:
                    return 'white';
                case AntButton.TypeFilled:
                case AntButton.TypeText:
                case AntButton.TypeLink:
                    return control.active ? control.themeSource.colorTextActive : (control.hovered ? control.themeSource.colorTextHover : control.themeSource.colorText);
                default:
                    return control.themeSource.colorText;
            }
        }
        return control.themeSource.colorTextDisabled;
    }
    property color colorBg: {
        if (control.type === AntButton.TypeLink) {
            return 'transparent';
        }
        if (enabled || control.forceState) {
            if (control.danger) {
                switch (control.type) {
                    case AntButton.TypePrimary:
                        return control.active ? control.themeSource.colorErrorBgActive: (control.hovered ? control.themeSource.colorErrorBgHover : control.themeSource.colorErrorBg);
                    case AntButton.TypeFilled:
                        return control.active ? control.themeSource.colorErrorFillBgActive: (control.hovered ? control.themeSource.colorErrorFillBgHover : control.themeSource.colorErrorFillBg);
                    case AntButton.TypeText:
                        return control.active ? control.themeSource.colorErrorFillBgActive: (control.hovered ? control.themeSource.colorErrorFillBg : 'transparent');
                    case AntButton.TypeDefault:
                    case AntButton.TypeOutlined:
                    case AntButton.TypeDashed:
                        return control.active ? control.themeSource.colorBgActive: (control.hovered ? control.themeSource.colorBgHover : control.themeSource.colorBg);
                    default: return control.themeSource.colorBg;
                }
            }
            switch (control.type) {
                case AntButton.TypeDefault:
                case AntButton.TypeOutlined:
                case AntButton.TypeDashed:
                    return control.active ? control.themeSource.colorBgActive : (control.hovered ? control.themeSource.colorBgHover : control.themeSource.colorBg);
                case AntButton.TypePrimary:
                    return control.active ? control.themeSource.colorPrimaryBgActive : (control.hovered ? control.themeSource.colorPrimaryBgHover : control.themeSource.colorPrimaryBg);
                case AntButton.TypeFilled:
                    if (AntTheme.isDark) {
                        return control.active ? control.themeSource.colorFillBgDarkActive : (control.hovered ? control.themeSource.colorFillBgDarkHover : control.themeSource.colorFillBgDark);
                    } else {
                        return control.active ? control.themeSource.colorFillBgActive : (control.hovered ? control.themeSource.colorFillBgHover : control.themeSource.colorFillBg);
                    }
                case AntButton.TypeText:
                    if (AntTheme.isDark) {
                        return control.active ? control.themeSource.colorFillBgDarkActive : (control.hovered ? control.themeSource.colorFillBgDarkHover : control.themeSource.colorTextBg);
                    } else {
                        return control.active ? control.themeSource.colorTextBgActive : (control.hovered ? control.themeSource.colorTextBgHover : control.themeSource.colorTextBg);
                    }
                default:
                    return control.themeSource.colorBg;
            }
        }
        return control.themeSource.colorBgDisabled;
    }
    property color colorBorder: {
        if (type === AntButton.TypeLink) {
            return 'transparent';
        }
        if (enabled || control.forceState) {
            if (control.danger) {
                switch (control.type) {
                    case AntButton.TypeDefault:
                        return (control.active || control.visualFocus) ? control.themeSource.colorBorderActive : (control.hovered ? control.themeSource.colorErrorBorderHover : control.themeSource.colorDefaultBorder);
                    default:
                        return (control.active || control.visualFocus) ? control.themeSource.colorErrorBorderActive: (control.hovered ? control.themeSource.colorErrorBorderHover : control.themeSource.colorErrorBorder);
                }
            }
            switch (control.type) {
                case AntButton.TypeDefault:
                    return (control.active || control.visualFocus) ? control.themeSource.colorBorderActive : (control.hovered ? control.themeSource.colorBorderHover : control.themeSource.colorDefaultBorder);
                default:
                    return (control.active || control.visualFocus) ? control.themeSource.colorBorderActive : (control.hovered ? control.themeSource.colorBorderHover : control.themeSource.colorBorder);
            }
        }
        return control.themeSource.colorBorderDisabled;
    }
    property string ariaConstrual: text
    property var themeSource: AntTheme.AntButton

    objectName: '__AntButton__'
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    padding: 15
    topPadding: 6
    bottomPadding: 6
    font {
        family: control.themeSource.fontFamily
        pixelSize: control.themeSource.fontSize
    }
    contentItem: Text {
        text: control.text
        font: control.font
        lineHeight: control.themeSource.fontLineHeight
        color: control.colorText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    }
    background: Item {
        AntRectangleInternal {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: __bg.r
            topLeftRadius: __bg.tl
            topRightRadius: __bg.tr
            bottomLeftRadius: __bg.bl
            bottomRightRadius: __bg.br
            anchors.centerIn: parent
            visible: control.effectEnabled && control.type !== AntButton.TypeLink
            color: 'transparent'
            border.width: 0
            border.color: (control.enabled || control.forceState) ? control.themeSource.colorBorderHover : 'transparent'
            opacity: 0.2

            ParallelAnimation {
                id: __animation
                onFinished: __effect.border.width = 0;
                NumberAnimation {
                    target: __effect; property: 'width'; from: __bg.width + 3; to: __bg.width + 8;
                    duration: AntTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'height'; from: __bg.height + 3; to: __bg.height + 8;
                    duration: AntTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'opacity'; from: 0.2; to: 0;
                    duration: AntTheme.Primary.durationSlow
                }
            }

            Connections {
                target: control
                function onReleased() {
                    if (control.animationEnabled && control.effectEnabled) {
                        __effect.border.width = 8;
                        __animation.restart();
                    }
                }
            }
        }

        Loader {
            id: __bg
            width: realWidth
            height: realHeight
            anchors.centerIn: parent
            sourceComponent: control.type === AntButton.TypeDashed ? __dashedBgComponent : __bgComponent
            property real r: control.radiusBg?.all ?? 0
            property real tl: control.shape === AntButton.ShapeDefault ? control.radiusBg?.topLeft ?? 0 : height / 2
            property real tr: control.shape === AntButton.ShapeDefault ? control.radiusBg?.topRight ?? 0 : height / 2
            property real bl: control.shape === AntButton.ShapeDefault ? control.radiusBg?.bottomLeft ?? 0 : height / 2
            property real br: control.shape === AntButton.ShapeDefault ? control.radiusBg?.bottomRight ?? 0 : height / 2
            property real realWidth: control.shape === AntButton.ShapeDefault ? parent.width : parent.height
            property real realHeight: control.shape === AntButton.ShapeDefault ? parent.height : parent.height
        }

        Component {
            id: __bgComponent

            AntRectangleInternal {
                color: control.colorBg
                border.width: (control.type === AntButton.TypeFilled || control.type === AntButton.TypeText) ? 0 : 1
                border.color: (control.enabled || control.forceState) ? control.colorBorder : 'transparent'
                radius: r
                topLeftRadius: tl
                topRightRadius: tr
                bottomLeftRadius: bl
                bottomRightRadius: br

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
                Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
            }
        }

        Component {
            id: __dashedBgComponent

            AntRectangle {
                color: control.colorBg
                border.width: (control.type === AntButton.TypeFilled || control.type === AntButton.TypeText) ? 0 : 1
                border.color: (control.enabled || control.forceState) ? control.colorBorder : 'transparent'
                border.style: Qt.DashLine
                radius: r
                topLeftRadius: tl
                topRightRadius: tr
                bottomLeftRadius: bl
                bottomRightRadius: br

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
                Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
            }
        }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: control.ariaConstrual
    Accessible.onPressAction: control.clicked();
}
