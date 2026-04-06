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
# AntAnimatedImage 动态图片\n
可预览的动态图片。\n
* **继承自 { AnimatedImage }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
emptyAsError | bool | false | 是否将空的 source 视为加载失败(触发 fallback)
forceHoverCursor | bool | false | 是否强制鼠标为 hoverCursorShape
previewEnabled | bool | true| 是否启用预览
hovered | bool(readonly) | - | 鼠标是否悬浮
hoverCursorShape | int | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
fallback | url | '' | 加载失败时显示的图像占位符
placeholder | url | '' | 加载时显示的图像占位符
items | list | [] | 预览图片源
previewText | string | '预览' | 预览文字
previewFillMode | int | Image.PreserveAspectFit | 预览图片模式
\n<br/>
\n### {items}支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
url | url | 必选 | 图片源
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要展示动态图片时使用。\n
- 加载显示动态图或加载失败时容错处理。\n
                       `)
        }

        ThemeToken {
            source: 'AntImage'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
基本用法与 [AntImage](internal://AntImage) 一致。\n
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Column {
                    spacing: 10

                    AntSwitch {
                        id: previewEnabledSwitch
                        checkedText: 'Enable'
                        uncheckedText: 'Disable'
                        checked: true
                    }

                    AntAnimatedImage {
                        width: 200
                        height: width
                        source: 'https://gw.alipayobjects.com/zos/rmsportal/LyTPSGknLUlxiVdwMWyu.gif'
                        previewEnabled: previewEnabledSwitch.checked
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                AntSwitch {
                    id: previewEnabledSwitch
                    checkedText: 'Preview Enable'
                    uncheckedText: 'Preview Disable'
                    checked: true
                }

                AntAnimatedImage {
                    width: 200
                    height: width
                    source: 'https://gw.alipayobjects.com/zos/rmsportal/LyTPSGknLUlxiVdwMWyu.gif'
                    previewEnabled: previewEnabledSwitch.checked
                }
            }
        }
    }
}
