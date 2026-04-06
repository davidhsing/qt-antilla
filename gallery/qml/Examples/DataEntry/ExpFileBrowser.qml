import QtQuick
import Antilla.Basic
import '../../Controls'

Flickable {
    contentHeight: column.height
    AntScrollBar.vertical: AntScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# AntFileBrowser 文件浏览选择\n
文件/文件夹浏览器，支持选择文件或文件夹。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **inputDelegate: Component** 文本框代理\n
- **buttonDelegate: Component** 按钮代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
mode | int | AntFileBrowser.ModeOpenFile | 浏览器样式(来自 AntFileBrowser)
defaultFolder | string | - | 默认的浏览文件夹路径
inputText | string | - | 文本框文本
inputPlaceholder | string | - | 文本框占位符
inputEnabled | bool | true | 文本框已启用
inputReadOnly | bool | false | 文本框只读
buttonEnabled | bool | true | 按钮已启用
buttonText | string | '浏览' | 按钮文本
buttonType | int | AntButton.TypeDefault | 按钮样式(来自 AntButton)
buttonIconSource | int丨string | 0丨'' | 按钮图标源(来自 AntIcon)或图标链接
buttonWidth | int | 80 | 按钮宽度
spacing | int | 8 | 文本框与按钮的间距
convertNative | bool | true | 是否转化为本地文件形式(否则带 file:/// 前缀)
initFolder | string | - | 初始目录
defaultSuffix | string | - | 默认的文件后缀
nameFilters | [] | - | 文件选择过滤器
pathJoiner | string | '; ' | 多个文件的分隔符
\n<br/>
\n### 支持的信号：\n
- \`pathSelected(path: string)\` 选定单个路径时发出\n
  - \`path\` 选择的路径\n
- \`pathsSelected(paths: var)\` 选定多个路径时发出\n
  - \`paths\` 选择的路径数组\n
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
需要显示或选择更改一个文件/文件夹时。\n
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
最简单的用法。\n
通过 \`mode\` 属性设置文件/文件夹类型。\n
通过 \`inputText\` 属性设置文本框文本。\n
通过 \`inputPlaceholder\` 属性设置文本框占位符。\n
通过 \`buttonText\` 属性设置按钮文本。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    width: parent.width
    spacing: 16

    AntRadioBlock {
        id: browserModeRadio
        initCheckedIndex: 0
        model: [
            { label: 'OpenFile', value: AntFileBrowser.ModeOpenFile },
            { label: 'OpenFiles', value: AntFileBrowser.ModeOpenFiles },
            { label: 'OpenFolder', value: AntFileBrowser.ModeOpenFolder },
            { label: 'SaveFile', value: AntFileBrowser.ModeSaveFile }
        ]
    }

    AntRadioBlock {
        id: dangerRadio
        initCheckedIndex: 1
        model: [
            { label: 'Danger', value: true },
            { label: 'NonDanger', value: false }
        ]
    }

    AntFileBrowser {
        buttonText: qsTr('浏览')
        mode: browserModeRadio.currentCheckedValue
        danger: dangerRadio.currentCheckedValue
        defaultSuffix: 'jpg'
        nameFilters: [
            qsTr('JPEG Images (*.jpg *.jpeg)'),
            qsTr('All Files (*)')
        ]
    }
}
            `
            exampleDelegate: Column {
                width: parent.width
                spacing: 16

                AntRadioBlock {
                    id: browserModeRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'OpenFile', value: AntFileBrowser.ModeOpenFile },
                        { label: 'OpenFiles', value: AntFileBrowser.ModeOpenFiles },
                        { label: 'OpenFolder', value: AntFileBrowser.ModeOpenFolder },
                        { label: 'SaveFile', value: AntFileBrowser.ModeSaveFile }
                    ]
                }

                AntRadioBlock {
                    id: dangerRadio
                    initCheckedIndex: 1
                    model: [
                        { label: 'Danger', value: true },
                        { label: 'NonDanger', value: false }
                    ]
                }

                AntFileBrowser {
                    buttonText: qsTr('浏览')
                    mode: browserModeRadio.currentCheckedValue
                    danger: dangerRadio.currentCheckedValue
                    defaultSuffix: 'jpg'
                    nameFilters: [
                        qsTr('JPEG Images (*.jpg *.jpeg)'),
                        qsTr('All Files (*)')
                    ]
                }
            }
        }
    }
}
