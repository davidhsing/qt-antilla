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
# AntInput 输入框\n
通过鼠标或键盘输入内容，是最基础的表单域的包装。\n
* **继承自 { TextField }**\n
\n<br/>
\n### 支持的代理：\n
- **iconDelegate: Component** 图标代理\n
- **clearIconDelegate: Component** 清除图标代理\n
- **bgDelegate: Component** 背景代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
active | bool(readonly) | - | 是否处于激活状态
iconSource | int丨string | 0丨'' | 图标源(来自 AntIcon)或图标链接
iconSize | int | - | 图标大小
iconPosition | enum | AntInput.PositionLeft | 图标位置(来自 AntInput)
clearable | bool丨'active' | false | 是否启用清除按钮(active-仅当激活状态下可见)
clearIconSource | int丨string | AntIcon.CloseCircleFilled | 清除图标源(来自 AntIcon)或图标链接
clearIconSize | int | - | 清除图标大小
clearIconPosition | enum | AntInput.PositionRight | 清除图标位置(来自 AntInput)
clearLeftMargin | int | 5 | 清除图标左边距
clearRightMargin | int | 5 | 清除图标右边距
leftIconPadding | int(readonly) | - | 图标在左边时的填充
rightIconPadding | int(readonly) | - | 图标在右边时的填充
leftClearIconPadding | int(readonly) | - | 清除图标在左边时的填充
rightClearIconPadding | int(readonly) | - | 清除图标在右边时的填充
danger | bool | false | 是否为警示状态
colorIcon | color | - | 图标颜色
colorText | color | - | 文本颜色
colorBorder | color | - | 边框颜色
colorBg | color | - | 背景颜色
radiusBg | [AntRadius](internal://AntRadius) | - | 背景圆角半径
readOnlyBg | bool | false | 当只读时是否采用禁用时的背景色
ariaConstrual | string | '' | 内容描述(提高可用性)
\n<br/>
\n### 支持的信号：\n
- \`cleared()\` 点击清除图标时发出\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要用户输入表单域内容时。\n
- 提供组合型输入框，带搜索的输入框，还可以进行大小选择。\n
                       `)
        }

        ThemeToken {
            source: 'AntInput'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`iconSource\` 属性设置图标源，为 0 则不显示。\n
通过 \`iconSize\` 设置清除图标大小。\n
通过 \`iconPosition\` 属性改变图标位置，支持的位置：\n
- 图标在输入框左边(默认){ AntInput.PositionLeft }\n
- 图标在输入框右边{ AntInput.PositionRight }\n
通过 \`clearable\` 设置是否启用清除按钮。\n
通过 \`clearIconSource\` 设置清除图标，为 0 则不显示。\n
通过 \`clearIconSize\` 设置清除图标大小。\n
通过 \`clearIconPosition\` 设置清除图标的位置，支持的位置：\n
- 清除图标在输入框左边(默认){ AntInput.PositionLeft }\n
- 清除图标在输入框右边{ AntInput.PositionRight }\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntInput {
        width: 150
        placeholderText: 'Basic Usage'
    }

    AntInput {
        width: 150
        placeholderText: 'Clear Active'
        clearable: 'active'
    }

    AntInput {
        width: 150
        iconPosition: AntInput.PositionLeft
        iconSource: AntIcon.UserOutlined
        placeholderText: 'Username'
    }

    AntInput {
        width: 150
        iconPosition: AntInput.PositionRight
        iconSource: AntIcon.UserOutlined
        placeholderText: 'Username'
    }

    AntInput {
        width: 150
        placeholderText: 'Disabled'
        enabled: false
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntInput {
                    width: 150
                    placeholderText: 'Basic Usage'
                }

                AntInput {
                    width: 150
                    placeholderText: 'Clear Active'
                    clearable: 'active'
                }

                AntInput {
                    width: 150
                    iconPosition: AntInput.PositionLeft
                    iconSource: AntIcon.UserOutlined
                    placeholderText: 'Username'
                }

                AntInput {
                    width: 150
                    iconPosition: AntInput.PositionRight
                    iconSource: AntIcon.UserOutlined
                    placeholderText: 'Username'
                }

                AntInput {
                    width: 150
                    placeholderText: 'Disabled'
                    enabled: false
                }
            }
        }
    }
}
