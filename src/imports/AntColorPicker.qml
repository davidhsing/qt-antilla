import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Antilla.Basic

T.Control {
    id: control

    signal colorChanged(color: color)

    property bool animationEnabled: AntTheme.animationEnabled
    property bool active: hovered || visualFocus
    property bool danger: false
    property bool forceState: false
    readonly property alias value: __colorPickerPanel.value
    property color defaultValue: Qt.rgba(0, 0, 0, 0)
    property alias autoChange: __colorPickerPanel.autoChange
    property alias changeableValue: __colorPickerPanel.changeableValue
    property alias changeableSync: __colorPickerPanel.changeableSync
    property bool textVisible: false
    property var textFormatter: color => {
        switch (format.toLowerCase()) {
            case 'hex': return toHexString(color);
            case 'hsv': return toHsvString(color);
            case 'rgb': return toRgbString(color);
        }
    }
    property alias titleVisible: __colorPickerPanel.titleVisible
    property alias titleText: __colorPickerPanel.titleText
    property alias alphaEnabled: __colorPickerPanel.alphaEnabled
    property alias clearable: __colorPickerPanel.clearable
    property alias open: __popup.visible
    property alias format: __colorPickerPanel.format
    property alias presets: __colorPickerPanel.presets
    property alias presetsOrientation: __colorPickerPanel.presetsOrientation
    property alias presetsLayoutDirection: __colorPickerPanel.presetsLayoutDirection
    readonly property alias transparent: __colorPickerPanel.transparent
    property alias titleFont: __colorPickerPanel.titleFont
    property alias inputFont: __colorPickerPanel.inputFont
    property alias colorBg: __colorPickerPanel.colorBg
    property alias colorBorder: __colorPickerPanel.colorBorder
    property color colorText: enabled ? control.themeSource.colorText : control.themeSource.colorTextDisabled
    property alias colorInput: __colorPickerPanel.colorInput
    property alias colorTitle: __colorPickerPanel.colorTitle
    property alias colorPresetIcon: __colorPickerPanel.colorPresetIcon
    property alias colorPresetText: __colorPickerPanel.colorPresetText
    property alias popup: __popup
    property alias panel: __colorPickerPanel
    property real previewWidth: 22
    property real previewHeight: 22
    property real previewLeftMargin: 0
    property real previewRightMargin: 0
    property real sizeRatio: 1.0
    property AntRadius radiusTriggerBg: AntRadius { all: control.themeSource.radiusTriggerBg }
    property AntRadius radiusPopupBg: AntRadius { all: control.themeSource.radiusPopupBg }
    property var themeSource: AntTheme.AntColorPicker

    property Component textDelegate: AntText {
        padding: 4
        text: control.textFormatter(control.value)
        color: control.colorText
        font: control.font
        verticalAlignment: Text.AlignVCenter
    }
    property alias titleDelegate: __colorPickerPanel.titleDelegate
    property Component footerDelegate: Item { }

    objectName: '__AntColorPicker__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)
    padding: 4
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }
    contentItem: RowLayout {
        spacing: 4

        Item {
            Layout.preferredWidth: Math.max(0, control.previewWidth) * control.sizeRatio
            Layout.preferredHeight: Math.max(0, control.previewHeight) * control.sizeRatio

            AntCheckerBoard {
                anchors.fill: parent
                rows: 4
                columns: 4
                radiusBg: control.radiusTriggerBg
            }

            AntRectangleInternal {
                id: __colorPreview
                anchors.fill: parent
                anchors.leftMargin: control.previewLeftMargin * control.sizeRatio
                anchors.rightMargin: control.previewRightMargin * control.sizeRatio
                radius: control.radiusTriggerBg.all
                topLeftRadius: control.radiusTriggerBg.topLeft
                topRightRadius: control.radiusTriggerBg.topRight
                bottomLeftRadius: control.radiusTriggerBg.bottomLeft
                bottomRightRadius: control.radiusTriggerBg.bottomRight
                color: control.transparent ? control.themeSource.colorBg : control.value
                border.color: control.themeSource.colorBorder
            }

            // 空状态时的斜线
            Canvas {
                id: __emptyCanvas
                anchors.fill: parent
                visible: control.transparent
                onPaint: {
                    const ctx = getContext('2d');
                    ctx.strokeStyle = '#f759ab';
                    ctx.lineWidth = 2;
                    ctx.beginPath();
                    ctx.moveTo(ctx.lineWidth, height - ctx.lineWidth);
                    ctx.lineTo(width - ctx.lineWidth, ctx.lineWidth);
                    ctx.stroke();
                }

                Connections {
                    target: control
                    function onTransparentChanged() {
                        if (control.clearable) {
                            __emptyCanvas.requestPaint();
                        }
                    }
                }
            }
        }

        Loader {
            Layout.preferredHeight: 24 * control.sizeRatio
            active: control.textVisible
            visible: active
            sourceComponent: control.textDelegate
        }
    }
    background: AntRectangleInternal {
        radius: control.radiusTriggerBg.all
        topLeftRadius: control.radiusTriggerBg.topLeft
        topRightRadius: control.radiusTriggerBg.topRight
        bottomLeftRadius: control.radiusTriggerBg.bottomLeft
        bottomRightRadius: control.radiusTriggerBg.bottomRight
        color: control.colorBg
        border.color: {
            if (control.enabled || control.forceState) {
                if (control.danger) {
                    return visualFocus ? control.themeSource.colorErrorBorderActive : (hovered ? control.themeSource.colorErrorBorderHover : control.themeSource.colorErrorBorder);
                }
                return visualFocus ? control.themeSource.colorBorderActive : (hovered ? control.themeSource.colorBorderHover : control.themeSource.colorBorder);
            }
            return control.themeSource.colorBorderDisabled;
        }
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: __popup.visible = !__popup.visible;
    }

    AntPopup {
        id: __popup
        y: parent.height + 6
        padding: 0
        animationEnabled: control.animationEnabled
        radiusBg: control.radiusPopupBg
        closePolicy: T.Popup.NoAutoClose | T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
        Component.onCompleted: AntApi.setPopupAllowAutoFlip(this);
        transformOrigin: {
            if (isTop) {
                return isLeft ? Item.BottomRight : Item.BottomLeft;
            } else {
                return isLeft ? Item.TopRight : Item.TopLeft;
            }
        }
        enter: Transition {
            NumberAnimation {
                property: 'scale'
                from: 0.5
                to: 1.0
                easing.type: Easing.OutQuad
                duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'opacity'
                from: 0.0
                to: 1.0
                easing.type: Easing.OutQuad
                duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
            }
        }
        exit: Transition {
            NumberAnimation {
                property: 'scale'
                from: 1.0
                to: 0.5
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'opacity'
                from: 1.0
                to: 0
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
            }
        }
        contentItem: Column {
            AntColorPickerPanel {
                id: __colorPickerPanel
                animationEnabled: control.animationEnabled
                themeSource: control.themeSource
                active: control.active
                locale: control.locale
                background: Item { }
                onColorChanged: color => {
                    control.colorChanged(color);
                }

                Component.onCompleted: {
                    __colorPickerPanel.defaultValue = control.defaultValue;
                }
            }
            Loader {
                width: parent.width
                sourceComponent: control.footerDelegate
            }
        }
        property real xCenter: x + width / 2
        property real yCenter: y + height / 2
        property bool isLeft: xCenter < control.width / 2
        property bool isTop: yCenter < control.height / 2
    }

    function invertColor(color: color): color {
        return __colorPickerPanel.invertColor(color);
    }

    function isTransparent(color: color): bool {
        return __colorPickerPanel.isTransparent(color);
    }

    function setValue(color: color): void {
        __colorPickerPanel.setValue(color);
    }

    function toHexString(color: color, alpha = true): string {
        return __colorPickerPanel.toHexString(color, alpha);
    }

    function toHsvString(color: color, alpha = true): string {
        return __colorPickerPanel.toHsvString(color, alpha);
    }

    function toRgbString(color: color, alpha = true): string {
        return __colorPickerPanel.toRgbString(color, alpha);
    }
}
