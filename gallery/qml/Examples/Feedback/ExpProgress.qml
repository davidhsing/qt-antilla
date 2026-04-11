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
# AntProgress 进度条\n
展示操作的当前进度。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **infoDelegate: Component** 进度信息的代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
type | enum | AntProgress.TypeLine | 进度条类型(来自 AntProgress)
status | enum | AntProgress.StatusNormal | 进度条状态(来自 AntProgress)
percent | real | 0 | 进度百分比(0.0~100.0)
barThickness | real | 8 | 进度条宽度
strokeLineCap | string | 'round' | 进度条线帽样式, 支持 'butt'丨'round'
steps | int | 0 | 进度条步骤总数(大于0显示为步骤形式)
currentStep | int | 0 | 当前步骤数
gap | real | 4 | 步骤间隔(步骤形式时有效)
gapDegree | real | 60 | 间隔角度(仪表盘进度条时有效)
useGradient | bool | false | 是否使用渐变色
gradientStops | object | - | 渐变色样式对象
infoVisible | bool | true | 是否显示进度数值或状态图标
precision | int | 0 | 进度文本显示的小数点精度
formatter | function | - | 信息文本格式化器
colorBar | color | - | 进度条颜色
colorTrack | color | - | 进度条轨道颜色
colorInfo | color | - | 进度条信息文本颜色
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
在操作需要较长时间才能完成时，为用户显示该操作的当前进度和状态。\n
- 当一个操作会打断当前界面，或者需要在后台运行，且耗时可能超过 2 秒时。\n
- 当需要显示一个操作完成的百分比时。\n
                       `)
        }

        ThemeToken {
            source: 'AntProgress'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('条形进度条')
            desc: qsTr(`
默认的条形进度条。\n
通过 \`type\` 设置进度条类型，支持的类型：\n
- 条形进度条(默认){ AntProgress.TypeLine }\n
- 圆形进度条{ AntProgress.TypeCircle }\n
- 仪表盘进度条{ AntProgress.TypeDashboard }
通过 \`status\` 设置进度条状态，支持的状态：\n
- 一般状态(默认){ AntProgress.StatusNormal }\n
- 成功状态{ AntProgress.StatusSuccess }\n
- 异常状态{ AntProgress.StatusException }\n
- 激活状态(仅条形进度条有效){ AntProgress.StatusActive }\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    width: parent.width
    spacing: 10

    AntProgress { width: parent.width; percent: 30 }
    AntProgress { width: parent.width; percent: 50; status: AntProgress.StatusActive }
    AntProgress { width: parent.width; percent: 70; status: AntProgress.StatusException }
    AntProgress { width: parent.width; percent: 100; status: AntProgress.StatusSuccess }
    AntProgress { width: parent.width; percent: 50; infoVisible: false }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntProgress { width: parent.width; percent: 30 }
                AntProgress { width: parent.width; percent: 50; status: AntProgress.StatusActive }
                AntProgress { width: parent.width; percent: 70; status: AntProgress.StatusException }
                AntProgress { width: parent.width; percent: 100; status: AntProgress.StatusSuccess }
                AntProgress { width: parent.width; percent: 50; infoVisible: false }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('圆形进度条')
            desc: qsTr(`
圆形进度条。
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    width: parent.width
    spacing: 10

    AntProgress { width: 120; height: width; type: AntProgress.TypeCircle; percent: 75 }
    AntProgress { width: 120; height: width; type: AntProgress.TypeCircle; percent: 75; status: AntProgress.StatusException }
    AntProgress { width: 120; height: width; type: AntProgress.TypeCircle; percent: 100; status: AntProgress.StatusSuccess }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntProgress { width: 120; height: width; type: AntProgress.TypeCircle; percent: 75 }
                AntProgress { width: 120; height: width; type: AntProgress.TypeCircle; percent: 75; status: AntProgress.StatusException }
                AntProgress { width: 120; height: width; type: AntProgress.TypeCircle; percent: 100; status: AntProgress.StatusSuccess }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('仪表盘进度条')
            desc: qsTr(`
通过设置 \`type\` 为 \`AntProgress.TypeDashboard\`，可以很方便地实现仪表盘样式的进度条。\n
若想要修改缺口的角度，可以设置 \`gapDegree\` 为你想要的值。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    width: parent.width
    spacing: 10

    AntProgress {
        width: 120
        height: width
        type: AntProgress.TypeDashboard
        percent: 75
    }

    AntProgress {
        width: 120
        height: width
        type: AntProgress.TypeDashboard
        percent: 75
        gapDegree: 30
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntProgress {
                    width: 120
                    height: width
                    type: AntProgress.TypeDashboard
                    percent: 75
                }

                AntProgress {
                    width: 120
                    height: width
                    type: AntProgress.TypeDashboard
                    percent: 75
                    gapDegree: 30
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('动态展示')
            desc: qsTr(`
会动的进度条才是好进度条。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    width: parent.width
    spacing: 10
    property real newPercent: 0

    AntProgress {
        width: parent.width
        type: AntProgress.TypeLine
        percent: newPercent
        status: percent >= 100 ? AntProgress.StatusSuccess : AntProgress.StatusNormal
    }

    Row {
        AntProgress {
            width: 120
            height: width
            type: AntProgress.TypeCircle
            percent: newPercent
            gapDegree: 30
            status: percent >= 100 ? AntProgress.StatusSuccess : AntProgress.StatusNormal
        }

        AntProgress {
            width: 120
            height: width
            type: AntProgress.TypeDashboard
            percent: newPercent
            status: percent >= 100 ? AntProgress.StatusSuccess : AntProgress.StatusNormal
        }
    }

    Row {
        AntIconButton {
            padding: 10
            radiusBg.all: 0
            iconSource: AntIcon.MinusOutlined
            onClicked: {
                if (newPercent - 10 >= 0)
                    newPercent -= 10;
            }
        }
        AntIconButton {
            padding: 10
            radiusBg.all: 0
            iconSource: AntIcon.PlusOutlined
            onClicked: {
                if (newPercent + 10 <= 100)
                    newPercent += 10;
            }
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10
                property real newPercent: 0

                AntProgress {
                    width: parent.width
                    type: AntProgress.TypeLine
                    percent: newPercent
                    status: percent >= 100 ? AntProgress.StatusSuccess : AntProgress.StatusNormal
                }

                Row {
                    AntProgress {
                        width: 120
                        height: width
                        type: AntProgress.TypeCircle
                        percent: newPercent
                        gapDegree: 30
                        status: percent >= 100 ? AntProgress.StatusSuccess : AntProgress.StatusNormal
                    }

                    AntProgress {
                        width: 120
                        height: width
                        type: AntProgress.TypeDashboard
                        percent: newPercent
                        status: percent >= 100 ? AntProgress.StatusSuccess : AntProgress.StatusNormal
                    }
                }

                Row {
                    AntIconButton {
                        padding: 10
                        radiusBg.all: 0
                        iconSource: AntIcon.MinusOutlined
                        onClicked: {
                            if (newPercent - 10 >= 0)
                                newPercent -= 10;
                        }
                    }
                    AntIconButton {
                        padding: 10
                        radiusBg.all: 0
                        iconSource: AntIcon.PlusOutlined
                        onClicked: {
                            if (newPercent + 10 <= 100)
                                newPercent += 10;
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义信息文字格式')
            desc: qsTr(`
通过 \`formatter\` 属性指定格式，格式化器是形如：\`function(): string { }\` 的函数。\n。
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    width: parent.width
    spacing: 10

    AntProgress {
        width: 120
        height: width
        type: AntProgress.TypeCircle
        percent: 75
        formatter: () => \`\${percent} Days\`
    }

    AntProgress {
        width: 120
        height: width
        type: AntProgress.TypeCircle
        percent: 100
        status: AntProgress.StatusSuccess
        formatter: () => 'Done'
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntProgress {
                    width: 120
                    height: width
                    type: AntProgress.TypeCircle
                    percent: 75
                    formatter: () => `${percent} Days`
                }

                AntProgress {
                    width: 120
                    height: width
                    type: AntProgress.TypeCircle
                    percent: 100
                    status: AntProgress.StatusSuccess
                    formatter: () => 'Done'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义进度条渐变色')
            desc: qsTr(`
通过 \`useGradient\` 属性启用渐变，此时 \`colorBar\` 将不会生效。\n
通过 \`gradientStops\` 属性设置渐变色，它是形如 \`{ '0%': '#108ee9', '100%': '#87d068' }\` 的对象。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    width: parent.width
    spacing: 10

    property var twoColors: {
        '0%': '#108ee9',
        '100%': '#87d068',
    }
    property var conicColors: {
        '0%': '#87d068',
        '50%': '#ffe58f',
        '100%': '#ffccc7',
    };

    Column {
        spacing: 10

        AntProgress {
            width: 600
            percent: 99.9
            useGradient: true
            gradientStops: twoColors
        }

        AntProgress {
            width: 600
            percent: 50
            useGradient: true
            gradientStops: twoColors
        }
    }

    Row {
        spacing: 10

        AntProgress {
            width: 120
            height: width
            type: AntProgress.TypeCircle
            percent: 75
            useGradient: true
            gradientStops: twoColors
        }

        AntProgress {
            width: 120
            height: width
            type: AntProgress.TypeCircle
            status: AntProgress.StatusSuccess
            percent: 100
            useGradient: true
            gradientStops: twoColors
        }

        AntProgress {
            width: 120
            height: width
            type: AntProgress.TypeCircle
            percent: 93
            useGradient: true
            gradientStops: conicColors
        }
    }

    Row {
        spacing: 10

        AntProgress {
            width: 120
            height: width
            type: AntProgress.TypeDashboard
            percent: 75
            useGradient: true
            gradientStops: twoColors
        }

        AntProgress {
            width: 120
            height: width
            type: AntProgress.TypeDashboard
            status: AntProgress.StatusSuccess
            percent: 100
            useGradient: true
            gradientStops: twoColors
        }

        AntProgress {
            width: 120
            height: width
            type: AntProgress.TypeDashboard
            percent: 93
            useGradient: true
            gradientStops: conicColors
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                property var twoColors: {
                    '0%': '#108ee9',
                    '100%': '#87d068',
                }
                property var conicColors: {
                    '0%': '#87d068',
                    '50%': '#ffe58f',
                    '100%': '#ffccc7',
                };

                Column {
                    spacing: 10

                    AntProgress {
                        width: 600
                        percent: 99.9
                        useGradient: true
                        gradientStops: twoColors
                    }

                    AntProgress {
                        width: 600
                        percent: 50
                        useGradient: true
                        gradientStops: twoColors
                    }
                }

                Row {
                    spacing: 10

                    AntProgress {
                        width: 120
                        height: width
                        type: AntProgress.TypeCircle
                        percent: 75
                        useGradient: true
                        gradientStops: twoColors
                    }

                    AntProgress {
                        width: 120
                        height: width
                        type: AntProgress.TypeCircle
                        status: AntProgress.StatusSuccess
                        percent: 100
                        useGradient: true
                        gradientStops: twoColors
                    }

                    AntProgress {
                        width: 120
                        height: width
                        type: AntProgress.TypeCircle
                        percent: 93
                        useGradient: true
                        gradientStops: conicColors
                    }
                }

                Row {
                    spacing: 10

                    AntProgress {
                        width: 120
                        height: width
                        type: AntProgress.TypeDashboard
                        percent: 75
                        useGradient: true
                        gradientStops: twoColors
                    }

                    AntProgress {
                        width: 120
                        height: width
                        type: AntProgress.TypeDashboard
                        status: AntProgress.StatusSuccess
                        percent: 100
                        useGradient: true
                        gradientStops: twoColors
                    }

                    AntProgress {
                        width: 120
                        height: width
                        type: AntProgress.TypeDashboard
                        percent: 93
                        useGradient: true
                        gradientStops: conicColors
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('步骤进度条')
            desc: qsTr(`
通过将 \`steps\` 设置步骤总数为大于 0 的值来创建步骤形式的进度条。\n
通过将 \`currentStep\` 设置当前的步骤值。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    width: parent.width
    spacing: 10

    Column {
        AntCopyableText {
            text: \`Custom step count: \${stepCoutSlider.value[0]}\`
        }

        AntSlider {
            id: stepCoutSlider
            width: 200
            height: 30
            min: 1
            max: 100
            initialValue: 8
            stepSize: 1
        }

        AntCopyableText {
            text: \`Custom gap: \${gapCountSlider.value[0]}\`
        }

        AntSlider {
            id: gapCountSlider
            width: 200
            height: 30
            min: 0
            max: 40
            initialValue: 4
            stepSize: 4
            snapMode: AntSlider.SnapAlways
        }

        AntCopyableText {
            text: \`Custom bar thickness: \${barThicknessSlider.value[0]}\`
        }

        AntSlider {
            id: barThicknessSlider
            width: 200
            height: 30
            min: 4
            max: 40
            initialValue: 8
            stepSize: 1
        }
    }

    Column {
        spacing: 10

        AntProgress {
            width: 600
            height: Math.min(40, Math.max(barThickness, 16))
            barThickness: barThicknessSlider.value[0]
            percent: 75
            gap: gapCountSlider.value[0]
            steps: Math.round(stepCoutSlider.value[0])
            currentStep: Math.floor(percent / 100 * steps)
        }

        AntProgress {
            width: 600
            height: Math.min(40, Math.max(barThickness, 16))
            status: AntProgress.StatusException
            barThickness: barThicknessSlider.value[0]
            percent: 75
            gap: gapCountSlider.value[0]
            steps: Math.round(stepCoutSlider.value[0])
            currentStep: Math.floor(percent / 100 * steps)
        }
    }

    Row {
        spacing: 10

        AntProgress {
            width: 200
            height: width
            type: AntProgress.TypeCircle
            barThickness: barThicknessSlider.value[0]
            percent: 75
            gap: gapCountSlider.currentValue
            steps: Math.round(stepCoutSlider.currentValue)
            currentStep: Math.floor(percent / 100 * steps)
        }

        AntProgress {
            width: 200
            height: width
            type: AntProgress.TypeCircle
            status: AntProgress.StatusException
            barThickness: barThicknessSlider.currentValue
            percent: 75
            gap: gapCountSlider.currentValue
            steps: Math.round(stepCoutSlider.currentValue)
            currentStep: Math.floor(percent / 100 * steps)
        }
    }

    Row {
        spacing: 10

        AntProgress {
            width: 200
            height: width
            type: AntProgress.TypeDashboard
            barThickness: barThicknessSlider.currentValue
            percent: 75
            gap: gapCountSlider.currentValue
            steps: Math.round(stepCoutSlider.currentValue)
            currentStep: Math.floor(percent / 100 * steps)
        }

        AntProgress {
            width: 200
            height: width
            type: AntProgress.TypeDashboard
            status: AntProgress.StatusException
            barThickness: barThicknessSlider.currentValue
            percent: 75
            gap: gapCountSlider.currentValue
            steps: Math.round(stepCoutSlider.currentValue)
            currentStep: Math.floor(percent / 100 * steps)
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                Column {
                    AntCopyableText {
                        text: `Custom step count: ${stepCoutSlider.currentValue}`
                    }

                    AntSlider {
                        id: stepCoutSlider
                        width: 200
                        height: 30
                        min: 1
                        max: 100
                        initialValue: 8
                        stepSize: 1
                    }

                    AntCopyableText {
                        text: `Custom gap: ${gapCountSlider.currentValue}`
                    }

                    AntSlider {
                        id: gapCountSlider
                        width: 200
                        height: 30
                        min: 0
                        max: 40
                        initialValue: 4
                        stepSize: 4
                        snapMode: AntSlider.SnapAlways
                    }

                    AntCopyableText {
                        text: `Custom bar thickness: ${barThicknessSlider.currentValue}`
                    }

                    AntSlider {
                        id: barThicknessSlider
                        width: 200
                        height: 30
                        min: 4
                        max: 40
                        initialValue: 8
                        stepSize: 1
                    }
                }

                Column {
                    spacing: 10

                    AntProgress {
                        width: 600
                        height: Math.min(40, Math.max(barThickness, 16))
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }

                    AntProgress {
                        width: 600
                        height: Math.min(40, Math.max(barThickness, 16))
                        status: AntProgress.StatusException
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }
                }

                Row {
                    spacing: 10

                    AntProgress {
                        width: 200
                        height: width
                        type: AntProgress.TypeCircle
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }

                    AntProgress {
                        width: 200
                        height: width
                        type: AntProgress.TypeCircle
                        status: AntProgress.StatusException
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }
                }

                Row {
                    spacing: 10

                    AntProgress {
                        width: 200
                        height: width
                        type: AntProgress.TypeDashboard
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }

                    AntProgress {
                        width: 200
                        height: width
                        type: AntProgress.TypeDashboard
                        status: AntProgress.StatusException
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }
                }
            }
        }
    }
}
