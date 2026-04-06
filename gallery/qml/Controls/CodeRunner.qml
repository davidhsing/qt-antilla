import QtQuick
import QtQuick.Controls.Basic
import Antilla.Basic

AntWindow {
    id: root

    width: 900
    height: 600
    title: qsTr('代码运行器')
    captionBar.closeCallback:
        () => {
            root.destroy();
        }
    captionBar.winIconDelegate: Item {
        Image {
            width: 16
            height: 16
            anchors.centerIn: parent
            source: 'qrc:/Gallery/images/antilla_icon.svg'
        }
    }
    Component.onCompleted: {
        if (Qt.platform.os === 'windows') {
            if (setSpecialEffect(AntWindow.EffectWinDwmBlur)) return;
        } else if (Qt.platform.os === 'osx') {
            if (setSpecialEffect(AntWindow.EffectMacBlurEffect)) return;
        }
        AntApi.setWindowStaysOnTopHint(root, true);
    }

    property var created: undefined

    function createQmlObject(code) {
        codeEdit.text = code;
        updateCode();
    }

    function updateCode() {
        try {
            errorEdit.clear();
            if (created)
                created.destroy();
            created = Qt.createQmlObject(codeEdit.text, runnerBlock);
            created.parent = runnerBlock;
        } catch (error) {
            errorEdit.text = error.message;
        }
    }

    AntDivider {
        id: divider
        width: parent.width
        height: 1
        anchors.top: captionBar.bottom
    }

    Item {
        id: content
        width: parent.width
        anchors.top: divider.bottom
        anchors.bottom: parent.bottom

        Item {
            id: codeBlock
            width: parent.width * 0.4
            height: parent.height

            ScrollView {
                width: parent.width
                anchors.top: parent.top
                anchors.bottom: divider1.top
                ScrollBar.vertical: AntScrollBar { }
                ScrollBar.horizontal: AntScrollBar { }

                AntCopyableText {
                    id: codeEdit
                    readOnly: false
                    wrapMode: Text.WrapAnywhere
                }
            }

            AntDivider {
                id: divider1
                width: parent.width
                height: 10
                anchors.bottom: errorView.top
                titleText: qsTr('错误')
            }

            ScrollView {
                id: errorView
                width: parent.width
                height: 100
                anchors.bottom: parent.bottom

                TextArea {
                    id: errorEdit
                    readOnly: true
                    selectByKeyboard: true
                    selectByMouse: true
                    font {
                        family: AntTheme.Primary.fontPrimaryFamily
                        pixelSize: AntTheme.Primary.fontPrimarySize
                    }
                    color: AntTheme.Primary.colorError
                    wrapMode: Text.WordWrap
                }
            }
        }

        AntDivider {
            id: divider2
            width: 10
            height: parent.height
            anchors.left: codeBlock.right
            orientation: Qt.Vertical
            titleAlign: AntDivider.AlignCenter
            titleDelegate: AntIconButton {
                padding: 5
                iconSize: AntTheme.Primary.fontPrimarySizeHeading4
                iconSource: AntIcon.PlayCircleOutlined
                onClicked: {
                    root.updateCode();
                }
                AntToolTip {
                    visible: parent.hovered
                    text: qsTr('运行')
                }
            }
        }

        Item {
            id: runnerBlock
            anchors.left: divider2.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 5
        }
    }
}
