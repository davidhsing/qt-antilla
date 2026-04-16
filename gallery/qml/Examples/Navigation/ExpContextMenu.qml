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
# AntContextMenu 上下文菜单\n
上下文菜单，通常作为右键单击后显示的菜单。\n
* **继承自 { [AntPopup](internal://AntPopup) }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | true | 是否开启动画
defaultMenuIconSize | int | - | 默认菜单图标大小
defaultMenuIconSpacing | int | 8 | 默认菜单图标间隔
defaultMenuTextSize | int | - | 默认菜单文字大小
defaultMenuWidth | int | 140 | 默认菜单宽度
defaultMenuHieght | int | 40 | 默认菜单高度
defaultMenuSpacing | int | 4 | 默认菜单间隔
initModel | list | [] | 初始菜单模型
keepIconPlace | bool | true | 是否保留图标占位(即使没有图标)
tooltipVisible | bool | false | 是否显示工具提示
subMenuOffset | int | -4 | 子菜单偏移
radiusMenuBg | [AntRadius](internal://AntRadius) | - | 背景圆角半径
\n<br/>
\n### 支持的信号：\n
- \`menuClicked(deep: int, key: string, keyPath: var, data: var)\` 点击任意菜单项时发出\n
  - \`deep\` 菜单项深度\n
  - \`key\` 菜单项的键\n
  - \`keyPath\` 菜单项的键路径数组\n
  - \`data\` 菜单项数据\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
需要弹窗式菜单时使用（例如右键菜单），非弹窗式菜单请使用：[AntMenu](internal://AntMenu)。
                       `)
        }

        ThemeToken {
            source: 'AntMenu'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法大致等同于 \`AntMenu\`，区别是 \`AntContextMenu\` 内建为弹窗。
                       `)
            code: `
import QtQuick
import Antilla.Basic

MouseArea {
    width: parent.width
    height: parent.height
    acceptedButtons: Qt.RightButton
    onClicked:
        (mouse) => {
            if (mouse.button === Qt.RightButton) {
                contextMenu.x = mouseX;
                contextMenu.y = mouseY;
                contextMenu.open();
            }
        }

    AntContextMenu {
        id: contextMenu
        initModel: [
            {
                key: 'New',
                label: 'New',
                iconSource: AntIcon.FileOutlined,
                children: [
                    { key: 'NewFolder', label: 'Folder', },
                    { key: 'NewImage', label: 'Image File', },
                    { key: 'NewText', label: 'Text File', },
                    {
                        key: 'NewText',
                        label: 'Other',
                        children: [
                            { key: 'Other1', label: 'Other1', },
                            { key: 'Other2', label: 'Other2', },
                        ]
                    }
                ]
            },
            { key: 'Open', label: 'Open', iconSource: AntIcon.FormOutlined, },
            { key: 'Save', label: 'Save', iconSource: AntIcon.SaveOutlined },
            { type: 'divider' },
            { key: 'Exit', label: 'Exit', iconSource: AntIcon.IcoMoonExit },
        ]
        onMenuClicked: (deep, key, keyPath, data) => copyableText.append('Click: ' + key);
    }

    AntCopyableText {
        id: copyableText
        anchors.fill: parent
        clip: true
        text: 'Please right-click with the mouse.'
    }
}
            `
            exampleDelegate: MouseArea {
                width: parent.width
                height: 200
                acceptedButtons: Qt.RightButton
                onClicked:
                    (mouse) => {
                        if (mouse.button === Qt.RightButton) {
                            contextMenu.x = mouseX;
                            contextMenu.y = mouseY;
                            contextMenu.open();
                        }
                    }

                AntContextMenu {
                    id: contextMenu
                    initModel: [
                        {
                            key: 'New',
                            label: 'New',
                            iconSource: AntIcon.FileOutlined,
                            children: [
                                { key: 'NewFolder', label: 'Folder', },
                                { key: 'NewImage', label: 'Image File', },
                                { key: 'NewText', label: 'Text File', },
                                {
                                    key: 'NewText',
                                    label: 'Other',
                                    children: [
                                        { key: 'Other1', label: 'Other1', },
                                        { key: 'Other2', label: 'Other2', },
                                    ]
                                }
                            ]
                        },
                        { key: 'Open', label: 'Open', iconSource: AntIcon.FormOutlined, },
                        { key: 'Save', label: 'Save', iconSource: AntIcon.SaveOutlined },
                        { type: 'divider' },
                        { key: 'Exit', label: 'Exit', iconSource: AntIcon.IcoMoonExit },
                    ]
                    onMenuClicked: (deep, key, keyPath, data) => copyableText.append('Click: ' + key);
                }

                AntCopyableText {
                    id: copyableText
                    anchors.fill: parent
                    clip: true
                    text: 'Please right-click with the mouse.'
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
对于单选或多选菜单，只需简单自定义代理。
                       `)
            code: `
import QtQuick
import Antilla.Basic

Item {
    width: parent.width
    height: parent.height

    Component {
        id: checkIconDelegate

        AntIconText {
            width: menuButton.iconSize
            iconSize: menuButton.iconSize
            iconSource: isDark ? (AntTheme.isDark ? AntIcon.CheckOutlined : 0) :
                                 (AntTheme.isDark ? 0 : AntIcon.CheckOutlined)
            property bool isDark: menuButton.model.key === 'Dark'
        }
    }

    AntButton {
        text: qsTr('Open menu')
        onClicked: {
            contextMenu2.x = width + 5;
            contextMenu2.y = 0;
            contextMenu2.open();
        }

        AntContextMenu {
            id: contextMenu2
            initModel: [
                { key: 'Open', label: 'Open', iconSource: AntIcon.FormOutlined, },
                { key: 'Save', label: 'Save', iconSource: AntIcon.SaveOutlined },
                { type: 'divider' },
                { key: 'Exit', label: 'Exit', iconSource: AntIcon.IcoMoonExit },
                { type: 'divider' },
                { key: 'Dark', label: 'Dark', iconDelegate: checkIconDelegate, },
                { key: 'Light', label: 'Light', iconDelegate: checkIconDelegate, },
            ]
            onMenuClicked:
                (deep, key, keyPath, data) => {
                    if (key === 'Dark') {
                        galleryWindow.captionBar.themeCallback();
                    } else if (key === 'Light') {
                        galleryWindow.captionBar.themeCallback();
                    }
                }
        }
    }
}
            `
            exampleDelegate: Item {
                height: 100

                Component {
                    id: checkIconDelegate

                    AntIconText {
                        width: menuButton.iconSize
                        iconSize: menuButton.iconSize
                        iconSource: isDark ? (AntTheme.isDark ? AntIcon.CheckOutlined : 0) :
                                             (AntTheme.isDark ? 0 : AntIcon.CheckOutlined)
                        property bool isDark: menuButton.model.key === 'Dark'
                    }
                }

                AntButton {
                    text: qsTr('Open menu')
                    onClicked: {
                        contextMenu2.x = width + 5;
                        contextMenu2.y = 0;
                        contextMenu2.open();
                    }

                    AntContextMenu {
                        id: contextMenu2
                        initModel: [
                            { key: 'Open', label: 'Open', iconSource: AntIcon.FormOutlined, },
                            { key: 'Save', label: 'Save', iconSource: AntIcon.SaveOutlined },
                            { type: 'divider' },
                            { key: 'Exit', label: 'Exit', iconSource: AntIcon.IcoMoonExit },
                            { type: 'divider' },
                            { key: 'Dark', label: 'Dark', iconDelegate: checkIconDelegate, },
                            { key: 'Light', label: 'Light', iconDelegate: checkIconDelegate, },
                        ]
                        onMenuClicked:
                            (deep, key, keyPath, data) => {
                                if (key === 'Dark' && !AntTheme.isDark) {
                                    galleryWindow.captionBar.themeCallback();
                                } else if (key === 'Light' && AntTheme.isDark) {
                                    galleryWindow.captionBar.themeCallback();
                                }
                            }
                    }
                }
            }
        }
    }
}
