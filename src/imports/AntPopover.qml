import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Antilla.Basic

AntPopup {
    id: control

    property bool iconVisible: control.iconSource !== 0 && control.iconSource !== ''
    property var iconSource: AntIcon.ExclamationCircleFilled || ''
    property int iconSize: 16
    property bool titleVisible: !!control.titleText
    property string titleText: ''
    property bool descriptionVisible: !!control.descriptionText
    property string descriptionText: ''
    property bool arrowVisible: true
    property int arrowWidth: 16
    property int arrowHeight: 8
    property color colorIcon: control.themeSource.colorIcon
    property color colorTitle: control.themeSource.colorTitle
    property color colorDescription: control.themeSource.colorDescription
    property font titleFont: Qt.font({
        family: control.themeSource.fontFamily,
        bold: true,
        pixelSize: parseInt(control.themeSource.fontTitleSize)
    })
    property font descriptionFont: Qt.font({
        family: control.themeSource.fontFamily,
        pixelSize: parseInt(control.themeSource.fontDescriptionSize)
    })
    property Component arrowDelegate: Canvas {
        id: __arrowDelegate
        width: arrowWidth
        height: arrowHeight
        onWidthChanged: requestPaint();
        onHeightChanged: requestPaint();
        onFillStyleChanged: requestPaint();
        onPaint: {
            const ctx = getContext('2d');
            ctx.fillStyle = fillStyle;
            ctx.beginPath();
            ctx.moveTo(0, height);
            ctx.lineTo(width / 2, 0);
            ctx.lineTo(width, height);
            ctx.closePath();
            ctx.fill();
        }
        property color fillStyle: control.colorBg
    }
    property Component iconDelegate: AntIconText {
        color: control.colorIcon
        iconSource: control.iconSource
        iconSize: control.iconSize
    }
    property Component titleDelegate: AntText {
        font: control.titleFont
        color: control.colorTitle
        text: control.titleText
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component descriptionDelegate: AntText {
        width: parent.width
        font: control.descriptionFont
        color: control.colorDescription
        text: control.descriptionText
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component contentDelegate: Item {
        height: __columnLayout.implicitHeight + 20

        ColumnLayout {
            id: __columnLayout
            width: parent.width - 20
            anchors.centerIn: parent
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                visible: __iconLoader.active || __titleLoader.active

                Loader {
                    id: __iconLoader
                    Layout.alignment: Qt.AlignVCenter
                    sourceComponent: control.iconDelegate
                    active: control.iconVisible
                    visible: active
                }

                Loader {
                    id: __titleLoader
                    Layout.alignment: Qt.AlignVCenter
                    sourceComponent: control.titleDelegate
                    active: control.titleVisible
                    visible: active
                }
            }

            Loader {
                Layout.leftMargin: __iconLoader.width + 5
                Layout.fillWidth: true
                sourceComponent: control.descriptionDelegate
                active: control.descriptionVisible
                visible: active
            }

            Loader {
                id: __footerLoader
                Layout.fillWidth: true
                sourceComponent: control.footerDelegate
            }
        }
    }
    property Component bgDelegate: AntRectangleInternal {
        color: control.colorBg
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }
    property Component footerDelegate: Item { }

    objectName: '__AntPopover__'
    themeSource: AntTheme.AntPopover
    implicitHeight: implicitBackgroundHeight + topInset + bottomInset
    transformOrigin: __private.isTop ? Item.Bottom : Item.Top
    enter: Transition {
        NumberAnimation {
            property: 'scale'
            from: 0.5
            to: 1.0
            easing.type: Easing.OutQuad
            duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        }
        NumberAnimation {
            property: 'opacity'
            from: 0.0
            to: 1.0
            easing.type: Easing.OutQuad
            duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        }
    }
    exit: Transition {
        NumberAnimation {
            property: 'scale'
            from: 1.0
            to: 0.5
            easing.type: Easing.InQuad
            duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        }
        NumberAnimation {
            property: 'opacity'
            from: 1.0
            to: 0
            easing.type: Easing.InQuad
            duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        }
    }
    background: Item {
        implicitHeight: __bg.height

        AntShadow {
            anchors.fill: __bg
            source: __bg
            shadowColor: control.colorShadow
        }

        Loader {
            active: control.movable || control.resizable
            sourceComponent: AntMouseResizeArea {
                anchors.fill: parent
                target: control
                movable: control.movable
                resizable: control.resizable
                minimumX: control.minimumX
                maximumX: control.maximumX
                minimumY: control.minimumY
                maximumY: control.maximumY
                minimumWidth: control.minimumWidth
                maximumWidth: control.maximumWidth
                minimumHeight: control.minimumHeight
                maximumHeight: control.maximumHeight
            }
        }

        Item {
            id: __bg
            width: parent.width
            height: __arrowLoader.height + __contentLoader.height

            Loader {
                id: __arrowLoader
                x: -control.x + (__private.parentWidth - width) / 2
                y: __private.isTop ? (__bg.height - height) : 0
                width: control.arrowWidth
                height: control.arrowHeight
                rotation: __private.isTop ? 180 : 0
                active: control.arrowVisible
                sourceComponent: control.arrowDelegate
            }

            Loader {
                id: __bgLoader
                y: __private.isTop ? 0 : __arrowLoader.height
                width: parent.width
                height: __contentLoader.height
                sourceComponent: control.bgDelegate
            }
        }

        Loader {
            id: __contentLoader
            y: __private.isTop ? 0 : __arrowLoader.height
            width: parent.width
            sourceComponent: control.contentDelegate
        }
    }

    Component.onCompleted: AntApi.setPopupAllowAutoFlip(this);

    QtObject {
        id: __private
        property real parentWidth: control.parent?.width ?? 0
        property real parentHeight: control.parent?.height ?? 0
        property bool isTop: control.y < parentHeight
    }
}
