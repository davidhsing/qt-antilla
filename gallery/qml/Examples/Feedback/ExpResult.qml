import QtQuick
import QtQuick.Layouts
import Antilla.Basic
import '../../Controls'

Flickable {
    contentHeight: column.height
    AntScrollBar.vertical: AntScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 30

        Description {
            width: parent.width
            desc: qsTr(`
# AntResult 结果\n
用于反馈一系列操作任务的处理结果。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **bgDelegate: Component** 背景代理\n
- **extraDelegate: Component** 额外操作代理\n
- **titleDelegate: Component** 标题代理\n
- **descriptionDelegate: Component** 描述代理\n
- **actionDelegate: Component** 操作代理\n
- **footerDelegate: Component** 页脚代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
type | enum | AntResult.TypeInfo | 结果类型
borderVisible | bool | true | 外侧边框是否可见
iconVisible | bool | - | 图标是否可见
extraVisible | bool | true | 额外内容是否可见
titleVisible | bool | - | 标题是否可见
descriptionVisible | bool | - | 描述是否可见
actionVisible | bool | true | 操作区是否可见
footerVisible | bool | true | 页脚是否可见
iconImageSource | url | - | 自定义图片源
iconImageWidth | int | - | 自定义图片的宽度
iconImageHeight | int | - | 自定义图片的高度
iconSource | url | - | 图标源
iconSize | int | 80 | 图标大小
colorIcon | color | - | 图标颜色
extraPosition | AntResult.ExtraPosition | PositionRight | 额外内容位置
titleText | string | - | 标题文本
titleFont | font | - | 标题字体
descriptionText | string | - | 描述文本
descriptionFont | font | - | 描述字体
spacing | int | 16 | 间距
colorBg | color | - | 背景颜色
radiusBg | [AntRadius](internal://AntRadius) | 6 | 背景圆角半径
marginExtra | [AntMargin](internal://AntMargin) | 0 | 额外内容边距
marginIcon | [AntMargin](internal://AntMargin) | { top: 8; bottom: 0 } | 图标边距
marginTitle | [AntMargin](internal://AntMargin) | { top: 4; bottom: 0 } | 标题边距
marginDescription | [AntMargin](internal://AntMargin) | 0 | 描述边距
marginAction | [AntMargin](internal://AntMargin) | 0 | 操作区边距
marginFooter | [AntMargin](internal://AntMargin) | 0 | 页脚边距
\n<br/>
\n### 枚举：
- \`AntResult.TypeInfo\` 信息
- \`AntResult.TypeWarning\` 警告
- \`AntResult.TypeSuccess\` 成功
- \`AntResult.TypeError\` 错误
- \`AntResult.PositionLeft\` 左侧
- \`AntResult.PositionRight\` 右侧
            `)
        }

        Description {
            width: parent.width
            title: qsTr('何时使用')
            desc: qsTr('当有重要的操作需要告知用户处理结果时使用。')
        }

        ThemeToken {
            source: 'AntResult'
        }

        Description {
            width: parent.width
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            async: false
            descTitle: qsTr('成功')
            desc: qsTr('表示操作成功完成。')
            code: `
import QtQuick
import QtQuick.Layouts
import Antilla.Basic

AntResult {
    type: AntResult.TypeSuccess
    titleText: 'Successfully Purchased Cloud Server ECS'
    descriptionText: 'Order number: 2017182818828182881 Cloud server configuration takes 1-5 minutes, please wait.'
    actionDelegate: Item {
        height: 40

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            AntButton {
                text: 'Go Console'
                type: AntButton.TypePrimary
            }

            AntButton {
                text: 'Buy Again'
                type: AntButton.TypeDefault
            }
        }
    }
}`
            exampleDelegate: AntResult {
                type: AntResult.TypeSuccess
                titleText: 'Successfully Purchased Cloud Server ECS'
                descriptionText: 'Order number: 2017182818828182881 Cloud server configuration takes 1-5 minutes, please wait.'
                actionDelegate: Item {
                    height: 40

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        AntButton {
                            text: 'Go Console'
                            type: AntButton.TypePrimary
                        }

                        AntButton {
                            text: 'Buy Again'
                            type: AntButton.TypeDefault
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            async: false
            descTitle: qsTr('失败')
            desc: qsTr('表示操作失败。')
            code: `
import QtQuick
import QtQuick.Layouts
import Antilla.Basic

AntResult {
    type: AntResult.TypeError
    titleText: 'Submission Failed'
    descriptionText: 'Please check and modify the following information before resubmitting.'
    actionDelegate: Item {
        height: 40

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            AntButton {
                text: 'Go Console'
                type: AntButton.TypePrimary
            }

            AntButton {
                text: 'Buy Again'
                type: AntButton.TypeDefault
            }
        }
    }
}`
            exampleDelegate: AntResult {
                type: AntResult.TypeError
                titleText: 'Submission Failed'
                descriptionText: 'Please check and modify the following information before resubmitting.'
                actionDelegate: Item {
                    height: 40

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        AntButton {
                            text: 'Go Console'
                            type: AntButton.TypePrimary
                        }

                        AntButton {
                            text: 'Buy Again'
                            type: AntButton.TypeDefault
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            async: false
            descTitle: qsTr('信息')
            desc: qsTr('表示操作信息提示。')
            code: `
import QtQuick
import QtQuick.Layouts
import Antilla.Basic

AntResult {
    type: AntResult.TypeInfo
    titleText: 'Your operation has been executed'
    descriptionVisible: false
    actionDelegate: Item {
        height: 40

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            AntButton {
                text: 'Go Console'
                type: AntButton.TypePrimary
            }

            AntButton {
                text: 'Buy Again'
                type: AntButton.TypeDefault
            }
        }
    }
}`
            exampleDelegate: AntResult {
                type: AntResult.TypeInfo
                titleText: 'Your operation has been executed'
                descriptionVisible: false
                actionDelegate: Item {
                    height: 40

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        AntButton {
                            text: 'Go Console'
                            type: AntButton.TypePrimary
                        }

                        AntButton {
                            text: 'Buy Again'
                            type: AntButton.TypeDefault
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            async: false
            descTitle: qsTr('警告')
            desc: qsTr('表示操作警告。')
            code: `
import QtQuick
import QtQuick.Layouts
import Antilla.Basic

AntResult {
    type: AntResult.TypeWarning
    titleText: 'There are some problems with your operation.'
    descriptionVisible: false
    extraPosition: AntResult.PositionRight
    extraDelegate: AntIconButton {
        iconSource: AntIcon.CloseOutlined
        type: AntIconButton.TypeText
    }
    actionDelegate: Item {
        height: 40

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            AntButton {
                text: 'Go Console'
                type: AntButton.TypePrimary
            }

            AntButton {
                text: 'Buy Again'
                type: AntButton.TypeDefault
            }
        }
    }
}`
            exampleDelegate: AntResult {
                type: AntResult.TypeWarning
                titleText: 'There are some problems with your operation.'
                descriptionVisible: false
                extraPosition: AntResult.PositionRight
                extraDelegate: AntIconButton {
                    iconSource: AntIcon.CloseOutlined
                    type: AntIconButton.TypeText
                }
                actionDelegate: Item {
                    height: 40

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        AntButton {
                            text: 'Go Console'
                            type: AntButton.TypePrimary
                        }

                        AntButton {
                            text: 'Buy Again'
                            type: AntButton.TypeDefault
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            async: false
            descTitle: qsTr('自定义图片')
            desc: qsTr('使用自定义图片作为图标。')
            code: `
import QtQuick
import QtQuick.Layouts
import Antilla.Basic

AntResult {
    type: AntResult.TypeSuccess
    titleText: 'Custom Image Result'
    descriptionText: 'This result uses a custom image as the icon.'
    iconImageSource: 'qrc:/Antilla/resources/images/empty-default.svg'
    actionDelegate: Item {
        height: 40

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            AntButton {
                text: 'Go Console'
                type: AntButton.TypePrimary
            }

            AntButton {
                text: 'Buy Again'
                type: AntButton.TypeDefault
            }
        }
    }
}`
            exampleDelegate: AntResult {
                type: AntResult.TypeSuccess
                titleText: 'Custom Image Result'
                descriptionText: 'This result uses a custom image as the icon.'
                iconImageSource: 'qrc:/Antilla/resources/images/empty-default.svg'
                actionDelegate: Item {
                    height: 40

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        AntButton {
                            text: 'Go Console'
                            type: AntButton.TypePrimary
                        }

                        AntButton {
                            text: 'Buy Again'
                            type: AntButton.TypeDefault
                        }
                    }
                }
            }
        }
    }
}
