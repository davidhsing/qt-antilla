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
# AntTourFocus 漫游焦点\n
聚焦于某个功能的焦点。\n
* **继承自 { Popup }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
penetrationEvent | bool | false | 是否可穿透事件
maskClosable | bool | true | 是否允许点击蒙层来关闭
target | Item | - | 焦点目标
overlayColor | color | - | 覆盖层颜色
focusMargin | int | 5 | 焦点边距
focusRadius | int | 2 | 焦点圆角
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
用户需要聚焦于某个功能的焦点时使用。\n
本组件将通过高亮 \`target\` 项的方式来吸引注意力。\n
                       `)
        }

        ThemeToken {
            source: 'AntTour'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
通过 \`target\` 属性设置焦点目标。\n
通过 \`overlayColor\` 属性设置覆盖层颜色。\n
通过 \`focusMargin\` 属性设置焦点边距。\n
通过 \`focusRadius\` 属性设置焦点圆角。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntButton {
        text: qsTr('漫游焦点')
        type: AntButton.TypePrimary
        onClicked: {
            tourFocus.open();
        }

        AntTourFocus {
            id: tourFocus
            target: tourFocus1
        }
    }

    Row {
        spacing: 10

        AntButton {
            id: tourFocus1
            text: qsTr('漫游焦点1')
            type: AntButton.TypeOutlined
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntButton {
                    text: qsTr('漫游焦点')
                    type: AntButton.TypePrimary
                    onClicked: {
                        tourFocus.open();
                    }

                    AntTourFocus {
                        id: tourFocus
                        target: tourFocusButton
                    }
                }

                Row {
                    spacing: 10

                    AntButton {
                        id: tourFocusButton
                        text: qsTr('漫游焦点1')
                        type: AntButton.TypeOutlined
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('聚焦组件可交互')
            desc: qsTr(`
通过 \`penetrationEvent\` 属性设置是否可穿透事件。\n
                       `)
            code: `
import QtQuick
import QtQuick.Controls.Basic
import Antilla.Basic

Column {
    spacing: 10

    AntButton {
        text: qsTr('穿透焦点')
        type: AntButton.TypePrimary
        onClicked: {
            tourFocus2.open();
        }

        AntTourFocus {
            id: tourFocus2
            target: tourFocusGrid
            penetrationEvent: true
            focusMargin: marginSlider.currentValue
            focusRadius: radiusSlider.currentValue
            closePolicy: Popup.CloseOnEscape
        }
    }

    Grid {
        id: tourFocusGrid
        spacing: 10
        columns: 2
        verticalItemAlignment: Grid.AlignVCenter

        AntText {
            text: 'Margin: '
        }

        AntSlider {
            id: marginSlider
            width: 200
            height: 30
            min: 0
            max: 20
            value: 5
            handleToolTipDelegate: AntToolTip {
                visible: handleHovered || handlePressed
                text: marginSlider.currentValue.toFixed(0)
            }
        }

        AntText {
            text: 'Radius: '
        }

        AntSlider {
            id: radiusSlider
            width: 200
            height: 30
            min: 0
            max: 20
            handleToolTipDelegate: AntToolTip {
                visible: handleHovered || handlePressed
                text: radiusSlider.currentValue.toFixed(0)
            }
        }

        AntButton {
            text: qsTr('漫游焦点1')
            type: AntButton.TypeOutlined
        }

        AntButton {
            text: qsTr('关闭')
            type: AntButton.TypeOutlined
            onClicked: tourFocus2.close();
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntButton {
                    text: qsTr('穿透焦点')
                    type: AntButton.TypePrimary
                    onClicked: {
                        tourFocus2.open();
                    }

                    AntTourFocus {
                        id: tourFocus2
                        target: tourFocusGrid
                        penetrationEvent: true
                        focusMargin: marginSlider.currentValue
                        focusRadius: radiusSlider.currentValue
                        closePolicy: Popup.CloseOnEscape
                    }
                }

                Grid {
                    id: tourFocusGrid
                    spacing: 10
                    columns: 2
                    verticalItemAlignment: Grid.AlignVCenter

                    AntText {
                        text: 'Margin: '
                    }

                    AntSlider {
                        id: marginSlider
                        width: 200
                        height: 30
                        min: 0
                        max: 20
                        value: 5
                        handleToolTipDelegate: AntToolTip {
                            visible: handleHovered || handlePressed
                            text: marginSlider.currentValue.toFixed(0)
                        }
                    }

                    AntText {
                        text: 'Radius: '
                    }

                    AntSlider {
                        id: radiusSlider
                        width: 200
                        height: 30
                        min: 0
                        max: 20
                        handleToolTipDelegate: AntToolTip {
                            visible: handleHovered || handlePressed
                            text: radiusSlider.currentValue.toFixed(0)
                        }
                    }

                    AntButton {
                        text: qsTr('漫游焦点1')
                        type: AntButton.TypeOutlined
                    }

                    AntButton {
                        text: qsTr('关闭')
                        type: AntButton.TypeOutlined
                        onClicked: tourFocus2.close();
                    }
                }
            }
        }
    }
}
