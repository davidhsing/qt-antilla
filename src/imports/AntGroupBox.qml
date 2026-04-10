import QtQuick
import QtQuick.Shapes
import Antilla.Basic

Item {
    id: control

    enum TitlePosition {
        PositionTop = 0,
        PositionBottom = 1
    }

    enum TitleAlign {
        AlignLeft = 0,
        AlignCenter = 1,
        AlignRight = 2
    }

    property bool animationEnabled: AntTheme.animationEnabled
    property bool titleVisible: !!control.titleText
    property string titleText: ''
    property font titleFont: Qt.font({
        family: AntTheme.AntGroupBox.fontFamily,
        pixelSize: AntTheme.AntGroupBox.fontSize
    })
    property int titlePosition: AntGroupBox.PositionTop
    property int titleAlign: AntGroupBox.AlignLeft
    property int titlePadding: 20
    property int titleLeftPadding: 4
    property int titleRightPadding: 4
    property int borderWidth: 1
    property int contentMargins: 16
    property int contentTopMargin: contentMargins
    property int contentBottomMargin: contentMargins
    property int contentLeftMargin: contentMargins
    property int contentRightMargin: contentMargins
    property color colorTitle: AntTheme.AntGroupBox.colorTitle
    property color colorBorder: AntTheme.AntGroupBox.colorBorder
    property color colorBg: AntTheme.AntGroupBox.colorBg
    property AntRadius radiusBg: AntRadius { all: AntTheme.AntGroupBox.radiusBg }
    property string ariaConstrual: titleText

    property Component titleDelegate: AntText {
        text: control.titleText
        font: control.titleFont
        color: control.colorTitle
        leftPadding: control.titleLeftPadding
        rightPadding: control.titleRightPadding
    }

    property Component borderDelegate: Item {
        id: borderItem
        property real titleX: 0
        property real titleWidth: 0

        // 完整的带圆角边框
        AntRectangle {
            anchors.fill: parent
            color: control.colorBg
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            border.width: control.borderWidth
            border.color: control.colorBorder
            border.style: Qt.SolidLine
            // 根据标题位置设置边框留白
            topPreserve.from: control.titlePosition === AntGroupBox.PositionTop ? borderItem.titleX : 0
            topPreserve.to: control.titlePosition === AntGroupBox.PositionTop ? borderItem.titleX + borderItem.titleWidth : 0
            bottomPreserve.from: control.titlePosition === AntGroupBox.PositionBottom ? borderItem.titleX : 0
            bottomPreserve.to: control.titlePosition === AntGroupBox.PositionBottom ? borderItem.titleX + borderItem.titleWidth : 0
        }
    }

    default property alias content: __contentItem.data

    objectName: '__AntGroupBox__'
    implicitWidth: __mainLoader.implicitWidth
    implicitHeight: __mainLoader.implicitHeight

    Behavior on colorTitle { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

    // 临时内容容器（用于接收子组件）
    Item {
        id: __contentItem
        width: parent.width
        visible: false
    }

    Loader {
        id: __mainLoader
        anchors.fill: parent
        sourceComponent: __mainComponent
    }

    Component {
        id: __mainComponent
        Item {
            anchors.fill: parent
            implicitWidth: {
                let width = __realContentItem.implicitWidth + control.contentLeftMargin + control.contentRightMargin;
                return Math.max(1, width);
            }
            implicitHeight: {
                let height = __realContentItem.implicitHeight + control.contentTopMargin + control.contentBottomMargin;
                if (!!control.titleText && __titleLoader.item) {
                    height += __titleLoader.item.implicitHeight / 2;
                }
                return Math.max(1, height);
            }

            // 边框
            Loader {
                id: __borderLoader
                anchors.fill: parent
                sourceComponent: borderDelegate

                onLoaded: {
                    // 对于上边框，preserve.from 和 preserve.to 是从右边开始计算的
                    item.titleX = Qt.binding(function() {
                        if (control.titlePosition === AntGroupBox.PositionTop) {
                            // 上边框：转换为从右边开始计算
                            const titleEnd = __titleContainer.x + __titleContainer.width
                            return __borderLoader.width - titleEnd
                        } else {
                            return __titleContainer.x
                        }
                    });
                    item.titleWidth = Qt.binding(function() { return __titleContainer.width })
                }
            }

            // 标题容器
            Item {
                id: __titleContainer
                z: 1
                x: {
                    if (control.titleAlign === AntGroupBox.AlignLeft) {
                        return control.titlePadding;
                    } else if (control.titleAlign === AntGroupBox.AlignRight) {
                        return control.width - (__titleLoader.item ? __titleLoader.item.implicitWidth : 0) - control.titlePadding;
                    }
                    return (control.width - (__titleLoader.item ? __titleLoader.item.implicitWidth : 0)) / 2;
                }
                y: {
                    if (control.titlePosition === AntGroupBox.PositionTop) {
                        return -(__titleLoader.item ? __titleLoader.item.implicitHeight : 0) / 2;
                    } else if (control.titlePosition === AntGroupBox.PositionBottom) {
                        return control.height - (__titleLoader.item ? __titleLoader.item.implicitHeight : 0) / 2;
                    }
                    return 0;
                }
                width: __titleLoader.item ? __titleLoader.item.implicitWidth : 0
                height: __titleLoader.item ? __titleLoader.item.implicitHeight : 0

                // 标题
                Loader {
                    id: __titleLoader
                    anchors.centerIn: parent
                    sourceComponent: control.titleDelegate
                    active: control.titleVisible
                    visible: active
                }
            }

            // 真正的内容区域（显示子组件）
            Item {
                id: __realContentItem
                anchors.fill: parent
                anchors.topMargin: control.contentTopMargin
                anchors.bottomMargin: control.contentBottomMargin
                anchors.leftMargin: control.contentLeftMargin
                anchors.rightMargin: control.contentRightMargin
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height

                // 将临时容器中的子组件移到这里
                Component.onCompleted: {
                    for (let i = 0; i < __contentItem.data.length; i++) {
                        __contentItem.data[i].parent = __realContentItem;
                    }
                }
            }
        }
    }

    Accessible.role: Accessible.Grouping
    Accessible.name: control.titleText
    Accessible.description: control.ariaConstrual
}
