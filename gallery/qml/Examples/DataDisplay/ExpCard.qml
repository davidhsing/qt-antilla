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
# AntCard 卡片\n
通用卡片容器。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **bgDelegate: Component** 背景代理\n
- **titleDelegate: Component** 卡片标题代理\n
- **extraDelegate: Component** 卡片右上角操作代理\n
- **coverDelegate: Component** 卡片封面代理\n
- **bodyDelegate: Component** 卡片主体代理\n
- **actionDelegate: Component** 卡片动作代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
bgVisible | bool | true | 背景是否可见
borderVisible | bool | true | 边框是否可见
borderWidth | real | 1 | 边框宽度
hoverable | bool | false | 鼠标移过时可浮起
shadowVisible | bool | hoverable | 是否显示阴影
titleVisible | bool | true | 标题是否可见
titleText | string | '' | 标题文本
titleFont | font | - | 标题字体
titleDividerVisible | bool | true | 标题下的分割线是否可见
titleHeight | int | 60 | 标题高度
coverVisible | bool | true | 封面图片是否可见
coverSource | url | '' | 封面图片链接
coverFillMode | enum | Image.Stretch | 封面图片填充模式(来自 Image)
coverHeight | int | 180 | 封面图片高度
bodyVisible | bool | true | 内容是否可见
bodyAvatarSize | int |  40 | 内容字体
bodyAvatarIcon | int | 0 | 主体部分头像图标(来自 AntIcon)
bodyAvatarSource | url | '' | 主体部分头像链接
bodyAvatarText | string | '' | 主体部分头像文本
bodyTitleText | string | '' | 主体部分标题文本
bodyTitleFont | font | - | 主体部分标题字体
bodyDescriptionText | string | '' | 主体部分描述文本
bodyDescriptionFont | font | - | 主体部分描述字体
bodyHeight | int | 100 | 主体部分高度
actionVisible | bool | true | 动作区是否可见
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
colorShadow | color | - | 阴影颜色
colorTitle | color | - | 标题文本颜色
colorBodyAvatar | color | - | 主体部分头像颜色
colorBodyAvatarBg | color | - | 主体部分头像背景颜色
colorBodyTitle | color | - | 主体部分标题颜色
colorBodyDescription | color | - | 主体部分描述颜色
radiusBg | [AntRadius](internal://AntRadius) | - | 背景圆角半径
\n **注意** \`[bodyAvatarIcon/bodyAvatarSource/bodyAvatarText]\`只需提供一种即可
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
最基础的卡片容器，可承载文字、列表、图片、段落。
                       `)
        }

        ThemeToken {
            source: 'AntCard'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('典型卡片')
            desc: qsTr(`
包含标题、内容、操作区域。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 10

    AntCard {
        titleText: qsTr('Card title')
        extraDelegate: AntButton { type: AntButton.TypeLink; text: qsTr('More') }
        bodyDescriptionText: qsTr('Card content\\nCard content\\nCard content')
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntCard {
                    titleText: qsTr('Card title')
                    extraDelegate: AntButton { type: AntButton.TypeLink; text: qsTr('More') }
                    bodyDescriptionText: qsTr('Card content\nCard content\nCard content')
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('悬浮效果')
            desc: qsTr(`
通过 \`hoverable\` 属性设置鼠标移过时可浮起。\n
通过 \`colorShadow\` 属性设置阴影颜色。\n
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Column {
                    spacing: 15

                    Row {
                        spacing: 5

                        AntText {
                            text: 'ShadowColor: '
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        AntColorPicker {
                            id: colorPicker
                            autoChange: false
                            changeValue: AntTheme.Primary.colorTextBase
                            onColorChanged: color => {
                                colorPicker.changeableValue = color;
                            }
                        }
                    }

                    Grid {
                        rows: 2
                        columns: 3
                        spacing: -1

                        Repeater {
                            model: 6

                            AntCard {
                                hoverable: true
                                titleText: 'Title'
                                bodyDelegate: null
                                radiusBg.all: 0
                                colorShadow: colorPicker.value
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                Row {
                    spacing: 5

                    AntText {
                        text: 'Shadow Color: '
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    AntColorPicker {
                        id: colorPicker
                        autoChange: false
                        changeableValue: AntTheme.Primary.colorTextBase
                        onColorChanged: color => {
                            colorPicker.changeableValue = color;
                        }
                    }
                }

                Grid {
                    rows: 2
                    columns: 3
                    spacing: -1

                    Repeater {
                        model: 6

                        AntCard {
                            hoverable: true
                            titleText: 'Title'
                            bodyDelegate: null
                            radiusBg.all: 0
                            colorShadow: colorPicker.value
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('整体结构')
            desc: qsTr(`
通过代理可自由定制卡片内容:\n
- **titleDelegate: Component** 卡片标题代理\n
- **extraDelegate: Component** 卡片右上角操作代理\n
- **coverDelegate: Component** 卡片封面代理\n
- **bodyDelegate: Component** 卡片主体代理\n
- **actionDelegate: Component** 卡片动作代理\n
将代理设置为 \`Item {}\` 可以隐藏该部分。\n
                       `)
            code: `
import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Row {
    width: parent.width

    AntCard {
        id: card
        titleText: qsTr('Card title')
        extraDelegate: AntButton { type: AntButton.TypeLink; text: qsTr('More') }
        coverSource: 'https://gw.alipayobjects.com/zos/rmsportal/JiqGstEfoWAOHiTxclqi.png'
        bodyAvatarIcon: AntIcon.AccountBookOutlined
        bodyTitleText: 'Card Meta title'
        bodyDescriptionText: 'This is the description'
        actionDelegate: Item {
            height: 45

            AntDivider {
                width: parent.width
                height: 1
            }

            RowLayout {
                width: parent.width
                height: parent.height

                Item {
                    Layout.preferredWidth: parent.width / 3
                    Layout.fillHeight: true

                    AntIconText {
                        anchors.centerIn: parent
                        iconSource: AntIcon.SettingOutlined
                        iconSize: 16
                    }
                }

                Item {
                    Layout.preferredWidth: parent.width / 3
                    Layout.fillHeight: true

                    AntDivider {
                        width: 1
                        height: parent.height / 2
                        anchors.verticalCenter: parent.verticalCenter
                        orientation: Qt.Vertical
                    }

                    AntIconText {
                        anchors.centerIn: parent
                        iconSource: AntIcon.EditOutlined
                        iconSize: 16
                    }
                }

                Item {
                    Layout.preferredWidth: parent.width / 3
                    Layout.fillHeight: true

                    AntDivider {
                        width: 1
                        height: parent.height / 2
                        anchors.verticalCenter: parent.verticalCenter
                        orientation: Qt.Vertical
                    }

                    AntIconText {
                        anchors.centerIn: parent
                        iconSource: AntIcon.EllipsisOutlined
                        iconSize: 16
                    }
                }
            }
        }
    }
}
            `
            exampleDelegate: Row {
                spacing: 40

                AntCard {
                    id: card
                    titleText: qsTr('Card title')
                    extraDelegate: AntButton { type: AntButton.TypeLink; text: qsTr('More') }
                    coverSource: 'https://gw.alipayobjects.com/zos/rmsportal/JiqGstEfoWAOHiTxclqi.png'
                    bodyAvatarIcon: AntIcon.AccountBookOutlined
                    bodyTitleText: qsTr('Card Meta title')
                    bodyDescriptionText: qsTr('This is the description')
                    actionDelegate: Item {
                        height: 45

                        AntDivider {
                            width: parent.width
                            height: 1
                        }

                        RowLayout {
                            width: parent.width
                            height: parent.height

                            Item {
                                Layout.preferredWidth: parent.width / 3
                                Layout.fillHeight: true

                                AntIconText {
                                    anchors.centerIn: parent
                                    iconSource: AntIcon.SettingOutlined
                                    iconSize: 16
                                }
                            }

                            Item {
                                Layout.preferredWidth: parent.width / 3
                                Layout.fillHeight: true

                                AntDivider {
                                    width: 1
                                    height: parent.height / 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    orientation: Qt.Vertical
                                }

                                AntIconText {
                                    anchors.centerIn: parent
                                    iconSource: AntIcon.EditOutlined
                                    iconSize: 16
                                }
                            }

                            Item {
                                Layout.preferredWidth: parent.width / 3
                                Layout.fillHeight: true

                                AntDivider {
                                    width: 1
                                    height: parent.height / 2
                                    anchors.verticalCenter: parent.verticalCenter
                                    orientation: Qt.Vertical
                                }

                                AntIconText {
                                    anchors.centerIn: parent
                                    iconSource: AntIcon.EllipsisOutlined
                                    iconSize: 16
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: focusRect
                        width: 0
                        height: 0
                        color: 'transparent'
                        border.width: 2
                        border.color: 'red'

                        Behavior on x { NumberAnimation { duration: AntTheme.Primary.durationMid } }
                        Behavior on y { NumberAnimation { duration: AntTheme.Primary.durationMid } }
                        Behavior on width { NumberAnimation { duration: AntTheme.Primary.durationMid } }
                        Behavior on height { NumberAnimation { duration: AntTheme.Primary.durationMid } }
                    }
                }

                component Area: Rectangle {
                    width: 300
                    height: 60
                    color: hovered ? AntThemeFunctions.alpha(AntTheme.Primary.colorTextBase, 0.1) : AntTheme.Primary.colorBgBase
                    border.color: AntThemeFunctions.alpha(AntTheme.Primary.colorTextBase, 0.1)

                    property alias text: areaText.text
                    property alias hovered: hoverHandler.hovered

                    function setArea(x, y, w, h) {
                        if (hovered) {
                            hoverTimer.stop();
                            focusRect.x = x;
                            focusRect.y = y;
                            focusRect.width = w;
                            focusRect.height = h;
                        } else {
                            hoverTimer.restart();
                        }
                    }

                    AntText {
                        id: areaText
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 30
                        color: AntTheme.Primary.colorTextBase
                        font {
                            family: AntTheme.Primary.fontPrimaryFamily
                            pixelSize: AntTheme.Primary.fontPrimarySize
                        }
                    }

                    HoverHandler { id: hoverHandler }
                }

                Timer {
                    id: hoverTimer
                    interval: 2000
                    onTriggered: {
                        focusRect.width = 0;
                        focusRect.height = 0;
                    }
                }

                Column {
                    spacing: -1
                    Area {
                        text: qsTr('titleDelegate\n设置卡片标题区域代理')
                        onHoveredChanged: {
                            setArea(0, 0, 210, 60);
                        }
                    }
                    Area {
                        text: qsTr('extraDelegate\n设置卡片右上角操作区域代理')
                        onHoveredChanged: {
                            setArea(210, 0, 90, 60);
                        }
                    }
                    Area {
                        text: qsTr('coverDelegate\n设置卡片封面区域代理')
                        onHoveredChanged: {
                            setArea(0, 60, card.width, 180);
                        }
                    }
                    Area {
                        text: qsTr('bodyDelegate\n设置卡片主体区域代理')
                        onHoveredChanged: {
                            setArea(0, 240, card.width, 100);
                        }
                    }
                    Area {
                        text: qsTr('actionDelegate\n设置卡片动作区域代理')
                        onHoveredChanged: {
                            setArea(0, 340, card.width, 45);
                        }
                    }
                }
            }
        }
    }
}
