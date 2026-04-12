import QtQuick
import QtQuick.Layouts
import Antilla.Basic
import '../../Controls'

Flickable {
    contentHeight: column.height
    AntScrollBar.vertical: AntScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 30

        Description {
            width: parent.width
            desc: qsTr(`
# AntAlert 警告提示\n
静态的警告提示组件，用于展示重要信息。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **bgDelegate: Component** 背景代理\n
- **extraDelegate: Component** 额外操作代理\n
- **titleDelegate: Component** 标题代理\n
- **descriptionDelegate: Component** 描述代理\n
- **closeDelegate: Component** 关闭代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | - | 是否启用动画，从主题系统获取
borderVisible | bool | true | 是否显示边框
closable | bool | false | 是否显示关闭按钮
delay | int | 0 | 正数表示启动延迟关闭
type | enum | AntAlert.TypeInfo | 警告类型
iconVisible | bool | - | 图标是否可见
iconSize | int | 24 | 图标大小
iconSource | var | - | 图标源
titleVisible | bool | - | 标题是否可见
titleText | string | '' | 标题文本内容
descriptionVisible | bool | - | 描述是否可见
descriptionText | string | '' | 描述文本内容
extraVisible | bool | true | 额外内容是否可见
radiusBg | [AntRadius](internal://AntRadius) | 6 | 背景圆角半径
contentRowSpacing | real | 10 | 内容区行间距
contentColumnSpacing | real | 8 | 内容区列间距
closeAlign | var | Qt.AlignRight | 关闭区的对齐方式
extraAlign | var | Qt.AlignRight | 额外区的对齐方式
marqueeEnabled | bool | false | 是否启用跑马灯效果
marqueeDelay | int | 0 | 跑马灯延迟滚动时间（毫秒）(停留多长时间后开始滚动)
marqueeSpeed | int | 25000 | 跑马灯滚动速度（毫秒）
marqueeDirection | int | AntAlert.DirectionLeft | 跑马灯方向
colorBg | color | - | 背景颜色，根据 type 自动获取
colorBorder | color | - | 边框颜色，根据 type 自动获取
colorIcon | color | - | 图标颜色，根据 type 自动获取
colorTitle | color | - | 标题文本颜色
colorDescription | color | - | 描述文本颜色
colorMarquee | color | - | 跑马灯文本颜色
titleFont | font | - | 标题字体
descriptionFont | font | - | 描述字体
marqueeFont | font | - | 跑马灯字体
marginIcon | [AntMargin](internal://AntMargin) | 0 | 图标边距
marginContent | [AntMargin](internal://AntMargin) | { left: 16 } | 内容区边距
marginExtra | [AntMargin](internal://AntMargin) | { top: 4; right: 6 } | 额外内容边距
\n<br/>
\n### 枚举：
- \`AntAlert.TypeInfo\` 信息
- \`AntAlert.TypeWarning\` 警告
- \`AntAlert.TypeSuccess\` 成功
- \`AntAlert.TypeError\` 错误
- \`AntAlert.DirectionLeft\` 左侧
- \`AntAlert.DirectionRight\` 右侧
\n### 支持的信号：\n
- \`closed()\` 关闭后发出\n
\n### 支持的函数：\n
- \`close()\` 关闭组件\n
            `)
        }

        Description {
            width: parent.width
            title: qsTr('何时使用')
            desc: qsTr('当有重要的操作需要告知用户处理结果时使用。')
        }

        ThemeToken {
            source: 'AntAlert'
        }

        Description {
            width: parent.width
            title: qsTr('代码演示')
        }

        CodeBox {
            expTitle: 'Info 类型'
            desc: '信息类型的警告提示，通常用于展示一般性信息。可设置延迟 20 秒自动关闭。'
            code: `
import QtQuick
import Antilla.Basic

AntAlert {
    width: parent.width
    height: 80
    type: AntAlert.TypeInfo
    titleText: '信息提示'
    descriptionText: '这是一条信息提示内容'
    delay: 20000
}`
            exampleDelegate: AntAlert {
                id: _alert
                width: parent.width
                height: 80
                type: AntAlert.TypeInfo
                titleText: '信息提示'
                descriptionText: '这是一条信息提示内容。'
                delay: 20000
            }
        }

        CodeBox {
            expTitle: 'Warning 类型'
            desc: '警告类型的警告提示，用于展示需要注意的信息。'
            code: `
import QtQuick
import Antilla.Basic

AntAlert {
    width: parent.width
    height: 80
    type: AntAlert.TypeWarning
    titleText: '警告信息'
    descriptionText: '请注意，此操作可能存在风险'
    closable: true
}`
            exampleDelegate: AntAlert {
                width: parent.width
                height: 80
                type: AntAlert.TypeWarning
                titleText: '警告信息'
                descriptionText: '请注意，此操作可能存在风险'
                closable: true
            }
        }

        CodeBox {
            expTitle: 'Success 类型'
            desc: '成功类型的警告提示，用于展示操作成功的反馈。'
            code: `
import QtQuick
import Antilla.Basic

AntAlert {
    width: parent.width
    height: 80
    type: AntAlert.TypeSuccess
    titleText: '操作成功'
    descriptionText: '您的操作已成功完成'
}`
            exampleDelegate: AntAlert {
                width: parent.width
                height: 80
                type: AntAlert.TypeSuccess
                titleText: '操作成功'
                descriptionText: '您的操作已成功完成'
            }
        }

        CodeBox {
            expTitle: 'Error 类型'
            desc: '错误类型的警告提示，用于展示错误信息。'
            code: `
import QtQuick
import Antilla.Basic

AntAlert {
    width: parent.width
    height: 80
    type: AntAlert.TypeError
    titleText: '错误提示'
    descriptionText: '操作失败，请检查输入信息'
    extraDelegate: AntButton {
        iconSource: AntIcon.RedoOutlined
        type: AntIconButton.TypeText
    }
}`
            exampleDelegate: AntAlert {
                width: parent.width
                height: 80
                type: AntAlert.TypeError
                titleText: '错误提示'
                descriptionText: '操作失败，请检查输入信息'
                extraDelegate: AntIconButton {
                    iconSource: AntIcon.RedoOutlined
                    type: AntIconButton.TypeText
                }
            }
        }

        CodeBox {
            expTitle: '跑马灯效果'
            desc: '启用跑马灯效果，文本会自动滚动显示。适用于公告栏等场景。'
            code: `
import QtQuick
import Antilla.Basic

AntAlert {
    width: parent.width
    height: 30
    type: AntAlert.TypeInfo
    borderVisible: false
    iconSize: 16
    titleText: '重要公告'
    descriptionText: '系统将于今晚22:00进行维护，预计持续2小时'
    marqueeEnabled: true
}`
            exampleDelegate: AntAlert {
                width: parent.width
                height: 30
                type: AntAlert.TypeInfo
                borderVisible: false
                iconSize: 16
                titleText: '重要公告'
                descriptionText: '系统将于今晚22:00进行维护，预计持续2小时'
                marqueeEnabled: true
            }
        }
    }
}
