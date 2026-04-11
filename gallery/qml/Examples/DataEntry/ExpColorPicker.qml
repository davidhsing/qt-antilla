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
# AntColorPicker 颜色选择器\n
用于选择颜色。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **textDelegate: Component** 文本代理\n
- **titleDelegate: Component** 弹窗标题代理\n
- **footerDelegate: Component** 弹窗页脚代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
active | bool | - | 是否处于激活状态
danger | bool | false | 是否警示状态
forceState | bool | false | 无禁用状态(即被禁用时不会更改颜色)
value | color | '' | 当前的颜色值(autoChange为false时等于changeValue)
defaultValue | color | Qt.rgba(0, 0, 0, 0) | 默认颜色值
autoChange | bool | true | 默认颜色值
changeableValue | color | defaultValue | 更改的颜色值
changeableSync | bool | false | 是否自动同步更改的颜色值到颜色值(changeableValue->value)
textVisible | bool | false | 是否显示文本
textFormatter | function(color): string | - | 文本格式化器
titleVisible | bool | false | 弹窗标题是否可见
titleText | string | '' | 弹窗标题文本
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
colorText | color | - | 文本颜色
colorTitle | color | - | 标题颜色
colorInput | color | - | 输入框文本颜色
colorPresetIcon | color | - | 预设视图图标颜色
colorPresetText | color | - | 预设视图文本颜色
previewWidth | real | 24 | 预览小方块的宽度
previewHeight | real | 24 | 预览小方块的高度
previewLeftMargin | real | 0 | 预览小方块的左边距
previewRightMargin | real | 0 | 预览小方块的右边距
sizeRatio | real | 1.0 | 整体的缩放比例
radiusTriggerBg | [AntRadius](internal://AntRadius) | - | 触发器背景圆角
radiusPopupBg | [AntRadius](internal://AntRadius) | - | 弹窗背景圆角
popup | [AntPopup](internal://AntPopup) | - | 访问内部弹窗
panel | [AntColorPickerPanel](internal://AntColorPickerPanel) | - | 访问内部颜色选择面板
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
- \`isTransparent(color: color, alpha: bool): bool \` 判断 \`color\` 是否为透明色\n
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
当用户需要弹出式的自定义颜色选择的时候使用。\n
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
            descTitle: qsTr('基本使用')
            desc: qsTr(`
最简单的用法。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntColorPicker {
        defaultValue: '#1677FF'
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntColorPicker {
                    defaultValue: '#1677FF'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('透明度和清除')
            desc: qsTr(`
通过 \`alphaEnabled\` 属性设置是否启用透明度。\n
通过 \`clearable\` 属性设置是否允许清除。\n
通过 \`setValue\` 方法设置颜色。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntCheckBox {
        id: alphaCheckBox
        checked: true
        text: qsTr('Enabled Alpha')
    }

    AntColorPicker {
        id: colorPicker
        defaultValue: '#1677FF'
        alphaEnabled: alphaCheckBox.checked
    }

    AntButton {
        text: qsTr('Set color')
        onClicked: {
            colorPicker.setValue('#000');
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntCheckBox {
                    id: alphaCheckBox
                    checked: true
                    text: qsTr('Enabled Alpha')
                }

                AntCheckBox {
                    id: clearCheckBox
                    checked: true
                    text: qsTr('Enabled Clear')
                }

                AntColorPicker {
                    id: colorPicker
                    defaultValue: '#1677FF'
                    alphaEnabled: alphaCheckBox.checked
                    clearable: clearCheckBox.checked
                }

                AntButton {
                    text: qsTr('Set color')
                    onClicked: {
                        colorPicker.setValue('#000');
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义文本')
            desc: qsTr(`
通过 \`textVisible\` 属性设置是否显示触发器文本。\n
通过 \`textFormatter\` 属性设置触发器文本格式化器，它是形如：\`function(color: color): string { }\` 的函数。\n
通过 \`textDelegate\` 属性自定义触发器文本代理。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntColorPicker {
        defaultValue: '#1677ff'
        textVisible: true
    }

    AntColorPicker {
        defaultValue: '#1677ff'
        textVisible: true
        textFormatter: color => \`Custom Text (\${String(color).toUpperCase()})\`
    }

    AntColorPicker {
        id: customTextPicker
        defaultValue: '#1677ff'
        textVisible: true
        textDelegate: AntIconText {
            iconSource: customTextPicker.open ? AntIcon.UpOutlined : AntIcon.DownOutlined
            verticalAlignment: AntIconText.AlignVCenter
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntColorPicker {
                    defaultValue: '#1677ff'
                    textVisible: true
                }

                AntColorPicker {
                    defaultValue: '#1677ff'
                    textVisible: true
                    textFormatter: color => `Custom Text (${String(color).toUpperCase()})`
                }

                AntColorPicker {
                    id: customTextPicker
                    defaultValue: '#1677ff'
                    textVisible: true
                    textDelegate: AntIconText {
                        rightPadding: 2
                        iconSource: customTextPicker.open ? AntIcon.UpOutlined : AntIcon.DownOutlined
                        verticalAlignment: AntIconText.AlignVCenter
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义标题')
            desc: qsTr(`
通过 \`titleText\` 属性设置是否显示弹出面板的标题。\n
通过 \`titleVisible\` 属性设置是否显示弹出面板的标题是否可见。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntColorPicker {
        defaultValue: '#1677ff'
        textVisible: true
        titleText: 'Color Picker'
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntColorPicker {
                    defaultValue: '#1677ff'
                    textVisible: true
                    titleVisible: true
                    titleText: 'Color Picker'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('受控模式')
            desc: qsTr(`
通过 \`autoChange\` 属性设置自动更新值。\n
为否时 \`value\` 值为 \`changeableValue\`，此时可手动设置 \`changeableValue\` 来更新 \`value\`。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntColorPicker {
        id: noAutoChangePicker
        defaultValue: '#1677ff'
        textVisible: true
        autoChange: false
        onColorChanged: color => selectColor = color;
        property color selectColor: value
        footerDelegate: Item {
            height: 45

            AntDivider {
                width: parent.width - 24
                height: 1
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                spacing: 20
                anchors.centerIn: parent

                AntButton {
                    text: qsTr('Accept')
                    onClicked: {
                        noAutoChangePicker.changeableValue = noAutoChangePicker.selectColor;
                        noAutoChangePicker.open = false;
                    }
                }

                AntButton {
                    text: qsTr('Cancel')
                    onClicked: {
                        noAutoChangePicker.changeableValue = noAutoChangePicker.value;
                        noAutoChangePicker.defaultValue = noAutoChangePicker.value;
                        noAutoChangePicker.open = false;
                    }
                }
            }
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntColorPicker {
                    id: noAutoChangePicker
                    defaultValue: '#1677ff'
                    textVisible: true
                    autoChange: false
                    onColorChanged: color => selectColor = color;
                    property color selectColor: value
                    footerDelegate: Item {
                        height: 45

                        AntDivider {
                            width: parent.width - 24
                            height: 1
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Row {
                            spacing: 20
                            anchors.centerIn: parent

                            AntButton {
                                text: qsTr('Accept')
                                onClicked: {
                                    noAutoChangePicker.changeableValue = noAutoChangePicker.selectColor;
                                    noAutoChangePicker.open = false;
                                }
                            }

                            AntButton {
                                text: qsTr('Cancel')
                                onClicked: {
                                    noAutoChangePicker.changeableValue = noAutoChangePicker.value;
                                    noAutoChangePicker.defaultValue = noAutoChangePicker.value;
                                    noAutoChangePicker.open = false;
                                }
                            }
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('预设颜色')
            desc: qsTr(`
通过 \`presets\` 属性设置预设颜色数组，数组对象支持的属性：\n
- { label: 标签 }\n
- { colors: 颜色列表 }\n
- { expanded: 默认是否展开 }\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntColorPicker {
        defaultValue: '#1677ff'
        presets: [
            { label: 'primary', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Blue) },
            { label: 'red', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Red), expanded: false },
            { label: 'green', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Green) },
        ]
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntColorPicker {
                    defaultValue: '#1677ff'
                    presets: [
                        { label: 'primary', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Blue) },
                        { label: 'red', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Red), expanded: false },
                        { label: 'green', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Green) },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('预设颜色视图的方向和布局')
            desc: qsTr(`
通过 \`presetsOrientation\` 属性设置预设颜色视图的方向。\n
通过 \`presetsLayoutDirection\` 属性设置预设颜色视图的布局方向。\n
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

    AntColorPicker {
        defaultValue: '#1677ff'
        presets: [
            { label: 'primary', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Blue) },
            { label: 'red', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Red), expanded: false },
            { label: 'green', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Green) },
        ]
        presetsOrientation: orientatioRadio.currentCheckedValue
        presetsLayoutDirection: layoutDirectionRadio.currentCheckedValue
        danger: true
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

                AntColorPicker {
                    defaultValue: '#1677ff'
                    presets: [
                        { label: 'primary', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Blue) },
                        { label: 'red', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Red), expanded: false },
                        { label: 'green', colors: AntThemeFunctions.genColor(AntColorGenerator.Preset_Green) },
                    ]
                    presetsOrientation: orientatioRadio.currentCheckedValue
                    presetsLayoutDirection: layoutDirectionRadio.currentCheckedValue
                    danger: true
                }
            }
        }
    }
}
