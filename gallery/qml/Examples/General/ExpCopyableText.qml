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
# AntCopyableText 可复制文本\n
在需要可复制的文本时使用(替代Text)。\n
* **继承自 { TextEdit }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
copyable | bool | true | 是否允许复制文本
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
Qml中普通文本(Text)无法复制，因此在需要可复制的文本时建议使用。
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`TextEdit\`
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 15

    AntCopyableText {
        text: qsTr('可以复制我')
    }
}
            `
            exampleDelegate: Row {
                spacing: 15

                AntCopyableText {
                    text: qsTr('可以复制我')
                }
            }
        }
    }
}
