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
# AntColorPickerPanel 颜色选择器面板\n
用于选择颜色。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **titleDelegate: Component** 标题代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
active | bool | - | 是否处于激活状态
value | color | '' | 当前的颜色值(autoChange为false时等于changeValue)
defaultValue | color | Qt.rgba(0, 0, 0, 0) | 默认颜色值
autoChange | bool | true | 默认颜色值
changeableValue | color | defaultValue | 更改的颜色值
changeableSync | bool | false | 是否自动同步更改的颜色值到颜色值(changeableValue->value)
titleVisible | bool | - | 标题是否可见
titleText | string | '' | 标题文本
alphaEnabled | bool | true | 透明度是否启用
clearable | bool | false | 是否允许清除颜色(鼠标悬浮右下角预览小方块显示清除图标)
open | bool | false | 弹窗是否打开
format | string | 'hex' | 颜色格式
presets | list | [] | 预设颜色列表
presetsOrientation | enum | Qt.Vertical | 预设颜色视图的方向(来自 Qt.*)
presetsLayoutDirection | enum | Qt.LeftToRight | 预设颜色视图的布局方向(来自 Qt.*)
transparent | bool (readonly) | - | 只读属性，表示当前是否是透明色(被清除了颜色)
titleFont | font | - | 标题字体
inputFont | font | - | 输入框文本字体
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
colorTitle | color | - | 标题颜色
colorInput | color | - | 输入框文本颜色
colorPresetIcon | color | - | 预设视图图标颜色
colorPresetText | color | - | 预设视图文本颜色
radiusBg | [AntRadius](internal://AntRadius) | - | 背景圆角
\n<br/>
\n### \`presets\` 支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
label | string | 必选 | 标签
colors | list | 必选 | 颜色列表
expanded | bool | 可选 | 默认是否展开
\n<br/>
\n### 支持的函数：\n
- \`invertColor(color: color): color\` 将 \`color\` 反转\n
- \`isTransparent(color: color): bool \` 判断 \`color\` 是否为透明色\n
- \`setValue(color: color): void\` 将 \`color\` 设置为当前颜色值(注意关联的 autoChange)\n
- \`toHexString(color: color, alpha: bool): string\` 将 \`color\` 转为 hex 字符串, 参数 \`alpha\`是否包含透明度, 默认 \`true\`\n
- \`toHsvString(color: color, alpha: bool): string\` 将 \`color\` 转为 hsv 字符串, 参数 \`alpha\`是否包含透明度, 默认 \`true\`\n
- \`toRgbString(color: color, alpha: bool): string\` 将 \`color\` 转为 rgb 字符串, 参数 \`alpha\`是否包含透明度, 默认 \`true\`\n
\n<br/>
\n### 支持的信号：\n
- \`colorChanged(color: color)\` 颜色改变时发出\n
  - \`color\` 当前的颜色\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当用户需要非弹出式的自定义颜色选择面板时使用。\n
                       `)
        }

        ThemeToken {
            source: 'AntColorPicker'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
基本用法在 [AntColorPicker](internal://AntColorPicker) 中已有示例。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntRadioBlock {
        id: orientatioRadio
        initCheckedIndex: 0
        model: [
            { label: 'Horizontal', value: Qt.Horizontal },
            { label: 'Vertical', value: Qt.Vertical },
        ]
    }

    AntRadioBlock {
        id: layoutDirectionRadio
        initCheckedIndex: 0
        model: [
            { label: 'LeftToRight', value: Qt.LeftToRight },
            { label: 'RightToLeft', value: Qt.RightToLeft },
        ]
    }

    AntColorPickerPanel {
        id: colorPickerPanel
        titleText: 'color picker panel'
        defaultValue: '#1677ff'
        presets: [
            { label: 'primary', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Blue) },
            { label: 'red', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Red), expanded: false },
            { label: 'green', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Green) },
        ]
        presetsOrientation: orientatioRadio.currentCheckedValue
        presetsLayoutDirection: layoutDirectionRadio.currentCheckedValue
    }

    AntButton {
        text: qsTr('Set color')
        onClicked: {
            colorPickerPanel.setValue('#1677ff')
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntRadioBlock {
                    id: orientatioRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'Horizontal', value: Qt.Horizontal },
                        { label: 'Vertical', value: Qt.Vertical },
                    ]
                }

                AntRadioBlock {
                    id: layoutDirectionRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'LeftToRight', value: Qt.LeftToRight },
                        { label: 'RightToLeft', value: Qt.RightToLeft },
                    ]
                }

                AntColorPickerPanel {
                    id: colorPickerPanel
                    titleText: 'color picker panel'
                    clearable: true
                    defaultValue: '#1677ff'
                    presets: [
                        { label: 'primary', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Blue) },
                        { label: 'red', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Red), expanded: false },
                        { label: 'green', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Green) },
                    ]
                    presetsOrientation: orientatioRadio.currentCheckedValue
                    presetsLayoutDirection: layoutDirectionRadio.currentCheckedValue
                }

                AntButton {
                    text: qsTr('Set color')
                    onClicked: {
                        colorPickerPanel.setValue('#1677ff')
                    }
                }
            }
        }
    }
}
