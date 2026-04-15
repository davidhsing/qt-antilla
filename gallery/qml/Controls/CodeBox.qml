import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Antilla.Basic

Rectangle {
    id: root

    width: parent.width
    height: column.height + 40
    radius: 5
    color: 'transparent'
    border.color: AntThemeFunctions.alpha(AntTheme.Primary.colorTextBase, 0.1)
    clip: true

    property alias expTitle: expDivider.titleText
    property alias descTitle: descDivider.titleText
    property alias desc: descTextLoader.text
    property bool async: true
    property Component exampleDelegate: Item { }
    property alias code: codeText.text

    AntMessage {
        id: message
        z: 999
        parent: galleryWindow.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }

    Column {
        id: column
        width: parent.width - 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        spacing: 10

        AntDivider {
            id: expDivider
            width: parent.width
            height: 25
            visible: false
            titleText: qsTr('示例')
        }

        Loader {
            width: parent.width
            asynchronous: root.async
            sourceComponent: exampleDelegate
        }

        AntDivider {
            id: descDivider
            width: parent.width
            height: 25
            titleText: qsTr('说明')
        }

        MouseArea {
            id: descMouseArea
            width: parent.width
            height: descTextLoader.height
            hoverEnabled: true

            Loader{
                id: descTextLoader
                width: parent.width
                asynchronous: true
                sourceComponent: AntCopyableText {
                    textFormat: Text.MarkdownText
                    wrapMode: Text.WordWrap
                    text: descTextLoader.text
                    onLinkActivated: (link) => {
                        if (link.startsWith('internal://')) {
                            galleryMenu.gotoMenu(link.slice(11));
                        } else {
                            Qt.openUrlExternally(link);
                        }
                    }
                    onHoveredLinkChanged: {
                        if (hoveredLink === '') {
                            linkTooltip.visible = false;
                        } else {
                            linkTooltip.text = hoveredLink;
                            linkTooltip.x = descMouseArea.mouseX;
                            linkTooltip.y = descMouseArea.mouseY;
                            linkTooltip.visible = true;
                        }
                    }
                }
                property string text: ''
            }

            AntToolTip {
                id: linkTooltip
            }
        }

        AntDivider {
            width: parent.width
            height: 30
            titleText: qsTr('代码')
            titleAlign: AntDivider.AlignCenter
            titleDelegate: Row {
                spacing: 10
                AntIconButton {
                    padding: 4
                    topPadding: 4
                    bottomPadding: 4
                    onClicked: {
                        codeText.expanded = !codeText.expanded;
                    }
                    contentItem: Item {
                        implicitWidth: AntTheme.Primary.fontPrimarySizeHeading4
                        implicitHeight: implicitWidth
                        Row {
                            height: parent.implicitHeight
                            anchors.horizontalCenter: parent.horizontalCenter
                            AntIconText {
                                anchors.verticalCenter: parent.verticalCenter
                                iconSize: AntTheme.Primary.fontPrimarySize - 4
                                iconSource: AntIcon.LeftOutlined
                            }
                            AntIconText {
                                anchors.verticalCenter: parent.verticalCenter
                                iconSize: AntTheme.Primary.fontPrimarySize - 4
                                iconSource: AntIcon.RightOutlined
                            }
                        }

                        AntIconText {
                            anchors.centerIn: parent
                            iconSize: AntTheme.Primary.fontPrimarySize - 2
                            iconSource: AntIcon.MinusOutlined
                            rotation: -80
                            opacity: codeText.expanded ? 1 : 0
                            Behavior on opacity { NumberAnimation { duration: AntTheme.Primary.durationMid } }
                        }
                    }

                    AntToolTip {
                        arrowVisible: false
                        visible: parent ? parent.hovered : false
                        text: codeText.expanded ? qsTr('收起代码') : qsTr('展开代码')
                    }
                }
                AntIconButton {
                    padding: 4
                    topPadding: 4
                    bottomPadding: 4
                    iconSize: AntTheme.Primary.fontPrimarySizeHeading4
                    iconSource: AntIcon.CodeOutlined
                    onClicked: {
                        const component = Qt.createComponent('CodeRunner.qml');
                        if (component.status === Component.Ready) {
                            let win = component.createObject(root);
                            win.createQmlObject(code);
                        }
                    }
                    AntToolTip {
                        arrowVisible: false
                        visible: parent ? parent.hovered : false
                        text: qsTr('运行代码')
                    }
                }
                AntIconButton {
                    padding: 4
                    topPadding: 4
                    bottomPadding: 4
                    iconSize: AntTheme.Primary.fontPrimarySizeHeading4
                    iconSource: AntIcon.CopyOutlined
                    onClicked: {
                        AntApi.setClipboardText(codeText.text);
                        message.success(qsTr('代码复制成功'))
                    }
                    AntToolTip {
                        arrowVisible: false
                        visible: parent ? parent.hovered : false
                        text: qsTr('复制代码')
                    }
                }
            }
        }

        AntCopyableText {
            id: codeText
            clip: true
            width: parent.width
            height: expanded ? implicitHeight : 0
            wrapMode: Text.WordWrap
            property bool expanded: false

            Behavior on height { NumberAnimation { duration: AntTheme.Primary.durationMid } }
        }
    }
}
