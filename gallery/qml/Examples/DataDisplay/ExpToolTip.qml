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
# AntToolTip 文字提示\n
单的文字提示气泡框。\n
* **继承自 { ToolTip }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
arrowVisible | bool | false | 是否显示箭头
arrowOffset | int | 4 | 箭尖到组件的偏移量
position | enum | AntToolTip.PositionTop | 文字提示的位置(来自 AntToolTip)
colorText | color | - | 文本颜色
colorBg | color | - | 背景颜色
radiusBg | [AntRadius](internal://AntRadius) | - | 背景圆角半径
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
鼠标移入则显示提示，移出消失，气泡浮层不承载复杂文本和操作。\n
可用来代替系统默认的 \`title\` 提示，提供一个 \`按钮/文字/操作\` 的文案解释。\n
                       `)
        }

        ThemeToken {
            source: 'AntToolTip'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`arrowVisible\` 属性设置是否显示箭头\n
通过 \`position\` 属性设置文字提示的位置，支持的位置：\n
- 文字提示在项目上方(默认){ AntToolTip.PositionTop }\n
- 文字提示在项目下方{ AntToolTip.PositionBottom }\n
- 文字提示在项目左方{ AntToolTip.PositionLeft }\n
- 文字提示在项目右方{ AntToolTip.PositionRight }\n
                       `)
            code: `
import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Column {
    width: parent.width
    spacing: 10

    GridLayout {
        width: 400
        rows: 3
        columns: 3

        AntButton {
            Layout.alignment: Qt.AlignHCenter
            Layout.columnSpan: 3
            text: qsTr('上方')

            AntToolTip {
                visible: parent.hovered
                arrowVisible: true
                text: qsTr('上方文字提示')
            }
        }

        AntButton {
            Layout.alignment: Qt.AlignLeft
            text: qsTr('左方')

            AntToolTip {
                visible: parent.hovered
                arrowVisible: true
                text: qsTr('左方文字提示')
                position: AntToolTip.PositionLeft
            }
        }

        AntButton {
            Layout.alignment: Qt.AlignCenter
            text: qsTr('箭头中心')

            AntToolTip {
                x: 0
                visible: parent.hovered
                arrowVisible: true
                text: qsTr('箭头中心会自动指向 parent 的中心')
                position: AntToolTip.PositionTop
            }
        }

        AntButton {
            Layout.alignment: Qt.AlignRight
            text: qsTr('右方')

            AntToolTip {
                visible: parent.hovered
                arrowVisible: true
                text: qsTr('右方文字提示')
                position: AntToolTip.PositionRight
            }
        }

        AntButton {
            Layout.alignment: Qt.AlignHCenter
            Layout.columnSpan: 3
            text: qsTr('下方')

            AntToolTip {
                visible: parent.hovered
                arrowVisible: true
                text: qsTr('下方文字提示')
                position: AntToolTip.PositionBottom
            }
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                GridLayout {
                    width: 400
                    rows: 3
                    columns: 3

                    AntButton {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.columnSpan: 3
                        text: qsTr('上方')

                        AntToolTip {
                            visible: parent.hovered
                            arrowVisible: true
                            text: qsTr('上方文字提示')
                        }
                    }

                    AntButton {
                        Layout.alignment: Qt.AlignLeft
                        text: qsTr('左方')

                        AntToolTip {
                            visible: parent.hovered
                            arrowVisible: true
                            text: qsTr('左方文字提示')
                            position: AntToolTip.PositionLeft
                        }
                    }

                    AntButton {
                        Layout.alignment: Qt.AlignCenter
                        text: qsTr('箭头中心')

                        AntToolTip {
                            x: 0
                            visible: parent.hovered
                            arrowVisible: true
                            text: qsTr('箭头中心会自动指向 parent 的中心')
                            position: AntToolTip.PositionTop
                        }
                    }

                    AntButton {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr('右方')

                        AntToolTip {
                            visible: parent.hovered
                            arrowVisible: true
                            text: qsTr('右方文字提示')
                            position: AntToolTip.PositionRight
                        }
                    }

                    AntButton {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.columnSpan: 3
                        text: qsTr('下方')

                        AntToolTip {
                            visible: parent.hovered
                            arrowVisible: true
                            text: qsTr('下方文字提示')
                            position: AntToolTip.PositionBottom
                        }
                    }
                }
            }
        }
    }
}
