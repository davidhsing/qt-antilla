import QtQuick
import Antilla.Basic
import '../../Controls'

Flickable {
    contentHeight: column.height
    AntScrollBar.vertical: AntScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# AntQrCode 二维码\n
能够将文本转换生成二维码的组件，支持自定义配色和 Logo 配置。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
text | string | '' | 要编码的内容
margin | int | 4 | 边距
errorLevel | enum | AntQrCode.Medium | 纠错等级(来自 AntQrCode)
icon.url | url | '' | 图标链接
icon.width | int | 40 | 图标宽度
icon.height | int | 40 | 图高度标
color | color | 'black' | 二维码颜色
colorMargin | color | 'transparent' | 边距颜色
colorBg | color | 'transparent' | 背景颜色
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当需要将文本转换成为二维码时使用。\n
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本使用')
            desc: qsTr(`
通过 \`text\` 属性设置文本内容。\n
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Column {
                    spacing: 10

                    AntQrCode {
                        text: input.text
                        color: AntTheme.Primary.colorTextBase

                        Rectangle {
                            anchors.fill: parent
                            radius: AntTheme.Primary.radiusPrimary
                            color: 'transparent'
                            border.color: AntTheme.Primary.colorFillPrimary
                        }
                    }

                    AntInput {
                        id: input
                        width: 280
                        maximumLength: 60
                        text: 'https://github.com/davidhsing/qt-antilla'
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                AntQrCode {
                    text: input.text
                    color: AntTheme.Primary.colorTextBase

                    Rectangle {
                        anchors.fill: parent
                        radius: AntTheme.Primary.radiusPrimary
                        color: 'transparent'
                        border.color: AntTheme.Primary.colorFillPrimary
                    }
                }

                AntInput {
                    id: input
                    width: 280
                    maximumLength: 60
                    text: 'https://github.com/davidhsing/qt-antilla'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('带 Icon 的例子')
            desc: qsTr(`
通过 \`icon\` 属性设置图标对象，支持的属性有：\n
- icon.url 图标链接\n
- icon.width 图标宽度(默认40)\n
- icon.height 图标高度(默认40)\n
通过 \`errorLevel\` 属性设置错误级别，支持的级别有：\n
- L级 { AntQrCode.Low }\n
- M级(默认) { AntQrCode.Medium }\n
- Q级 { AntQrCode.Quartile }\n
- H级{ AntQrCode.High }\n
**说明:** L级 可纠正约 7% 错误、M级 可纠正约 15% 错误、Q级 可纠正约 25% 错误、H级 可纠正约30% 错误。\n
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Column {
                    spacing: 10

                    AntQrCode {
                        text: 'https://github.com/davidhsing/qt-antilla'
                        errorLevel: AntQrCode.High
                        color: AntTheme.Primary.colorTextBase
                        icon.url: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'

                        Rectangle {
                            anchors.fill: parent
                            radius: AntTheme.Primary.radiusPrimary
                            color: 'transparent'
                            border.color: AntTheme.Primary.colorFillPrimary
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                AntQrCode {
                    text: 'https://github.com/davidhsing/qt-antilla'
                    errorLevel: AntQrCode.High
                    color: AntTheme.Primary.colorTextBase
                    icon.url: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'

                    Rectangle {
                        anchors.fill: parent
                        radius: AntTheme.Primary.radiusPrimary
                        color: 'transparent'
                        border.color: AntTheme.Primary.colorFillPrimary
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义尺寸')
            desc: qsTr(`
通过 \`width/height\` 属性设置二维码大小。\n
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Column {
                    spacing: 10

                    AntButtonBlock {
                        id: sizeBlock
                        model: [
                            { iconSource: AntIcon.MinusOutlined, autoRepeat: true, label: 'Smaller' },
                            { iconSource: AntIcon.PlusOutlined, autoRepeat: true, label: 'Larger' },
                        ]
                        onClicked:
                            (index) => {
                                if (index === 0) size = Math.max(48, Math.min(300, size - 10));
                                if (index === 1) size = Math.max(48, Math.min(300, size + 10));
                            }
                        property int size: 160
                    }

                    AntQrCode {
                        text: 'https://github.com/davidhsing/qt-antilla'
                        width: sizeBlock.size
                        height: sizeBlock.size
                        errorLevel: AntQrCode.High
                        color: AntTheme.Primary.colorTextBase
                        icon.url: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'

                        Rectangle {
                            anchors.fill: parent
                            radius: AntTheme.Primary.radiusPrimary
                            color: 'transparent'
                            border.color: AntTheme.Primary.colorFillPrimary
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                AntButtonBlock {
                    id: sizeBlock
                    model: [
                        { iconSource: AntIcon.MinusOutlined, autoRepeat: true, label: 'Smaller' },
                        { iconSource: AntIcon.PlusOutlined, autoRepeat: true, label: 'Larger' },
                    ]
                    onClicked:
                        (index) => {
                            if (index === 0) size = Math.max(48, Math.min(300, size - 10));
                            if (index === 1) size = Math.max(48, Math.min(300, size + 10));
                        }
                    property int size: 160
                }

                AntQrCode {
                    text: 'https://github.com/davidhsing/qt-antilla'
                    width: sizeBlock.size
                    height: sizeBlock.size
                    errorLevel: AntQrCode.High
                    color: AntTheme.Primary.colorTextBase
                    icon.url: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'

                    Rectangle {
                        anchors.fill: parent
                        radius: AntTheme.Primary.radiusPrimary
                        color: 'transparent'
                        border.color: AntTheme.Primary.colorFillPrimary
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义颜色')
            desc: qsTr(`
通过 \`color\` 属性设置二维码颜色。\n
通过 \`colorBg\` 属性设置背景颜色。\n
通过 \`colorMargin\` 属性设置边缘颜色。\n
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Row {
                    spacing: 10

                    AntQrCode {
                        text: 'https://github.com/davidhsing/qt-antilla'
                        color: AntTheme.Primary.colorSuccess
                    }

                    AntQrCode {
                        text: 'https://github.com/davidhsing/qt-antilla'
                        color: AntTheme.Primary.colorInfo
                        colorBg: AntTheme.Primary.colorWarning
                        colorMargin: "#80ff0000"
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                AntQrCode {
                    text: 'https://github.com/davidhsing/qt-antilla'
                    color: AntTheme.Primary.colorSuccess
                }

                AntQrCode {
                    text: 'https://github.com/davidhsing/qt-antilla'
                    color: AntTheme.Primary.colorInfo
                    colorBg: AntTheme.Primary.colorWarning
                    colorMargin: "#80ff0000"
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('高级用法')
            desc: qsTr(`
带气泡卡片的例子。\n
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Row {
                    spacing: 10

                    AntButton {
                        text: 'Hover me'
                        type: AntButton.TypePrimary

                        AntPopover {
                            x: (parent.width - width) / 2
                            y: parent.height + 6
                            width: 160
                            visible: parent.hovered || parent.down
                            closePolicy: AntPopover.NoAutoClose
                            contentDelegate: AntQrCode {
                                text: 'https://github.com/davidhsing/qt-antilla'
                                color: AntTheme.Primary.colorTextBase
                            }
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                AntButton {
                    text: 'Hover me'
                    type: AntButton.TypePrimary

                    AntPopover {
                        x: (parent.width - width) / 2
                        y: parent.height + 6
                        width: 160
                        visible: parent.hovered || parent.down
                        closePolicy: AntPopover.NoAutoClose
                        contentDelegate: AntQrCode {
                            text: 'https://github.com/davidhsing/qt-antilla'
                            color: AntTheme.Primary.colorTextBase
                        }
                    }
                }
            }
        }
    }
}
