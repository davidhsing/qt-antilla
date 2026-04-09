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
# AntModal 对话框\n
展示一个对话框，提供标题、内容区、操作区。\n
* **继承自 { [AntPopup](internal://AntPopup) }**\n
\n<br/>
\n### 支持的代理：\n
- **bgDelegate: Component** 背景代理\n
- **iconDelegate: Component** 图标代理\n
- **titleDelegate: Component** 标题代理\n
- **descriptionDelegate: Component** 描述代理\n
- **contentDelegate: Component** 内容代理\n
- **footerDelegate: Component** 页脚代理(包含确认/取消按钮)\n
- **closeDelegate: Component** 右上角关闭按钮代理\n
- **confirmDelegate: Component** 确认按钮代理\n
- **cancelDelegate: Component** 取消按钮代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | AntTheme.animationEnabled | 是否开启动画
position | enum | AntModal.PositionCenter | 弹框出现的位置(来自 AntModal)
positionMargin | int | 120 | 弹框出现位置距离窗口边缘的距离
closable | bool | true | 是否显示右上角的关闭按钮
maskClosable | bool | true | 是否允许点击蒙层来关闭
iconSource | int丨string | 0丨'' | 图标源(来自 AntIcon)或图标链接
iconSize | int | 24 | 图标大小
titleText | string | '' | 标题文本
descriptionText | string | '' | 描述文本
confirmText | string | '' | 确认文本
cancelText | string | '' | 取消文本
colorIcon | color | - | 图标颜色
colorTitle | color | - | 标题文本颜色
colorDescription | color | - | 描述文本颜色
titleFont | font | - | 标题文本字体
descriptionFont | font | - | 描述文本字体
bgVisible | bool | true | 背景是否可见
iconVisible | bool | - | 图标是否可见
titleVisible | bool | - | 标题是否可见
descriptionVisible | bool | - | 描述是否可见
footerVisible | bool | true | 页脚是否可见
confirmVisible | bool | true | 确认按钮是否可见
cancelVisible | bool | true | 取消按钮是否可见
widthRevision | int | -40 | 宽度修正(相对于父组件)
heightRevision | int | 40 | 高度修正(相对于代理组件)
\n<br/>
\n### 支持的函数：\n
- \`openInfo()\` 打开 \`info\` 弹框\n
- \`openSuccess()\` 打开 \`success\` 弹框\n
- \`openError()\` 打开 \`error\` 弹框\n
- \`openWarning()\` 打开 \`warning\` 弹框\n
\n<br/>
\n### 支持的信号：\n
- \`confirmed()\` 点击确认按钮后发出\n
- \`canceled()\` 点击取消按钮后发出\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
需要用户处理事务，又不希望跳转页面以致打断工作流程时，可以使用 \`AntModal\` 在当前页面打开一个浮层，承载相应的操作。\n
                       `)
        }

        ThemeToken {
            source: 'AntModal'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
基础弹框。\n
通过 \`modal\` 属性设置是否为模态。\n
通过 \`titleText\` 属性设置标题文本。\n
通过 \`descriptionText\` 属性设置描述文本。\n
通过 \`confirmText\` 属性设置确认文本\n
通过 \`cancelText\` 属性设置取消文本。\n
通过 \`closable\` 属性设置右上角关闭按钮。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntButton {
        text: 'Open Modal'
        type: AntButton.TypePrimary
        onClicked: modal1.open();

        AntModal {
            id: modal1
            width: 500
            modal: modalSwitch.checked
            position: parseInt(positionRadio.currentCheckedValue)
            closable: closableRadio.currentCheckedValue
            titleText: 'Basic Modal'
            descriptionText: 'Some contents...\\nSome contents...\\nSome contents...'
            confirmText: 'Yes'
            cancelText: 'No'
            onConfirmed: close();
            onCanceled: close();
        }
    }

    Row {
        spacing: 10

        AntText {
            text: 'Modal:'
            anchors.verticalCenter: parent.verticalCenter
        }

        AntSwitch {
            id: modalSwitch
            checked: true
        }
    }

    AntRadioBlock {
        id: positionRadio
        initCheckedIndex: 0
        model: [
            { label: 'Top', value: AntModal.PositionTop},
            { label: 'Bottom', value: AntModal.PositionBottom },
            { label: 'Center', value: AntModal.PositionCenter },
            { label: 'Left', value: AntModal.PositionLeft },
            { label: 'Right', value: AntModal.PositionRight }
        ]
    }

    AntRadioBlock {
        id: closableRadio
        initCheckedIndex: 0
        model: [
            { label: 'Closable', value: true},
            { label: 'Non-closable', value: false }
        ]
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntButton {
                    text: 'Open Modal'
                    type: AntButton.TypePrimary
                    onClicked: modal1.open();

                    AntModal {
                        id: modal1
                        width: 500
                        modal: modalSwitch.checked
                        position: parseInt(positionRadio.currentCheckedValue)
                        closable: closableRadio.currentCheckedValue
                        titleText: 'Basic Modal'
                        descriptionText: 'Some contents...\nSome contents...\nSome contents...'
                        confirmText: 'Yes'
                        cancelText: 'No'
                        onConfirmed: close();
                        onCanceled: close();
                    }
                }

                Row {
                    spacing: 10

                    AntText {
                        text: 'Modal:'
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    AntSwitch {
                        id: modalSwitch
                        checked: true
                    }
                }

                AntRadioBlock {
                    id: positionRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'Top', value: AntModal.PositionTop},
                        { label: 'Bottom', value: AntModal.PositionBottom },
                        { label: 'Center', value: AntModal.PositionCenter },
                        { label: 'Left', value: AntModal.PositionLeft },
                        { label: 'Right', value: AntModal.PositionRight }
                    ]
                }

                AntRadioBlock {
                    id: closableRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'Closable', value: true},
                        { label: 'Non-closable', value: false }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义页脚')
            desc: qsTr(`
更复杂的例子，自定义了页脚的按钮，点击提交后进入 \`loading\` 状态，完成后关闭。\n
不需要默认确定取消按钮时，你可以把 \`footerDelegate\` 设为 null。\n
通过 \`footerDelegate\` 属性设置自定义页脚代理。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    spacing: 10

    AntButton {
        text: 'Open Modal'
        type: AntButton.TypePrimary
        onClicked: modal2.open();

        AntModal {
            id: modal2
            width: 500
            titleText: 'Title'
            descriptionText: 'Some contents...\\nSome contents...\\nSome contents...\\nSome contents...\\nSome contents...'
            footerDelegate: Item {
                height: 30

                Row {
                    anchors.right: parent.right
                    spacing: 10

                    AntButton {
                        text: 'Return'
                        type: AntButton.TypeOutlined
                        onClicked: modal2.close();
                    }

                    AntIconButton {
                        text: 'Submit'
                        type: AntButton.TypePrimary
                        onClicked: {
                            loading = true;
                            submitTimer.restart();
                        }

                        Timer {
                            id: submitTimer
                            interval: 2000
                            onTriggered: {
                                modal2.close();
                                parent.loading = false;
                            }
                        }
                    }

                    AntButton {
                        text: 'Search on Google'
                        type: AntButton.TypePrimary
                        onClicked: Qt.openUrlExternally('https://google.com');
                    }
                }
            }
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntButton {
                    text: 'Open Modal with customized footer'
                    type: AntButton.TypePrimary
                    onClicked: modal2.open();

                    AntModal {
                        id: modal2
                        width: 500
                        titleText: 'Title'
                        descriptionText: 'Some contents...\nSome contents...\nSome contents...\nSome contents...\nSome contents...'
                        footerDelegate: Item {
                            height: 30

                            Row {
                                anchors.right: parent.right
                                spacing: 10

                                AntButton {
                                    text: 'Return'
                                    type: AntButton.TypeOutlined
                                    onClicked: modal2.close();
                                }

                                AntIconButton {
                                    text: 'Submit'
                                    type: AntButton.TypePrimary
                                    onClicked: {
                                        loading = true;
                                        submitTimer.restart();
                                    }

                                    Timer {
                                        id: submitTimer
                                        interval: 2000
                                        onTriggered: {
                                            modal2.close();
                                            parent.loading = false;
                                        }
                                    }
                                }

                                AntButton {
                                    text: 'Search on Google'
                                    type: AntButton.TypePrimary
                                    onClicked: Qt.openUrlExternally('https://google.com');
                                }
                            }
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('其他提示消息类型')
            desc: qsTr(`
包括成功、失败、信息、警告弹框。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 10

    AntButton {
        text: 'Success'
        onClicked: modal3.openSuccess();
    }

    AntButton {
        text: 'Warning'
        onClicked: modal3.openWarning();
    }

    AntButton {
        text: 'Info'
        onClicked: modal3.openInfo();
    }

    AntButton {
        text: 'Error'
        onClicked: modal3.openError();
    }

    AntModal {
        id: modal3
        width: 500
        titleText: 'Title'
        descriptionText: 'Reachable: Light!\\nUnreachable: null!'
        confirmText: 'Yes'
        cancelText: 'No'
        onConfirmed: close();
        onCanceled: close();
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntButton {
                    text: 'Success'
                    onClicked: modal3.openSuccess();
                }

                AntButton {
                    text: 'Warning'
                    onClicked: modal3.openWarning();
                }

                AntButton {
                    text: 'Info'
                    onClicked: modal3.openInfo();
                }

                AntButton {
                    text: 'Error'
                    onClicked: modal3.openError();
                }

                AntModal {
                    id: modal3
                    width: 500
                    titleText: 'Title'
                    descriptionText: 'Reachable: Light!\nUnreachable: null!'
                    confirmText: 'Yes'
                    cancelText: 'No'
                    onConfirmed: close();
                    onCanceled: close();
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('可拖拽的弹框')
            desc: qsTr(`
通过 \`movable\` 属性设置为可移动，具体请参考 [AntPopup](internal://AntPopup)。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    spacing: 10

    AntButton {
        text: 'Open Draggable Modal'
        onClicked: modal4.open();

        AntModal {
            id: modal4
            width: 500
            titleText: 'Draggable Modal'
            movable: true
            descriptionText: 'Just dont learn physics at school and your life will be full of magic and miracles. \\n\\nDay before yesterday I saw a rabbit, and yesterday a deer, and today, you.'
            confirmText: 'Yes'
            cancelText: 'No'
            onConfirmed: close();
            onCanceled: close();
        }
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntButton {
                    text: 'Open Draggable Modal'
                    onClicked: modal4.open();

                    AntModal {
                        id: modal4
                        width: 500
                        titleText: 'Draggable Modal'
                        movable: true
                        descriptionText: 'Just dont learn physics at school and your life will be full of magic and miracles. \n\nDay before yesterday I saw a rabbit, and yesterday a deer, and today, you.'
                        confirmText: 'Yes'
                        cancelText: 'No'
                        onConfirmed: close();
                        onCanceled: close();
                    }
                }
            }
        }
    }
}
