import QtQuick
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
# AntIconButton 图标按钮\n
带图标的按钮。\n
* **继承自 { [AntButton](internal://AntButton) }**\n
<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
iconSource | int丨string | 0丨'' | 图标源(来自 AntIcon)或图标链接
iconSize | int | - | 图标大小
iconSpacing | int | 5 | 图标间隔
iconPosition | enum | AntIconButton.PositionLeft | 图标位置(来自 AntIconButton)
loading | bool | false | 是否在加载中
colorIcon | color | - | 图标颜色
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
等同于 [AntButton](internal://AntButton)，但提供一个前/后的可选图标。
                       `)
        }

        ThemeToken {
            source: 'AntButton'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`loading\` 属性设置是否在加载中\n
通过 \`iconSource\` 属性设置图标源{ AntIcon中定义 }\n
通过 \`iconSize\` 属性设置图标大小\n
通过 \`iconPosition\` 属性设置图标位置，支持的位置有：\n
- 图标处于开始位置(默认){ AntIconButton.PositionLeft }\n
- 图标处于结束位置{ AntIconButton.PositionRight }
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 15

    AntIconButton {
        text: qsTr('搜索')
        iconSource: AntIcon.SearchOutlined
    }

    AntIconButton {
        text: qsTr('搜索')
        type: AntButton.TypeOutlined
        iconSource: AntIcon.SearchOutlined
    }

    AntIconButton {
        type: AntButton.TypePrimary
        iconSource: AntIcon.SearchOutlined
    }

    AntIconButton {
        text: qsTr('搜索')
        type: AntButton.TypePrimary
        iconSource: AntIcon.SearchOutlined
    }

    AntIconButton {
        text: qsTr('搜索')
        type: AntButton.TypePrimary
        iconSource: AntIcon.SearchOutlined
        iconPosition: AntIconButton.PositionRight
    }

    AntIconButton {
        text: qsTr('搜索')
        type: AntButton.TypeFilled
        iconSource: AntIcon.SearchOutlined
    }

    AntIconButton {
        text: qsTr('搜索')
        type: AntButton.TypeText
        iconSource: AntIcon.SearchOutlined
    }
    
    AntIconButton {
        text: qsTr('加载中')
        loading: true
    }
}
            `
            exampleDelegate: Row {
                spacing: 15

                AntIconButton {
                    text: qsTr('搜索')
                    iconSource: AntIcon.SearchOutlined
                }

                AntIconButton {
                    text: qsTr('搜索')
                    type: AntButton.TypeOutlined
                    iconSource: AntIcon.SearchOutlined
                }

                AntIconButton {
                    type: AntButton.TypePrimary
                    iconSource: AntIcon.SearchOutlined
                }

                AntIconButton {
                    text: qsTr('搜索')
                    type: AntButton.TypePrimary
                    iconSource: AntIcon.SearchOutlined
                }

                AntIconButton {
                    text: qsTr('搜索')
                    type: AntButton.TypePrimary
                    iconSource: AntIcon.SearchOutlined
                    iconPosition: AntIconButton.PositionRight
                }

                AntIconButton {
                    text: qsTr('搜索')
                    type: AntButton.TypeFilled
                    iconSource: AntIcon.SearchOutlined
                }

                AntIconButton {
                    text: qsTr('搜索')
                    type: AntButton.TypeText
                    iconSource: AntIcon.SearchOutlined
                }

                AntIconButton {
                    text: qsTr('加载中')
                    loading: true
                }
            }
        }
    }
}
