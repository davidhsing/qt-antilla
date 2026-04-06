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
# AntCaptionButton 标题按钮\n
一般用于窗口标题栏的按钮。\n
* **继承自 { [AntIconButton](internal://AntIconButton) }**\n
<br/>
                       `)
        }

        ThemeToken {
            source: 'AntCaptionButton'
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
一般配合无边框窗口使用，用于窗口标题栏的自定义按钮。
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`danger\` 属性设置为警示按钮，例如关闭按钮。
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 15

    AntCaptionButton {
        iconSource: AntIcon.CloseOutlined
    }

    AntCaptionButton {
        text: qsTr('普通')
        colorText: colorIcon
        iconSource: AntIcon.CloseOutlined
    }

    AntCaptionButton {
        text: qsTr('警示')
        colorText: colorIcon
        danger: true
        iconSource: AntIcon.CloseOutlined
    }
}
            `
            exampleDelegate: Row {
                spacing: 15

                AntCaptionButton {
                    iconSource: AntIcon.CloseOutlined
                }

                AntCaptionButton {
                    text: qsTr('普通')
                    colorText: colorIcon
                    iconSource: AntIcon.CloseOutlined
                }

                AntCaptionButton {
                    text: qsTr('警示')
                    colorText: colorIcon
                    danger: true
                    iconSource: AntIcon.CloseOutlined
                }
            }
        }
    }
}
