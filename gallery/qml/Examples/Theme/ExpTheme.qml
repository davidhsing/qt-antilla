import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Antilla.Basic
import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: AntScrollBar { }

    AntColorGenerator {
        id: antColorGenerator
    }

    Column {
        id: column
        width: parent.width
        spacing: 30

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`AntTheme.installThemePrimaryColorBase()\` 方法设置全局主题的主基础颜色，主基础颜色影响所有颜色的生成。
                       `)
            code: `
                AntTheme.installThemePrimaryColorBase('#ff0000');
            `
            exampleDelegate: Column {
                spacing: 10

                AntDivider {
                    width: parent.width
                    height: 30
                    titleText: qsTr('更改主基础颜色')
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    Repeater {
                        id: repeater
                        model: [
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Red), colorName: 'red' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Volcano), colorName: 'volcano' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Orange), colorName: 'orange' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Gold), colorName: 'gold' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Yellow), colorName: 'yellow' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Lime), colorName: 'lime' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Green), colorName: 'green' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Cyan), colorName: 'cyan' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Blue), colorName: 'blue' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Geekblue), colorName: 'geekblue' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Purple), colorName: 'purple' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Magenta), colorName: 'magenta' },
                            { color: antColorGenerator.presetToColor(AntColorGenerator.Preset_Grey), colorName: 'grey' }
                        ]
                        delegate: Rectangle {
                            id: rootItem
                            width: 50
                            height: 50
                            color: hovered ? AntThemeFunctions.lighter(modelData.color, 110) : modelData.color
                            border.color: isCurrent || hovered ? AntTheme.Primary.colorPrimaryBorderHover :
                                                                 AntTheme.Primary.colorPrimaryBorder
                            radius: AntTheme.Primary.radiusPrimary

                            property bool hovered: false
                            property bool isCurrent: index === repeater.currentIndex

                            Behavior on color { ColorAnimation { } }
                            Behavior on border.color { ColorAnimation { } }

                            AntIconText {
                                anchors.centerIn: parent
                                iconSource: AntIcon.CheckOutlined
                                iconSize: 18
                                color: 'white'
                                visible: rootItem.isCurrent
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: rootItem.hovered = true;
                                onExited: rootItem.hovered = false;
                                onClicked: {
                                    galleryGlobal.themeIndex = repeater.currentIndex = index;
                                    AntTheme.installThemePrimaryColorBase(rootItem.color);
                                }
                            }
                        }
                        property int currentIndex: galleryGlobal.themeIndex
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`AntTheme.installThemePrimaryFontSizeBase()\` 方法设置全局主题的主基础字体大小，主基础字体大小影响所有字体大小的生成。
                       `)
            code: `
                AntTheme.installThemePrimaryFontSizeBase(32);
            `
            exampleDelegate: Column {
                spacing: 10

                AntDivider {
                    width: parent.width
                    height: 30
                    titleText: qsTr('更改主基础字体大小')
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`AntTheme.installThemePrimaryFontFamiliesBase()\` 方法设置全局主题的主基础字体族字符串，该字符串可以是多个字体名，用逗号分隔，主题引擎将自动选择该列表中在本平台支持的字体。
                       `)
            code: `
                AntTheme.installThemePrimaryFontFamiliesBase(''Microsoft YaHei UI', BlinkMacSystemFont, 'Segoe UI', Roboto');
            `
            exampleDelegate: Column {
                spacing: 10

                AntDivider {
                    width: parent.width
                    height: 30
                    titleText: qsTr('更改主基础字体族')
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`AntTheme.installThemePrimaryRadiusBase()\` 方法设置圆角半径基础大小。
                       `)
            code: `
                AntTheme.installThemePrimaryRadiusBase(6);
            `
            exampleDelegate: Column {
                spacing: 10

                AntDivider {
                    width: parent.width
                    height: 30
                    titleText: qsTr('更改圆角半径基础大小')
                }
            }
        }


        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`AntTheme.installThemePrimaryAnimationBase()\` 方法设置动画基础速度。
                       `)
            code: `
                AntTheme.installThemePrimaryAnimationBase(100, 200, 300);
            `
            exampleDelegate: Column {
                spacing: 10

                AntDivider {
                    width: parent.width
                    height: 30
                    titleText: qsTr('更改动画基础速度')
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`AntTheme.animationEnabled\` 属性开启/关闭全局动画，关闭动画资源占用更低。
                       `)
            code: `
                AntTheme.animationEnabled = true;
            `
            exampleDelegate: Column {
                spacing: 10

                AntDivider {
                    width: parent.width
                    height: 30
                    titleText: qsTr('更改全局动画')
                }

                AntSwitch {
                    checked: AntTheme.animationEnabled
                    checkedText: qsTr('开启')
                    uncheckedText: qsTr('关闭')
                    onToggled: {
                        AntTheme.animationEnabled = checked;
                    }
                }
            }
        }
    }
}
