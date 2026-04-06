import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls.Basic
import Antilla.Basic
import Gallery

AntWindow {
    id: root
    width: 800
    height: 550
    minimumWidth: 800
    minimumHeight: 550
    captionBar.winTitle: qsTr('创建新项目')
    captionBar.winIconDelegate: Item {
        Image {
            width: 16
            height: 16
            anchors.centerIn: parent
            source: 'qrc:/Gallery/images/antilla_icon.svg'
        }
    }
    captionBar.minimizeButtonVisible: false
    captionBar.maximizeButtonVisible: false
    captionBar.color: AntTheme.Primary.colorFillTertiary
    captionBar.closeCallback: () => creatorLoader.visible = false;
    Component.onCompleted: setSpecialEffect(galleryWindow.specialEffect);

    Connections {
        target: galleryWindow
        function onSpecialEffectChanged() {
            root.setSpecialEffect(galleryWindow.specialEffect);
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 40
        anchors.topMargin: captionBar.height + 20

        Column {
            spacing: 15

            AntText {
                text: qsTr('项目名称')
            }

            AntInput {
                id: projectNameInput
                width: 500
                text: 'AntillaProject'
            }

            AntText {
                text: qsTr('位置')
            }

            AntInput {
                id: projectLocationInput
                width: 500
                Component.onCompleted: {
                    text = Creator.urlToLocalFile(projectLocationFolderDialog.currentFolder);
                }

                AntIconButton {
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    leftPadding: 10
                    rightPadding: 10
                    iconSource: AntIcon.EllipsisOutlined
                    onClicked: {
                        projectLocationFolderDialog.open();
                    }

                    FolderDialog {
                        id: projectLocationFolderDialog
                        currentFolder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
                        onAccepted: {
                            currentFolder = selectedFolder;
                            projectLocationInput.text = Creator.urlToLocalFile(selectedFolder);
                        }
                    }
                }
            }

            AntText {
                text: qsTr('Antilla 包含方式')
            }

            AntRadioBlock {
                id: containMethod
                initCheckedIndex: 2
                model: [
                    { label: qsTr('不包含'), value: Creator.NoContain, toolTip: { text: qsTr('将创建基础的 CMake 项目') } },
                    { label: qsTr('源码包含'), value: Creator.SourceContain, toolTip: { text: qsTr('将使用 add_subdirectory()') } },
                    { label: qsTr('库包含'), value: Creator.LibraryContain, toolTip: { text: qsTr('将以动态库形式包含') } },
                ]
                onCurrentCheckedIndexChanged: {
                    if (currentCheckedIndex == 1) {
                        sourceLocation.text = Creator.urlToLocalFile(sourceFloderDialog.currentFolder);
                    } else if (currentCheckedIndex == 2) {
                        defaultCheckBox.checkedChanged();
                    }
                }
            }

            AntText {
                text: {
                    switch (containMethod.currentCheckedIndex) {
                    case 0: return '';
                    case 1: return qsTr('Antilla 源码位置');
                    case 2: return qsTr('Antilla 库位置');
                    }
                }
                visible: containMethod.currentCheckedIndex != 0
            }

            AntCheckBox {
                id: defaultCheckBox
                text: qsTr('默认构建位置')
                checked: true
                visible: containMethod.currentCheckedIndex == 2
                onCheckedChanged: {
                    if (containMethod.currentCheckedIndex == 2) {
                        if (checked)
                            sourceLocation.text = "${Qt_DIR}/../../../";
                        else
                            sourceLocation.text = Creator.urlToLocalFile(sourceFloderDialog.currentFolder);
                    }
                }
                Component.onCompleted: checkedChanged();

                AntIconText {
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: AntIcon.QuestionCircleOutlined
                    iconSize: AntTheme.Primary.fontPrimarySize + 2
                    colorIcon: AntTheme.Primary.colorPrimary

                    AntToolTip {
                        text: qsTr('如果 Antilla 是默认构建的，库将生成在 QtSDK 目录\n如果使用 Intall 生成库则可不勾选')
                        visible: buildLocationHover.hovered
                    }

                    HoverHandler {
                        id: buildLocationHover
                    }
                }
            }

            AntInput {
                id: sourceLocation
                width: 500
                visible: containMethod.currentCheckedIndex != 0
                enabled: !(containMethod.currentCheckedIndex == 2 && defaultCheckBox.checked)
                Component.onCompleted: {
                    text = Creator.urlToLocalFile(sourceFloderDialog.currentFolder);
                }

                AntIconButton {
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    leftPadding: 10
                    rightPadding: 10
                    iconSource: AntIcon.EllipsisOutlined
                    onClicked: {
                        sourceFloderDialog.currentFolder = Creator.localFileToUrl(sourceLocation.text);
                        sourceFloderDialog.open();
                    }

                    FolderDialog {
                        id: sourceFloderDialog
                        onAccepted: {
                            currentFolder = selectedFolder;
                            sourceLocation.text = Creator.urlToLocalFile(selectedFolder);
                        }
                    }
                }
            }

            AntCheckBox {
                id: addDeployScript
                text: qsTr('添加 CMake 部署脚本')
                checked: true
            }

            AntCheckBox {
                id: isShareLibrary
                visible: containMethod.currentCheckedIndex != 0
                text: qsTr('Antilla 动态库')
                checked: true

                AntIconText {
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: AntIcon.QuestionCircleOutlined
                    iconSize: AntTheme.Primary.fontPrimarySize + 2
                    colorIcon: AntTheme.Primary.colorPrimary

                    AntToolTip {
                        text: qsTr('如果 Antilla 构建为动态库请勾选，静态库则不要勾选')
                        visible: isShareLibrarynHover.hovered
                    }

                    HoverHandler {
                        id: isShareLibrarynHover
                    }
                }
            }
        }

        Row {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            spacing: 15

            AntButton {
                text: qsTr('创建')
                type: AntButton.TypePrimary
                onClicked: {
                    let object = {};
                    object.projectName = projectNameInput.text;
                    object.projectLocation = projectLocationInput.text;
                    object.containMethod = containMethod.currentCheckedValue;
                    object.isDefaultBuild = defaultCheckBox.checked;
                    object.sourceLocation = sourceLocation.text;
                    object.addDeployScript = addDeployScript.checked;
                    object.isShareLibrary = isShareLibrary.checked;
                    Creator.createProject(object);
                }
            }

            AntButton {
                text: qsTr('取消')
                type: AntButton.TypeOutlined
                onClicked: captionBar.closeCallback();
            }
        }
    }
}
