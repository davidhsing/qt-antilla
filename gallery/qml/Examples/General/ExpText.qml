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
# AntText 文本\n
提供统一字体和颜色的文本(替代Text)。\n
* **继承自 { Text }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
hovered | (readonly)bool | - | 鼠标是否悬停（只读）
colorText | color | - | 文本颜色
colorTextDisabled | color | - | 禁用状态文本颜色
colorTextHover | color | - | 悬停状态文本颜色
cursorShape | enumeration | Qt.ArrowCursor | 鼠标光标形状
`)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
需要统一字体和颜色的文本时建议使用。
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`Text\`
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 15

    AntSwitch {
        id: enabledSwitch
        checked: true
        checkedText: qsTr('启用')
        uncheckedText: qsTr('禁用')
    }

    AntText {
        enabled: enabledSwitch.checked
        text: qsTr('AntText 文本')
        colorTextHover: 'red'
    }
}
            `
            exampleDelegate: Column {
                spacing: 15

                AntSwitch {
                    id: enabledSwitch
                    checked: true
                    checkedText: qsTr('启用')
                    uncheckedText: qsTr('禁用')
                }

                AntText {
                    enabled: enabledSwitch.checked
                    text: qsTr('AntText 文本')
                    colorTextHover: 'red'
                }
            }
        }
    }
}
