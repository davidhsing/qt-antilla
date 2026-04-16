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
# AntPreserve 保留区域\n
提供边缘保留区域的类型，用于指定从某处到某处的保留距离。\n
* **继承自 { QObject }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
from | real | 0 | 起始位置
to | real | 0 | 结束位置
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
在用户需要指定边缘保留区域范围时使用，通常用于定义某个方向上需要保留的空间范围。\n
                       `)
        }
    }
}
