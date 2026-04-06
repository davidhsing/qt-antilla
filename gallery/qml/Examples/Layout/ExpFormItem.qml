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
# AntFormItem 表单项
表单项组件，用于包装输入组件并提供标签、验证反馈等功能。
* **继承自 { [Item](internal://Item) }**

\n<br/>
\n### 支持的代理：\n
- **contentDelegate: Component** 内容代理\n
\n<br/>
\n### 支持的属性：
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否启用动画
orientation | enum | Qt.Horizontal | 方向(Qt.Horizontal 或 Qt.Vertical)
required | bool | false | 是否必填，为 true 时标签前显示红色星号
requiredSpacing | int | 4 | 红色星号与标签的间距
labelText | string | '' | 标签文本
labelAlign | int | - | 标签文本水平对齐方式(AntFormItem.AlignLeft/AlignRight), 垂直居中
labelWidth | int | 100 | 水平布局时标签宽度
labelSpacing | int | 4/10 | 标签与输入组件的间距,水平布局默认10,垂直布局默认4
colonText | string | ':' | 标签末尾分隔符文本
colonVisible | bool | true | 是否显示标签末尾分隔符
feedbackSpacing | int | 2 | 输入组件与反馈文本的间距
keepFeedbackPlace | bool | true | 当反馈文本为空时，依然保留反馈文本的区域
marginItem | [AntMargin](internal://AntMargin) | 0 | 表单项边距
tooltipVisible | bool | true | 是否显示提示图标
tooltipSpacing | int | 2 | 提示图标与标签的间距
tooltipArrowVisible | bool | true | 提示框是否显示箭头
tooltipArrowOffset | int | 4 | 提示框箭头与图标的间距
tooltipPosition | int | AntToolTip.PositionTop | 提示框位置
tooltipIconSource | var | AntIcon.QuestionCircleOutlined | 提示图标源
tooltipIconSize | int | AntTheme.AntFormItem.fontTooltipIconSize | 提示图标大小
colorTooltipIcon | color | AntTheme.AntFormItem.colorTooltipIcon | 提示图标颜色
tooltipText | string | '' | 提示文本内容
tooltipTextSize | int | AntTheme.AntFormItem.fontTooltipTextSize | 提示文本字体大小
colorTooltipText | color | AntTheme.AntFormItem.colorTooltipText | 提示文本颜色
validator | function | - | 验证函数，参数为任意自定义对象，返回 {valid: bool, message: string} 或 boolean 或 undefined
colorLabelText | color | AntTheme.Primary.colorTextPrimary | 标签颜色
colorLabelRequired | color | AntTheme.Primary.colorError | 必填星号颜色
colorFeedbackSuccess | color | AntTheme.Primary.colorSuccess | 成功状态颜色
colorFeedbackError | color | AntTheme.Primary.colorError | 错误状态颜色
\n<br/>
\n### 支持的函数：
- \`validate()\` 执行验证，返回 bool 表示是否通过
\n<br/>
\n### 枚举：
- \`AntFormItem.LayoutVertical\` 垂直布局
- \`AntFormItem.LayoutHorizontal\` 水平布局
- \`AntFormItem.ValidationNone\` 无验证状态
- \`AntFormItem.ValidationSuccess\` 验证成功
- \`AntFormItem.ValidationError\` 验证失败
            `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要统一管理表单项的布局和样式时
            `)
        }

        ThemeToken {
            source: 'AntFormItem'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基础用法')
            desc: qsTr(`最基本的表单项，包含标签和输入组件。`)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntRadioBlock {
        id: horizontalAlignRadio
        initCheckedIndex: 0
        model: [
            { label: 'Left', value: AntFormItem.AlignLeft },
            { label: 'Right', value: AntFormItem.AlignRight }
        ]
    }

    AntFormItem {
        labelText: '用户名'
        width: parent.width
        orientation: Qt.Horizontal
        labelAlign: horizontalAlignRadio.currentCheckedValue
        required: true

        AntInput {
            width: parent.width
            placeholderText: '请输入用户名'
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntRadioBlock {
                    id: horizontalAlignRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'Left', value: AntFormItem.AlignLeft },
                        { label: 'Right', value: AntFormItem.AlignRight }
                    ]
                }

                AntFormItem {
                    labelText: '用户名'
                    width: parent.width
                    orientation: Qt.Horizontal
                    labelAlign: horizontalAlignRadio.currentCheckedValue
                    required: true

                    AntInput {
                        width: parent.width
                        placeholderText: '请输入用户名'
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('表单验证')
            desc: qsTr(`
通过 \`validator\` 属性提供验证函数，参数为空或任意自定义对象，返回 \`{valid: bool, message: string}\` 对象来显示验证反馈。
            `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntRadioBlock {
        id: verticalAlignRadio
        initCheckedIndex: 0
        model: [
            { label: 'Left', value: AntFormItem.AlignLeft },
            { label: 'Right', value: AntFormItem.AlignRight }
        ]
    }

    AntFormItem {
        id: usernameItem
        width: parent.width
        required: true
        labelText: '用户名'
        labelAlign: verticalAlignRadio.currentCheckedValue
        tooltipText: '用户名的描述'
        validator: () => {
            if (!username.text) {
                return {
                    valid: false,
                    message: '用户名不能为空'
                };
            }
            if (username.text.length < 3) {
                return {
                    valid: false,
                    message: '用户名至少3个字符'
                };
            }
            return {
                valid: true,
                message: '用户名可用'
            };
        }

        AntInput {
            id: username
            width: parent.width
            placeholderText: '请输入用户名'
            onTextChanged: usernameItem.validate()
        }
    }

    AntFormItem {
        id: emailItem
        width: parent.width
        required: true
        labelText: '邮箱'
        labelAlign: verticalAlignRadio.currentCheckedValue
        validator: () => {
            if (!email.text) {
                return {
                    valid: false,
                    message: '邮箱不能为空'
                };
            }
            const emailRegex = /^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$/;
            if (!emailRegex.test(email.text)) {
                return {
                    valid: false,
                    message: '邮箱格式不正确'
                };
            }
            return {
                valid: true,
                message: '邮箱格式正确'
            };
        }

        AntInput {
            id: email
            width: parent.width
            placeholderText: '请输入邮箱'
            onTextChanged: emailItem.validate()
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntRadioBlock {
                    id: verticalAlignRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'Left', value: AntFormItem.AlignLeft },
                        { label: 'Right', value: AntFormItem.AlignRight }
                    ]
                }

                AntFormItem {
                    id: usernameItem
                    width: parent.width
                    required: true
                    labelText: '用户名'
                    labelAlign: verticalAlignRadio.currentCheckedValue
                    tooltipText: '用户名的描述'
                    validator: () => {
                        if (!username.text) {
                            return {
                                valid: false,
                                message: '用户名不能为空'
                            };
                        }
                        if (username.text.length < 3) {
                            return {
                                valid: false,
                                message: '用户名至少3个字符'
                            };
                        }
                        return {
                            valid: true,
                            message: '用户名可用'
                        };
                    }

                    AntInput {
                        id: username
                        width: parent.width
                        placeholderText: '请输入用户名'
                        onTextChanged: usernameItem.validate()
                    }
                }

                AntFormItem {
                    id: emailItem
                    width: parent.width
                    required: true
                    labelText: '邮箱'
                    labelAlign: verticalAlignRadio.currentCheckedValue
                    validator: () => {
                        if (!email.text) {
                            return {
                                valid: false,
                                message: '邮箱不能为空'
                            };
                        }
                        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        if (!emailRegex.test(email.text)) {
                            return {
                                valid: false,
                                message: '邮箱格式不正确'
                            };
                        }
                        return {
                            valid: true,
                            message: '邮箱格式正确'
                        };
                    }

                    AntInput {
                        id: email
                        width: parent.width
                        placeholderText: '请输入邮箱'
                        onTextChanged: emailItem.validate()
                    }
                }
            }
        }
    }
}
