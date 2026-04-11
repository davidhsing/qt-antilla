import QtQuick
import Antilla.Basic

Image {
    id: control

    property bool animationEnabled: AntTheme.animationEnabled
    property bool emptyAsError: false
    property bool previewEnabled: false
    readonly property alias hovered: __hoverHandler.hovered
    property int hoverCursorShape: Qt.PointingHandCursor
    property bool forceHoverCursor: false
    property var fallback: ''
    property var placeholder: ''
    property var items: []
    property string previewText: qsTr('预览')
    property var themeSource: AntTheme.AntImage

    objectName: '__AntImage__'
    onSourceChanged: {
        if (control.items.length === 0) {
            __private.previewItems = [{ url: source }];
        }
    }
    onItemsChanged: {
        if (control.items.length > 0) {
            __private.previewItems = [...control.items];
        }
    }

    QtObject {
        id: __private
        property var previewItems: []
    }

    Loader {
        anchors.centerIn: parent
        active: control.status === Image.Error || (control.emptyAsError && ((typeof control.source === 'string' && control.source === '') || (typeof control.source === 'object' && control.source.toString() === ''))) && ((typeof control.fallback == 'string' && control.fallback !== '') || (typeof control.fallback == 'object' && control.fallback.toString() !== ''))
        sourceComponent: Image {
            width: control.width
            height: control.height
            fillMode: control.fillMode
            source: control.fallback
            Component.onCompleted: {
                __private.previewItems = [{ url: control.fallback }]
            }
        }
    }

    Loader {
        anchors.centerIn: parent
        active: (control.status === Image.Loading) && ((typeof control.placeholder === 'string' && control.placeholder !== '') || (typeof control.placeholder === 'object' && control.placeholder.toString() !== ''))
        sourceComponent: Image {
            width: control.width
            height: control.height
            fillMode: control.fillMode
            source: control.placeholder
        }
    }

    Loader {
        anchors.fill: parent
        active: control.previewEnabled
        sourceComponent: Rectangle {
            color: AntTheme.Primary.colorTextTertiary
            opacity: control.hovered ? 1.0 : 0.0

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
            Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }

            Row {
                anchors.centerIn: parent
                spacing: 5

                AntIconText {
                    anchors.verticalCenter: parent.verticalCenter
                    colorIcon: control.themeSource.colorText
                    iconSource: AntIcon.EyeOutlined
                    iconSize: control.themeSource.fontSize
                }

                AntText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: control.previewText
                    color: control.themeSource.colorText
                }
            }

            AntImagePreview {
                id: __preview
                animationEnabled: control.animationEnabled
                items: __private.previewItems
            }

            TapHandler {
                onTapped: {
                    if (!__preview.opened) {
                        __preview.open();
                    }
                }
            }
        }
    }

    HoverHandler {
        id: __hoverHandler
        cursorShape: (control.previewEnabled || control.items.length > 0 || control.forceHoverCursor) ? control.hoverCursorShape : Qt.ArrowCursor
    }
}
