import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Antilla.Basic

T.Control {
    id: control

    signal colorChanged(color: color)

    property bool animationEnabled: AntTheme.animationEnabled
    property bool active: hovered || visualFocus
    readonly property color value: autoChange ? __private.value : changeableValue
    property color defaultValue: Qt.rgba(0, 0, 0, 0)
    property bool autoChange: true
    property color changeableValue: defaultValue
    property bool changeableSync: false
    property bool titleVisible: !!control.titleText
    property string titleText: ''
    property bool alphaEnabled: true
    property bool clearable: false
    property string format: 'hex'
    property var presets: []
    property int presetsOrientation: Qt.Vertical
    property int presetsLayoutDirection: Qt.LeftToRight
    readonly property alias transparent: __private.transparent
    property alias titleFont: control.font
    property font inputFont: Qt.font({
        family: control.themeSource.fontFamilyInput,
        pixelSize: parseInt(control.themeSource.fontSizeInput) - 2
    })
    property color colorBg: control.themeSource.colorBg
    property color colorBorder: enabled ? (active ? control.themeSource.colorBorderHover : control.themeSource.colorBorder) : control.themeSource.colorBorderDisabled
    property color colorTitle: control.themeSource.colorTitle
    property color colorInput: control.themeSource.colorInput
    property color colorPresetIcon: control.themeSource.colorPresetIcon
    property color colorPresetText: control.themeSource.colorPresetText
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }
    property var themeSource: AntTheme.AntColorPicker

    property Component titleDelegate: AntText {
        text: control.titleText
        color: control.colorTitle
        font: control.titleFont
    }

    objectName: '__AntColorPickerPanel__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)
    padding: 8
    font {
        family: control.themeSource.fontFamilyTitle
        pixelSize: parseInt(control.themeSource.fontSizeTitle)
    }
    onDefaultValueChanged: __private.updateHSV(defaultValue);
    contentItem: Loader {
        sourceComponent: control.presetsOrientation === Qt.Horizontal ? __horLayout : __verLayout
    }
    background: AntRectangleInternal {
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
        color: control.colorBg
        border.color: control.colorBorder
    }

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }

    component PickerView: ColumnLayout {
        spacing: 12

        Loader {
            Layout.fillWidth: true
            sourceComponent: control.titleDelegate
            active: control.titleVisible
            visible: active
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 160

            Rectangle {
                anchors.fill: parent
                color: Qt.hsva(__private.h, 1, 1, 1)
                radius: 6
            }

            // 色板
            Rectangle {
                anchors.fill: parent
                radius: 6
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: '#ffffffff' }
                    GradientStop { position: 1.0; color: '#00ffffff' }
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 6
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: '#00000000' }
                    GradientStop { position: 1.0; color: '#ff000000' }
                }
            }

            Rectangle {
                x: __private.visualS * parent.width - radius
                y: (1 - __private.visualV) * parent.height - radius
                width: 16
                height: width
                radius: width / 2
                border.width: 2
                border.color: AntTheme.isDark ? 'black' : 'white'
                color: 'transparent'
            }

            MouseArea {
                anchors.fill: parent
                preventStealing: true
                cursorShape: Qt.PointingHandCursor
                onPressed: mouse => handleMouse(mouse);
                onPositionChanged: mouse => handleMouse(mouse);

                function handleMouse(mouse) {
                    __private.s = Math.max(0, Math.min(1, mouse.x / width));
                    __private.v = 1 - Math.max(0, Math.min(1, mouse.y / height));
                    // 重置透明状态
                    __private.transparent = false;
                    // 如果透明度为 0，恢复为1确保颜色可见
                    if (control.alphaEnabled && __private.a === 0) {
                        __private.a = 1;
                        __private.updateInput();
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            spacing: 10

            Column {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 4

                // 色相
                Item {
                    id: __hueSlider
                    width: parent.width
                    height: 12

                    Rectangle {
                        width: parent.width
                        height: 7
                        anchors.verticalCenter: parent.verticalCenter
                        radius: height / 2
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.00; color: '#ff0000' }
                            GradientStop { position: 0.17; color: '#ffff00' }
                            GradientStop { position: 0.33; color: '#00ff00' }
                            GradientStop { position: 0.50; color: '#00ffff' }
                            GradientStop { position: 0.67; color: '#0000ff' }
                            GradientStop { position: 0.83; color: '#ff00ff' }
                            GradientStop { position: 1.00; color: '#ff0000' }
                        }
                    }

                    Rectangle {
                        x: __private.h * (parent.width) - radius
                        width: 14
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                        radius: width / 2
                        color: AntTheme.isDark ? 'black' : 'white'
                        border.color: control.themeSource.colorBorderHover
                        border.width: 1

                        Rectangle {
                            width: parent.width - 6
                            height: width
                            anchors.centerIn: parent
                            radius: width / 2
                            color: Qt.hsva(__private.h, 1, 1, 1)
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        preventStealing: true
                        cursorShape: Qt.PointingHandCursor
                        onPressed: mouse => handleMouse(mouse);
                        onPositionChanged: mouse => handleMouse(mouse);

                        function handleMouse(mouse) {
                            __private.h = Math.max(0, Math.min(1, mouse.x / width));
                        }
                    }
                }

                // 透明度
                Loader {
                    width: parent.width
                    height: 12
                    active: control.alphaEnabled
                    visible: active
                    sourceComponent: Item {
                        AntCheckerBoard {
                            width: parent.width
                            height: 7
                            anchors.verticalCenter: parent.verticalCenter
                            rows: 2
                            columns: 36
                            radiusBg.all: height / 2
                        }

                        Rectangle {
                            width: parent.width
                            height: 7
                            anchors.verticalCenter: parent.verticalCenter
                            radius: height / 2
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop {
                                    position: 0
                                    color: Qt.hsva(__private.h, __private.s, __private.v, 0)
                                }
                                GradientStop {
                                    position: 1
                                    color: Qt.hsva(__private.h, __private.s, __private.v, 1)
                                }
                            }
                        }

                        Rectangle {
                            x: __private.a * (parent.width) - radius
                            width: 14
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            radius: width / 2
                            color: 'transparent'
                            border.color: control.themeSource.colorBorderHover
                            border.width: 1

                            Rectangle {
                                width: parent.width - 2
                                height: width
                                anchors.centerIn: parent
                                radius: width / 2
                                color: 'transparent'
                                border.color: AntTheme.isDark ? 'black' : 'white'
                                border.width: 2
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            preventStealing: true
                            cursorShape: Qt.PointingHandCursor
                            onPressed: mouse => handleMouse(mouse);
                            onPositionChanged: mouse => handleMouse(mouse);

                            function handleMouse(mouse) {
                                __private.a = Math.max(0, Math.min(1, mouse.x / width));
                                __private.transparent = control.alphaEnabled && control.isTransparent(control.value);
                                __private.updateInput();
                            }
                        }
                    }
                }
            }

            Item {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24

                AntCheckerBoard {
                    anchors.fill: parent
                    rows: 4
                    columns: 4
                    radiusBg.all: 4
                }

                Rectangle {
                    id: __colorPreview
                    anchors.fill: parent
                    radius: 4
                    color: __private.transparent ? control.themeSource.colorBg : __private.value
                    border.color: control.themeSource.colorBorder
                    border.width: 1
                }

                // 空状态时的斜线
                Canvas {
                    id: __emptyCanvas
                    anchors.fill: parent
                    visible: __private.transparent
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
                        target: __private
                        function onTransparentChanged() {
                            if (control.clearable) {
                                __emptyCanvas.requestPaint();
                            }
                        }
                    }
                }

                // 清除按钮
                AntIconText {
                    anchors.centerIn: parent
                    iconSource: AntIcon.CloseCircleOutlined
                    iconSize: 16
                    colorIcon: control.invertColor(__private.value)
                    visible: control.clearable && !__private.transparent && __hoverHandler.hovered
                    scale: __hoverHandler.hovered ? 1.1 : 1.0
                    cursorShape: Qt.PointingHandCursor
                    z: 1

                    Behavior on scale {
                        enabled: control.animationEnabled
                        NumberAnimation { duration: AntTheme.Primary.durationFast }
                    }
                }

                HoverHandler {
                    id: __hoverHandler
                    cursorShape: control.clearable && !__private.transparent ? Qt.PointingHandCursor : Qt.ArrowCursor
                }

                TapHandler {
                    onTapped: {
                        if (control.clearable && !control.isTransparent(__private.value)) {
                            __private.clearColor();
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            AntSelect {
                Layout.preferredWidth: 60
                Layout.leftMargin: -5
                Layout.rightMargin: -5
                leftPadding: 0
                rightPadding: 0
                animationEnabled: control.animationEnabled
                font: control.inputFont
                clearable: false
                valueRole: 'label'
                background: Item { }
                model: [
                    { label: 'HEX' },
                    { label: 'HSV' },
                    { label: 'RGB' },
                ]
                onActivated: {
                    control.format = String(currentValue).toLowerCase();
                }
                Component.onCompleted: {
                    currentIndex = model.findIndex(o => o.label.toLowerCase() === control.format);
                }
            }

            Loader {
                Layout.fillWidth: true
                active: control.format === 'hex'
                visible: active
                sourceComponent: AntInput {
                    padding: 4
                    topPadding: 4
                    bottomPadding: 4
                    animationEnabled: control.animationEnabled
                    iconSource: 1
                    iconDelegate: AntText {
                        leftPadding: 12
                        text: '#'
                        color: control.colorPresetIcon
                    }
                    font: control.inputFont
                    text: __private.toHex(__private.value)
                    validator: RegularExpressionValidator {
                        regularExpression: control.alphaEnabled ? /[0-9a-fA-F]{6}([0-9a-fA-F]{2})?/ : /[0-9a-fA-F]{6}/
                    }
                    maximumLength: control.alphaEnabled ? 8 : 6
                    onTextEdited: {
                        let color = undefined;
                        if (length === 6) {
                            color = Qt.color('#' + text);
                            color.a = __private.a;
                        } else if (length === 8) {
                            color = Qt.color('#' + text);
                        }
                        if (color) {
                            __private.updateHSV(color);
                            __private.transparent = control.alphaEnabled && control.isTransparent(color);
                        }
                    }
                }
            }

            Loader {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                active: control.format === 'hsv'
                visible: active
                sourceComponent: Row {
                    spacing: 4
                    Component.onCompleted: __private.valueChanged();

                    AntInputInteger {
                        id: __hInput
                        width: 50
                        defaultHandlerWidth: 18
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 359
                        font: control.inputFont
                        onValueModified: {
                            __private.h = value / 359;
                            // 重置透明状态
                            __private.transparent = control.alphaEnabled && control.isTransparent(control.value);
                        }
                    }

                    AntInputInteger {
                        id: __sInput
                        width: 50
                        defaultHandlerWidth: 18
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 100
                        font: control.inputFont
                        formatter: (value) => value + '%'
                        parser: (text) => text.replace('%', '')
                        onValueModified: {
                            __private.s = value * 0.01;
                            // 重置透明状态
                            __private.transparent = control.alphaEnabled && control.isTransparent(control.value);
                        }
                    }

                    AntInputInteger {
                        id: __vInput
                        width: 50
                        defaultHandlerWidth: 18
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 100
                        font: control.inputFont
                        formatter: (value) => value + '%'
                        parser: (text) => text.replace('%', '')
                        onValueModified: {
                            __private.v = value * 0.01;
                            // 重置透明状态
                            __private.transparent = control.alphaEnabled && control.isTransparent(control.value);
                        }
                    }

                    Connections {
                        target: __private
                        function onValueChanged() {
                            __hInput.value = Math.round(__private.h * 359);
                            __sInput.value = Math.round(__private.s * 100);
                            __vInput.value = Math.round(__private.v * 100);
                        }
                    }
                }
            }

            Loader {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                active: control.format === 'rgb'
                visible: active
                sourceComponent: Row {
                    spacing: 4
                    Component.onCompleted: __private.valueChanged();

                    function updateRGB() {
                        const color = Qt.rgba(__rInput.value / 255, __gInput.value / 255, __bInput.value / 255, __private.a);
                        __private.updateHSV(color);
                    }

                    AntInputInteger {
                        id: __rInput
                        width: 50
                        defaultHandlerWidth: 18
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 255
                        font: control.inputFont
                        onValueModified: {
                            parent.updateRGB();
                            // 重置透明状态
                            __private.transparent = control.alphaEnabled && control.isTransparent(control.value);
                        }
                    }

                    AntInputInteger {
                        id: __gInput
                        width: 50
                        defaultHandlerWidth: 18
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 255
                        font: control.inputFont
                        onValueModified: {
                            parent.updateRGB();
                            // 重置透明状态
                            __private.transparent = control.alphaEnabled && control.isTransparent(control.value);
                        }
                    }

                    AntInputInteger {
                        id: __bInput
                        width: 50
                        defaultHandlerWidth: 18
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 255
                        font: control.inputFont
                        onValueModified: {
                            parent.updateRGB();
                            // 重置透明状态
                            __private.transparent = control.alphaEnabled && control.isTransparent(control.value);
                        }
                    }

                    Connections {
                        target: __private
                        function onValueChanged() {
                            __rInput.value = Math.round(__private.value.r * 255);
                            __gInput.value = Math.round(__private.value.g * 255);
                            __bInput.value = Math.round(__private.value.b * 255);
                        }
                    }
                }
            }

            Loader {
                Layout.preferredWidth: 60
                active: control.alphaEnabled
                visible: active
                sourceComponent: AntInputInteger {
                    id: __alphaInput
                    defaultHandlerWidth: 18
                    input.padding: 4
                    input.topPadding: 4
                    input.bottomPadding: 4
                    animationEnabled: control.animationEnabled
                    useWheel: true
                    useKeyboard: true
                    min: 0
                    max: 100
                    font: control.inputFont
                    formatter: (value) => value + '%'
                    parser: (text) => text.replace('%', '')
                    onValueModified: {
                        __private.a = value * 0.01;
                        __private.transparent = control.alphaEnabled && control.isTransparent(control.value);
                    }

                    Component.onCompleted: __private.updateInput();

                    Connections {
                        target: __private
                        function onUpdateInput() {
                            __alphaInput.value = Math.round(__private.a * 100);
                        }
                    }
                }
            }
        }
    }

    component PresetView: Column {
        spacing: 10

        Repeater {
            model: control.presets
            delegate: Column {
                id: __presetRootItem
                width: parent.width
                spacing: 10

                property bool expanded: modelData?.expanded ?? true

                Item {
                    width: parent.width
                    height: 20

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        AntIconText {
                            iconSource: AntIcon.RightOutlined
                            colorIcon: control.colorPresetIcon
                            rotation: __presetRootItem.expanded ? 90 : 0

                            Behavior on rotation {
                                enabled: control.animationEnabled
                                RotationAnimation {
                                    duration: AntTheme.Primary.durationFast
                                }
                            }
                        }

                        AntText {
                            Layout.fillWidth: true
                            text: modelData.label
                            color: control.colorPresetText
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            __presetRootItem.expanded = !__presetRootItem.expanded;
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: __presetRootItem.expanded ? __presetColorFlow.implicitHeight : 0
                    clip: true

                    Behavior on height {
                        enabled: control.animationEnabled
                        NumberAnimation {
                            duration: AntTheme.Primary.durationFast
                        }
                    }

                    // 预设颜色
                    Flow {
                        id: __presetColorFlow
                        width: parent.width
                        spacing: 6

                        Repeater {
                            model: modelData.colors

                            Rectangle {
                                width: 24
                                height: 24
                                radius: 6
                                color: modelData

                                AntIconText {
                                    anchors.centerIn: parent
                                    iconSource: AntIcon.CheckOutlined
                                    iconSize: 18
                                    colorIcon: parent.color.hslLightness > 0.5 ? 'black' : 'white'
                                    scale: visible ? 1 : 0
                                    visible: String(__private.value) === String(modelData)
                                    transformOrigin: Item.Bottom

                                    Behavior on scale {
                                        enabled: control.animationEnabled
                                        NumberAnimation {
                                            easing.type: Easing.OutBack
                                            duration: AntTheme.Primary.durationSlow
                                        }
                                    }

                                    Behavior on opacity {
                                        enabled: control.animationEnabled
                                        NumberAnimation {
                                            duration: AntTheme.Primary.durationMid
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        const color = Qt.color(modelData);
                                        __private.updateHSV(color);
                                        // 重置透明状态
                                        __private.transparent = control.alphaEnabled && control.isTransparent(color);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: __horLayout

        RowLayout {
            layoutDirection: control.presetsLayoutDirection
            spacing: 12

            Loader {
                Layout.preferredWidth: 280
                Layout.alignment: Qt.AlignTop
                visible: active
                sourceComponent: PickerView { }
            }

            Loader {
                Layout.preferredWidth: 1
                Layout.fillHeight: true
                active: control.presets.length > 0
                visible: active
                sourceComponent: AntDivider {
                    animationEnabled: control.animationEnabled
                    orientation: Qt.Vertical
                }
            }

            Loader {
                Layout.preferredWidth: 280
                Layout.alignment: Qt.AlignTop
                active: control.presets.length > 0
                visible: active
                sourceComponent: PresetView { }
            }
        }
    }

    Component {
        id: __verLayout

        ColumnLayout {
            layoutDirection: control.presetsLayoutDirection
            spacing: 12

            Loader {
                Layout.preferredWidth: 280
                visible: active
                sourceComponent: PickerView { }
            }

            Loader {
                Layout.preferredWidth: 280
                Layout.preferredHeight: 1
                active: control.presets.length > 0
                visible: active
                sourceComponent: AntDivider {
                    animationEnabled: control.animationEnabled
                }
            }

            Loader {
                Layout.preferredWidth: 280
                active: control.presets.length > 0
                visible: active
                sourceComponent: PresetView { }
            }
        }
    }

    onAlphaEnabledChanged: {
        __private.a = alphaEnabled ? 1 : 0;
        if (!alphaEnabled) {
            __private.transparent = false;
        } else {
            __private.transparent = control.isTransparent(control.value);
        }
    }

    onChangeableValueChanged: {
        if (control.changeableSync) {
            __private.updateHSV(changeableValue);
            __private.transparent = control.alphaEnabled && control.isTransparent(changeableValue);
        }
    }

    function invertColor(color: color): color {
        const r = 1 - color.r;
        const g = 1 - color.g;
        const b = 1 - color.b;
        return Qt.rgba(r, g, b, color.a);
    }

    function isTransparent(color: color): bool {
        return color.r === 0 && color.g === 0 && color.b === 0 && color.a === 0;
    }

    function setValue(color: color): void {
        if (!color.valid) {
            return;
        }
        __private.valueUpdating = true;
        if (control.autoChange) {
            if (String(color) !== String(__private.value)) {
                __private.updateHSV(color);
                __private.transparent = control.alphaEnabled && control.isTransparent(color);
                // 只更新视觉位置到右上角，不影响实际颜色值
                __private.visualS = 1;
                __private.visualV = 1;
            }
        } else {
            if (String(color) !== String(control.changeableValue)) {
                control.changeableValue = color;
            }
        }
        __private.valueUpdating = false;
    }

    function toHexString(color: color, alpha = true): string {
        const r = Math.round(color.r * 255).toString(16).padStart(2, '0').toUpperCase();
        const g = Math.round(color.g * 255).toString(16).padStart(2, '0').toUpperCase();
        const b = Math.round(color.b * 255).toString(16).padStart(2, '0').toUpperCase();
        if (!alpha || color.a >= 1) {
            return `#${r}${g}${b}`;
        }
        const a = Math.round(color.a * 255).toString(16).padStart(2, '0').toUpperCase();
        return `#${r}${g}${b}${a}`;
    }

    function toHsvString(color: color, alpha = true): string {
        const h = Math.round(color.hsvHue * 359);
        const s = Math.round(color.hsvSaturation * 100);
        const v = Math.round(color.hsvValue * 100);
        if (!alpha || color.a >= 1) {
            return `hsv(${h}, ${s}%, ${v}%)`;
        }
        return `hsva(${h}, ${s}%, ${v}%, ${color.a.toFixed(2)})`;
    }

    function toRgbString(color: color, alpha = true): string {
        const r = Math.round(color.r * 255);
        const g = Math.round(color.g * 255);
        const b = Math.round(color.b * 255);
        if (!alpha || color.a >= 1) {
            return `rgb(${r}, ${g}, ${b})`;
        }
        return `rgba(${r}, ${g}, ${b}, ${color.a.toFixed(2)})`;
    }

    QtObject {
        id: __private

        signal updateInput()

        property real h: 0    // Hue (0-1)
        property real s: 1    // Saturation (0-1)
        property real v: 1    // Value (0-1)
        property real a: 1    // Alpha (0-1)

        property real visualS: s
        property real visualV: v

        property color value: Qt.hsva(h, s, v, alphaEnabled ? a : 1)
        property bool valueUpdating: false
        property bool transparent: control.isTransparent(control.defaultValue)

        onValueChanged: {
            if (!valueUpdating) {
                control.colorChanged(value);
            }
        }

        function clearColor() {
            updateHSV(Qt.rgba(0, 0, 0, 0));
            __private.transparent = true;
        }

        function updateHSV(color) {
            if (color.valid) {
                h = Math.max(0, color.hsvHue);
                s = Math.max(0, color.hsvSaturation);
                v = Math.max(0, color.hsvValue);
                if (control.alphaEnabled) {
                    a = color.a;
                }
                updateInput();
            }
        }

        function floatToHex(value) {
            return Math.round(value).toString(16).padStart(2, '0').toUpperCase();
        }

        function toHex(color) {
            const hexRed = floatToHex(color.r * 255);
            const hexGreen = floatToHex(color.g * 255);
            const hexBlue = floatToHex(color.b * 255);
            let result = hexRed + hexGreen + hexBlue;
            if (control.alphaEnabled && color.a < 1) {
                result += floatToHex(color.a * 255);
            }
            return result;
        }
    }
}
