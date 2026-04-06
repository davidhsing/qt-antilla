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
# AntAudioDiagnosis 音频诊断器\n
用于测试音频输入设备，显示实时音频信号强度的圆形指示器组件。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
deviceId | string | '' | 音频设备ID，指定要使用的音频输入设备
active | bool | true | 是否允许录音
fallbackDefault | bool | false | 设备无效时是否使用系统默认音频输入设备
autoStart | bool | true | 是否初始化后立即开始录音
recording | bool (readonly) | false | 只读属性，表示当前是否正在录音
buttonVisible | bool | true | 是否显示开始/停止按钮
buttonType | var | - | 开始/停止按钮的类型(来自AntButton)
buttonWidth | int | - | 开始/停止按钮的宽度
buttonMargin | int | 16 | 开始/停止按钮的底部到父组件底部的间距
startText | string | 开始 | 开始按钮的文本
stopText | string | 停止 | 停止按钮的文本
iconSource | int丨string | AntIcon.AudioOutlined | 图标源(来自 AntIcon)或图标链接
iconSourceMuted | int丨string | AntIcon.AudioMutedOutlined | 设备无效时的图标源(来自 AntIcon)或图标链接
iconSize | int | 60 | 图标大小
probeInterval | int | 50 | 音频探针的检测间隔(毫秒)
progressWidth | int | 160 | 进度条宽度
progressHeight | int | 160 | 进度条高度
progressGap | int | 120 | 进度条开口度
progressGradient | bool | true | 进度条是否使用渐变色
progressThickness | real | 10 | 进度条宽度
locationCallback | function | - | 音频临时文件的存储路径(必须返回字符串，完整文件名)
colorBar | color | - | 进度条激活状态的颜色
colorTrack | color | - | 进度条轨道的颜色
colorIconRecording | color | - | 录音时图标的颜色
colorIconStopped | color | - | 停止时图标的颜色
\n<br/>
\n### 支持的函数：
- \`generateAudioLocation()\` 生成音频文件的存储路径
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
需要测试音频输入设备时。\n
                       `)
        }

        ThemeToken {
            source: 'AntAudioDiagnosis'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
最简单的用法。\n
通过 \`deviceId\` 属性设置音频输入源。\n
通过 \`active\` 属性设置是否录音。\n
通过 \`buttonVisible\` 属性设置按钮是否可见。\n
通过 \`fallbackDefault\` 属性设置当输入源无效时是否使用默认的音频输入源。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    Rectangle {
        width: 250
        height: 250
        color: AntTheme.Primary.colorBgBase

        AntAudioDiagnosis {
            anchors.centerIn: parent
            fallbackDefault: true
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                Rectangle {
                    width: 250
                    height: 250
                    color: AntTheme.Primary.colorBgBase

                    AntAudioDiagnosis {
                        anchors.centerIn: parent
                        fallbackDefault: true
                    }
                }
            }
        }
    }
}
