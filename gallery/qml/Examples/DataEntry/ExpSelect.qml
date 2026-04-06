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
# AntSelect 选择器\n
下拉选择器。\n
* **继承自 { ComboBox }**\n
\n<br/>
\n### 支持的代理：\n
- **indicatorDelegate: Component** 右侧指示器代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
active | bool(readonly) | - | 是否处于激活状态
clearable | bool | false | 是否启用清除按钮
clearIconSource | int丨string | AntIcon.CloseCircleFilled | 清除图标源(来自 AntIcon)或图标链接
defaultPopupMaxHeight | int | 240 | 默认弹窗最大高度
danger | bool | false | 是否为警示状态
hoverCursorShape | enum | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
initValue | var | - | 初始值
activeValue | var | - | 绑定值
loading | bool | false | 是否在加载中
readOnly | bool | false | 是否只读
tooltipVisible | bool | false | 是否显示文字提示
placeholderText | string | - | 占位符文本
colorText | color | - | 文本颜色
colorBorder | color | - | 边框颜色
colorBg | color | - | 背景颜色
radiusBg | [AntRadius](internal://AntRadius) | - | 背景圆角
radiusItemBg | [AntRadius](internal://AntRadius) | - | 选项背景圆角
radiusPopupBg | [AntRadius](internal://AntRadius) | - | 弹窗背景圆角
ariaConstrual | string | '' | 内容描述(提高可用性)
\n<br/>
\n### 支持的信号：\n
- \`cleared()\` 点击清除图标时发出\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 弹出一个下拉菜单给用户选择操作，用于代替原生的组合框(ComboBox)。\n
- 当选项少时（少于 5 项），建议直接将选项平铺，使用 [AntRadio](internal://AntRadio) 是更好的选择。\n
- 如果你在寻找一个可输可选的输入框，那你可能需要 [AntAutoComplete](internal://AntAutoComplete)。\n
- 如果你在寻找一个更优雅的多选器时，那你可能需要 [AntMultiSelect](internal://AntMultiSelect)。\n
                       `)
        }

        ThemeToken {
            source: 'AntSelect'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`model\` 属性设置初始选择器的模型，选择项支持的属性：\n
- { label: 本选择项的标签 } 可通过 **textRole** 更改\n
- { value: 本选择项的值 } 可通过 **valueRole** 更改\n
- { enabled: 本选择项是否启用 }\n
- { readOnly: 本选择项是否只读 }\n
通过 \`loading\` 属性设置是否在加载中。\n
可以让 \`enabled\` 绑定 \`loading\` 实现加载完成才启用。\n
通过 \`danger\` 属性设置警示状态。\n
通过 \`initValue\` 属性设置初始值。\n
通过 \`tooltipVisible\` 属性设置是否显示文字提示框(主要用于长文本)。\n
通过 \`defaultPopupMaxHeight\` 属性设置默认弹出窗口的高度。\n
                       `)
            code: `
import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Row {
    width: parent.width
    spacing: 10

    AntSelect {
        width: 120
        height: 30
        tooltipVisible: true
        model: [
            { value: 'jack', label: 'Jack' },
            { value: 'lucy', label: 'Lucy' },
            { value: 'david', label: 'Yimingheabcdef' },
            { value: 'disabled', label: 'Disabled', enabled: false },
        ]
        danger: true
        placeholderText: '请选择'
    }

    AntSelect {
        width: 120
        height: 30
        enabled: false
        model: [
            { value: 'jack', label: 'Jack' },
            { value: 'lucy', label: 'Lucy' },
            { value: 'david', label: 'David' },
            { value: 'disabled', label: 'Disabled', enabled: false },
        ]
        initValue: 'lucy'
    }

    AntSelect {
        width: 120
        height: 30
        loading: true
        model: [
            { value: 'jack', label: 'Jack' },
            { value: 'lucy', label: 'Lucy' },
            { value: 'david', label: 'David' },
            { value: 'disabled', label: 'Disabled', enabled: false },
        ]
    }

    AntSelect {
        width: 120
        height: 30
        model: [
            { value: 'readOnly', label: 'readOnly' }
        ]
        initValue: 'readOnly'
        readOnly: true
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntSelect {
                    width: 120
                    height: 30
                    tooltipVisible: true
                    model: [
                        { value: 'jack', label: 'Jack' },
                        { value: 'lucy', label: 'Lucy' },
                        { value: 'david', label: 'Yimingheabcdef' },
                        { value: 'disabled', label: 'Disabled', enabled: false },
                    ]
                    danger: true
                    placeholderText: '请选择'
                }

                AntSelect {
                    width: 120
                    height: 30
                    enabled: false
                    model: [
                        { value: 'jack', label: 'Jack' },
                        { value: 'lucy', label: 'Lucy' },
                        { value: 'david', label: 'David' },
                        { value: 'disabled', label: 'Disabled', enabled: false },
                    ]
                    initValue: 'lucy'
                }

                AntSelect {
                    width: 120
                    height: 30
                    loading: true
                    model: [
                        { value: 'jack', label: 'Jack' },
                        { value: 'lucy', label: 'Lucy' },
                        { value: 'david', label: 'David' },
                        { value: 'disabled', label: 'Disabled', enabled: false },
                    ]
                }

                AntSelect {
                    width: 120
                    height: 30
                    model: [
                        { value: 'readOnly', label: 'readOnly' }
                    ]
                    initValue: 'readOnly'
                    readOnly: true
                }
            }
        }
    }
}
