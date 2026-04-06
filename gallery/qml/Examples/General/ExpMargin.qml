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
# AntMargin 边距\n
提供四方向的边距类型。\n
* **继承自 { QObject }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
all | real | 0 | 统一设置四个边距
left | real | 0 | 左边距
top | real | 0 | 上边距
right | real | 0 | 右边距
bottom | real | 0 | 下边距
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
在用户需要任意方向边距类型时使用。\n
                       `)
        }
    }
}
