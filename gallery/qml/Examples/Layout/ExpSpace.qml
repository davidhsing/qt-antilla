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
# AntSpace 间距\n
布局并设置组件之间的间距/圆角。\n
* **继承自 { Loader }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
layout | enum | AntSpace.TypeRow | 布局类型(来自 AntSpace)
combineRadius | bool | true | 是否自动组合圆角
radiusBg | [AntRadius](internal://AntRadius) | - | 背景圆角
\n其他属性来自 **Row/RowLayout/Column/ColumnLayout/Grid/GridLayout** \n
\n**注意** 覆盖问题请使用 \`z: active ? 1 : 0\` 或类似的方案解决\n
\n**注意** 自动组合圆角无法正确处理 Repeater 创建的项，此时应关闭 \`combineRadius\` 并手动设置圆角\n
`)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- AntSpace 当用户需要简化布局和组合组件时使用，自动为子元素计算间距和圆角，其本身是原生固定布局(Row* Column* Grid*)的容器。\n
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
通过 \`layout\` 属性设置实例化布局(设置一次)，设置完成后和原生布局一样使用即可。\n
\`layout\` 支持的值有：'TypeRow' 'TypeRowLayout' 'TypeColumn' 'TypeColumnLayout' 'TypeGrid' 'TypeGridLayout' \n
                       `)
            code: `
                import QtQuick
                import Antilla.Basic

                Column {
                    spacing: 15

                    Row {
                        AntText {
                            width: 120
                            anchors.verticalCenter: parent.verticalCenter
                            text: 'ButtonType: '
                        }
                        AntRadioBlock {
                            id: buttonTypeRadio
                            initCheckedIndex: 0
                            model: [
                                { label: 'Default', value: AntButton.TypeDefault },
                                { label: 'Outlined', value: AntButton.TypeOutlined },
                                { label: 'Dashed', value: AntButton.TypeDashed },
                                { label: 'Primary', value: AntButton.TypePrimary },
                                { label: 'Filled', value: AntButton.TypeFilled },
                            ]
                        }
                    }

                    Row {
                        AntText {
                            width: 120
                            anchors.verticalCenter: parent.verticalCenter
                            text: 'LayoutDirection: '
                        }
                        AntRadioBlock {
                            id: layoutDirectionRadio
                            initCheckedIndex: 0
                            model: [
                                { label: 'LeftToRight', value: Qt.LeftToRight },
                                { label: 'RightToLeft', value: Qt.RightToLeft },
                            ]
                        }
                    }

                    Row {
                        AntText {
                            width: 120
                            anchors.verticalCenter: parent.verticalCenter
                            text: 'Space: '
                        }
                        AntSlider {
                            id: spaceSlider
                            width: 200
                            height: 30
                            min: -1
                            max: 100
                            initialValue: -1
                        }
                    }

                    AntSpace {
                        layout: AntSpace.TypeRow
                        spacing: spaceSlider.value[0]
                        layoutDirection: layoutDirectionRadio.currentCheckedValue

                        AntIconButton {
                            type: buttonTypeRadio.currentCheckedValue
                            iconSource: AntIcon.LikeOutlined
                            AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Like' }
                        }

                        AntIconButton {
                            type: buttonTypeRadio.currentCheckedValue
                            iconSource: AntIcon.CommentOutlined
                            AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Comment' }
                        }

                        AntIconButton {
                            type: buttonTypeRadio.currentCheckedValue
                            iconSource: AntIcon.StarOutlined
                            AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Star' }
                        }

                        AntIconButton {
                            type: buttonTypeRadio.currentCheckedValue
                            iconSource: AntIcon.HeartOutlined
                            AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Heart' }
                        }

                        AntIconButton {
                            type: buttonTypeRadio.currentCheckedValue
                            iconSource: AntIcon.ShareAltOutlined
                            AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Share' }
                        }

                        AntIconButton {
                            enabled: false
                            type: buttonTypeRadio.currentCheckedValue
                            iconSource: AntIcon.DownloadOutlined
                            AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Download' }
                        }

                        AntIconButton {
                            type: buttonTypeRadio.currentCheckedValue
                            iconSource: AntIcon.EllipsisOutlined
                            onClicked: contextMenu.open();

                            AntContextMenu {
                                id: contextMenu
                                y: parent.height + 2
                                defaultMenuWidth: 140
                                initModel: [
                                    { key: '1', label: 'Report', iconSource: AntIcon.WarningOutlined, },
                                    { key: '2', label: 'Mail', iconSource: AntIcon.MailOutlined },
                                    { key: '3', label: 'Mobile', iconSource: AntIcon.MobileOutlined },
                                ]
                                onMenuClicked: close();
                                Component.onCompleted: AntApi.setPopupAllowAutoFlip(this);
                            }
                        }
                    }

                    AntSpace {
                        layout: AntSpace.TypeRow
                        spacing: spaceSlider.value[0]
                        layoutDirection: layoutDirectionRadio.currentCheckedValue

                        AntButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button1' }
                        AntButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button2' }
                        AntButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button3' }
                        AntButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button4' }

                        AntIconButton {
                            enabled: false
                            type: buttonTypeRadio.currentCheckedValue
                            iconSource: AntIcon.DownloadOutlined
                            AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Download' }
                        }

                        AntIconButton {
                            type: buttonTypeRadio.currentCheckedValue
                            iconSource: AntIcon.DownloadOutlined
                            AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Download' }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                Row {
                    AntText {
                        width: 120
                        anchors.verticalCenter: parent.verticalCenter
                        text: 'ButtonType: '
                    }
                    AntRadioBlock {
                        id: buttonTypeRadio
                        initCheckedIndex: 0
                        model: [
                            { label: 'Default', value: AntButton.TypeDefault },
                            { label: 'Outlined', value: AntButton.TypeOutlined },
                            { label: 'Dashed', value: AntButton.TypeDashed },
                            { label: 'Primary', value: AntButton.TypePrimary },
                            { label: 'Filled', value: AntButton.TypeFilled },
                        ]
                    }
                }

                Row {
                    AntText {
                        width: 120
                        anchors.verticalCenter: parent.verticalCenter
                        text: 'LayoutDirection: '
                    }
                    AntRadioBlock {
                        id: layoutDirectionRadio
                        initCheckedIndex: 0
                        model: [
                            { label: 'LeftToRight', value: Qt.LeftToRight },
                            { label: 'RightToLeft', value: Qt.RightToLeft },
                        ]
                    }
                }

                Row {
                    AntText {
                        width: 120
                        anchors.verticalCenter: parent.verticalCenter
                        text: 'Space: '
                    }
                    AntSlider {
                        id: spaceSlider
                        width: 200
                        height: 30
                        min: -1
                        max: 100
                        initialValue: -1
                    }
                }

                AntSpace {
                    layout: AntSpace.TypeRow
                    spacing: spaceSlider.value[0]
                    layoutDirection: layoutDirectionRadio.currentCheckedValue

                    AntIconButton {
                        type: buttonTypeRadio.currentCheckedValue
                        iconSource: AntIcon.LikeOutlined
                        AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Like' }
                    }

                    AntIconButton {
                        type: buttonTypeRadio.currentCheckedValue
                        iconSource: AntIcon.CommentOutlined
                        AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Comment' }
                    }

                    AntIconButton {
                        type: buttonTypeRadio.currentCheckedValue
                        iconSource: AntIcon.StarOutlined
                        AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Star' }
                    }

                    AntIconButton {
                        type: buttonTypeRadio.currentCheckedValue
                        iconSource: AntIcon.HeartOutlined
                        AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Heart' }
                    }

                    AntIconButton {
                        type: buttonTypeRadio.currentCheckedValue
                        iconSource: AntIcon.ShareAltOutlined
                        AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Share' }
                    }

                    AntIconButton {
                        enabled: false
                        type: buttonTypeRadio.currentCheckedValue
                        iconSource: AntIcon.DownloadOutlined
                        AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Download' }
                    }

                    AntIconButton {
                        type: buttonTypeRadio.currentCheckedValue
                        iconSource: AntIcon.EllipsisOutlined
                        onClicked: contextMenu.open();

                        AntContextMenu {
                            id: contextMenu
                            y: parent.height + 2
                            defaultMenuWidth: 140
                            initModel: [
                                { key: '1', label: 'Report', iconSource: AntIcon.WarningOutlined, },
                                { key: '2', label: 'Mail', iconSource: AntIcon.MailOutlined },
                                { key: '3', label: 'Mobile', iconSource: AntIcon.MobileOutlined },
                            ]
                            onMenuClicked: close();
                            Component.onCompleted: AntApi.setPopupAllowAutoFlip(this);
                        }
                    }
                }

                AntSpace {
                    layout: AntSpace.TypeRow
                    spacing: spaceSlider.value[0]
                    layoutDirection: layoutDirectionRadio.currentCheckedValue

                    AntButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button1' }
                    AntButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button2' }
                    AntButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button3' }
                    AntButton { type: buttonTypeRadio.currentCheckedValue; text: 'Button4' }

                    AntIconButton {
                        enabled: false
                        type: buttonTypeRadio.currentCheckedValue
                        iconSource: AntIcon.DownloadOutlined
                        AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Download' }
                    }

                    AntIconButton {
                        type: buttonTypeRadio.currentCheckedValue
                        iconSource: AntIcon.DownloadOutlined
                        AntToolTip { arrowVisible: true; visible: parent.hovered; text: 'Download' }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('列布局')
            desc: qsTr(`
layout === 'TypeColumn/TypeColumnLayout' 用法，等同于使用原生 \`Column/ColumnLayout\`。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Layouts
                import Antilla.Basic

                Row {
                    spacing: 15

                    AntSpace {
                        layout: AntSpace.TypeColumn

                        AntButton { text: 'Button1' }
                        AntButton { text: 'Button2' }
                        AntButton { text: 'Button3' }
                    }

                    AntSpace {
                        layout: AntSpace.TypeColumn

                        AntButton { type: AntButton.TypeDashed; text: 'Button1' }
                        AntButton { type: AntButton.TypeDashed; text: 'Button2' }
                        AntButton { type: AntButton.TypeDashed; text: 'Button3' }
                    }

                    AntSpace {
                        layout: AntSpace.TypeColumn

                        AntButton { type: AntButton.TypePrimary; text: 'Button1' }
                        AntButton { type: AntButton.TypePrimary; text: 'Button2' }
                        AntButton { type: AntButton.TypePrimary; text: 'Button3' }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                AntSpace {
                    layout: AntSpace.TypeColumn

                    AntButton { text: 'Button1' }
                    AntButton { text: 'Button2' }
                    AntButton { text: 'Button3' }
                }

                AntSpace {
                    layout: AntSpace.TypeColumn

                    AntButton { type: AntButton.TypeDashed; text: 'Button1' }
                    AntButton { type: AntButton.TypeDashed; text: 'Button2' }
                    AntButton { type: AntButton.TypeDashed; text: 'Button3' }
                }

                AntSpace {
                    layout: AntSpace.TypeColumn

                    AntButton { type: AntButton.TypePrimary; text: 'Button1' }
                    AntButton { type: AntButton.TypePrimary; text: 'Button2' }
                    AntButton { type: AntButton.TypePrimary; text: 'Button3' }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('网格布局')
            desc: qsTr(`
layout === 'Grid/GridLayout' 用法，等同于使用原生 \`Grid/GridLayout\`。\n
\`AntSpace\` 会自动组合子组件，使它们看起来像一个整体。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Layouts
                import Antilla.Basic

                Column {
                    spacing: 15

                    Row {
                        AntText {
                            width: 120
                            anchors.verticalCenter: parent.verticalCenter
                            text: 'LayoutDirection: '
                        }
                        AntRadioBlock {
                            id: layoutDirectionRadio2
                            initCheckedIndex: 0
                            model: [
                                { label: 'LeftToRight', value: Qt.LeftToRight },
                                { label: 'RightToLeft', value: Qt.RightToLeft },
                            ]
                        }
                    }

                    AntSpace {
                        layout: AntSpace.TypeGridLayout
                        rows: 3
                        columns: 3
                        layoutDirection: layoutDirectionRadio2.currentCheckedValue

                        AntButton { Layout.preferredWidth: 100; z: hovered ? 1 : 0; type: AntButton.TypePrimary; text: 'Button1' }
                        AntButton { Layout.preferredWidth: 100; z: hovered ? 1 : 0; text: 'Button2' }
                        AntIconButton { Layout.fillWidth: true; z: hovered ? 1 : 0; iconSource: AntIcon.LikeOutlined }

                        AntSelect {
                            Layout.preferredWidth: 100
                            z: active ? 1 : 0
                            currentIndex: 0
                            model: [
                                { label: 'Between' },
                                { label: 'Except' },
                            ]
                        }
                        AntInput {
                            Layout.preferredWidth: 150
                            Layout.columnSpan: 2
                            z: hovered ? 1 : 0
                        }

                        AntLabel {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            text: '$'
                            colorBg: AntTheme.Primary.colorFillPrimary
                            verticalAlignment: AntLabel.AlignVCenter
                            horizontalAlignment : AntLabel.AlignHCenter
                        }
                        AntInput {
                            Layout.fillWidth: true
                            Layout.maximumWidth: 100
                            z: hovered ? 1 : 0
                            text: '1,000,000'
                        }
                        AntIconButton {
                            Layout.fillWidth: true
                            z: hovered ? 1 : 0
                            iconSource: AntIcon.SearchOutlined
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                Row {
                    AntText {
                        width: 120
                        anchors.verticalCenter: parent.verticalCenter
                        text: 'LayoutDirection: '
                    }
                    AntRadioBlock {
                        id: layoutDirectionRadio2
                        initCheckedIndex: 0
                        model: [
                            { label: 'LeftToRight', value: Qt.LeftToRight },
                            { label: 'RightToLeft', value: Qt.RightToLeft },
                        ]
                    }
                }

                AntSpace {
                    layout: AntSpace.TypeGridLayout
                    rows: 3
                    columns: 3
                    layoutDirection: layoutDirectionRadio2.currentCheckedValue

                    AntButton { Layout.preferredWidth: 100; z: hovered ? 1 : 0; type: AntButton.TypePrimary; text: 'Button1' }
                    AntButton { Layout.preferredWidth: 100; z: hovered ? 1 : 0; text: 'Button2' }
                    AntIconButton { Layout.fillWidth: true; z: hovered ? 1 : 0; iconSource: AntIcon.LikeOutlined }

                    AntSelect {
                        Layout.preferredWidth: 100
                        z: active ? 1 : 0
                        currentIndex: 0
                        model: [
                            { label: 'Between' },
                            { label: 'Except' },
                        ]
                    }
                    AntInput {
                        Layout.preferredWidth: 150
                        Layout.columnSpan: 2
                        z: active ? 1 : 0
                    }

                    AntLabel {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        text: '$'
                        colorBg: AntTheme.Primary.colorFillPrimary
                        verticalAlignment: AntLabel.AlignVCenter
                        horizontalAlignment : AntLabel.AlignHCenter
                    }
                    AntInput {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 100
                        z: active ? 1 : 0
                        text: '1,000,000'
                    }
                    AntIconButton {
                        Layout.fillWidth: true
                        z: hovered ? 1 : 0
                        iconSource: AntIcon.SearchOutlined
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('常见组合')
            desc: qsTr(`
一些常见的组合例子。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Layouts
                import Antilla.Basic

                Column {
                    spacing: 10

                    AntSpace {
                        layout: AntSpace.TypeRow

                        AntInput { width: 100; text: '0571' }
                        AntInput { width: 150; text: '26888888' }
                    }

                    AntSpace {
                        layout: AntSpace.TypeRow

                        AntInput { text: 'https://github.com/davidhsing/qt-antilla' }
                        AntButton { type: AntButton.TypePrimary; text: 'Submit' }
                    }

                    AntSpace {
                        layout: AntSpace.TypeRow

                        AntInput { text: 'https://github.com/davidhsing/qt-antilla' }
                        AntIconButton { iconSource: AntIcon.CopyOutlined }
                    }

                    AntSpace {
                        layout: AntSpace.TypeRow

                        AntSelect { width: 100; model: [{ label: 'Jiangsu' }, { label: 'Hubei' }] }
                        AntInput { width: 300; text: 'Pukou District, Nanjing' }
                    }

                    AntSpace {
                        layout: AntSpace.TypeRow

                        AntMultiSelect { width: 300; options: [{ label: 'Jiangsu' }, { label: 'Hubei' }] }
                        AntInput { width: 300; text: 'Pukou District, Nanjing' }
                    }

                    AntSpace {
                        layout: AntSpace.TypeRow

                        AntInput { width: 200; text: 'input content' }
                        AntDateTimePicker { width: 200; placeholderText: 'Please select date' }
                    }

                    AntSpace {
                        layout: AntSpace.TypeRowLayout

                        AntDateTimePicker { Layout.preferredWidth: 200; placeholderText: 'Please select start date' }
                        AntLabel { Layout.fillHeight: true; text: '  =>  '; verticalAlignment: AntLabel.AlignVCenter }
                        AntDateTimePicker { Layout.preferredWidth: 200; placeholderText: 'Please select end date' }
                    }

                    AntSpace {
                        layout: AntSpace.TypeRow

                        AntInput { width: 200; text: 'input content' }
                        AntColorPicker {
                            radiusTriggerBg.topLeft: 0
                            radiusTriggerBg.bottomLeft: 0
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                AntSpace {
                    layout: AntSpace.TypeRow

                    AntInput { width: 100; text: '0571' }
                    AntInput { width: 150; text: '26888888' }
                }

                AntSpace {
                    layout: AntSpace.TypeRow

                    AntInput { text: 'https://github.com/davidhsing/qt-antilla' }
                    AntButton { type: AntButton.TypePrimary; text: 'Submit' }
                }

                AntSpace {
                    layout: AntSpace.TypeRow

                    AntInput { text: 'https://github.com/davidhsing/qt-antilla' }
                    AntIconButton { iconSource: AntIcon.CopyOutlined }
                }

                AntSpace {
                    layout: AntSpace.TypeRow

                    AntSelect { width: 100; model: [{ label: 'Jiangsu' }, { label: 'Hubei' }] }
                    AntInput { width: 300; text: 'Pukou District, Nanjing' }
                }

                AntSpace {
                    layout: AntSpace.TypeRow

                    AntMultiSelect { width: 300; options: [{ label: 'Jiangsu' }, { label: 'Hubei' }] }
                    AntInput { width: 300; text: 'Pukou District, Nanjing' }
                }

                AntSpace {
                    layout: AntSpace.TypeRow

                    AntInput { width: 200; text: 'input content' }
                    AntDateTimePicker { width: 200; placeholderText: 'Please select date' }
                }

                AntSpace {
                    layout: AntSpace.TypeRowLayout

                    AntDateTimePicker { Layout.preferredWidth: 200; placeholderText: 'Please select start date' }
                    AntLabel { Layout.fillHeight: true; text: '  =>  '; verticalAlignment: AntLabel.AlignVCenter }
                    AntDateTimePicker { Layout.preferredWidth: 200; placeholderText: 'Please select end date' }
                }

                AntSpace {
                    layout: AntSpace.TypeRow

                    AntInput { width: 200; text: 'input content' }
                    AntColorPicker {
                        radiusTriggerBg.topLeft: 0
                        radiusTriggerBg.bottomLeft: 0
                    }
                }
            }
        }
    }
}
