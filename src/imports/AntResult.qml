import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Item {
    id: control

    enum ResultType {
        TypeInfo = 0,
        TypeWarning = 1,
        TypeSuccess = 2,
        TypeError = 3
    }

    enum ExtraPosition {
        PositionLeft = 0,
        PositionRight = 1
    }

    // Basic properties
    property bool animationEnabled: AntTheme.animationEnabled
    property bool borderVisible: true
    property int spacing: 16
    property int type: AntResult.TypeInfo

    // Icon properties
    property bool iconVisible: control.iconSource !== 0 && control.iconSource !== ''
    property var iconSource: {
        switch (control.type) {
            case AntResult.TypeInfo: return AntIcon.ExclamationCircleFilled;
            case AntResult.TypeWarning: return AntIcon.ExclamationCircleFilled;
            case AntResult.TypeSuccess: return AntIcon.CheckCircleFilled;
            case AntResult.TypeError: return AntIcon.CloseCircleFilled;
            default: return AntIcon.ExclamationCircleFilled;
        }
    }
    property real iconSize: 80
    property var iconImageSource: ''
    property var iconImageFallback: ''
    property int iconImageFillMode: Image.PreserveAspectFit
    property bool iconImageEmptyAsError: false
    property int iconImageWidth: -1
    property int iconImageHeight: -1
    property color colorIcon: {
        switch (control.type) {
            case AntResult.TypeInfo: return AntTheme.Primary.colorInfo;
            case AntResult.TypeWarning: return AntTheme.Primary.colorWarning;
            case AntResult.TypeSuccess: return AntTheme.Primary.colorSuccess;
            case AntResult.TypeError: return AntTheme.Primary.colorError;
            default: return AntTheme.Primary.colorInfo;
        }
    }

    // Extra properties
    property bool extraVisible: true
    property int extraPosition: AntResult.PositionRight

    // Title properties
    property bool titleVisible: !!control.titleText
    property string titleText: ''
    property font titleFont: Qt.font({
        family: control.themeSource.fontTitleFamily,
        pixelSize: control.themeSource.fontTitleSize
    })

    // Description properties
    property bool descriptionVisible: !!control.descriptionText
    property string descriptionText: ''
    property font descriptionFont: Qt.font({
        family: control.themeSource.fontDescriptionFamily,
        pixelSize: control.themeSource.fontDescriptionSize
    })

    // Action properties
    property bool actionVisible: true

    // Footer properties
    property bool footerVisible: true

    // Background properties
    property color colorBg: control.themeSource.colorBg
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }

    // Margin properties
    property AntMargin marginExtra: AntMargin { all: 0 }
    property AntMargin marginIcon: AntMargin { top: 8; bottom: 0 }
    property AntMargin marginTitle: AntMargin { top: 4; bottom: 0 }
    property AntMargin marginDescription: AntMargin { all: 0 }
    property AntMargin marginAction: AntMargin { all: 0 }
    property AntMargin marginFooter: AntMargin { all: 0 }

    // Delegates
    property Component iconDelegate: ColumnLayout {
        implicitHeight: __iconLoader.item ? __iconLoader.item.implicitHeight : control.iconSize
        implicitWidth: __iconLoader.item ? __iconLoader.item.implicitWidth : control.iconSize

        Loader {
            id: __iconLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            sourceComponent: (typeof control.iconImageSource === 'string' && control.iconImageSource !== '') || (typeof control.iconImageSource === 'object' && control.iconImageSource.toString() !== '') ? __iconImageComp : __iconTextComp
        }

        Component {
            id: __iconImageComp
            AntImage {
                id: __iconImage
                anchors.fill: parent
                emptyAsError: control.iconImageEmptyAsError
                fallback: control.iconImageFallback
                fillMode: control.iconImageFillMode
                horizontalAlignment: Text.AlignHCenter
                width: control.iconImageWidth > 0 ? control.iconImageWidth : implicitWidth
                height: control.iconImageHeight > 0 ? control.iconImageHeight : implicitHeight
                source: control.iconImageSource
            }
        }

        Component {
            id: __iconTextComp
            AntIconText {
                id: __iconText
                anchors.fill: parent
                color: control.colorIcon
                iconSource: control.iconSource
                iconSize: control.iconSize
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
    property Component extraDelegate: Item { }
    property Component titleDelegate: AntText {
        text: control.titleText
        font: control.titleFont
        color: control.themeSource.colorTitle
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: !!control.titleText
    }
    property Component descriptionDelegate: AntText {
        text: control.descriptionText
        font: control.descriptionFont
        color: control.themeSource.colorDescription
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: !!control.descriptionText
    }
    property Component actionDelegate: Item { }
    property Component footerDelegate: Item { }
    property Component bgDelegate: AntRectangleInternal {
        border.color: control.themeSource.colorBorder
        border.width: 1
        color: control.colorBg
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }
    property var themeSource: AntTheme.AntResult

    objectName: '__AntResult__'
    implicitWidth: Math.max(__bgLoader.implicitWidth, __mainLayout.implicitWidth)
    implicitHeight: Math.max(__bgLoader.implicitHeight, __mainLayout.implicitHeight)
    width: parent.width
    height: implicitHeight

    Loader {
        id: __bgLoader
        anchors.fill: parent
        sourceComponent: control.bgDelegate
    }

    // Extra area
    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: control.marginExtra.top
        anchors.leftMargin: control.extraPosition === AntResult.PositionLeft ? control.marginExtra.left : 0
        anchors.rightMargin: control.extraPosition === AntResult.PositionRight ? control.marginExtra.right : 0
        implicitHeight: __extraLoader.item ? __extraLoader.item.implicitHeight : 0
        visible: control.extraVisible

        Loader {
            id: __extraLoader
            anchors.top: parent.top
            anchors.left: control.extraPosition === AntResult.PositionLeft ? parent.left : undefined
            anchors.right: control.extraPosition === AntResult.PositionRight ? parent.right : undefined
            sourceComponent: control.extraDelegate
            active: control.extraVisible
            visible: active
            z: 1
        }
    }

    // Content area
    ColumnLayout {
        id: __mainLayout
        anchors.fill: parent
        spacing: control.spacing

        // Icon
        Loader {
            id: __iconLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: control.marginIcon.top
            Layout.bottomMargin: control.marginIcon.bottom
            Layout.leftMargin: control.marginIcon.left
            Layout.rightMargin: control.marginIcon.right
            sourceComponent: control.iconDelegate
            active: control.iconVisible
            visible: active
        }

        // Title
        Loader {
            id: __titleLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: control.marginTitle.top
            Layout.bottomMargin: control.marginTitle.bottom
            Layout.leftMargin: control.marginTitle.left
            Layout.rightMargin: control.marginTitle.right
            sourceComponent: control.titleDelegate
            active: control.titleVisible
            visible: active
        }

        // Description
        Loader {
            id: __descriptionLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: control.marginDescription.top
            Layout.bottomMargin: control.marginDescription.bottom
            Layout.leftMargin: control.marginDescription.left
            Layout.rightMargin: control.marginDescription.right
            sourceComponent: control.descriptionDelegate
            active: control.descriptionVisible
            visible: active
        }

        // Action
        Loader {
            id: __actionLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: control.marginAction.top
            Layout.bottomMargin: control.marginAction.bottom
            Layout.leftMargin: control.marginAction.left
            Layout.rightMargin: control.marginAction.right
            sourceComponent: control.actionDelegate
            active: control.actionVisible
            visible: active
        }

        // Footer
        Loader {
            id: __footerLoader
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: control.marginFooter.top
            Layout.bottomMargin: control.marginFooter.bottom
            Layout.leftMargin: control.marginFooter.left
            Layout.rightMargin: control.marginFooter.right
            sourceComponent: control.footerDelegate
            active: control.footerVisible
            visible: active
        }
    }
}
