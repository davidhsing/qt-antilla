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
# AntMouseBlurArea 鼠标失焦区域\n
提供一个透明的鼠标点击区域，用于在点击空白处时使输入框等控件失去焦点。\n
* **继承自 { MouseArea }**\n
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当页面中有输入框、下拉框等需要获取焦点的控件时，用户期望点击空白区域能够取消焦点。
AntMouseBlurArea 通常放置在页面底层，用于捕获空白区域的点击事件并取消焦点。
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本使用')
            desc: qsTr(`
可以通过设置 \`enabled: false\` 临时禁用失焦功能。
                       `)
            code: `
import QtQuick
import Antilla.Basic

Rectangle {
    color: 'transparent'
    border.color: AntTheme.Primary.colorTextQuaternary
    width: parent.width
    height: 200

    Column {
        anchors.centerIn: parent
        spacing: 15

        AntInput {
            placeholderText: '切换失焦功能'
            width: 200
        }

        AntSwitch {
            id: enabledSwitch
            checkedText: '已启用'
            uncheckedText: '已禁用'
        }
    }

    AntMouseBlurArea {
        id: blurArea
        enabled: enabledSwitch.checked
    }
}
            `
            exampleDelegate: Rectangle {
                color: 'transparent'
                border.color: AntTheme.Primary.colorTextQuaternary
                width: parent.width
                height: 200

                Column {
                    anchors.centerIn: parent
                    spacing: 15

                    AntInput {
                        placeholderText: '切换失焦功能'
                        width: 200
                    }

                    AntSwitch {
                        id: enabledSwitch
                        checkedText: '已启用'
                        uncheckedText: '已禁用'
                    }
                }

                AntMouseBlurArea {
                    id: blurArea
                    enabled: enabledSwitch.checked
                }
            }
        }
    }
}
