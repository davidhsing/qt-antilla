import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Antilla.Basic

T.Control {
    id: control

    property bool animationEnabled: AntTheme.animationEnabled
    property bool bgVisible: true
    property bool borderVisible: true
    property real borderWidth: 1
    property bool hoverable: false
    property bool shadowVisible: hoverable
    property bool titleVisible: true
    property string titleText: ''
    property font titleFont: Qt.font({
        family: control.themeSource.fontFamily,
        pixelSize: control.themeSource.fontSizeTitle,
        weight: Font.DemiBold,
    })
    property bool titleDividerVisible: true
    property int titleHeight: 60
    property bool coverVisible: true
    property var coverSource: ''
    property int coverFillMode: Image.Stretch
    property int coverHeight: 180
    property bool bodyVisible: true
    property int bodyAvatarSize: 40
    property var bodyAvatarIcon: 0 ?? ''
    property var bodyAvatarSource: ''
    property string bodyAvatarText: ''
    property string bodyTitleText: ''
    property font bodyTitleFont: Qt.font({
        family: control.themeSource.fontFamily,
        pixelSize: control.themeSource.fontSizeBodyTitle,
        weight: Font.DemiBold,
    })
    property string bodyDescriptionText: ''
    property font bodyDescriptionFont: Qt.font({
        family: control.themeSource.fontFamily,
        pixelSize: control.themeSource.fontSizeBodyDescription,
    })
    property int bodyHeight: 100
    property color colorBg: control.themeSource.colorBg
    property color colorBorder: control.themeSource.colorBorder
    property color colorTitle: control.themeSource.colorTitle
    property color colorShadow: control.themeSource.colorShadow
    property color colorBodyAvatar: control.themeSource.colorBodyAvatar
    property color colorBodyAvatarBg: 'transparent'
    property color colorBodyTitle: control.themeSource.colorBodyTitle
    property color colorBodyDescription: control.themeSource.colorBodyDescription
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }

    property Component titleDelegate: Item {
        height: control.titleHeight

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            anchors.leftMargin: 15
            anchors.rightMargin: 15

            AntText {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: control.titleText
                font: control.titleFont
                color: control.colorTitle
                wrapMode: Text.WrapAnywhere
                verticalAlignment: Text.AlignVCenter
            }

            Loader {
                Layout.alignment: Qt.AlignVCenter
                sourceComponent: extraDelegate
            }
        }

        AntDivider {
            width: parent.width;
            height: 1
            anchors.bottom: parent.bottom
            visible: control.titleDividerVisible || (typeof control.coverSource === 'string' && control.coverSource !== '') || (typeof control.coverSource === 'object' && control.coverSource.toString() !== '')
        }
    }
    property Component extraDelegate: Item { }
    property Component coverDelegate: Image {
        fillMode: control.coverFillMode
        height: !visible ? 0 : control.coverHeight
        source: control.coverSource
        visible: (typeof control.coverSource === 'string' && control.coverSource !== '') || (typeof control.coverSource === 'object' && control.coverSource.toString() !== '')
    }
    property Component bodyDelegate: Item {
        height: control.bodyHeight

        RowLayout {
            anchors.fill: parent

            Item {
                Layout.preferredWidth: __avatar.visible ? 70 : 0
                Layout.fillHeight: true

                AntAvatar {
                    id: __avatar
                    size: control.bodyAvatarSize
                    anchors.centerIn: parent
                    colorBg: control.colorBodyAvatarBg
                    iconSource: control.bodyAvatarIcon
                    imageSource: control.bodyAvatarSource
                    textSource: control.bodyAvatarText
                    colorIcon: control.colorBodyAvatar
                    colorText: control.colorBodyAvatar
                    visible: (iconSource !== 0 && iconSource !== '') || ((typeof imageSource == 'string' && imageSource !== '') || (typeof imageSource == 'object' && imageSource.toString() !== '')) || textSource !== ''
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                AntText {
                    Layout.fillWidth: true
                    leftPadding: __avatar.visible ? 0 : 15
                    rightPadding: 15
                    text: control.bodyTitleText
                    font: control.bodyTitleFont
                    color: control.colorBodyTitle
                    wrapMode: Text.WrapAnywhere
                    visible: control.bodyTitleText !== ''
                }

                AntText {
                    Layout.fillWidth: true
                    leftPadding: __avatar.visible ? 0 : 15
                    rightPadding: 15
                    text: control.bodyDescriptionText
                    font: control.bodyDescriptionFont
                    color: control.colorBodyDescription
                    wrapMode: Text.WrapAnywhere
                    visible: control.bodyDescriptionText !== ''
                }
            }
        }
    }
    property bool actionVisible: true
    property Component actionDelegate: Item { }
    property Component bgDelegate: AntRectangleInternal {
        color: control.colorBg
        border.color: control.colorBorder
        border.width: control.borderVisible ? control.borderWidth : 0
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
    }
    property var themeSource: AntTheme.AntCard

    objectName: '__AntCard__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)
    z: (hoverable && hovered) ? 1 : 0

    contentItem: Column {
        id: __column
        width: parent.width

        Loader {
            width: parent.width
            sourceComponent: control.titleDelegate
            active: control.titleVisible
            visible: active
        }
        Loader {
            width: parent.width - control.borderWidth * 2
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: control.coverDelegate
            active: control.coverVisible
            visible: active
        }
        Loader {
            width: parent.width - control.borderWidth * 2
            sourceComponent: control.bodyDelegate
            active: control.bodyVisible
            visible: active
        }
        Loader {
            width: parent.width
            sourceComponent: control.actionDelegate
            active: control.actionVisible
            visible: active
        }
    }

    background: Item {
        implicitWidth: 300

        Loader {
            anchors.fill: __bgLoader
            active: control.hoverable || control.shadowVisible
            visible: active
            sourceComponent: AntShadow {
                source: __bgLoader
                scale: control.hoverable ? (control.hovered ? 1.01 : 1.0) : 1.0
                shadowOpacity: control.hoverable ? (control.hovered ? 0.3 : 0) : 0.3
                shadowScale: 1.02
                shadowColor: control.colorShadow

                Behavior on scale {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: AntTheme.Primary.durationFast }
                }

                Behavior on shadowOpacity {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: AntTheme.Primary.durationFast }
                }
            }
        }

        Loader {
            id: __bgLoader
            anchors.fill: parent
            sourceComponent: control.bgDelegate
            active: control.bgVisible
            visible: active
        }
    }
}
