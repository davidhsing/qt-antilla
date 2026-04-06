import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Antilla.Basic

T.Drawer {
    id: control

    enum ClosePosition {
        PositionLeft = 0,
        PositionRight = 1
    }

    property bool animationEnabled: AntTheme.animationEnabled
    property bool maskClosable: true
    property int closePosition: AntDrawer.PositionLeft
    property int drawerSize: 378
    property bool titleVisible: !!control.titleText
    property string titleText: ''
    property font titleFont: Qt.font({
        family: AntTheme.AntDrawer.fontFamily,
        pixelSize: AntTheme.AntDrawer.fontSizeTitle
    })
    property color colorTitle: AntTheme.AntDrawer.colorTitle
    property color colorBg: AntTheme.AntDrawer.colorBg
    property color colorOverlay: AntTheme.AntDrawer.colorOverlay

    property Component closeDelegate: AntCaptionButton {
        topPadding: 2
        bottomPadding: 2
        leftPadding: 4
        rightPadding: 4
        anchors.verticalCenter: parent.verticalCenter
        animationEnabled: control.animationEnabled
        radiusBg.all: AntTheme.AntDrawer.radiusButtonBg
        iconSource: AntIcon.CloseOutlined
        hoverCursorShape: Qt.PointingHandCursor
        onClicked: {
            control.close();
        }
    }

    property Component titleDelegate: Item {
        height: 56

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            anchors.rightMargin: 15
            spacing: 5

            Loader {
                id: __closeLeftLoader
                sourceComponent: closeDelegate
                Layout.alignment: Qt.AlignVCenter
                active: control.closePosition === AntDrawer.PositionLeft
                visible: control.closePosition === AntDrawer.PositionLeft
            }

            AntText {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                text: control.titleText
                font: control.titleFont
                color: control.colorTitle
            }

            Loader {
                id: __closeRightLoader
                sourceComponent: closeDelegate
                Layout.alignment: Qt.AlignVCenter
                active: control.closePosition === AntDrawer.PositionRight
                visible: control.closePosition === AntDrawer.PositionRight
            }
        }

        AntDivider {
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            animationEnabled: control.animationEnabled
        }
    }

    property Component contentDelegate: Item { }

    objectName: '__AntDrawer__'
    width: edge == Qt.LeftEdge || edge == Qt.RightEdge ? drawerSize : parent.width
    height: edge == Qt.LeftEdge || edge == Qt.RightEdge ? parent.height : drawerSize
    edge: Qt.RightEdge
    parent: T.Overlay.overlay
    modal: true
    closePolicy: maskClosable ? T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside : T.Popup.NoAutoClose
    enter: Transition { NumberAnimation { duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0 } }
    exit: Transition { NumberAnimation { duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0 } }
    background: Item {
        AntShadow {
            anchors.fill: __rect
            source: __rect
            shadowColor: AntTheme.AntDrawer.colorShadow
        }

        Rectangle {
            id: __rect
            anchors.fill: parent
            color: control.colorBg
        }
    }
    contentItem: ColumnLayout {
        spacing: 0
        Loader {
            Layout.fillWidth: true
            sourceComponent: control.titleDelegate
            active: control.titleVisible
            visible: active
            onLoaded: {
                /*! 无边框窗口的标题栏会阻止事件传递, 需要调这个 */
                if (captionBar) {
                    captionBar.addInteractionItem(item);
                }
            }
        }
        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: control.contentDelegate
        }
    }

    // 因 qwindowkit 新版本逻辑变更（或者说 bug）, 无法继续使用
    // onAboutToShow: {
    //     if (captionBar && modal) {
    //         captionBar.enabled = false;
    //     }
    // }
    // onAboutToHide: {
    //     if (captionBar && modal) {
    //         captionBar.enabled = true;
    //     }
    // }

    T.Overlay.modal: Rectangle {
        color: control.colorOverlay
    }
}
