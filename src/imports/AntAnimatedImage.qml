import QtQuick
import Antilla.Basic

AnimatedImage {
    id: control

    property bool animationEnabled: AntTheme.animationEnabled
    property bool emptyAsError: false
    property bool previewEnabled: true
    readonly property alias hovered: __hoverHandler.hovered
    property int hoverCursorShape: Qt.PointingHandCursor
    property bool forceHoverCursor: false
    property var fallback: ''
    property var placeholder: ''
    property var items: []
    property string previewText: qsTr('预览')
    property int previewFillMode: Image.PreserveAspectFit

    objectName: '__AntAnimatedImage__'
    onSourceChanged: {
        if (items.length === 0) {
            __private.previewItems = [{ url: source }];
        }
    }
    onItemsChanged: {
        if (items.length > 0) {
            __private.previewItems = [...items];
        }
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
                    colorIcon: AntTheme.AntImage.colorText
                    iconSource: AntIcon.EyeOutlined
                    iconSize: AntTheme.AntImage.fontSize
                }

                AntText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: control.previewText
                    color: AntTheme.AntImage.colorText
                }
            }

            AntImagePreview {
                id: __preview
                animationEnabled: control.animationEnabled
                items: __private.previewItems
                sourceDelegate: AnimatedImage {
                    source: sourceUrl
                    fillMode: control.previewFillMode
                    onStatusChanged: {
                        if (status === Image.Ready) {
                            __preview.resetTransform();
                        }
                    }
                }
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

    QtObject {
        id: __private
        property var previewItems: []
    }
}
