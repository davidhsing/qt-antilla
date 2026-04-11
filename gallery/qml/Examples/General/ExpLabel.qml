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
# AntLabel 文本标签\n
扩展了AntText(文本)的功能, 并自带背景和圆角。\n
* **继承自 { Label }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
hovered | (readonly)bool | - | 鼠标是否悬停（只读）
borderWidth | real | 1 | 边框宽度
colorText | color | - | 文本颜色
colorTextDisabled | color | - | 禁用状态文本颜色
colorTextHover | color | - | 悬停状态文本颜色
colorBg | color | - | 背景颜色
colorBgDisabled | color | - | 禁用状态背景颜色
colorBgHover | color | - | 悬停状态背景颜色
colorBorder | color | - | 边框颜色
colorBorderDisabled | color | - | 禁用状态边框颜色
colorBorderHover | color | - | 悬停状态边框颜色
radiusBg | [AntRadius](internal://AntRadius) | - | 背景圆角
cursorShape | enumeration | Qt.ArrowCursor | 鼠标光标形状
`)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
需要统一字体和颜色的并带自背景和圆角的文本时。
                       `)
        }

        ThemeToken {
            source: 'AntLabel'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`Label\`
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Column {
                    spacing: 15

                    Row {
                        AntText {
                            anchors.verticalCenter: parent.verticalCenter
                            text: 'Radius:   '
                        }
                        AntSlider {
                            id: radiusSlider
                            width: 150
                            height: 30
                            min: 0
                            max: 30
                            initialValue: 4
                        }
                    }

                    AntSwitch {
                        id: enabledSwitch
                        checked: true
                        checkedText: qsTr('启用')
                        uncheckedText: qsTr('禁用')
                    }

                    AntLabel {
                        padding: 20
                        text: qsTr('AntLabel 文本')
                        enabled: enabledSwitch.checked
                        colorTextHover: 'red'
                        radiusBg.all: radiusSlider.value[0]
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        width: 250
                        height: 60
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                Row {
                    AntText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: 'Radius:   '
                    }
                    AntSlider {
                        id: radiusSlider
                        width: 150
                        height: 30
                        min: 0
                        max: 30
                        initialValue: 4
                    }
                }

                AntSwitch {
                    id: enabledSwitch
                    checked: true
                    checkedText: qsTr('启用')
                    uncheckedText: qsTr('禁用')
                }

                AntLabel {
                    padding: 20
                    text: qsTr('AntLabel 文本')
                    enabled: enabledSwitch.checked
                    colorTextHover: 'red'
                    radiusBg.all: radiusSlider.value[0]
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    width: 250
                    height: 60
                }
            }
        }
    }
}
