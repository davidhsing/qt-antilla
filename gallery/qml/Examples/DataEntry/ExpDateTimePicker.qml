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
# AntDateTimePicker 日期选择框\n
输入或选择日期时间的控件。\n
* **继承自 { [AntInput](internal://AntInput) }**\n
\n<br/>
\n### 支持的代理：\n
- **dayDelegate: Component** 天项代理，代理可访问属性：\n
  - \`model: var\` 天模型(参见 MonthGrid)\n
  - \`isHovered: bool\` 是否悬浮在本项\n
  - \`isCurrentWeek: bool\` 是否为当前周\n
  - \`isHoveredWeek: bool\` 是否为悬浮周\n
  - \`isCurrentMonth: bool\` 是否为当前月\n
  - \`isCurrentVisualMonth: bool\` 是否为(==visualMonth)\n
  - \`isCurrentDay: bool\` 是否为当前天\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
dateVisible | bool | - | 显示日期部分
timeVisible | bool | - | 显示时间部分
pickerMode | int | AntDateTimePicker.ModeDay | 日期选择模式(来自 AntDateTimePicker)
timePattern | int | AntDateTimePicker.PatternHHMMSS | 时间选择模式(来自 AntDateTimePicker)
initDateTime | date | undefined | 初始日期时间
currentDateTime | date | - | 当前日期时间
currentYear | int | - | 当前年份
currentMonth | int | - | 当前月份
currentDay | int | - | 当前天数
currentWeekNumber | int | - | 当前周数
currentQuarter | int | - | 当前季度
currentHours | int | - | 当前小时数
currentMinutes | int | - | 当前分钟数
currentSeconds | int | - | 当前秒数
visualYear | int | - | 弹窗显示的年份(通常不需要使用)
visualMonth | int | - | 弹窗显示的月份(通常不需要使用)
visualDay | int | - | 弹窗显示的天数(通常不需要使用)
visualQuarter | int | - | 弹窗显示的季度(通常不需要使用)
format | string | 'yyyy-MM-dd hh:mm:ss' | 日期时间格式
radiusItemBg | [AntRadius](internal://AntRadius) | - | 选择项圆角半径
radiusPopupBg | [AntRadius](internal://AntRadius) | - | 弹窗圆角半径
\n<br/>
\n### 支持的函数：\n
- \`setDateTime(date: jsDate)\` 设置当前日期时间为 \`date\`\n
- \`getDateTime(): jsDate\` 获取当前的日期时间\n
- \`setDateTimeString(dateTimeString: string)\` 设置当前日期时间字符串为 \`dateTimeString\`\n
- \`getDateTimeString(): string\` 获取当前的日期时间字符串
- \`openPicker()\` 打开选择弹窗
- \`closePicker()\` 关闭选择弹窗
\n<br/>
\n### 支持的信号：\n
- \`selected(date: jsDate)\` 选择日期时间时发出\n
  -  \`date\` 选择的日期时间\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当用户需要输入一个日期，可以点击标准输入框，弹出日期面板进行选择。\n
                       `)
        }

        ThemeToken {
            source: 'AntDateTimePicker'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
最简单的用法，在浮层中可以选择或者输入日期。\n
通过 \`dateVisible\` 属性设置是否显示日期选择部分。\n
通过 \`timeVisible\` 属性设置是否显示时间选择部分。\n
通过 \`pickerMode\` 属性设置日期选择模式，支持的模式：\n
- 年份选择模式{ AntDateTimePicker.ModeYear }\n
- 季度选择模式{ AntDateTimePicker.ModeQuarter }\n
- 月选择模式{ AntDateTimePicker.ModeMonth }\n
- 周选择模式{ AntDateTimePicker.ModeWeek }\n
- 天选择模式(默认){ AntDateTimePicker.ModeDay }\n
通过 \`timePattern\` 属性设置时间选择模式，支持的模式：\n
- 小时分钟秒{hh:mm:ss}(默认){ AntDateTimePicker.PatternHHMMSS }\n
- 小时分钟{hh:mm}{ AntDateTimePicker.PatternHHMM }\n
- 分钟秒{mm:ss}{ AntDateTimePicker.PatternMMSS }\n
通过 \`format\` 属性设置日期时间格式：\n
年月日时分秒遵从一般日期格式 \`yyyy MM dd hh mm ss\`，而 \`w\` 将替换为周数，\`q\` 将替换为季度。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntDateTimePicker {
        placeholderText: qsTr('请选择日期时间')
        format: qsTr('yyyy-MM-dd hh:mm:ss')
    }

    AntDateTimePicker {
        placeholderText: qsTr('请选择日期')
        pickerMode: AntDateTimePicker.ModeDay
        timeVisible: false
        format: qsTr('yyyy-MM-dd')
    }

    AntDateTimePicker {
        placeholderText: qsTr('请选择周')
        pickerMode: AntDateTimePicker.ModeWeek
        timeVisible: false
        format: qsTr('yyyy-w周')
    }

    AntDateTimePicker {
        placeholderText: qsTr('请选择月份')
        pickerMode: AntDateTimePicker.ModeMonth
        timeVisible: false
        format: qsTr('yyyy-MM')
    }

    AntDateTimePicker {
        placeholderText: qsTr('请选择季度')
        pickerMode: AntDateTimePicker.ModeQuarter
        timeVisible: false
        format: qsTr('yyyy-Qq')
    }

    AntDateTimePicker {
        placeholderText: qsTr('请选择年份')
        pickerMode: AntDateTimePicker.ModeYear
        timeVisible: false
        format: qsTr('yyyy')
    }

    AntDateTimePicker {
        placeholderText: qsTr('请选择时间')
        dateVisible: false
        timePattern: AntDateTimePicker.PatternHHMMSS
        format: qsTr('hh:mm:ss')
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntDateTimePicker {
                    placeholderText: qsTr('请选择日期时间')
                    format: qsTr('yyyy-MM-dd hh:mm:ss')
                }

                AntDateTimePicker {
                    placeholderText: qsTr('请选择日期')
                    pickerMode: AntDateTimePicker.ModeDay
                    timeVisible: false
                    format: qsTr('yyyy-MM-dd')
                }

                AntDateTimePicker {
                    placeholderText: qsTr('请选择周')
                    pickerMode: AntDateTimePicker.ModeWeek
                    timeVisible: false
                    format: qsTr('yyyy-w周')
                }

                AntDateTimePicker {
                    placeholderText: qsTr('请选择月份')
                    pickerMode: AntDateTimePicker.ModeMonth
                    timeVisible: false
                    format: qsTr('yyyy-MM')
                }

                AntDateTimePicker {
                    placeholderText: qsTr('请选择季度')
                    pickerMode: AntDateTimePicker.ModeQuarter
                    timeVisible: false
                    format: qsTr('yyyy-Qq')
                }

                AntDateTimePicker {
                    placeholderText: qsTr('请选择年份')
                    pickerMode: AntDateTimePicker.ModeYear
                    timeVisible: false
                    format: qsTr('yyyy')
                }

                AntDateTimePicker {
                    placeholderText: qsTr('请选择时间')
                    dateVisible: false
                    timePattern: AntDateTimePicker.PatternHHMMSS
                    format: qsTr('hh:mm:ss')
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('任意选择时分秒部分')
            desc: qsTr(`
可任意选择小时分钟秒/小时分钟/分钟秒三种模式。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 10

    AntDateTimePicker {
        dateVisible: false
        timePattern: AntDateTimePicker.PatternHHMMSS
        format: 'hh:mm:ss'
    }

    AntDateTimePicker {
        dateVisible: false
        timePattern: AntDateTimePicker.PatternHHMM
        format: 'hh:mm'
    }

    AntDateTimePicker {
        dateVisible: false
        timePattern: AntDateTimePicker.PatternMMSS
        format: 'mm:ss'
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntDateTimePicker {
                    dateVisible: false
                    timePattern: AntDateTimePicker.PatternHHMMSS
                    format: 'hh:mm:ss'
                }

                AntDateTimePicker {
                    dateVisible: false
                    timePattern: AntDateTimePicker.PatternHHMM
                    format: 'hh:mm'
                }

                AntDateTimePicker {
                    dateVisible: false
                    timePattern: AntDateTimePicker.PatternMMSS
                    format: 'mm:ss'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义日历')
            desc: qsTr(`
简单创建一个五月带有农历和节日的日历。\n
通过 \`initDateTime\` 属性设置初始日期时间。\n
通过 \`dayDelegate\` 属性设置日代理。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntDateTimePicker {
        id: customDatePicker
        initDateTime: new Date(2025, 4, 1)
        placeholderText: qsTr('请选择日期')
        pickerMode: AntDateTimePicker.ModeDay
        timeVisible: false
        format: qsTr('yyyy-MM-dd')
        dayDelegate: AntButton {
            padding: 0
            implicitWidth: 50
            implicitHeight: 50
            type: isCurrentDay || isHovered ? AntButton.TypePrimary : AntButton.TypeLink
            text: \`<span>\${model.day}</span>\${getHoliday()}\`
            effectEnabled: false
            colorText: isCurrentDay ? 'white' : AntTheme.Primary.colorTextBase
            Component.onCompleted: contentItem.textFormat = Text.RichText;

            function getHoliday() {
                if (model.month === 4 && model.day === 1) {
                    return \`<br/><span style=\'color:red\'>劳动节</span>\`;
                } else if (model.month === 4 && model.day === 21) {
                    return \`<br/><span style=\'color:red\'>小满</span>\`;
                } else if (model.month === 4 && model.day === 31) {
                    return \`<br/><span style=\'color:red\'>端午节</span>\`;
                } else {
                    const lunarDaysMay2025 = [
                      '初四', '初五', '初六', '初七', '初八',
                      '初九', '初十', '十一', '十二', '十三',
                      '十四', '十五', '十六', '十七', '十八',
                      '十九', '二十', '廿一', '廿二', '廿三',
                      '廿四', '廿五', '廿六', '廿七', '廿八',
                      '廿九', '三十', '初一', '初二', '初三',
                      '初四'
                    ];
                    if (model.month === 4)
                        return \`<br/><span style='color:\${colorText}'>\${lunarDaysMay2025[model.day - 1]}</span>\`;
                    else
                        return '';
                }
            }
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntDateTimePicker {
                    id: customDatePicker
                    initDateTime: new Date(2025, 4, 1)
                    placeholderText: qsTr('请选择日期')
                    pickerMode: AntDateTimePicker.ModeDay
                    timeVisible: false
                    format: qsTr('yyyy-MM-dd')
                    dayDelegate: AntButton {
                        padding: 0
                        implicitWidth: 50
                        implicitHeight: 50
                        type: isCurrentDay || isHovered ? AntButton.TypePrimary : AntButton.TypeLink
                        text: `<span>${model.day}</span>${getHoliday()}`
                        effectEnabled: false
                        colorText: isCurrentDay ? 'white' : AntTheme.Primary.colorTextBase
                        Component.onCompleted: contentItem.textFormat = Text.RichText;

                        function getHoliday() {
                            if (model.month === 4 && model.day === 1) {
                                return `<br/><span style=\'color:red\'>劳动节</span>`;
                            } else if (model.month === 4 && model.day === 21) {
                                return `<br/><span style=\'color:red\'>小满</span>`;
                            } else if (model.month === 4 && model.day === 31) {
                                return `<br/><span style=\'color:red\'>端午节</span>`;
                            } else {
                                const lunarDaysMay2025 = [
                                  '初四', '初五', '初六', '初七', '初八',
                                  '初九', '初十', '十一', '十二', '十三',
                                  '十四', '十五', '十六', '十七', '十八',
                                  '十九', '二十', '廿一', '廿二', '廿三',
                                  '廿四', '廿五', '廿六', '廿七', '廿八',
                                  '廿九', '三十', '初一', '初二', '初三',
                                  '初四'
                                ];
                                if (model.month === 4)
                                    return `<br/><span style='color:${colorText}'>${lunarDaysMay2025[model.day - 1]}</span>`;
                                else
                                    return '';
                            }
                        }
                    }
                }
            }
        }
    }
}
