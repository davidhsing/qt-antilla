import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

Item {
    id: control

    enum BlockType {
        TypeFilled = 0,
        TypeOutlined = 1
    }

    enum RadioSize {
        SizeAuto = 0,
        SizeFixed = 1
    }

    signal clicked(index: int, radioData: var)

    property bool animationEnabled: AntTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property var model: []
    readonly property int count: model.length
    property int initCheckedIndex: -1
    property int currentCheckedIndex: -1
    property var currentCheckedValue: undefined
    property int type: AntRadioBlock.TypeFilled
    property int size: AntRadioBlock.SizeAuto
    property int radioWidth: 120
    property int radioHeight: 30
    property font font: Qt.font({
        family: control.themeSource.fontFamily,
        pixelSize: control.themeSource.fontSize
    })
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBlockBg }
    property Component toolTipDelegate: AntToolTip {
        text: toolTip.text ?? ''
        delay: toolTip.delay ?? 500
        timeout: toolTip.timeout ?? -1
        visible: hovered
        animationEnabled: control.animationEnabled
    }
    property Component radioDelegate: AntIconButton {
        id: __rootItem

        required property var modelData
        required property int index

        T.ButtonGroup.group: __buttonGroup
        Component.onCompleted: {
            if (control.initCheckedIndex == index) {
                checked = true;
                __buttonGroup.clicked(__rootItem);
            }
        }

        animationEnabled: control.animationEnabled
        effectEnabled: control.effectEnabled
        hoverCursorShape: control.hoverCursorShape
        implicitWidth: control.size == AntRadioBlock.SizeAuto ? (implicitContentWidth + leftPadding + rightPadding) :
                                                                 control.radioWidth
        implicitHeight: control.size == AntRadioBlock.SizeAuto ? (implicitContentHeight + topPadding + bottomPadding) :
                                                                  control.radioHeight
        z: (hovered || checked) ? 1 : 0
        enabled: control.enabled && (modelData.enabled === undefined ? true : modelData.enabled)
        font: control.font
        type: AntButton.TypeDefault
        iconSource: modelData.iconSource ?? 0
        text: modelData.label ?? ''
        colorBorder: (enabled && checked) ? control.themeSource.colorBlockBorderChecked :
                                            control.themeSource.colorBlockBorder;
        colorText: {
            if (enabled) {
                if (control.type == AntRadioBlock.TypeFilled) {
                    return checked ? control.themeSource.colorBlockTextFilledChecked :
                                     hovered ? control.themeSource.colorBlockTextChecked :
                                               control.themeSource.colorBlockText;
                } else {
                    return (checked || hovered) ? control.themeSource.colorBlockTextChecked :
                                                  control.themeSource.colorBlockText;
                }
            } else {
                return control.themeSource.colorTextDisabled;
            }
        }
        colorBg: {
            if (enabled) {
                if (control.type == AntRadioBlock.TypeFilled) {
                    return down ? (checked ? control.themeSource.colorBlockBgActive : control.themeSource.colorBlockBg) :
                                  hovered ? (checked ? control.themeSource.colorBlockBgHover : control.themeSource.colorBlockBg) :
                                            checked ? control.themeSource.colorBlockBgChecked :
                                                      control.themeSource.colorBlockBg;
                } else {
                    return control.themeSource.colorBlockBg;
                }
            } else {
                return checked ? control.themeSource.colorBlockBgCheckedDisabled : control.themeSource.colorBlockBgDisabled;
            }
        }
        checkable: true
        background: Item {
            Rectangle {
                id: __effect
                width: __bg.width
                height: __bg.height
                anchors.centerIn: parent
                visible: __rootItem.effectEnabled
                color: 'transparent'
                border.width: 0
                border.color: __rootItem.enabled ? control.themeSource.colorBlockEffectBg : 'transparent'
                opacity: 0.2

                ParallelAnimation {
                    id: __animation
                    onFinished: __effect.border.width = 0;
                    NumberAnimation {
                        target: __effect; property: 'width'; from: __bg.width + 3; to: __bg.width + 8;
                        duration: AntTheme.Primary.durationFast
                        easing.type: Easing.OutQuart
                    }
                    NumberAnimation {
                        target: __effect; property: 'height'; from: __bg.height + 3; to: __bg.height + 8;
                        duration: AntTheme.Primary.durationFast
                        easing.type: Easing.OutQuart
                    }
                    NumberAnimation {
                        target: __effect; property: 'opacity'; from: 0.2; to: 0;
                        duration: AntTheme.Primary.durationSlow
                    }
                }

                Connections {
                    target: __rootItem
                    function onReleased() {
                        if (__rootItem.animationEnabled && __rootItem.effectEnabled) {
                            __effect.border.width = 8;
                            __animation.restart();
                        }
                    }
                }
            }

            AntRectangleInternal {
                id: __bg
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                color: __rootItem.colorBg
                topLeftRadius: index == 0 ? control.radiusBg.topLeft : 0
                topRightRadius: index === (count - 1) ? control.radiusBg.topRight : 0
                bottomLeftRadius: index == 0 ? control.radiusBg.bottomLeft : 0
                bottomRightRadius: index === (count - 1) ? control.radiusBg.bottomRight : 0
                border.width: 1
                border.color: __rootItem.colorBorder

                Behavior on color { enabled: __rootItem.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
                Behavior on border.color { enabled: __rootItem.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
            }
        }

        Loader {
            x: (parent.width - width) / 2
            active: toolTip !== undefined
            sourceComponent: control.toolTipDelegate
            property bool checked: __rootItem.released
            property bool pressed: __rootItem.pressed
            property bool hovered: __rootItem.hovered
            property var toolTip: modelData.toolTip
        }

        Connections {
            target: control
            function onCurrentCheckedIndexChanged() {
                if (__rootItem.index == control.currentCheckedIndex) {
                    __rootItem.checked = true;
                }
            }
        }
    }
    property string ariaConstrual: ''
    property var themeSource: AntTheme.AntRadioBlock

    objectName: '__AntRadioBlock__'
    implicitWidth: __loader.implicitWidth
    implicitHeight: __loader.implicitHeight

    Loader {
        id: __loader
        sourceComponent: Row {
            spacing: -1

            Repeater {
                id: __repeater
                model: control.model
                delegate: radioDelegate
            }
        }

        T.ButtonGroup {
            id: __buttonGroup
            onClicked:
                button => {
                    control.currentCheckedIndex = button.index;
                    control.currentCheckedValue = button.modelData.value;
                    control.clicked(button.index, button.modelData);
                }
        }
    }

    Accessible.role: Accessible.RadioButton
    Accessible.name: control.ariaConstrual
    Accessible.description: control.ariaConstrual
    Accessible.onPressAction: control.clicked();
}
