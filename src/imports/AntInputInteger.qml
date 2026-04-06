import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Antilla.Basic

T.SpinBox {
    id: control

    signal beforeActivated(index: int, var data)
    signal afterActivated(index: int, var data)

    property bool animationEnabled: AntTheme.animationEnabled
    property alias clearable: __input.clearable
    property alias clearIconSource: __input.clearIconSource
    property alias clearIconSize: __input.clearIconSize
    property alias clearIconPosition: __input.clearIconPosition
    property alias readOnly: __input.readOnly
    property bool handlerVisible: true
    property bool handlerAlwaysVisible: false
    property bool useWheel: false
    property bool useKeyboard: true
    property alias min: control.from
    property alias max: control.to
    property alias step: control.stepSize
    property string prefix: ''
    property string suffix: ''
    property var upIcon: AntIcon.UpOutlined || ''
    property var downIcon: AntIcon.DownOutlined || ''
    property font labelFont: Qt.font({
        family: 'Antilla-Icons',
        pixelSize: parseInt(themeSource.fontSize)
    })
    property var beforeLabel: '' || []
    property var afterLabel: '' || []
    property int initBeforeLabelIndex: 0
    property int initAfterLabelIndex: 0
    property string currentBeforeLabel: ''
    property string currentAfterLabel: ''
    property var formatter: (value, locale) => value.toString()    // value.toLocaleString(locale, 'f', 0)
    property var parser: (text, locale) => Number(text) || 0    // Number.fromLocaleString(locale, text)
    property int defaultHandlerWidth: 24
    property alias colorText: __input.colorText
    property color colorPrefix: themeSource.colorPrefix
    property color colorSuffix: themeSource.colorSuffix
    property color colorBeforeLabel: themeSource.colorBeforeLabel
    property color colorAfterLabel: themeSource.colorAfterLabel
    property AntRadius radiusBg: AntRadius { all: themeSource.radiusBg }
    property var themeSource: AntTheme.AntInputInteger
    property alias input: __input
    property Component beforeDelegate: AntRectangleInternal {
        enabled: control.enabled
        width: Math.max(30, __beforeCompLoader.implicitWidth + 10)
        topLeftRadius: control.radiusBg.topLeft
        bottomLeftRadius: control.radiusBg.bottomLeft
        color: enabled ? control.themeSource.colorLabelBg : control.themeSource.colorLabelBgDisabled
        border.color: enabled ? control.themeSource.colorBorder : control.themeSource.colorBorderDisabled

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

        Loader {
            id: __beforeCompLoader
            anchors.centerIn: parent
            sourceComponent: typeof control.beforeLabel == 'string' ? __labelComp : __selectComp
            property bool isBefore: true
        }
    }
    property Component afterDelegate: AntRectangleInternal {
        enabled: control.enabled
        width: Math.max(30, __afterCompLoader.implicitWidth + 10)
        topRightRadius: control.radiusBg.topRight
        bottomRightRadius: control.radiusBg.bottomRight
        color: enabled ? control.themeSource.colorLabelBg : control.themeSource.colorLabelBgDisabled
        border.color: enabled ? control.themeSource.colorBorder : control.themeSource.colorBorderDisabled

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

        Loader {
            id: __afterCompLoader
            anchors.centerIn: parent
            sourceComponent: typeof control.afterLabel == 'string' ? __labelComp : __selectComp
            property bool isBefore: false
        }
    }
    property Component handlerDelegate: Item {
        id: __handlerRoot
        clip: true
        enabled: control.enabled
        width: enabled && (control.hovered || control.handlerAlwaysVisible) ? control.defaultHandlerWidth : 0

        property real halfHeight: height / 2
        property real hoverHeight: height * 0.6
        property real noHoverHeight: height * 0.4
        property color colorBorder: enabled ? control.themeSource.colorBorder : control.themeSource.colorBorderDisabled
        property color colorHandlerBg: enabled ? control.themeSource.colorBg : 'transparent'

        Behavior on width {
            enabled: control.animationEnabled;
            NumberAnimation {
                easing.type: Easing.OutCubic
                duration: AntTheme.Primary.durationMid
            }
        }

        AntIconButton {
            id: __upButton
            width: parent.width
            height: hovered ? parent.hoverHeight :
                              __downButton.hovered ? parent.noHoverHeight : parent.halfHeight
            padding: 0
            enabled: control.enabled
            animationEnabled: control.animationEnabled
            autoRepeat: true
            colorIcon: control.enabled ?
                           hovered ? control.themeSource.colorBorderHover :
                                     control.themeSource.colorBorder : control.themeSource.colorBorderDisabled
            iconSize: parseInt(control.themeSource.fontSize) - 4
            iconSource: control.upIcon
            hoverCursorShape: control.value >= control.max ? Qt.ForbiddenCursor : Qt.PointingHandCursor
            background: AntRectangleInternal {
                topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.topRight : 0
                color: __handlerRoot.colorHandlerBg
                border.color: __handlerRoot.colorBorder
            }
            onClicked: {
                control.increase();
                control.valueModified();
            }

            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }
        }

        AntIconButton {
            id: __downButton
            width: parent.width
            height: (hovered ? parent.hoverHeight :
                               __upButton.hovered ? parent.noHoverHeight : parent.halfHeight) + 1
            anchors.top: __upButton.bottom
            anchors.topMargin: -1
            padding: 0
            enabled: control.enabled
            animationEnabled: control.animationEnabled
            autoRepeat: true
            colorIcon: control.enabled ?
                           hovered ? control.themeSource.colorBorderHover :
                                     control.themeSource.colorBorder : control.themeSource.colorBorderDisabled
            iconSize: parseInt(control.themeSource.fontSize) - 4
            iconSource: control.downIcon
            hoverCursorShape: control.value <= control.min ? Qt.ForbiddenCursor : Qt.PointingHandCursor
            background: AntRectangleInternal {
                bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.bottomRight : 0
                color: __handlerRoot.colorHandlerBg
                border.color: __handlerRoot.colorBorder
            }
            onClicked: {
                control.decrease();
                control.valueModified();
            }

            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }
        }
    }

    objectName: '__AntInputNumber__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    leftPadding: __beforeLoader.active ? (__beforeLoader.implicitWidth - 1) : 0
    rightPadding: __afterLoader.active ? (__afterLoader.implicitWidth - 1) : 0
    editable: true
    live: true
    min: -2147483648
    max: 2147483647
    validator: IntValidator {
        locale: (control && control.locale) ? control.locale.name : Qt.locale().name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize)
    }
    // valueFromText: parser
    // textFromValue: formatter
    contentItem: AntInput {
        id: __input
        enabled: control.enabled
        readOnly: !control.editable
        animationEnabled: control.animationEnabled
        leftPadding: (__prefixLoader.active ? __prefixLoader.implicitWidth : (leftClearIconPadding > 0 ? 5 : 10))
                     + leftIconPadding + leftClearIconPadding
        rightPadding: (__suffixLoader.active ? __suffixLoader.implicitWidth : (rightClearIconPadding > 0 ? 5 : 10))
                      + rightIconPadding + rightClearIconPadding
        text: control.displayText
        validator: control.validator
        inputMethodHints: control.inputMethodHints
        font: control.font
        background: AntRectangleInternal {
            color: __input.colorBg
            topLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.topLeft : 0
            topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.topRight : 0
            bottomLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.bottomLeft : 0
            bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.bottomRight : 0
        }
        clearLeftMargin: leftPadding + (!__handlerLoader.active ? 0 : __handlerLoader.width) + 10
        clearRightMargin: rightPadding + (!__handlerLoader.active ? 0 : __handlerLoader.width) + 10
        clearIconDelegate: AntIconText {
            iconSource: control.clearIconSource
            iconSize: control.clearIconSize
            leftPadding: control.clearIconPosition === AntInput.PositionLeft ? (control.leftIconPadding > 0 ? 5 : 10) * __input.sizeRatio : 0
            rightPadding: control.clearIconPosition === AntInput.PositionRight ?
                              ((control.rightIconPadding > 0 ? 5 : 30) * __input.sizeRatio + __handlerLoader.implicitWidth) : 0
            colorIcon: {
                if (control.enabled) {
                    return __tapHandler.pressed ? control.themeSource.colorClearIconActive :
                                                  __hoverHandler.hovered ? control.themeSource.colorClearIconHover :
                                                                           control.themeSource.colorClearIcon;
                } else {
                    return control.themeSource.colorClearIconDisabled;
                }
            }

            Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }

            HoverHandler {
                id: __hoverHandler
                enabled: (control.clearable === 'active' || control.clearable === true) && !control.readOnly
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                id: __tapHandler
                enabled: (control.clearable === 'active' || control.clearable === true) && !control.readOnly
                onTapped: {
                    control.clear();
                    control.valueModified();
                }
            }
        }
        onTextChanged: {
            Qt.callLater(() => {
                if (control && control.locale) {
                    const parsed = control.parser(text);
                    if (!isNaN(parsed) && parsed >= control.from && parsed <= control.to && parsed !== control.value) {
                        control.value = parsed;
                    }
                }
            });
        }
        onEditingFinished: control.valueChanged();

        property bool modified: false

        Keys.onUpPressed: {
            if (control.enabled && control.useKeyboard) {
                control.increase();
                control.valueModified();
            }
        }
        Keys.onDownPressed: {
            if (control.enabled && control.useKeyboard) {
                control.decrease();
                control.valueModified();
            }
        }

        WheelHandler {
            enabled: control.enabled && control.useWheel
            onWheel: function(wheel) {
                if (wheel.angleDelta.y > 0) {
                    control.increase();
                    control.valueModified();
                } else {
                    control.decrease();
                    control.valueModified();
                }
            }
        }

        Loader {
            id: __prefixLoader
            height: parent.height
            active: control.prefix != ''
            sourceComponent: AntText {
                leftPadding: 10
                rightPadding: 5
                text: control.prefix
                color: control.colorPrefix
                verticalAlignment: Text.AlignVCenter
            }
        }

        Loader {
            id: __suffixLoader
            height: parent.height
            anchors.right: __handlerLoader.left
            active: control.suffix != ''
            sourceComponent: AntText {
                leftPadding: 5
                rightPadding: 10
                text: control.suffix
                color: control.colorSuffix
                verticalAlignment: Text.AlignVCenter
            }
        }

        Loader {
            id: __handlerLoader
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            active: control.handlerVisible && !__input.readOnly
            sourceComponent: control.handlerDelegate
        }
    }

    onValueChanged: {
        Qt.callLater(() => {
            if (control) {
                __input.text = control.formatter(value, control.locale);
            }
        });
    }
    onPrefixChanged: valueChanged();
    onSuffixChanged: valueChanged();
    onCurrentAfterLabelChanged: valueChanged();
    onCurrentBeforeLabelChanged: valueChanged();

    Component.onCompleted: {
        __input.text = control.formatter(value, control.locale);
        valueChanged();
    }

    Loader {
        id: __beforeLoader
        height: parent.height
        anchors.left: parent.left
        active: control.beforeLabel?.length !== 0
        sourceComponent: control.beforeDelegate
    }

    Loader {
        id: __afterLoader
        height: parent.height
        anchors.right: parent.right
        active: control.afterLabel?.length !== 0
        sourceComponent: control.afterDelegate
    }

    AntRectangleInternal {
        anchors.fill: parent.contentItem
        color: 'transparent'
        border.color: __input.colorBorder
        topLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.topLeft : 0
        bottomLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.bottomLeft : 0
        topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.topRight : 0
        bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.bottomRight : 0
    }

    Component {
        id: __selectComp

        AntSelect {
            id: __afterText
            rightPadding: 4
            animationEnabled: control.animationEnabled
            colorText: isBefore ? control.colorBeforeLabel : control.colorAfterLabel
            colorBg: 'transparent'
            colorBorder: 'transparent'
            clearable: false
            model: isBefore ? control.beforeLabel : control.afterLabel
            currentIndex: isBefore ? control.initBeforeLabelIndex : control.initAfterLabelIndex
            onActivated:
                (index) => {
                    if (isBefore) {
                        control.beforeActivated(index, valueAt(index));
                    } else {
                        control.afterActivated(index, valueAt(index));
                    }
                }
            onCurrentTextChanged: {
                if (isBefore) {
                    control.currentBeforeLabel = currentText;
                } else {
                    control.currentAfterLabel = currentText;
                }
            }
        }
    }

    Component {
        id: __labelComp

        AntText {
            text: isBefore ? control.beforeLabel : control.afterLabel
            color: isBefore ? control.colorBeforeLabel : control.colorAfterLabel
            font: control.labelFont
            Component.onCompleted: {
                if (isBefore) {
                    control.currentBeforeLabel = control.beforeLabel;
                } else {
                    control.currentAfterLabel = control.afterLabel;
                }
            }
        }
    }

    function getFullText() {
        return __input.text;
    }

    function select(start: int, end: int) {
        __input.select(start, end);
    }

    function selectAll(start: int, end: int) {
        __input.selectAll(start, end);
    }

    function selectWord(start: int, end: int) {
        __input.selectWord(start, end);
    }

    function clear() {
        __input.clear();
        control.valueChanged();
    }

    function copy() {
        __input.copy();
    }

    function cut() {
        __input.cut();
        control.valueChanged();
    }

    function paste() {
        __input.paste();
        control.valueChanged();
    }

    function redo() {
        __input.redo();
        control.valueChanged();
    }

    function undo() {
        __input.undo();
        control.valueChanged();
    }
}
