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
# AntButton 按钮\n
按钮用于开始一个即时操作。\n
* **继承自 { Button }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
active | bool | down丨checked | 是否处于激活状态
danger | bool | false | 是否警示状态
effectEnabled | bool | true | 是否开启点击效果
forceState | bool | false | 无禁用状态(即被禁用时不会更改颜色)
hoverCursorShape | int | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
type | enum | AntButton.TypeDefault | 按钮类型(来自 AntButton)
shape | enum | AntButton.ShapeDefault | 按钮形状(来自 AntButton)
radiusBg | [AntRadius](internal://AntRadius) | - | 背景圆角半径
colorText | color | - | 文本颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
ariaConstrual | string | '' | 内容描述(提高可用性)
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
标记了一个（或封装一组）操作命令，响应用户点击行为，触发相应的业务逻辑。\n
在 Antilla 中我们提供了五种按钮。\n
- 默认按钮：用于没有主次之分的一组行动点。\n
- 主要按钮：用于主行动点，一个操作区域只能有一个主按钮。\n
- 线框按钮：等同于默认按钮，但线框使用了主要颜色。\n
- 填充按钮：用于次级的行动点。\n
- 文本按钮：用于最次级的行动点。\n
- 链接按钮：一般用于链接，即导航至某位置。\n
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
通过 \`type\` 属性改变按钮类型，支持的类型：\n
- 默认按钮{ AntButton.TypeDefault }\n
- 线框按钮{ AntButton.TypeOutlined }\n
- 虚线按钮{ AntButton.TypeDashed }\n
- 主要按钮{ AntButton.TypePrimary }\n
- 填充按钮{ AntButton.TypeFilled }\n
- 文本按钮{ AntButton.TypeText }\n
- 链接按钮{ AntButton.TypeLink }\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 15

    AntButton {
        text: qsTr('默认')
    }

    AntButton {
        text: qsTr('线框')
        type: AntButton.TypeOutlined
    }

    AntButton {
        text: qsTr('虚线')
        type: AntButton.TypeDashed
    }

    AntButton {
        text: qsTr('主要')
        type: AntButton.TypePrimary
    }

    AntButton {
        text: qsTr('填充')
        type: AntButton.TypeFilled
    }

    AntButton {
        text: qsTr('文本')
        type: AntButton.TypeText
    }

    AntButton {
        text: qsTr('链接')
        type: AntButton.TypeLink
    }
}
            `
            exampleDelegate: Row {
                spacing: 15

                AntButton {
                    text: qsTr('默认')
                }

                AntButton {
                    text: qsTr('线框')
                    type: AntButton.TypeOutlined
                }

                AntButton {
                    text: qsTr('虚线')
                    type: AntButton.TypeDashed
                }

                AntButton {
                    text: qsTr('主要')
                    type: AntButton.TypePrimary
                }

                AntButton {
                    text: qsTr('填充')
                    type: AntButton.TypeFilled
                }

                AntButton {
                    text: qsTr('文本')
                    type: AntButton.TypeText
                }

                AntButton {
                    text: qsTr('链接')
                    type: AntButton.TypeLink
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`danger\` 属性设置危险按钮：\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 15

    AntButton {
        text: qsTr('默认')
        danger: true
    }

    AntButton {
        text: qsTr('线框')
        type: AntButton.TypeOutlined
        danger: true
    }

    AntButton {
        text: qsTr('虚线')
        type: AntButton.TypeDashed
        danger: true
    }

    AntButton {
        text: qsTr('主要')
        type: AntButton.TypePrimary
        danger: true
    }

    AntButton {
        text: qsTr('填充')
        type: AntButton.TypeFilled
        danger: true
    }

    AntButton {
        text: qsTr('文本')
        type: AntButton.TypeText
        danger: true
    }

    AntButton {
        text: qsTr('链接')
        type: AntButton.TypeLink
        danger: true
    }
}
            `
            exampleDelegate: Row {
                spacing: 15

                AntButton {
                    text: qsTr('默认')
                    danger: true
                }

                AntButton {
                    text: qsTr('线框')
                    type: AntButton.TypeOutlined
                    danger: true
                }

                AntButton {
                    text: qsTr('虚线')
                    type: AntButton.TypeDashed
                    danger: true
                }

                AntButton {
                    text: qsTr('主要')
                    type: AntButton.TypePrimary
                    danger: true
                }

                AntButton {
                    text: qsTr('填充')
                    type: AntButton.TypeFilled
                    danger: true
                }

                AntButton {
                    text: qsTr('文本')
                    type: AntButton.TypeText
                    danger: true
                }

                AntButton {
                    text: qsTr('链接')
                    type: AntButton.TypeLink
                    danger: true
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`enabled\` 属性启用或禁用按钮，禁用的按钮不会响应任何交互。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 15

    AntButton {
        text: qsTr('默认')
        enabled: false
    }

    AntButton {
        text: qsTr('线框')
        type: AntButton.TypeOutlined
        enabled: false
    }

    AntButton {
        text: qsTr('虚线')
        type: AntButton.TypeDashed
        enabled: false
    }

    AntButton {
        text: qsTr('主要')
        type: AntButton.TypePrimary
        enabled: false
    }

    AntButton {
        text: qsTr('填充')
        type: AntButton.TypeFilled
        enabled: false
    }

    AntButton {
        text: qsTr('文本')
        type: AntButton.TypeText
        enabled: false
    }

    AntButton {
        text: qsTr('链接')
        type: AntButton.TypeLink
        enabled: false
    }
}
            `
            exampleDelegate: Row {
                spacing: 15

                AntButton {
                    text: qsTr('默认')
                    enabled: false
                }

                AntButton {
                    text: qsTr('线框')
                    type: AntButton.TypeOutlined
                    enabled: false
                }

                AntButton {
                    text: qsTr('虚线')
                    type: AntButton.TypeDashed
                    enabled: false
                }

                AntButton {
                    text: qsTr('主要')
                    type: AntButton.TypePrimary
                    enabled: false
                }

                AntButton {
                    text: qsTr('填充')
                    type: AntButton.TypeFilled
                    enabled: false
                }

                AntButton {
                    text: qsTr('文本')
                    type: AntButton.TypeText
                    enabled: false
                }

                AntButton {
                    text: qsTr('链接')
                    type: AntButton.TypeLink
                    enabled: false
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`shape\` 属性改变按钮形状，支持的形状：\n
- 默认形状{ AntButton.ShapeDefault }\n
- 圆形{ AntButton.ShapeCircle }
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 15

    AntButton {
        text: qsTr('A')
        shape: AntButton.ShapeCircle
    }

    AntButton {
        text: qsTr('A')
        type: AntButton.TypeOutlined
        shape: AntButton.ShapeCircle
    }

    AntButton {
        text: qsTr('A')
        type: AntButton.TypeDashed
        shape: AntButton.ShapeCircle
    }

    AntButton {
        text: qsTr('A')
        type: AntButton.TypePrimary
        shape: AntButton.ShapeCircle
    }

    AntButton {
        text: qsTr('A')
        type: AntButton.TypeFilled
        shape: AntButton.ShapeCircle
    }

    AntButton {
        text: qsTr('A')
        type: AntButton.TypeText
        shape: AntButton.ShapeCircle
    }
}
            `
            exampleDelegate: Row {
                spacing: 15

                AntButton {
                    text: qsTr('A')
                    shape: AntButton.ShapeCircle
                }

                AntButton {
                    text: qsTr('A')
                    type: AntButton.TypeOutlined
                    shape: AntButton.ShapeCircle
                }

                AntButton {
                    text: qsTr('A')
                    type: AntButton.TypeDashed
                    shape: AntButton.ShapeCircle
                }

                AntButton {
                    text: qsTr('A')
                    type: AntButton.TypePrimary
                    shape: AntButton.ShapeCircle
                }

                AntButton {
                    text: qsTr('A')
                    type: AntButton.TypeFilled
                    shape: AntButton.ShapeCircle
                }

                AntButton {
                    text: qsTr('A')
                    type: AntButton.TypeText
                    shape: AntButton.ShapeCircle
                }
            }
        }
    }
}
