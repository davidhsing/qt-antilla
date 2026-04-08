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
# AntSlider 滑动输入条\n
滑动型输入器，展示当前值和可选范围。。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **handleDelgate: Component** 滑块代理，代理可访问属性：\n
  - \`slider: Slider / RangeSlider\` 滑动条本身
  - \`visualPosition: real\` 滑块的有效视觉位置\n
  - \`pressed: bool\` 当前滑块是否被按下\n
- **handleToolTipDelegate: Component** 滑块文字提示代理，代理可访问属性：\n
  - \`handleHovered: bool\` 指示当前滑块是否有鼠标悬浮\n
  - \`handlePressed: bool\` 指示当前滑块是否有鼠标按下\n
- **bgDelegate: Component** 背景代理，代理可访问属性：\n
  - \`slider: Slider / RangeSlider\` 滑动条本身
  - \`visualPosition: bool\` 滑块的有效视觉位置\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
hoverCursorShape | enum | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
min | real | 0 | 最小值
max | real | 100 | 最大值
stepSize | real | 0.0 | 步长
initialValue | number丨[number, ...] | 0丨[0, 0] | 设置滑块初始值，支持单值、双值或多值数组。单值或长度为1的数组为单滑块模式，长度为2的数组为双滑块模式，长度大于2的数组为多滑块编辑模式
handleCount | (readonly)int | - | 当前滑块数量
value | (readonly)[number, ...] | - | 获取当前滑块值，始终返回数组形式
editable | bool | false | 是否启用滑块编辑模式
minHandle | int | -1 | 最小滑块数量限制（-1 表示不限制）
maxHandle | int | -1 | 最大滑块数量限制（-1 表示不限制）
hovered | (readonly)bool | - | 是否悬浮在滑动条上
snapMode | enum | AntSlider.SnapNone | 滑块对齐模式(来自 AntSlider)
orientation | enum | Qt.Horizontal | 滑动条方向(Qt.Horizontal 或 Qt.Vertical)
colorHandle | color | - | 滑块颜色
colorTrack | color | - | 滑块轨道颜色
colorBg | color | - | 背景颜色
radiusBg | [AntRadius](internal://AntRadius) | - | 背景圆角半径
ariaConstrual | string | '' | 内容描述(提高可用性)
\n<br/>
\n### 支持的函数：\n
- \`decrease(index: int = 0)\` 将指定索引的滑块值减小 stepSize 或 0.1\n
- \`increase(index: int = 0)\` 将指定索引的滑块值增加 stepSize 或 0.1\n
\n<br/>
\n### 支持的信号：\n
- \`handleAdded(index: int)\` 添加滑块时发出，index 为新滑块的索引\n
- \`handleDeleted(index: int)\` 删除滑块时发出，index 为被删除滑块的索引\n
- \`handleMoved(index: int, value: real)\` 滑块移动时发出，index 为滑块索引，value 为新值\n
- \`handleReleased(index: int, value: real)\` 滑块释放时发出，index 为滑块索引，value 为最终值\n
`)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当用户需要在数值区间/自定义区间内进行选择时，可为连续或离散值。
                       `)
        }

        ThemeToken {
            source: 'AntSlider'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
基本滑动条。\n
通过 \`initialValue\` 设置初始值并决定滑块模式：\n
- 单值或长度为1的数组：单滑块模式\n
- 长度为2的数组：双滑块模式\n
- 长度大于2的数组：多滑块模式\n\n
当 \`enabled\` 为 \`false\` 时，滑块处于不可用状态。\n
通过 \`value\` 获取当前值，始终返回数组形式。
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    AntSlider {
        width: 300
        height: 30
        initialValue: 50

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: parent.value[0].toFixed(0);
        }
    }

    AntSlider {
        width: 300
        height: 30
        initialValue: [20, 50]

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: {
                const v = parent.value;
                return v[0].toFixed(0) + ', '+ v[1].toFixed(0);
            }
        }
    }

    AntSlider {
        width: 300
        height: 30
        initialValue: 50
        enabled: false
    }
}
            `
            exampleDelegate: Column {
                AntSlider {
                    width: 300
                    height: 30
                    initialValue: 50

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: parent.value[0].toFixed(0);
                    }
                }

                AntSlider {
                    width: 300
                    height: 30
                    initialValue: [20, 50]

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: {
                            const v = parent.value;
                            return v[0].toFixed(0) + ', '+ v[1].toFixed(0);
                        }
                    }
                }

                AntSlider {
                    width: 300
                    height: 30
                    initialValue: 50
                    enabled: false
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
垂直方向的滚动条。\n
通过 \`orientation\` 属性改变方向，支持的方向：\n
- 水平滚动条(默认){ Qt.Horizontal }\n
- 垂直滚动条{ Qt.Vertical }\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    height: 310 + AntTheme.Primary.fontPrimarySize
    spacing: 30

    AntSlider {
        width: 30
        height: 300
        initialValue: 50
        orientation: Qt.Vertical

        AntCopyableText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
            anchors.topMargin: 10
            text: parent.value[0].toFixed(0);
        }
    }

    AntSlider {
        width: 30
        height: 300
        initialValue: [20, 50]
        orientation: Qt.Vertical

        AntCopyableText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
            anchors.topMargin: 10
            text: {
                const v = parent.value;
                return v[0].toFixed(0) + ', '+ v[1].toFixed(0);
            }
        }
    }
}
            `
            exampleDelegate: Row {
                height: 310 + AntTheme.Primary.fontPrimarySize
                spacing: 30

                AntSlider {
                    width: 30
                    height: 300
                    initialValue: 50
                    orientation: Qt.Vertical

                    AntCopyableText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                        anchors.topMargin: 10
                        text: parent.value[0].toFixed(0);
                    }
                }

                AntSlider {
                    width: 30
                    height: 300
                    initialValue: [20, 50]
                    orientation: Qt.Vertical

                    AntCopyableText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                        anchors.topMargin: 10
                        text: {
                            const v = parent.value;
                            return v[0].toFixed(0) + ', '+ v[1].toFixed(0);
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`snapMode\` 属性改变滑块对齐模式，支持的模式：\n
- 不对齐(默认){ AntSlider.SnapNone }\n
- 拖动控制柄时滑块会自动对齐 { AntSlider.SnapAlways }\n
- 滑块在拖动时不会对齐，但只有在释放滑块后才会对齐 { AntSlider.SnapOnRelease }\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    AntSlider {
        width: 300
        height: 30
        min: 0
        max: 10
        stepSize: 1
        snapMode: AntSlider.SnapNone

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: parent.value[0];
        }
    }

    AntSlider {
        width: 300
        height: 30
        min: 0
        max: 10
        stepSize: 1
        snapMode: AntSlider.SnapAlways

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: parent.value[0];
        }
    }

    AntSlider {
        width: 300
        height: 30
        min: 0
        max: 10
        stepSize: 1
        snapMode: AntSlider.SnapOnRelease

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: parent.value[0];
        }
    }
}
            `
            exampleDelegate: Column {
                AntSlider {
                    width: 300
                    height: 30
                    min: 0
                    max: 10
                    stepSize: 1
                    snapMode: AntSlider.SnapNone

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: parent.value[0];
                    }
                }

                AntSlider {
                    width: 300
                    height: 30
                    min: 0
                    max: 10
                    stepSize: 1
                    snapMode: AntSlider.SnapAlways

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: parent.value[0];
                    }
                }

                AntSlider {
                    width: 300
                    height: 30
                    min: 0
                    max: 10
                    stepSize: 1
                    snapMode: AntSlider.SnapOnRelease

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: parent.value[0];
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
多滑块模式。\n
- 点击空白区域添加新滑块\n
- 点击滑块选中，按 Del 键删除\n
- 通过 \`editable\` 设置编辑模式\n
- 通过 \`minHandle\` 和 \`maxHandle\` 限制滑块数量\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 20

    AntText {
        text: "当前滑块数: " + slider.handleCount
    }

    AntSlider {
        id: slider
        width: 400
        height: 30
        initialValue: [20, 50, 80]
        editable: true

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: parent.value.map(v => v.toFixed(0)).join(', ');
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 20

                Row {
                    spacing: 10
                    AntText {
                        text: "当前滑块数: " + slider.handleCount
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                AntSlider {
                    id: slider
                    width: 400
                    height: 30
                    initialValue: [20, 50, 80]
                    editable: true

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: parent.value.map(v => v.toFixed(0)).join(', ');
                    }
                }
            }
        }
    }
}
