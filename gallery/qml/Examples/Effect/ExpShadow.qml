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
# AntShadow 阴影\n
阴影效果。\n
* **继承自 { MultiEffect }**\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当用户需要统一的阴影效果时。
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`source\` 属性设置需要阴影的项目。\n
通过 \`shadowOpacity\` 属性设置阴影透明度。\n
通过 \`shadowScale\` 属性设置阴影缩放。\n
通过 \`shadowVerticalOffset\` 属性设置阴影垂直偏移。\n
通过 \`shadowHorizontalOffset\` 属性设置阴影水平偏移。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    width: parent.width
    spacing: 10

    AntSlider {
        id: shadowOpacitySlider
        width: 150
        height: 30
        initialValue: 1.0
        min: 0.0
        max: 1.0
        stepSize: 0.1

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: qsTr('阴影透明度: ') + parent.value[0].toFixed(1);
        }
    }

    AntSlider {
        id: shadowScaleSlider
        width: 150
        height: 30
        initialValue: 1.0
        min: 1.0
        max: 1.5
        stepSize: 0.01

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: qsTr('阴影缩放: ') + parent.value[0].toFixed(1);
        }
    }

    AntSlider {
        id: shadowVerticalOffsetSlider
        width: 150
        height: 30
        initialValue: 0
        min: -100
        max: 100
        stepSize: 1

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: qsTr('阴影垂直偏移: ') + parent.value[0].toFixed(1);
        }
    }

    AntSlider {
        id: shadowHorizontalOffsetSlider
        width: 150
        height: 30
        initialValue: 0
        min: -100
        max: 100
        stepSize: 1

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: qsTr('阴影水平偏移: ') + parent.value[0].toFixed(1);
        }
    }

    AntSlider {
        id: topLeftSlider
        width: 150
        height: 30
        min: 0
        max: 100
        stepSize: 1

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: qsTr('左上圆角: ') + parent.value[0].toFixed(0);
        }
    }

    AntSlider {
        id: topRightSlider
        width: 150
        height: 30
        min: 0
        max: 100
        stepSize: 1

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: qsTr('右上圆角: ') + parent.value[0].toFixed(0);
        }
    }

    AntSlider {
        id: bottomLeftSlider
        width: 150
        height: 30
        min: 0
        max: 100
        stepSize: 1

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: qsTr('左下圆角: ') + parent.value[0].toFixed(0);
        }
    }

    AntSlider {
        id: bottomRightSlider
        width: 150
        height: 30
        min: 0
        max: 100
        stepSize: 1

        AntCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: qsTr('右下圆角: ') + parent.value[0].toFixed(0);
        }
    }

    Item {
        width: parent.width
        height: 200

        AntShadow {
            anchors.fill: back
            source: back
            shadowOpacity: shadowOpacitySlider.value[0]
            shadowScale: shadowScaleSlider.value[0]
            shadowVerticalOffset: shadowVerticalOffsetSlider.value[0]
            shadowHorizontalOffset: shadowHorizontalOffsetSlider.value[0]
            paddingRect: Qt.rect(width * shadowScale, height * shadowScale, width * shadowScale, height * shadowScale)
        }

        AntRectangle {
            id: back
            width: 200
            height: 200
            anchors.centerIn: parent
            color: '#EF8A8A'
            topLeftRadius: topLeftSlider.value[0]
            topRightRadius: topRightSlider.value[0]
            bottomLeftRadius: bottomLeftSlider.value[0]
            bottomRightRadius: bottomRightSlider.value[0]
            visible: false
        }
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                AntSlider {
                    id: shadowOpacitySlider
                    width: 150
                    height: 30
                    initialValue: 0.5
                    min: 0.0
                    max: 1.0
                    stepSize: 0.1

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('阴影透明度: ') + parent.value[0].toFixed(1);
                    }
                }

                AntSlider {
                    id: shadowScaleSlider
                    width: 150
                    height: 30
                    initialValue: 1.0
                    min: 1.0
                    max: 1.5
                    stepSize: 0.01

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('阴影缩放: ') + parent.value[0].toFixed(1);
                    }
                }

                AntSlider {
                    id: shadowVerticalOffsetSlider
                    width: 150
                    height: 30
                    initialValue: 0
                    min: -100
                    max: 100
                    stepSize: 1

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('阴影垂直偏移: ') + parent.value[0].toFixed(1);
                    }
                }

                AntSlider {
                    id: shadowHorizontalOffsetSlider
                    width: 150
                    height: 30
                    initialValue: 0
                    min: -100
                    max: 100
                    stepSize: 1

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('阴影水平偏移: ') + parent.value[0].toFixed(1);
                    }
                }

                AntSlider {
                    id: topLeftSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('左上圆角: ') + parent.value[0].toFixed(0);
                    }
                }

                AntSlider {
                    id: topRightSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('右上圆角: ') + parent.value[0].toFixed(0);
                    }
                }

                AntSlider {
                    id: bottomLeftSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('左下圆角: ') + parent.value[0].toFixed(0);
                    }
                }

                AntSlider {
                    id: bottomRightSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    AntCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('右下圆角: ') + parent.value[0].toFixed(0);
                    }
                }

                Item {
                    width: parent.width
                    height: 200

                    AntShadow {
                        anchors.fill: back
                        source: back
                        shadowOpacity: shadowOpacitySlider.value[0]
                        shadowScale: shadowScaleSlider.value[0]
                        shadowVerticalOffset: shadowVerticalOffsetSlider.value[0]
                        shadowHorizontalOffset: shadowHorizontalOffsetSlider.value[0]
                        paddingRect: Qt.rect(width * shadowScale, height * shadowScale, width * shadowScale, height * shadowScale)
                    }

                    AntRectangle {
                        id: back
                        width: 200
                        height: 200
                        anchors.centerIn: parent
                        color: '#EF8A8A'
                        topLeftRadius: topLeftSlider.value[0]
                        topRightRadius: topRightSlider.value[0]
                        bottomLeftRadius: bottomLeftSlider.value[0]
                        bottomRightRadius: bottomRightSlider.value[0]
                        visible: false
                    }
                }
            }
        }
    }
}
