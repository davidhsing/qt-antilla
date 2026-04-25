import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Antilla.Basic

AntPopup {
    id: control

    enum PopupPosition {
        PositionTop = 0,
        PositionBottom = 1,
        PositionCenter = 2,
        PositionLeft = 3,
        PositionRight = 4
    }

    signal confirmed()
    signal canceled()

    property int position: AntModal.PositionCenter
    property int positionMargin: 120
    property bool closable: true
    property bool maskClosable: !control.modal
    property var iconSource: 0 || ''
    property int iconSize: 24
    property string titleText: ''
    property string descriptionText: ''
    property string confirmText: ''
    property string cancelText: ''
    property color colorOverlay: control.themeSource.colorOverlay
    property color colorIcon: control.themeSource.colorIcon
    property color colorTitle: control.themeSource.colorTitle
    property color colorDescription: control.themeSource.colorDescription
    property font titleFont: Qt.font({
        family: control.themeSource.fontFamily,
        pixelSize: parseInt(control.themeSource.fontTitleSize),
        bold: true
    })
    property font descriptionFont: Qt.font({
        family: control.themeSource.fontFamily,
        pixelSize: parseInt(control.themeSource.fontDescriptionSize)
    })
    property bool bgVisible: true
    property bool iconVisible: control.iconSource !== 0 && control.iconSource !== ''
    property bool titleVisible: !!control.titleText
    property bool descriptionVisible: !!control.descriptionText
    property bool footerVisible: true
    property bool confirmDanger: false
    property int confirmType: AntButton.TypePrimary
    property bool confirmVisible: true
    property bool cancelDanger: false
    property int cancelType: AntButton.TypeDefault
    property bool cancelVisible: true
    property int widthRevision: -50
    property int heightRevision: 40
    property AntRadius radiusCloseBg: AntRadius { all: control.themeSource.radiusCloseBg }
    property Component bgDelegate: AntRectangleInternal {
        color: control.colorBg
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }
    property Component closeDelegate: AntCaptionButton {
        animationEnabled: control.animationEnabled
        topPadding: 4
        bottomPadding: 4
        leftPadding: 8
        rightPadding: 8
        hoverCursorShape: Qt.PointingHandCursor
        iconSource: AntIcon.CloseOutlined
        radiusBg: radiusCloseBg
        onClicked: control.close();
    }
    property Component iconDelegate: AntIconText {
        color: control.colorIcon
        iconSource: control.iconSource
        iconSize: control.iconSize
    }
    property Component titleDelegate: AntText {
        height: !control.titleText ? 0 : implicitHeight
        font: control.titleFont
        color: control.colorTitle
        text: control.titleText
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component descriptionDelegate: AntText {
        height: !control.descriptionText ? 0 : implicitHeight
        font: control.descriptionFont
        color: control.colorDescription
        text: control.descriptionText
        lineHeight: control.themeSource.fontDescriptionLineHeight
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component confirmDelegate: AntButton {
        animationEnabled: control.animationEnabled
        text: control.confirmText
        danger: control.confirmDanger
        type: control.confirmType
        visible: !!control.confirmText
        onClicked: control.confirmed();
    }
    property Component cancelDelegate: AntButton {
        animationEnabled: control.animationEnabled
        text: control.cancelText
        danger: control.cancelDanger
        type: control.cancelType
        visible: !!control.cancelText
        onClicked: control.canceled();
    }
    property Component footerDelegate: Item {
        height: __footer.height

        Row {
            id: __footer
            anchors.right: parent.right
            spacing: 10

            Loader {
                sourceComponent: control.confirmDelegate
                active: control.confirmVisible
                visible: active
            }

            Loader {
                sourceComponent: control.cancelDelegate
                active: control.cancelVisible
                visible: active
            }
        }
    }
    property Component contentDelegate: Item {
        height: __columnLayout.implicitHeight + control.heightRevision

        Column {
            id: __columnLayout
            width: parent.width + control.widthRevision
            anchors.centerIn: parent
            spacing: 10

            RowLayout {
                width: parent.width
                spacing: 10

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
                    Layout.fillWidth: true
                    sourceComponent: control.titleDelegate
                    active: control.titleVisible
                    visible: active
                }
            }

            Loader {
                width : parent.width
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: __iconLoader.active ? (__iconLoader.width + 10) : 0
                sourceComponent: control.descriptionDelegate
                active: control.descriptionVisible
                visible: active
            }

            Loader {
                width : parent.width
                sourceComponent: control.footerDelegate
                active: control.footerVisible
                visible: active
            }
        }

        Loader {
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.top: parent.top
            anchors.topMargin: 2
            sourceComponent: control.closeDelegate
            active: control.closable
            visible: active
        }
    }

    objectName: '__AntModal__'
    themeSource: AntTheme.AntModal
    parent: T.Overlay.overlay
    x: {
        switch (control.position) {
        case AntModal.PositionTop:
            return (parent.width - width) / 2;
        case AntModal.PositionBottom:
            return (parent.width - width) / 2;
        case AntModal.PositionCenter:
            return (parent.width - width) / 2;
        case AntModal.PositionLeft:
            return positionMargin;
        case AntModal.PositionRight:
            return parent.width - width - positionMargin;
        }
    }
    y: {
        switch (control.position) {
        case AntModal.PositionTop:
            return positionMargin;
        case AntModal.PositionBottom:
            return parent.height - height - positionMargin;
        case AntModal.PositionCenter:
            return (parent.height - height) / 2;
        case AntModal.PositionLeft:
            return (parent.height - height) / 2;
        case AntModal.PositionRight:
            return (parent.height - height) / 2;
        }
    }
    implicitHeight: implicitBackgroundHeight + topInset + bottomInset
    modal: true
    focus: true
    closePolicy: control.maskClosable ? T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside : T.Popup.NoAutoClose
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
    exit: null
    background: Item {
        implicitHeight: __bgLoader.height

        AntShadow {
            anchors.fill: __bgLoader
            source: __bgLoader
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

        Loader {
            id: __bgLoader
            width: parent.width
            height: __contentLoader.height
            sourceComponent: control.bgDelegate
            active: control.bgVisible
        }

        Loader {
            id: __contentLoader
            width: parent.width
            sourceComponent: control.contentDelegate
        }
    }
    onAboutToHide: {
        if (animationEnabled && !__private.isClosing && opacity > 0) {
            visible = true;
            __private.startClosing();
        }
    }
    T.Overlay.modal: Item {
        Rectangle {
            anchors.fill: parent
            color: control.colorOverlay
            opacity: control.opacity
        }
    }

    NumberAnimation {
        running: __private.isClosing
        target: control
        property: 'opacity'
        from: 1.0
        to: 0.0
        duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        easing.type: Easing.InQuad
        onFinished: {
            __private.isClosing = false;
            control.visible = false;
        }
    }

    NumberAnimation  {
        running: __private.isClosing
        target: control
        property: 'scale'
        from: 1.0
        to: 0.5
        easing.type: Easing.InQuad
        duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
    }

    function openInfo() {
        iconSource = AntIcon.ExclamationCircleFilled;
        colorIcon = AntTheme.Primary.colorInfo;
        open();
    }

    function openSuccess() {
        iconSource = AntIcon.CheckCircleFilled;
        colorIcon = AntTheme.Primary.colorSuccess;
        open();
    }

    function openError() {
        iconSource = AntIcon.CloseCircleFilled;
        colorIcon = AntTheme.Primary.colorError;
        open();
    }

    function openWarning() {
        iconSource = AntIcon.ExclamationCircleFilled;
        colorIcon = AntTheme.Primary.colorWarning;
        open();
    }

    function close() {
        if (!visible || __private.isClosing) return;
        if (animationEnabled) {
            __private.startClosing();
        } else {
            visible = false;
        }
    }

    QtObject {
        id: __private
        property bool isClosing: false

        function startClosing() {
            if (isClosing) return;
            isClosing = true;
        }
    }
}
