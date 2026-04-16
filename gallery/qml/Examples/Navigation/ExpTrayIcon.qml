import QtQuick
import QtQuick.Controls.Basic
import Qt.labs.platform as Platform
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
# AntTrayIcon 托盘图标\n
基于 Qt.labs.platform.SystemTrayIcon 封装，配合 AntMenu 实现自定义样式的托盘菜单。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
icon | object | - | 托盘图标，同 SystemTrayIcon.icon
tooltip | string | '' | 托盘图标提示文本
iconVisible | bool | true | 托盘图标是否可见
iconSource | int丨string | 0丨'' | 图标源(来自 AntIcon)或图标链接
menu | AntMenu | null | 托盘菜单，直接使用 [AntMenu](internal://AntMenu)
menuAnimationEnabled | bool | AntTheme.animationEnabled | 是否开启菜单弹出/关闭动画
menuShadowVisible | bool | true | 是否开启菜单阴影
colorBg | color | - | 菜单背景颜色
colorShadow | color | - | 菜单阴影颜色
radiusBg | [AntRadius](internal://AntRadius) | - | 菜单背景圆角半径
menuVisible | bool | false | 菜单是否可见(只读)
iconAnimationEnabled | bool | false | 是否开启图标帧动画
iconFrames | list | [] | 图标帧动画图片列表
iconFrameInterval | int | 500 | 图标帧动画间隔(毫秒)
iconFrameLoops | int | -1 | 图标帧动画循环次数(-1为无限)
\n<br/>
\n### 支持的信号：\n
- \`activated(reason: int)\` 托盘图标被激活时发出\n
  - \`reason\` 激活原因，参见 SystemTrayIcon.ActivationReason\n
\n<br/>
\n### 支持的函数：\n
- \`open()\` 打开托盘菜单\n
- \`close()\` 关闭托盘菜单\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要在系统托盘区显示应用图标时。\n
- 需要通过托盘图标提供自定义样式菜单时，配合 [AntMenu](internal://AntMenu) 使用。\n
- 需要实现"最小化到托盘"或"关闭到托盘"功能时。\n
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
通过 \`AntSwitch\` 控制托盘图标的显示和隐藏。\n
点击托盘图标可弹出自定义样式的 \`AntMenu\` 菜单。\n
图标使用 Gallery 自身的图标。\n
                       `)
            code: `
import QtQuick
import Qt.labs.platform as Platform
import Antilla.Basic
  
Row {
    spacing: 15
  
    AntSwitch {
        id: traySwitch
        checkedText: qsTr('显示')
        uncheckedText: qsTr('隐藏')
    }
  
    AntText {
        anchors.verticalCenter: parent.verticalCenter
        text: traySwitch.checked
              ? qsTr('托盘图标已显示，请查看系统托盘区')
              : qsTr('托盘图标已隐藏')
    }
  
    AntTrayIcon {
        iconVisible: traySwitch.checked
        iconSource: 'qrc:/Gallery/images/antilla_icon.svg'
        tooltip: 'Antilla Gallery'
  
        menu: AntMenu {
            defaultMenuWidth: 150
            defaultMenuHeight: 30
            defaultMenuTextSize: 13
            marginContent.all: 0
            popupMode: true
            initModel: [
                { key: 'show', label: '显示主窗口',
                  iconSource: AntIcon.DesktopOutlined },
                { key: 'setting', label: '设置',
                  iconSource: AntIcon.SettingOutlined },
                { type: 'divider' },
                { key: 'quit', label: '退出',
                  iconSource: AntIcon.PoweroffOutlined }
            ]
            onMenuClicked: (deep, key, keyPath, data) => {
                if (key === 'show') {
                    galleryWindow.show();
                    galleryWindow.raise();
                } else if (key === 'quit') {
                    Qt.quit();
                }
            }
        }
  
        onActivated: (reason) => {
            if (reason === Platform.SystemTrayIcon.DoubleClick) {
                galleryWindow.show();
                galleryWindow.raise();
            }
        }
    }
}
            `
            exampleDelegate: Row {
                spacing: 15

                AntSwitch {
                    id: traySwitch
                    checkedText: qsTr('显示')
                    uncheckedText: qsTr('隐藏')
                }

                AntText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: traySwitch.checked
                        ? qsTr('托盘图标已显示，请查看系统托盘区')
                        : qsTr('托盘图标已隐藏')
                }

                AntTrayIcon {
                    iconVisible: traySwitch.checked
                    iconSource: 'qrc:/Gallery/images/antilla_icon.svg'
                    tooltip: 'Antilla Gallery'
                    menu: AntMenu {
                        defaultMenuWidth: 150
                        defaultMenuHeight: 30
                        defaultMenuTextSize: 13
                        marginContent.all: 0
                        popupMode: true
                        initModel: [
                            { key: 'show', label: '显示主窗口', iconSource: AntIcon.DesktopOutlined },
                            { key: 'setting', label: '设置', iconSource: AntIcon.SettingOutlined },
                            { type: 'divider' },
                            { key: 'quit', label: '退出', iconSource: AntIcon.PoweroffOutlined }
                        ]
                        onMenuClicked: (deep, key, keyPath, data) => {
                            if (key === 'show') {
                                galleryWindow.show();
                                galleryWindow.raise();
                            } else if (key === 'quit') {
                                Qt.quit();
                            }
                        }
                    }

                    onActivated: (reason) => {
                        if (reason === Platform.SystemTrayIcon.DoubleClick) {
                            galleryWindow.show();
                            galleryWindow.raise();
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('关闭菜单动画')
            desc: qsTr(`
通过 \`menuAnimationEnabled\` 属性控制菜单弹出和关闭时是否播放动画。\n
设置为 \`false\` 时菜单将立即显示/隐藏。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic
  
Row {
    spacing: 15
  
    AntSwitch {
        id: animSwitch
        checked: true
        checkedText: qsTr('动画开')
        uncheckedText: qsTr('动画关')
    }
  
    AntSwitch {
        id: traySwitch2
        checkedText: qsTr('显示')
        uncheckedText: qsTr('隐藏')
    }
  
    AntTrayIcon {
        iconVisible: traySwitch2.checked
        iconSource: 'qrc:/Gallery/images/antilla_icon.svg'
        tooltip: 'Antilla Gallery (No Animation)'
        menuAnimationEnabled: animSwitch.checked
  
        menu: AntMenu {
            defaultMenuWidth: 150
            defaultMenuHeight: 30
            defaultMenuTextSize: 13
            marginContent.all: 0
            popupMode: true
            initModel: [
                { key: 'about', label: '关于', iconSource: AntIcon.InfoCircleOutlined },
                { type: 'divider' },
                { key: 'quit', label: '退出', iconSource: AntIcon.PoweroffOutlined }
            ]
        }
    }
}
            `
            exampleDelegate: Row {
                spacing: 15

                AntSwitch {
                    id: animSwitch
                    checked: true
                    checkedText: qsTr('动画开')
                    uncheckedText: qsTr('动画关')
                }

                AntSwitch {
                    id: traySwitch2
                    checkedText: qsTr('显示')
                    uncheckedText: qsTr('隐藏')
                }

                AntTrayIcon {
                    iconVisible: traySwitch2.checked
                    iconSource: 'qrc:/Gallery/images/antilla_icon.svg'
                    tooltip: 'Antilla Gallery (No Animation)'
                    menuAnimationEnabled: animSwitch.checked

                    menu: AntMenu {
                        defaultMenuWidth: 150
                        defaultMenuHeight: 30
                        defaultMenuTextSize: 13
                        marginContent.all: 0
                        popupMode: true
                        initModel: [
                            { key: 'about', label: '关于', iconSource: AntIcon.InfoCircleOutlined },
                            { type: 'divider' },
                            { key: 'quit', label: '退出', iconSource: AntIcon.PoweroffOutlined }
                        ]
                    }
                }
            }
        }
    }
}
