import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Antilla.Basic
import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: AntScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# AntTag 标签\n
进行标记和分类的小标签。\n
* **继承自 { Rectangle }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
tagState | enum | AntTag.StateDefault | 标签状态(来自 AntTag)
text | string | '' | 标签文本
font | font | - | 标签字体
adjustWidth | int | 16 | 调整宽度
adjustHeight | int | 8 | 调整高度
rotating | bool | false | 旋转中
iconSource | int丨string | 0丨'' | 图标(来自 AntIcon)或图标链接
iconSize | int | - | 图标大小
closeIconSource | int丨string | 0丨'' | 关闭图标(来自 AntIcon)或图标链接
closeIconSize | int | true | 关闭图标大小
spacing | int | 5 | 图标间隔
presetColor | string | '' | 预设颜色
colorText | color | - |文本颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
colorIcon | color | - | 图标颜色
\n<br/>
\n### 支持的信号：\n
- \`closed()\` 点击关闭图标(如果有)时发出\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 用于标记事物的属性和维度。\n
- 进行分类。\n
                       `)
        }

        ThemeToken {
            source: 'AntTag'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
基本标签的用法\n
通过 \`text\` 设置标签文本。\n
通过 \`closeIconSource\` 设置关闭图标。\n
点击关闭图标将发送 \`closed\` 信号。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    width: parent.width
    spacing: 10

    Row {
        spacing: 10

        AntTag {
            text: 'Tag 1'
        }

        AntTag {
            text: 'Link'

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Qt.openUrlExternally('https://github.com/davidhsing/qt-antilla');
                }
            }
        }

        AntTag {
            text: 'Prevent Default'
            closeIconSource: AntIcon.CloseOutlined
        }

        AntTag {
            text: 'Tag 2'
            closeIconSource: AntIcon.CloseCircleOutlined
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    AntTag {
                        text: 'Tag 1'
                    }

                    AntTag {
                        text: 'Link'

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Qt.openUrlExternally('https://github.com/davidhsing/qt-antilla');
                            }
                        }
                    }

                    AntTag {
                        text: 'Prevent Default'
                        closeIconSource: AntIcon.CloseOutlined
                    }

                    AntTag {
                        text: 'Tag 2'
                        closeIconSource: AntIcon.CloseCircleOutlined
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('多彩标签')
            desc: qsTr(`
通过 \`presetColor\` 设置预设颜色。\n
支持的预设颜色：\n
**['red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta']**\n
如果预设颜色不在该列表中，则为自定义标签。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    width: parent.width
    spacing: 10

    Row {
        spacing: 10

        Repeater {
            model: [ 'red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta' ]
            delegate: AntTag {
                text: modelData
                presetColor: modelData
            }
        }
    }

    Row {
        spacing: 10

        Repeater {
            model: [ '#f50', '#2db7f5', '#87d068', '#108ee9' ]
            delegate: AntTag {
                text: modelData
                presetColor: modelData
            }
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    Repeater {
                        model: [ 'red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta' ]
                        delegate: AntTag {
                            text: modelData
                            presetColor: modelData
                        }
                    }
                }

                Row {
                    spacing: 10

                    Repeater {
                        model: [ '#f50', '#2db7f5', '#87d068', '#108ee9' ]
                        delegate: AntTag {
                            text: modelData
                            presetColor: modelData
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('动态添加和删除')
            desc: qsTr(`
简单生成一组标签，利用 \`closed()\` 信号可以实现动态添加和删除。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    width: parent.width
    spacing: 10

    Flow {
        width: parent.width
        spacing: 10

        Repeater {
            id: editRepeater
            model: ListModel {
                id: editTagsModel
                ListElement { tag: 'Unremovable'; removable: false }
                ListElement { tag: 'Tag 1'; removable: true }
                ListElement { tag: 'Tag 2'; removable: true }
            }
            delegate: AntTag {
                text: tag
                closeIconSource: removable ? AntIcon.CloseOutlined : 0
                onClosed: {
                    editTagsModel.remove(index, 1);
                }
            }
        }

        AntInput {
            width: 100
            font.pixelSize: AntTheme.Primary.fontPrimarySize - 2
            iconSource: AntIcon.PlusOutlined
            placeholderText: 'New Tag'
            colorBg: 'transparent'
            onAccepted: {
                focus = false;
                editTagsModel.append({ tag: text, removable: true })
                clear();
            }
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                Flow {
                    width: parent.width
                    spacing: 10

                    Repeater {
                        id: editRepeater
                        model: ListModel {
                            id: editTagsModel
                            ListElement { tag: 'Unremovable'; removable: false }
                            ListElement { tag: 'Tag 1'; removable: true }
                            ListElement { tag: 'Tag 2'; removable: true }
                        }
                        delegate: AntTag {
                            text: tag
                            closeIconSource: removable ? AntIcon.CloseOutlined : 0
                            onClosed: {
                                editTagsModel.remove(index, 1);
                            }
                        }
                    }

                    AntInput {
                        width: 100
                        font.pixelSize: AntTheme.Primary.fontPrimarySize - 2
                        iconSource: AntIcon.PlusOutlined
                        placeholderText: 'New Tag'
                        colorBg: 'transparent'
                        onAccepted: {
                            focus = false;
                            editTagsModel.append({ tag: text, removable: true })
                            clear();
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('带图标的标签')
            desc: qsTr(`
通过 \`iconSource\` 设置左侧图标。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    width: parent.width
    spacing: 10

    AntTag {
        text: 'Twitter'
        iconSource: AntIcon.TwitterOutlined
        presetColor: '#55acee'
    }

    AntTag {
        text: 'Youtube'
        iconSource: AntIcon.YoutubeOutlined
        presetColor: '#cd201f'
    }

    AntTag {
        text: 'Facebook '
        iconSource: AntIcon.FacebookOutlined
        presetColor: '#3b5999'
    }

    AntTag {
        text: 'LinkedIn'
        iconSource: AntIcon.LinkedinOutlined
        presetColor: '#55acee'
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntTag {
                    text: 'Twitter'
                    iconSource: AntIcon.TwitterOutlined
                    presetColor: '#55acee'
                }

                AntTag {
                    text: 'Youtube'
                    iconSource: AntIcon.YoutubeOutlined
                    presetColor: '#cd201f'
                }

                AntTag {
                    text: 'Facebook '
                    iconSource: AntIcon.FacebookOutlined
                    presetColor: '#3b5999'
                }

                AntTag {
                    text: 'LinkedIn'
                    iconSource: AntIcon.LinkedinOutlined
                    presetColor: '#55acee'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('预设状态的标签')
            desc: qsTr(`
通过 \`rotating\` 设置图标是否旋转中。\n
通过 \`tagState\` 来设置不同的状态，支持的状态有：\n
- 默认状态(默认){ AntTag.StateDefault }\n
- 成功状态{ AntTag.StateSuccess }\n
- 处理中状态{ AntTag.StateProcessing }\n
- 错误状态{ AntTag.StateError }\n
- 警告状态{ AntTag.StateWarning }\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    width: parent.width
    spacing: 10

    Row {
        spacing: 10

        AntTag {
            text: 'success'
            tagState: AntTag.StateSuccess
        }

        AntTag {
            text: 'processing'
            tagState: AntTag.StateProcessing
        }

        AntTag {
            text: 'error'
            tagState: AntTag.StateError
        }

        AntTag {
            text: 'warning'
            tagState: AntTag.StateWarning
        }

        AntTag {
            text: 'default'
            tagState: AntTag.StateDefault
        }
    }

    Row {
        spacing: 10

        AntTag {
            text: 'success'
            tagState: AntTag.StateSuccess
            iconSource: AntIcon.CheckCircleOutlined
        }

        AntTag {
            text: 'processing'
            rotating: true
            tagState: AntTag.StateProcessing
            iconSource: AntIcon.SyncOutlined
        }

        AntTag {
            text: 'error'
            tagState: AntTag.StateError
            iconSource: AntIcon.CloseCircleOutlined
        }

        AntTag {
            text: 'warning'
            tagState: AntTag.StateWarning
            iconSource: AntIcon.ExclamationCircleOutlined
        }

        AntTag {
            text: 'waiting'
            tagState: AntTag.StateDefault
            iconSource: AntIcon.ClockCircleOutlined
        }

        AntTag {
            text: 'stop'
            tagState: AntTag.StateDefault
            iconSource: AntIcon.MinusCircleOutlined
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    AntTag {
                        text: 'success'
                        tagState: AntTag.StateSuccess
                    }

                    AntTag {
                        text: 'processing'
                        tagState: AntTag.StateProcessing
                    }

                    AntTag {
                        text: 'error'
                        tagState: AntTag.StateError
                    }

                    AntTag {
                        text: 'warning'
                        tagState: AntTag.StateWarning
                    }

                    AntTag {
                        text: 'default'
                        tagState: AntTag.StateDefault
                    }
                }

                Row {
                    spacing: 10

                    AntTag {
                        text: 'success'
                        tagState: AntTag.StateSuccess
                        iconSource: AntIcon.CheckCircleOutlined
                    }

                    AntTag {
                        text: 'processing'
                        rotating: true
                        tagState: AntTag.StateProcessing
                        iconSource: AntIcon.SyncOutlined
                    }

                    AntTag {
                        text: 'error'
                        tagState: AntTag.StateError
                        iconSource: AntIcon.CloseCircleOutlined
                    }

                    AntTag {
                        text: 'warning'
                        tagState: AntTag.StateWarning
                        iconSource: AntIcon.ExclamationCircleOutlined
                    }

                    AntTag {
                        text: 'waiting'
                        tagState: AntTag.StateDefault
                        iconSource: AntIcon.ClockCircleOutlined
                    }

                    AntTag {
                        text: 'stop'
                        tagState: AntTag.StateDefault
                        iconSource: AntIcon.MinusCircleOutlined
                    }
                }
            }
        }
    }
}
