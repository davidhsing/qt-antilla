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
# AntGroupBox 分组框
用于将相关内容组织在一起的分组框。
* **继承自 { [Item](internal://Item) }**
\n<br/>
\n### 支持的代理：\n
- **titleDelegate: Component** 标题代理\n
- **borderDelegate: Component** 边框代理\n
\n<br/>
\n### 支持的属性：
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否启用动画
titleVisible | bool | - | 标题是否可见
titleText | string | '' | 标题文本
titlePosition | enum | PositionTop | 标题位置(PositionTop/PositionBottom)（来自 AntGroupBox）
titleAlign | enum | AlignLeft | 标题对齐方式(AlignLeft/AlignCenter/AlignRight)（来自 AntGroupBox）
titlePadding | int | 20 | 标题距离边框的水平距离
titleLeftPadding | int | 4 | 标题左侧内边距
titleRightPadding | int | 4 | 标题右侧内边距
titleFont | font | - | 标题字体
borderWidth | int | 1 | 边框宽度
colorTitle | color | - | 标题颜色
colorBorder | color | - | 边框颜色
colorBg | color | - | 背景颜色
radiusBg | [AntRadius](internal://AntRadius) | - | 背景圆角半径
contentMargins | int | 16 | 内容区域统一边距
contentTopMargin | int | - | 内容区域顶部边距(标题在顶部时为15)
contentBottomMargin | int | - | 内容区域底部边距(标题在底部时为15)
contentLeftMargin | int | - | 内容区域左侧边距
contentRightMargin | int | - | 内容区域右侧边距
\n<br/>
            `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要管理表单项，将相关内容组织在一起时
            `)
        }

        ThemeToken {
            source: 'AntGroupBox'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基础用法')
            desc: qsTr('最简单的用法,默认标题在顶部左对齐。')
            code: `
AntGroupBox {
    titleText: '用户信息'

    Column {
        width: parent.width
        spacing: 10

        AntText { text: '姓名: 张三' }
        AntText { text: '年龄: 25' }
        AntText { text: '职业: 软件工程师' }
    }
}`
            exampleDelegate: AntGroupBox {
                titleText: qsTr('用户信息')

                Column {
                    width: parent.width
                    spacing: 10

                    AntText { text: qsTr('姓名: 张三') }
                    AntText { text: qsTr('年龄: 25') }
                    AntText { text: qsTr('职业: 软件工程师') }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('标题位置')
            desc: qsTr('可以设置标题在顶部或底部。')
            code: `
Row {
    width: parent.width
    spacing: 20

    AntGroupBox {
        width: 250
        height: 150
        titleText: '顶部标题'
        titlePosition: AntGroupBox.PositionTop

        AntText {
            anchors.centerIn: parent
            text: '标题在顶部'
        }
    }

    AntGroupBox {
        width: 250
        height: 150
        titleText: '底部标题'
        titlePosition: AntGroupBox.PositionBottom

        AntText {
            anchors.centerIn: parent
            text: '标题在底部'
        }
    }
}`
            exampleDelegate: Row {
                width: parent.width
                spacing: 20

                AntGroupBox {
                    width: 250
                    height: 150
                    titleText: qsTr('顶部标题')
                    titlePosition: AntGroupBox.PositionTop

                    AntText {
                        anchors.centerIn: parent
                        text: qsTr('标题在顶部')
                    }
                }

                AntGroupBox {
                    width: 250
                    height: 150
                    titleText: qsTr('底部标题')
                    titlePosition: AntGroupBox.PositionBottom

                    AntText {
                        anchors.centerIn: parent
                        text: qsTr('标题在底部')
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('标题对齐')
            desc: qsTr('可以设置标题左对齐、居中或右对齐。')
            code: `
Column {
    width: parent.width
    spacing: 20

    AntGroupBox {
        width: 400
        height: 100
        titleText: '左对齐'
        titleAlign: AntGroupBox.AlignLeft

        AntText {
            anchors.centerIn: parent
            text: '标题左对齐'
        }
    }

    AntGroupBox {
        width: 400
        height: 100
        titleText: '居中对齐'
        titleAlign: AntGroupBox.AlignCenter

        AntText {
            anchors.centerIn: parent
            text: '标题居中对齐'
        }
    }

    AntGroupBox {
        width: 400
        height: 100
        titleText: '右对齐'
        titleAlign: AntGroupBox.AlignRight

        AntText {
            anchors.centerIn: parent
            text: '标题右对齐'
        }
    }
}`
            exampleDelegate: Column {
                width: parent.width
                spacing: 20

                AntGroupBox {
                    width: 400
                    height: 100
                    titleText: qsTr('左对齐')
                    titleAlign: AntGroupBox.AlignLeft

                    AntText {
                        anchors.centerIn: parent
                        text: qsTr('标题左对齐')
                    }
                }

                AntGroupBox {
                    width: 400
                    height: 100
                    titleText: qsTr('居中对齐')
                    titleAlign: AntGroupBox.AlignCenter

                    AntText {
                        anchors.centerIn: parent
                        text: qsTr('标题居中对齐')
                    }
                }

                AntGroupBox {
                    width: 400
                    height: 100
                    titleText: qsTr('右对齐')
                    titleAlign: AntGroupBox.AlignRight

                    AntText {
                        anchors.centerIn: parent
                        text: qsTr('标题右对齐')
                    }
                }
            }
        }
    }
}
