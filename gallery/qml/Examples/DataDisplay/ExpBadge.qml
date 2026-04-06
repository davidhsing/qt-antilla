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
# AntBadge 徽标数\n
图标右上角的圆形徽标数字。\n
* **继承自 { Item }**\n
<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
badgeState | enum | AntBadge.StateError | 徽标状态(来自 AntBadge)
stateEffect | bool | - | 是否有动态效果(默认 AntBadge.StateProcessing 有)
presetColor | color | '' | 预设颜色
count | int | 0 | 徽标展示的数字
iconSource | int丨string | 0丨'' | 徽标展示的图标(来自 AntIcon)或图标链接
dot | bool | false | 不展示数字,只有一个小红点(默认 false)
zeroVisible | bool | false | 当数值为 0 时, 是否展示 AntBadge
overflowCount | int | 99 | 展示封顶的数字值
font | font | - | 文本字体
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
colorText | color | - | 文本颜色
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
一般出现在通知图标或头像的右上角，用于显示需要处理的消息条数，通过醒目视觉形式吸引用户处理。\n
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
通过 \`count \` 属性设置展示的数字，大于 overflowCount 时显示为 {overflowCount}+，为 0 时隐藏。\n
通过 \`zeroVisible\` 属性设置为 0 时也显示数字。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 20

    AntAvatar {
        size: 40
        radiusBg.all: 6

        AntBadge { count: 5 }
    }

    AntAvatar {
        size: 40
        radiusBg.all: 6

        AntBadge { count: 0; zeroVisible: true }
    }

    AntAvatar {
        size: 40
        radiusBg.all: 6

        AntBadge {
            iconSource: AntIcon.ClockCircleOutlined
            colorBorder: 'transparent'
            colorBg: 'transparent'
            colorText: '#f5222d'
        }
    }
}
            `
            exampleDelegate: Row {
                spacing: 20

                AntAvatar {
                    size: 40
                    radiusBg.all: 6

                    AntBadge { count: 5 }
                }

                AntAvatar {
                    size: 40
                    radiusBg.all: 6

                    AntBadge { count: 0; zeroVisible: true }
                }

                AntAvatar {
                    size: 40
                    radiusBg.all: 6

                    AntBadge {
                        iconSource: AntIcon.ClockCircleOutlined
                        colorBorder: 'transparent'
                        colorBg: 'transparent'
                        colorText: '#f5222d'
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('独立使用')
            desc: qsTr(`
不包裹任何元素即是独立使用，可自定样式展现。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 10

    AntSwitch {
        id: showSwitch
        checked: false
    }

    AntBadge { count: showSwitch.checked ? 11 : 0; zeroVisible: true; colorBg: '#faad14' }
    AntBadge { count: showSwitch.checked ? 25 : 0 }
    AntBadge {
        iconSource: showSwitch.checked ? AntIcon.ClockCircleOutlined : 0
        colorBorder: 'transparent'
        colorBg: 'transparent'
        colorText: '#f5222d'
    }
    AntBadge { count: showSwitch.checked ? 109 : 0; colorBg: '#52c41a' }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntSwitch {
                    id: showSwitch
                    checked: false
                }

                AntBadge { count: showSwitch.checked ? 11 : 0; zeroVisible: true; colorBg: '#faad14' }
                AntBadge { count: showSwitch.checked ? 25 : 0 }
                AntBadge {
                    iconSource: showSwitch.checked ? AntIcon.ClockCircleOutlined : 0
                    colorBorder: 'transparent'
                    colorBg: 'transparent'
                    colorText: '#f5222d'
                }
                AntBadge { count: showSwitch.checked ? 109 : 0; colorBg: '#52c41a' }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('封顶数字')
            desc: qsTr(`
通过 \`overflowCount\` 属性设置展示封顶的数字值。\n
超过 \`overflowCount\` 的会显示为 \`{overflowCount}+\`，默认的 \`overflowCount\` 为 99。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 20

    AntAvatar {
        size: 40
        radiusBg.all: 6

        AntBadge { count: 99 }
    }

    AntAvatar {
        size: 40
        radiusBg.all: 6

        AntBadge { count: 100 }
    }

    AntAvatar {
        size: 40
        radiusBg.all: 6

        AntBadge { count: 99; overflowCount: 10 }
    }

    AntAvatar {
        size: 40
        radiusBg.all: 6

        AntBadge { count: 1000; overflowCount: 999 }
    }
}
            `
            exampleDelegate: Row {
                spacing: 20

                AntAvatar {
                    size: 40
                    radiusBg.all: 6

                    AntBadge { count: 99 }
                }

                AntAvatar {
                    size: 40
                    radiusBg.all: 6

                    AntBadge { count: 100 }
                }

                AntAvatar {
                    size: 40
                    radiusBg.all: 6

                    AntBadge { count: 99; overflowCount: 10 }
                }

                AntAvatar {
                    size: 40
                    radiusBg.all: 6

                    AntBadge { count: 1000; overflowCount: 999 }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('讨嫌的小红点')
            desc: qsTr(`
没有具体的数字。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 20

    AntIconText {
        iconSize: 18
        iconSource: AntIcon.NotificationOutlined

        AntBadge { dot: true }
    }

    AntButton {
        padding: 0
        topPadding: 0
        bottomPadding: 0
        type: AntButton.TypeLink
        text: 'Link something'

        AntBadge { dot: true }
    }
}
            `
            exampleDelegate: Row {
                spacing: 20

                AntIconText {
                    iconSize: 18
                    iconSource: AntIcon.NotificationOutlined

                    AntBadge { dot: true }
                }

                AntButton {
                    padding: 0
                    topPadding: 0
                    bottomPadding: 0
                    type: AntButton.TypeLink
                    text: 'Link something'

                    AntBadge { dot: true }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('动态')
            desc: qsTr(`
展示动态变化的效果。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 20
    width: parent.width

    Row {
        spacing: 20

        AntAvatar {
            size: 40
            radiusBg.all: 6

            AntBadge { id: badge; count: 5 }
        }

        AntButtonBlock {
            model: [
                { iconSource: AntIcon.MinusOutlined, autoRepeat: true },
                { iconSource: AntIcon.PlusOutlined, autoRepeat: true },
                { iconSource: AntIcon.QuestionOutlined, autoRepeat: true },
            ]
            onClicked:
                (index) => {
                    switch (index) {
                        case 0: badge.count = Math.max(0, badge.count - 1); break;
                        case 1: badge.count++; break;
                        case 2: badge.count = Math.floor(Math.random() * 100); break;
                    }
                }
        }
    }

    Row {
        spacing: 20

        AntAvatar {
            size: 40
            radiusBg.all: 6

            AntBadge { id: badge2; count: 0; dot: true }
        }

        AntSwitch {
            checked: true
            onCheckedChanged: badge2.dot = checked;
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 20
                width: parent.width

                Row {
                    spacing: 20

                    AntAvatar {
                        size: 40
                        radiusBg.all: 6

                        AntBadge { id: badge; count: 5 }
                    }

                    AntButtonBlock {
                        model: [
                            { iconSource: AntIcon.MinusOutlined, autoRepeat: true },
                            { iconSource: AntIcon.PlusOutlined, autoRepeat: true },
                            { iconSource: AntIcon.QuestionOutlined, autoRepeat: true },
                        ]
                        onClicked:
                            (index) => {
                                switch (index) {
                                    case 0: badge.count = Math.max(0, badge.count - 1); break;
                                    case 1: badge.count++; break;
                                    case 2: badge.count = Math.floor(Math.random() * 100); break;
                                }
                            }
                    }
                }

                Row {
                    spacing: 20

                    AntAvatar {
                        size: 40
                        radiusBg.all: 6

                        AntBadge { id: badge2; count: 0; dot: true }
                    }

                    AntSwitch {
                        checked: true
                        onCheckedChanged: badge2.dot = checked;
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('状态点')
            desc: qsTr(`
通过 \`badgeState\` 来设置不同的状态，支持的状态有：\n
- 默认状态(默认){ AntBadge.StateDefault }\n
- 成功状态{ AntBadge.StateSuccess }\n
- 处理中状态(该状态默认有动效){ AntBadge.StateProcessing }\n
- 错误状态(该状态手动加了动效){ AntBadge.StateError }\n
- 警告状态{ AntBadge.StateWarning }\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10
    width: parent.width

    Row {
        spacing: 10

        AntBadge { dot: true; badgeState: AntBadge.StateSuccess }
        AntBadge { dot: true; badgeState: AntBadge.StateProcessing }
        AntBadge { dot: true; badgeState: AntBadge.StateError; stateEffect: true }
        AntBadge { dot: true; badgeState: AntBadge.StateWarning }
        AntBadge { dot: true; badgeState: AntBadge.StateDefault }
    }

    Column {
        spacing: 10

        Row {
            spacing: 10
            AntBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: AntBadge.StateSuccess }
            AntText { text: 'Success' }
        }

        Row {
            spacing: 10
            AntBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: AntBadge.StateProcessing }
            AntText { text: 'Processing' }
        }

        Row {
            spacing: 10
            AntBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: AntBadge.StateError }
            AntText { text: 'Error' }
        }

        Row {
            spacing: 10
            AntBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: AntBadge.StateWarning }
            AntText { text: 'Warning' }
        }

        Row {
            spacing: 10
            AntBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: AntBadge.StateDefault }
            AntText { text: 'Default' }
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    AntBadge { dot: true; badgeState: AntBadge.StateSuccess }
                    AntBadge { dot: true; badgeState: AntBadge.StateProcessing }
                    AntBadge { dot: true; badgeState: AntBadge.StateError; stateEffect: true }
                    AntBadge { dot: true; badgeState: AntBadge.StateWarning }
                    AntBadge { dot: true; badgeState: AntBadge.StateDefault }
                }

                Column {
                    spacing: 10

                    Row {
                        spacing: 10
                        AntBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: AntBadge.StateSuccess }
                        AntText { text: 'Success' }
                    }

                    Row {
                        spacing: 10
                        AntBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: AntBadge.StateProcessing }
                        AntText { text: 'Processing' }
                    }

                    Row {
                        spacing: 10
                        AntBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: AntBadge.StateError }
                        AntText { text: 'Error' }
                    }

                    Row {
                        spacing: 10
                        AntBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: AntBadge.StateWarning }
                        AntText { text: 'Warning' }
                    }

                    Row {
                        spacing: 10
                        AntBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: AntBadge.StateDefault }
                        AntText { text: 'Default' }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('多彩徽标')
            desc: qsTr(`
我们添加了多种预设色彩的徽标样式，用作不同场景使用。如果预设值不能满足你的需求，可以设置为具体的色值。\n
通过 \`presetColor\` 设置预设颜色。\n
支持的预设颜色：\n
**['red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta']**\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10
    width: parent.width

    Repeater {
        model: ['red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta']
        delegate: Row {
            spacing: 10

            AntBadge {
                anchors.verticalCenter: parent.verticalCenter
                dot: true
                presetColor: modelData
            }

            AntText {
                text: modelData
            }
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                Repeater {
                    model: ['red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta']
                    delegate: Row {
                        spacing: 10

                        AntBadge {
                            anchors.verticalCenter: parent.verticalCenter
                            dot: true
                            presetColor: modelData
                        }

                        AntText {
                            text: modelData
                        }
                    }
                }
            }
        }
    }
}
