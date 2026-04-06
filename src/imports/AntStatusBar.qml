import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Item {
    id: control

    enum ItemAlign {
        AlignLeft = 0,
        AlignCenter = 1,
        AlignRight = 2
    }

    property bool animationEnabled: AntTheme.animationEnabled
    property var model: []
    property int defaultFontSize: AntTheme.AntStatusBar.fontSize - 2
    property int defaultLeftMargin: 10
    property int defaultRightMargin: 10
    property int defaultElide: Text.ElideRight
    property color colorBg: AntTheme.AntStatusBar.colorBg
    property color colorDivider: AntTheme.AntStatusBar.colorDivider
    property color defaultColorText: AntTheme.AntStatusBar.colorText
    property AntRadius radiusBg: AntRadius { all: 0 }
    property string textRole: 'text'
    property string widthRole: 'width'
    property string alignRole: 'align'
    property string colorTextRole: 'colorText'
    property string fontSizeRole: 'fontSize'
    property string leftMarginRole: 'leftMargin'
    property string rightMarginRole: 'rightMargin'
    property string elideRole: 'elide'

    objectName: '__AntStatusBar__'
    implicitWidth: parent.width
    implicitHeight: 26

    AntRectangleInternal {
        anchors.fill: parent
        color: control.colorBg
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight

        RowLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            Repeater {
                model: control.model

                Item {
                    id: __item
                    required property var modelData
                    required property int index

                    property int itemWidth: modelData[control.widthRole] ?? 0
                    property int itemAlign: modelData[control.alignRole] ?? AntStatusBar.AlignLeft
                    property color itemColorText: modelData[control.colorTextRole] ?? control.defaultColorText
                    property int itemFontSize: modelData[control.fontSizeRole] ?? control.defaultFontSize
                    property int itemLeftMargin: modelData[control.leftMarginRole] ?? control.defaultLeftMargin
                    property int itemRightMargin: modelData[control.rightMarginRole] ?? control.defaultRightMargin
                    property int itemElide: modelData[control.elideRole] ?? control.defaultElide

                    Layout.fillHeight: true
                    Layout.preferredWidth: (itemWidth >= 0) ? itemWidth : 0
                    Layout.fillWidth: itemWidth < 0

                    AntText {
                        anchors.fill: parent
                        anchors.leftMargin: __item.itemLeftMargin
                        anchors.rightMargin: __item.itemRightMargin
                        text: __item.modelData[control.textRole] ?? ''
                        color: __item.itemColorText
                        font.pixelSize: __item.itemFontSize
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: {
                            if (__item.itemAlign === AntStatusBar.AlignLeft) {
                                return Text.AlignLeft;
                            }
                            else if (__item.itemAlign === AntStatusBar.AlignRight) {
                                return Text.AlignRight;
                            }
                            else if (__item.itemAlign === AntStatusBar.AlignCenter) {
                                return Text.AlignHCenter;
                            }
                            else {
                                return Text.AlignLeft;
                            }
                        }
                        elide: __item.itemElide

                        Behavior on color {
                            enabled: control.animationEnabled
                            ColorAnimation { duration: AntTheme.Primary.durationFast }
                        }
                    }

                    AntDivider {
                        width: 1
                        height: parent.height * 0.6
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        visible: __item.index < control.model.length - 1
                        orientation: Qt.Vertical
                    }
                }
            }
        }
    }

    Behavior on colorBg {
        enabled: control.animationEnabled
        ColorAnimation { duration: AntTheme.Primary.durationFast }
    }
    Behavior on defaultColorText {
        enabled: control.animationEnabled
        ColorAnimation { duration: AntTheme.Primary.durationFast }
    }
}
