import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Item {
    id: root

    width: parent.width
    height: column.height

    property string source: ''

    AntPopup {
        id: editPopup

        property int row
        property var edit

        padding: 5
        contentItem: Row {
            spacing: 5

            AntAutoComplete {
                id: editInput
                width: 200
                options: galleryGlobal.primaryTokens
                tooltipVisible: true
                filterOption: function(input, option){
                    return option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1;
                }
            }

            AntButton {
                text: qsTr('确认')
                onClicked: {
                    editPopup.edit.value = editInput.text;
                    if (root.source === '#') {
                        // 对于公共主题变量，使用 installIndexToken
                        AntTheme.installIndexToken(editPopup.edit.token, editInput.text);
                    } else {
                        galleryGlobal.componentTokens[root.source][editPopup.row].tokenValue.value = editPopup.edit.value;
                        AntTheme.installComponentToken(root.source, editPopup.edit.token, editInput.text);
                    }
                    editPopup.close();
                }
            }

            AntButton {
                text: qsTr('取消')
                onClicked: {
                    editPopup.close();
                }
            }

            AntButton {
                text: qsTr('重置')
                onClicked: {
                    editPopup.edit.value = editPopup.edit.rawValue;
                    if (root.source === '#') {
                        // 对于公共主题变量，使用 installIndexToken
                        AntTheme.installIndexToken(editPopup.edit.token, editPopup.edit.rawValue);
                    } else {
                        AntTheme.installComponentToken(root.source, editPopup.edit.token, editPopup.edit.rawValue);
                    }
                    editPopup.close();
                }
            }
        }
    }

    Component {
        id: tagDelegate

        Item {
            AntTag {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: cellData
                presetColor: 'orange'
                font.pixelSize: AntTheme.Primary.fontPrimarySize

                HoverHandler {
                    id: hoverHandler
                }

                AntToolTip {
                    text: parent.text
                    visible: hoverHandler.hovered
                }
            }
        }
    }

    Component {
        id: editDelegate

        Item {
            Row {
                id: editRow
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 5

                property string token: cellData.token
                property string rawValue: cellData.rawValue
                property string value: cellData.value

                AntIconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: AntIcon.EditOutlined
                    topPadding: 2
                    bottomPadding: 2
                    leftPadding: 4
                    rightPadding: 4
                    onClicked: {
                        editPopup.parent = this;
                        editPopup.row = row;
                        editPopup.edit = editRow;
                        editInput.text = editRow.value;
                        editInput.filter();
                        editPopup.open();
                    }

                    AntToolTip {
                        visible: parent.hovered
                        text: qsTr('编辑Token')
                    }
                }

                AntTag {
                    anchors.verticalCenter: parent.verticalCenter
                    text: editRow.value
                    presetColor: 'green'
                    font.pixelSize: AntTheme.Primary.fontPrimarySize

                    HoverHandler {
                        id: hoverHandler
                    }

                    AntToolTip {
                        text: parent.text
                        visible: hoverHandler.hovered
                    }
                }
            }
        }
    }

    Component {
        id: colorTagDelegate

        Item {
            property var theCellData: (root.source === '#') ? cellData : AntTheme[root.source][cellData]

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Rectangle {
                    width: tag.height
                    height: tag.height
                    radius: 4
                    color: {
                        try {
                            Qt.color(value);
                            return value;
                        } catch (err) {
                            return 'transparent';
                        }
                    }
                    property string value: theCellData
                }

                AntTag {
                    id: tag
                    Layout.leftMargin: 15
                    Layout.alignment: Qt.AlignVCenter
                    text: theCellData
                    presetColor: 'blue'
                    font.pixelSize: AntTheme.Primary.fontPrimarySize
                }
            }
        }
    }

    Column {
        id: column
        width: parent.width - 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 15

        UpdateDesc { }

        AntText {
            text: (root.source === '#') ? qsTr('公共主题变量（Design Token）') : qsTr('主题变量（Design Token）')
            width: parent.width
            font {
                pixelSize: AntTheme.Primary.fontPrimarySizeHeading3
                weight: Font.DemiBold
            }
            visible: !!root.source
        }

        Loader {
            id: tableLoader
            width: parent.width
            height: Math.min(400, 40 * ((root.source ? galleryGlobal.primaryTokens.length : galleryGlobal.componentTokens[root.source]?.length ?? 0)) + 1)
            active: !!root.source
            asynchronous: true
            sourceComponent: AntTable {
                propagateWheelEvent: false
                columnGridVisible: true
                columns: [
                    {
                        title: qsTr('Token 名称'),
                        dataIndex: 'tokenName',
                        key: 'tokenName',
                        delegate: tagDelegate,
                        width: 250
                    },
                    {
                        title: qsTr('Token 值'),
                        key: 'tokenValue',
                        dataIndex: 'tokenValue',
                        delegate: editDelegate,
                        width: 400
                    },
                    {
                        title: qsTr('Token 计算值'),
                        key: 'tokenCalcValue',
                        dataIndex: 'tokenCalcValue',
                        delegate: colorTagDelegate,
                        width: 250
                    }
                ]
                Component.onCompleted: {
                    if (!root.source) {
                        return;
                    }
                    let model;
                    if (root.source === '#') {
                        model = galleryGlobal.primaryTokens.map(token => ({
                            tokenName: token.label.substring(1), // 移除 @ 前缀
                            tokenValue: {
                                token: token.label.substring(1),
                                value: token.label,
                                rawValue: token.label
                            },
                            tokenCalcValue: AntTheme.Primary[token.label.substring(1)] || token.label
                        }));
                    } else {
                        model = galleryGlobal.componentTokens[root.source];
                    }
                    initModel = model;
                    height = Math.min(400, defaultColumnHeaderHeight + model.length * minimumRowHeight);
                }
            }
        }
    }
}
