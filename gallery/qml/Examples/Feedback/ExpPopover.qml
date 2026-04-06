import QtQuick
import QtQuick.Controls.Basic
import Antilla.Basic
import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: AntScrollBar { }

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
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# AntPopover 气泡显示框\n
点击元素，弹出气泡式的显示框。\n
* **继承自 { [AntPopup](internal://AntPopup) }**\n
\n<br/>
\n### 支持的代理：\n
- **arrowDelegate: Component** 箭头代理\n
- **iconDelegate: Component** 图标代理\n
- **titleDelegate: Component** 标题代理\n
- **descriptionDelegate: Component** 描述代理\n
- **contentDelegate: Component** 内容代理\n
- **bgDelegate: Component** 背景代理\n
- **footerDelegate: Component** 页脚代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
iconVisible | bool | - | 图标是否可见
iconSource | int丨string | AntIcon.ExclamationCircleFilled丨'' | 图标源(来自 AntIcon)或图标链接
iconSize | int | 16 | 图标大小
titleVisible | bool | - | 标题是否可见
titleText | string | '' | 标题文本
descriptionVisible | bool | - | 描述是否可见
descriptionText | string | '' | 描述文本
arrowVisible | bool | true | 是否显示箭头
arrowWidth | int | 16 | 箭头宽度
arrowHeight | int | 8 | 箭头高度
colorIcon | color | - | 图标颜色
colorTitle | color | - | 标题文本颜色
colorDescription | color | - | 描述文本颜色
titleFont | font | - | 标题文本字体
descriptionFont | font | - | 描述文本字体
\n<br/>
\n **注意** 需要显示给出弹出宽度，高度将根据内容自动计算
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
目标元素的操作需要展示更多详细信息时，在目标元素附近弹出浮层提示。\n
                       `)
        }

        ThemeToken {
            source: 'AntPopover'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
最简单的用法，支持标题和描述。\n
通过 \`titleText\` 属性设置标题文本。\n
通过 \`descriptionText\` 属性设置描述文本。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 10

    AntButton {
        text: 'Hover'
        type: AntButton.TypeOutlined

        AntPopover {
            x: (parent.width - width) / 2
            y: parent.height + 6
            width: 300
            visible: parent.hovered || parent.down
            closePolicy: AntPopover.NoAutoClose
            titleText: 'Hover details'
            descriptionText: 'What are you doing here?'
        }
    }

    AntButton {
        text: 'Click'
        type: AntButton.TypeOutlined
        onClicked: popover.open();

        AntPopover {
            id: popover
            x: (parent.width - width) / 2
            y: parent.height + 6
            width: 300
            titleText: 'Click details'
            descriptionText: 'What are you doing here?'
        }
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntButton {
                    text: 'Hover'
                    type: AntButton.TypeOutlined

                    AntPopover {
                        x: (parent.width - width) / 2
                        y: parent.height + 6
                        width: 300
                        visible: parent.hovered || parent.down
                        closePolicy: AntPopover.NoAutoClose
                        titleText: 'Hover details'
                        descriptionText: 'What are you doing here?'
                    }
                }

                AntButton {
                    text: 'Click'
                    type: AntButton.TypeOutlined
                    onClicked: popover.open();

                    AntPopover {
                        id: popover
                        x: (parent.width - width) / 2
                        y: parent.height + 6
                        width: 300
                        titleText: 'Click details'
                        descriptionText: 'What are you doing here?'
                    }
                }
            }
        }
    }
}
