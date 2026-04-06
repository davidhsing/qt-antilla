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
# AntDivider 分割线\n
区隔内容的分割线。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **titleDelegate: Component** 标题代理\n
- **splitDelegate: Component** 分割线代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
titleVisible | bool | - | 标题是否可见
titleSplit | bool | true | 是否自动拆分标题(垂直方向)
titleText | string | '' | 标题
titleFont | font | - | 标题字体
titleAlign | enum | AntDivider.AlignLeft | 标题对齐(来自 AntDivider)
titlePadding | int | 20 | 标题填充
lineStyle | enum | AntDivider.LineSolid | 分割线样式(来自 AntDivider)
lineWidth | real | 1 | 分割线宽度
dashPattern | list | [4, 2] | 分割线虚线模式
orientation | enum | Qt.Horizontal | 方向(Qt.Horizontal 或 Qt.Vertical)
colorText | color | - | 标题颜色
colorSplit | color | - | 分割线颜色
ariaConstrual | string | '' | 内容描述(提高可用性)
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 对不同章节的文本段落进行分割。\n
- 对行内文字/链接进行分割，例如表格的操作列。\n
                       `)
        }

        ThemeToken {
            source: 'AntDivider'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`titleText\` 属性改变标题文字\n
通过 \`titleAlign\` 属性改变标题对齐，支持的对齐：\n
- 居左(默认){ AntDivider.AlignLeft }\n
- 居中{ AntDivider.AlignCenter }\n
- 居右{ AntDivider.AlignRight }
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Column {
                    width: parent.width
                    spacing: 15

                    AntText {
                        width: parent.width
                        text: qsTr('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.')
                        wrapMode: Text.WrapAnywhere
                    }

                    AntDivider {
                        width: parent.width
                        height: 30
                        titleText: qsTr('水平分割线-居左')
                        titleAlign: AntDivider.AlignLeft
                    }

                    AntDivider {
                        width: parent.width
                        height: 30
                        titleText: qsTr('水平分割线-居中')
                        titleAlign: AntDivider.AlignCenter
                    }

                    AntDivider {
                        width: parent.width
                        height: 30
                        titleText: qsTr('水平分割线-居右')
                        titleAlign: AntDivider.AlignRight
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                AntText {
                    width: parent.width
                    text: qsTr('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.')
                    wrapMode: Text.WrapAnywhere
                }

                AntDivider {
                    width: parent.width
                    height: 30
                    titleText: qsTr('水平分割线-居左')
                    titleAlign: AntDivider.AlignLeft
                }

                AntDivider {
                    width: parent.width
                    height: 30
                    titleText: qsTr('水平分割线-居中')
                    titleAlign: AntDivider.AlignCenter
                }

                AntDivider {
                    width: parent.width
                    height: 30
                    titleText: qsTr('水平分割线-居右')
                    titleAlign: AntDivider.AlignRight
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`orientation\` 属性改变方向，支持的方向：\n
- 水平分割线(默认){ Qt.Horizontal }\n
- 垂直分割线{ Qt.Vertical }\n
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Column {
                    width: parent.width
                    spacing: 15

                    AntText {
                        width: parent.width
                        text: qsTr('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.')
                        wrapMode: Text.WrapAnywhere
                    }

                    AntDivider {
                        width: parent.width
                        height: 30
                        titleText: qsTr('水平分割线')
                    }

                    AntDivider {
                        width: 30
                        height: 200
                        orientation: Qt.Vertical
                        titleAlign: AntDivider.AlignCenter
                        titleText: qsTr('垂直分割线')
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                AntText {
                    width: parent.width
                    text: qsTr('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.')
                    wrapMode: Text.WrapAnywhere
                }

                AntDivider {
                    width: parent.width
                    height: 30
                    titleText: qsTr('水平分割线')
                }

                AntDivider {
                    width: 30
                    height: 200
                    orientation: Qt.Vertical
                    titleAlign: AntDivider.AlignCenter
                    titleText: qsTr('垂直分割线')
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`lineStyle\` 属性改变线条风格，支持的风格：\n
- 实线(默认){ AntDivider.LineSolid }\n
- 虚线{ AntDivider.LineDashed }
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Column {
                    width: parent.width
                    spacing: 15

                    AntText {
                        width: parent.width
                        text: qsTr('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.')
                        wrapMode: Text.WrapAnywhere
                    }

                    AntDivider {
                        width: parent.width
                        height: 30
                        titleText: qsTr('实线分割线')
                    }

                    AntDivider {
                        width: parent.width
                        height: 30
                        lineStyle: AntDivider.LineDashed
                        titleText: qsTr('虚线分割线')
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                AntText {
                    width: parent.width
                    text: qsTr('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.')
                    wrapMode: Text.WrapAnywhere
                }

                AntDivider {
                    width: parent.width
                    height: 30
                    titleText: qsTr('实线分割线')
                }

                AntDivider {
                    width: parent.width
                    height: 30
                    lineStyle: AntDivider.LineDashed
                    titleText: qsTr('虚线分割线')
                }
            }
        }
    }
}
