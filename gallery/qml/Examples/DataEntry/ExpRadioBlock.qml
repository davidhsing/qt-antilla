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
# AntRadioBlock 单选块\n
用于在多个备选项中选中单个状态。AntRadio 变种。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **toolTipDelegate: Component** 文字提示代理，代理可访问属性：\n
  - \`checked: int\` 是否选中\n
  - \`pressed: int\` 是否按下\n
  - \`hovered: int\` 是否悬浮\n
  - \`toolTip: var\` 文字提示数据\n
- **radioDelegate: Component** 单选项代理，代理可访问属性：\n
  - \`index: int\` 单选项索引\n
  - \`modelData: var\` 单选项数据\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
effectEnabled | bool | true | 是否开启点击效果
hoverCursorShape | enum |  Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
model | list | [] | 单选块模型
count | int | model.length | 单选数量
initCheckedIndex | int | -1 | 初始选择的单选项索引
currentCheckedIndex | int | -1 | 当前选择的单选项索引
currentCheckedValue | var | undefined | 当前选择的单选项的值
type | enum | AntRadioBlock.TypeFilled | 单选项类型(来自 AntRadioBlock)
size | enum | AntRadioBlock.SizeAuto | 单选项大小(来自 AntRadioBlock)
radioWidth | int | 120 | 单选项宽度(size == AntRadioBlock.SizeFixed 生效)
radioHeight | int | 30 | 单选项高度(size == AntRadioBlock.SizeFixed 生效)
font | font | true | 单选项字体
radiusBg | [AntRadius](internal://AntRadius) | - | 单选项背景圆角
ariaConstrual | string | '' | 内容描述(提高可用性)
\n<br/>
\n### 模型支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
label | string | 必选 | 本单选项的标签
value | sting | 可选 | 本单选项的值
enabled | var | 可选 | 本单选项是否启用
iconSource | int丨string | 可选 | 本按钮图标(参见 AntIcon)或图标链接
toolTip | var | 可选 | 存在时则创建文字提示
toolTip.text | string | 可选 | 存在时则创建文字提示
toolTip.delay | int | 可选 | 文字提示延时(ms)
toolTip.timeout | int | 可选 | 文字提示超时(ms)
\n<br/>
\n### 支持的信号：\n
- \`clicked(index: int, radioData: var)\` 点击单选项时发出\n
  - \`index\` 单选项索引\n
  - \`radioData\` 单选项数据\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 用于在多个备选项中选中单个状态。\n
- 和 [AntSelect](internal://AntSelect) 的区别是，AntRadioBlock 所有选项默认可见，方便用户在比较中选择，因此选项不宜过多。\n
- 和 [AntRadio](internal://AntRadio) 的区别是，AntRadioBlock 是成组的，通过 \`model\` 统一设置。\n
- 和 [AntButtonBlock](internal://AntButtonBlock) 的区别是，AntButtonBlock 每一项都是单独的按钮，并无单选状态。\n
                       `)
        }

        ThemeToken {
            source: 'AntRadio'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`model\` 属性设置初始单选块的模型，单选项支持的属性：\n
- { label: 本单选项的标签 }\n
- { value: 本单选项的值 }\n
- { enabled: 本单选项是否启用 }\n
- { iconSource: 本单选项图标 }\n
通过 \`type\` 属性设置单选块的类型，支持的类型：\n
- 填充样式的按钮(默认) { AntRadioBlock.TypeFilled }\n
- 线框样式的按钮(无填充) { AntRadioBlock.TypeOutlined }\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntRadioBlock {
        initCheckedIndex: 0
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear' },
            { label: 'Orange', value: 'Orange' },
            { iconSource: AntIcon.QuestionOutlined, value: 'Orange' },
        ]
    }

    AntRadioBlock {
        initCheckedIndex: 1
        type: AntRadioBlock.TypeOutlined
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear' },
            { label: 'Orange', value: 'Orange' },
            { iconSource: AntIcon.QuestionOutlined, value: 'Orange' },
        ]
    }

    AntRadioBlock {
        initCheckedIndex: 2
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear', enabled: false },
            { label: 'Orange', value: 'Orange' },
        ]
    }

    AntRadioBlock {
        enabled: false
        initCheckedIndex: 2
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear', enabled: false },
            { label: 'Orange', value: 'Orange' },
        ]
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntRadioBlock {
                    initCheckedIndex: 0
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                        { iconSource: AntIcon.QuestionOutlined, value: 'Orange' },
                    ]
                }

                AntRadioBlock {
                    initCheckedIndex: 1
                    type: AntRadioBlock.TypeOutlined
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                        { iconSource: AntIcon.QuestionOutlined, value: 'Orange' },
                    ]
                }

                AntRadioBlock {
                    initCheckedIndex: 2
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear', enabled: false },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                AntRadioBlock {
                    enabled: false
                    initCheckedIndex: 2
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear', enabled: false },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`size\` 属性设置单选块调整大小的模式，支持的大小：\n
- 自动计算大小(默认) { AntRadioBlock.SizeAuto }\n
- 固定大小(将使用radioWidth/radioHeight) { AntRadioBlock.SizeFixed }\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntRadioBlock {
        initCheckedIndex: 0
        size: AntRadioBlock.SizeFixed
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear' },
            { label: 'Orange', value: 'Orange' },
        ]
    }

    AntRadioBlock {
        initCheckedIndex: 0
        size: AntRadioBlock.SizeAuto
        type: AntRadioBlock.TypeOutlined
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear' },
            { label: 'Orange', value: 'Orange' },
        ]
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntRadioBlock {
                    initCheckedIndex: 0
                    size: AntRadioBlock.SizeFixed
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                AntRadioBlock {
                    initCheckedIndex: 0
                    size: AntRadioBlock.SizeAuto
                    type: AntRadioBlock.TypeOutlined
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }
            }
        }
    }
}
