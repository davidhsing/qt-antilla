import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

Item {
    id: control

    signal handleAdded(int index)
    signal handleDeleted(int index)
    signal handleMoved(int index, real value)
    signal handleReleased(int index, real value)

    enum SnapMode {
        SnapNone = 0,
        SnapAlways = 1,
        SnapOnRelease = 2
    }

    property bool animationEnabled: AntTheme.animationEnabled
    property int hoverCursorShape: Qt.PointingHandCursor
    property real min: 0
    property real max: 100
    property real stepSize: 1.0
    property var initialValue: 0
    property int handleCount: 0
    readonly property var value: {
        if (__private.handlesValues.length > 0) {
            return __private.handlesValues;
        }
        // For single/double handle modes, get values from the actual slider
        if (__sliderLoader.item) {
            if (__private.initialHandleCount === 2) {
                return [__sliderLoader.item.first.value, __sliderLoader.item.second.value];
            } else {
                return [__sliderLoader.item.value];
            }
        }
        return [0];
    }
    property bool editable: false
    property int minHandle: -1
    property int maxHandle: -1
    readonly property bool hovered: __sliderLoader.item ? __sliderLoader.item.hovered : (__multiHandleArea ? __multiHandleArea.containsMouse : false)
    property int snapMode: AntSlider.SnapOnRelease
    property int orientation: Qt.Horizontal
    property int fontMarkSize: control.themeSource.fontMarkSize
    property color colorBg: (enabled && hovered) ? control.themeSource.colorBgHover : control.themeSource.colorBg
    property color colorHandle: control.themeSource.colorHandle
    property color colorTrack: {
        if (!control.enabled) {
            return control.themeSource.colorTrackDisabled;
        }
        if (AntTheme.isDark) {
            return control.hovered ? control.themeSource.colorTrackHoverDark : control.themeSource.colorTrackDark;
        } else {
            return control.hovered ? control.themeSource.colorTrackHover : control.themeSource.colorTrack;
        }
    }
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }
    property bool handleToolTipEnabled: false
    property bool handleToolTipAlwaysVisible: false
    property int handleToolTipPosition: (control.orientation === Qt.Horizontal) ? AntToolTip.PositionTop : AntToolTip.PositionRight
    property bool markVisible: false
    property color colorMarkLine: control.themeSource.colorMarkLine
    property color colorMarkText: control.themeSource.colorMarkText
    property Component handleToolTipDelegate: AntToolTip {
        arrowVisible: true
        delay: 100
        text: handleValue.toFixed(0)
        position: control.handleToolTipPosition
        visible: control.handleToolTipAlwaysVisible || handlePressed || handleHovered
    }
    property Component handleDelegate: Rectangle {
        id: __handleItem
        x: __handleX
        y: __handleY
        implicitWidth: active ? 18 : 14
        implicitHeight: active ? 18 : 14
        radius: height / 2
        color: control.colorHandle
        border.color: {
            if (control.enabled) {
                if (AntTheme.isDark) {
                    return active || __selected ? control.themeSource.colorHandleBorderHoverDark : control.themeSource.colorHandleBorderDark;
                } else {
                    return active || __selected ? control.themeSource.colorHandleBorderHover : control.themeSource.colorHandleBorder;
                }
            } else {
                return control.themeSource.colorHandleBorderDisabled;
            }
        }
        border.width: active || __selected ? 4 : 2

        property bool down: pressed
        property bool active: __hoverHandler.hovered || down
        property bool __selected: false
        property int handleIndex: 0
        // __handleValue is set by the parent Loader in single/range slider modes
        // In multi-handle mode, it's bound directly in the Repeater item
        property real __handleValue: 0
        // visualPosition is passed directly from Loader in single/range slider modes
        // In multi-handle mode, calculate from __handleValue
        // visualPosition is passed directly from Loader in single/range slider modes
        // In multi-handle mode, calculate from __handleValue
        property real __visualPosition: visualPosition !== undefined ? visualPosition : ((__handleValue - control.min) / (control.max - control.min))
        property real __handleX: {
            if (control.orientation === Qt.Horizontal) {
                // For T.Slider, use width directly; for multi-handle, use availableWidth
                let availW = slider.availableWidth !== undefined ? slider.availableWidth : slider.width;
                let padL = slider.leftPadding !== undefined ? slider.leftPadding : 0;
                return padL + __visualPosition * (availW - width);
            }
            let availW = slider.availableWidth !== undefined ? slider.availableWidth : slider.width;
            let padT = slider.topPadding !== undefined ? slider.topPadding : 0;
            return padT + (availW - width) / 2;
        }
        property real __handleY: {
            if (control.orientation === Qt.Horizontal) {
                let availH = slider.availableHeight !== undefined ? slider.availableHeight : slider.height;
                let padT = slider.topPadding !== undefined ? slider.topPadding : 0;
                return padT + (availH - height) / 2;
            }
            let availH = slider.availableHeight !== undefined ? slider.availableHeight : slider.height;
            let padL = slider.leftPadding !== undefined ? slider.leftPadding : 0;
            return padL + __visualPosition * (availH - height);
        }

        Behavior on implicitWidth { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }
        Behavior on implicitHeight { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }
        Behavior on border.width { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }
        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
        Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

        HoverHandler {
            id: __hoverHandler
            cursorShape: control.hoverCursorShape
            // Only handle hover in multi-handle mode to avoid blocking T.Slider's drag
            enabled: __private.initialHandleCount > 2
        }

        TapHandler {
            id: __tapHandler
            enabled: __private.initialHandleCount > 2
            onTapped: {
                if (__private.initialHandleCount > 2) {
                    __private.selectHandle(handleIndex);
                }
            }
        }

        // Non-multi-handle mode: use MouseArea with acceptedButtons: Qt.NoButton to only track hover
        // without blocking T.Slider's built-in drag behavior
        MouseArea {
            id: __hoverArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            cursorShape: control.hoverCursorShape
            enabled: __private.initialHandleCount <= 2
            visible: enabled
        }

        Keys.onPressed: (event) => {
            if (control.editable && __private.initialHandleCount > 2 && __selected && (event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace)) {
                __private.deleteHandle(handleIndex);
                event.accepted = true;
            }
        }

        Loader {
            id: __toolTipLoader
            sourceComponent: handleToolTipDelegate
            active: control.handleToolTipEnabled
            visible: active
            onLoaded: item.parent = __handleItem;
            property bool handleHovered: __private.initialHandleCount > 2 ? __hoverHandler.hovered : __hoverArea.containsMouse
            property alias handlePressed: __handleItem.down
            property alias handleValue: __handleItem.__handleValue
            property int handleIndex: __handleItem.handleIndex
        }
    }
    property Component bgDelegate: Item {
        AntRectangleInternal {
            width: control.orientation === Qt.Horizontal ? parent.width : 4
            height: control.orientation === Qt.Horizontal ? 4 : parent.height
            anchors.horizontalCenter: control.orientation === Qt.Horizontal ? undefined : parent.horizontalCenter
            anchors.verticalCenter: control.orientation === Qt.Horizontal ? parent.verticalCenter : undefined
            color: control.colorBg
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

            Rectangle {
                x: __trackX
                y: __trackY
                width: __trackWidth
                height: __trackHeight
                color: colorTrack
                radius: parent.radius

                property real __trackX: {
                    if (control.orientation === Qt.Horizontal) {
                        return __private.minHandleIndex >= 0 ? (__private.getHandleVisualPosition(__private.minHandleIndex) * parent.width) : 0;
                    }
                    return 0;
                }
                property real __trackY: {
                    if (control.orientation === Qt.Horizontal) {
                        return 0;
                    }
                    return __private.maxHandleIndex >= 0 ? (__private.getHandleVisualPosition(__private.maxHandleIndex) * parent.height) : 0;
                }
                property real __trackWidth: {
                    if (control.orientation === Qt.Horizontal) {
                        if (__private.minHandleIndex >= 0 && __private.maxHandleIndex >= 0) {
                            return __private.getHandleVisualPosition(__private.maxHandleIndex) * parent.width - __trackX;
                        }
                        return __private.singleHandleVisualPosition * parent.width;
                    }
                    return parent.width;
                }
                property real __trackHeight: {
                    if (control.orientation === Qt.Horizontal) {
                        return parent.height;
                    }
                    if (__private.minHandleIndex >= 0 && __private.maxHandleIndex >= 0) {
                        return __private.getHandleVisualPosition(__private.minHandleIndex) * parent.height - __trackY;
                    }
                    return (1.0 - __private.singleHandleVisualPosition) * parent.height;
                }

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
            }
        }
    }
    property string ariaConstrual: ''
    property var themeSource: AntTheme.AntSlider

    objectName: '__AntSlider__'
    implicitWidth: (control.orientation === Qt.Horizontal) ? 400 : (control.markVisible ? 32 : 24)
    implicitHeight: (control.orientation === Qt.Horizontal) ? (control.markVisible ? 32 : 24) : 400

    // Force init when component is completed to ensure proper initialization
    Component.onCompleted: {
        if (__private.initialHandleCount > 2 && __private.handlesValues.length === 0) {
            __private.initHandles();
        }
    }

    // Multi-handle mode container
    Item {
        id: __multiHandleContainer
        anchors.fill: parent
        visible: control.editable || __private.initialHandleCount > 2

        Item {
            id: __sliderRoot
            anchors.fill: parent
            property real leftPadding: 0
            property real rightPadding: 0
            property real topPadding: 0
            property real bottomPadding: 0
            property real availableWidth: Math.max(0, width - leftPadding - rightPadding)
            property real availableHeight: Math.max(0, height - topPadding - bottomPadding)
        }

        // Background track
        Loader {
            sourceComponent: bgDelegate
            anchors.fill: parent
            property alias slider: __sliderRoot
        }

        // Marks display
        Item {
            anchors.fill: parent
            visible: control.markVisible

            Row {
                id: __marksHorizontal
                visible: control.orientation === Qt.Horizontal
                anchors.top: parent.top
                anchors.topMargin: 6
                anchors.left: parent.left
                anchors.leftMargin: __private.handleSize / 2 - 2
                anchors.right: parent.right
                anchors.rightMargin: __private.handleSize / 2 - 2
                height: 30
                spacing: (parent.width - __private.handleSize - ((__marksRepeater.count - 1) * 4)) / Math.max(1, __marksRepeater.count - 1)

                Repeater {
                    id: __marksRepeater
                    model: Math.round((control.max - control.min) / control.stepSize) + 1
                    delegate: Item {
                        width: 4
                        height: 6

                        Rectangle {
                            width: 4
                            height: 6
                            radius: 2
                            color: control.colorMarkLine
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        AntText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            anchors.topMargin: 10
                            text: control.stepSize * index + control.min
                            color: control.colorMarkText
                            font.pixelSize: control.fontMarkSize
                        }
                    }
                }
            }

            Column {
                id: __marksVertical
                visible: control.orientation === Qt.Vertical
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.top: parent.top
                anchors.topMargin: __private.handleSize / 2 - 2
                anchors.bottom: parent.bottom
                anchors.bottomMargin: __private.handleSize / 2 - 2
                width: 30
                spacing: (parent.height - __private.handleSize - ((__marksRepeaterVertical.count - 1) * 4)) / Math.max(1, __marksRepeaterVertical.count - 1)

                Repeater {
                    id: __marksRepeaterVertical
                    model: Math.round((control.max - control.min) / control.stepSize) + 1
                    delegate: Item {
                        width: 6
                        height: 4

                        Rectangle {
                            width: 6
                            height: 4
                            radius: 2
                            color: control.colorMarkLine
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        AntText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: control.max - (control.stepSize * index)
                            color: control.colorMarkText
                            font.pixelSize: control.fontMarkSize
                        }
                    }
                }
            }
        }

        // Click area to add new handle
        MouseArea {
            id: __multiHandleArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: (mouse) => {
                if (control.editable) {
                    let pos = control.orientation === Qt.Horizontal ?
                        (mouse.x - __sliderRoot.leftPadding) / __sliderRoot.availableWidth :
                        (mouse.y - __sliderRoot.topPadding) / __sliderRoot.availableHeight;
                    pos = Math.max(0, Math.min(1, pos));
                    let newValue = control.min + pos * (control.max - control.min);
                    __private.addHandle(newValue);
                }
            }
        }

        // Handles repeater
        Repeater {
            model: (control.editable || __private.initialHandleCount > 2) ? __private.handlesValues.length : 0

            Rectangle {
                id: __handleItemMulti
                x: __handleX
                y: __handleY
                implicitWidth: active ? 18 : 14
                implicitHeight: active ? 18 : 14
                radius: height / 2
                color: control.colorHandle
                border.color: {
                    if (control.enabled) {
                        if (AntTheme.isDark) {
                            return active || __selected ? control.themeSource.colorHandleBorderHoverDark : control.themeSource.colorHandleBorderDark;
                        } else {
                            return active || __selected ? control.themeSource.colorHandleBorderHover : control.themeSource.colorHandleBorder;
                        }
                    } else {
                        return control.themeSource.colorHandleBorderDisabled;
                    }
                }
                border.width: active || __selected ? 4 : 2

                property int handleIndex: index
                property bool down: __dragArea.pressed
                property bool active: __hoverHandler.hovered || down
                property bool __selected: __private.selectedIndex === index
                property real __handleValue: __private.handlesValues[index]
                property real __visualPosition: (__handleValue - control.min) / (control.max - control.min)
                property real __handleX: {
                    if (control.orientation === Qt.Horizontal) {
                        return __visualPosition * (__sliderRoot.availableWidth - width);
                    }
                    return (__sliderRoot.availableWidth - width) / 2;
                }
                property real __handleY: {
                    if (control.orientation === Qt.Horizontal) {
                        return (__sliderRoot.availableHeight - height) / 2;
                    }
                    return __visualPosition * (__sliderRoot.availableHeight - height);
                }

                Behavior on implicitWidth { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }
                Behavior on implicitHeight { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }
                Behavior on border.width { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }
                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
                Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

                HoverHandler {
                    id: __hoverHandler
                    cursorShape: control.hoverCursorShape
                }

                TapHandler {
                    onTapped: {
                        __private.selectHandle(handleIndex);
                        __handleItemMulti.forceActiveFocus();
                    }
                }

                MouseArea {
                    id: __dragArea
                    anchors.fill: parent
                    cursorShape: control.hoverCursorShape
                    property real pressValue: 0
                    onPressed: (mouse) => {
                        mouse.accepted = true;
                        __private.selectHandle(handleIndex);
                        __handleItemMulti.forceActiveFocus();
                        // Record the value at press time
                        pressValue = __private.handlesValues[handleIndex];
                    }
                    onReleased: (mouse) => {
                        mouse.accepted = true;
                        control.handleReleased(handleIndex, __private.handlesValues[handleIndex]);
                    }
                    onPositionChanged: (mouse) => {
                        mouse.accepted = true;
                        // Use mouse position relative to the slider root (not the handle)
                        let globalMouse = mapToGlobal(mouseX, mouseY);
                        let sliderLocal = __sliderRoot.mapFromGlobal(globalMouse.x, globalMouse.y);
                        let mousePos = control.orientation === Qt.Horizontal ? sliderLocal.x : sliderLocal.y;
                        let handleSize = control.orientation === Qt.Horizontal ? __handleItemMulti.width : __handleItemMulti.height;
                        let available = control.orientation === Qt.Horizontal ? __sliderRoot.availableWidth : __sliderRoot.availableHeight;
                        let padding = control.orientation === Qt.Horizontal ? __sliderRoot.leftPadding : __sliderRoot.topPadding;
                        // Mouse pos ranges from padding to padding + available, handle center should be able to reach min and max
                        let pos = (mousePos - padding - handleSize / 2) / (available - handleSize);
                        pos = Math.max(0, Math.min(1, pos));
                        let newValue = control.min + pos * (control.max - control.min);
                        __private.updateHandleValue(handleIndex, newValue);
                    }
                }

                Keys.onPressed: (event) => {
                    if (control.editable && __selected && (event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace)) {
                        __private.deleteHandle(handleIndex);
                        event.accepted = true;
                    }
                }

                focus: __selected
                activeFocusOnTab: true

                Loader {
                    sourceComponent: handleToolTipDelegate
                    active: control.handleToolTipEnabled
                    visible: active
                    onLoaded: item.parent = __handleItemMulti;
                    property alias handleHovered: __hoverHandler.hovered
                    property alias handlePressed: __handleItemMulti.down
                    property alias handleValue: __handleItemMulti.__handleValue
                    property int handleIndex: __handleItemMulti.handleIndex
                }
            }
        }
    }

    // Single/Double handle mode (non-editable)
    Component {
        id: __sliderComponent

        T.Slider {
            id: __control
            from: min
            to: max
            stepSize: control.stepSize
            orientation: control.orientation
            snapMode: {
                switch (control.snapMode) {
                    case AntSlider.SnapNone: return T.Slider.NoSnap;
                    case AntSlider.SnapAlways: return T.Slider.SnapAlways;
                    case AntSlider.SnapOnRelease: return T.Slider.SnapOnRelease;
                    default: return T.Slider.SnapNone;
                }
            }
            handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __control
                property alias visualPosition: __control.visualPosition
                property alias pressed: __control.pressed
                property int handleIndex: 0
                onLoaded: item.__handleValue = Qt.binding(function() { return __control.value; })
            }
            background: Loader {
                sourceComponent: bgDelegate
                property alias slider: __control
                property alias visualPosition: __control.visualPosition
            }

            // Marks display for single handle mode
            Item {
                anchors.fill: parent
                visible: control.markVisible

                Row {
                    id: __marksSliderHorizontal
                    visible: control.orientation === Qt.Horizontal
                    anchors.top: parent.top
                    anchors.topMargin: 6
                    anchors.left: parent.left
                    anchors.leftMargin: __private.handleSize / 2 - 2
                    anchors.right: parent.right
                    anchors.rightMargin: __private.handleSize / 2 - 2
                    height: 30
                    spacing: (parent.width - __private.handleSize - ((__marksSliderRepeater.count - 1) * 4)) / Math.max(1, __marksSliderRepeater.count - 1)

                    Repeater {
                        id: __marksSliderRepeater
                        model: Math.round((control.max - control.min) / control.stepSize) + 1
                        delegate: Item {
                            width: 4
                            height: 6

                            Rectangle {
                                width: 4
                                height: 6
                                radius: 2
                                color: control.colorMarkLine
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            AntText {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.bottom
                                anchors.topMargin: 10
                                text: control.stepSize * index + control.min
                                color: control.colorMarkText
                                font.pixelSize: control.fontMarkSize
                            }
                        }
                    }
                }

                Column {
                    id: __marksSliderVertical
                    visible: control.orientation === Qt.Vertical
                    anchors.left: parent.left
                    anchors.leftMargin: 6
                    anchors.top: parent.top
                    anchors.topMargin: __private.handleSize / 2 - 2
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: __private.handleSize / 2 - 2
                    width: 30
                    spacing: (parent.height - __private.handleSize - ((__marksSliderRepeaterVertical.count - 1) * 4)) / Math.max(1, __marksSliderRepeaterVertical.count - 1)

                    Repeater {
                        id: __marksSliderRepeaterVertical
                        model: Math.round((control.max - control.min) / control.stepSize) + 1
                        delegate: Item {
                            width: 6
                            height: 4

                            Rectangle {
                                width: 6
                                height: 4
                                radius: 2
                                color: control.colorMarkLine
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            AntText {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.right
                                anchors.leftMargin: 10
                                text: control.max - (control.stepSize * index)
                                color: control.colorMarkText
                                font.pixelSize: control.fontMarkSize
                            }
                        }
                    }
                }
            }
            onMoved: control.handleMoved(0, value);
            onPressedChanged: {
                if (!pressed) {
                    control.handleReleased(0, value);
                }
            }
        }
    }

    Component {
        id: __rangeSliderComponent

        T.RangeSlider {
            id: __control
            from: min
            to: max
            stepSize: control.stepSize
            snapMode: {
                switch (control.snapMode) {
                    case AntSlider.SnapNone: return T.RangeSlider.NoSnap;
                    case AntSlider.SnapAlways: return T.RangeSlider.SnapAlways;
                    case AntSlider.SnapOnRelease: return T.RangeSlider.SnapOnRelease;
                    default: return T.RangeSlider.NoSnap;
                }
            }
            orientation: control.orientation
            first.handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __control
                property alias visualPosition: __control.first.visualPosition
                property alias pressed: __control.first.pressed
                property int handleIndex: 0
                onLoaded: item.__handleValue = Qt.binding(function() { return __control.first.value; })
            }
            first.onMoved: control.handleMoved(0, first.value);
            first.onPressedChanged: {
                if (!first.pressed) {
                    control.handleReleased(0, first.value);
                }
            }
            second.handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __control
                property alias visualPosition: __control.second.visualPosition
                property alias pressed: __control.second.pressed
                property int handleIndex: 1
                onLoaded: item.__handleValue = Qt.binding(function() { return __control.second.value; })
            }
            second.onMoved: control.handleMoved(1, second.value);
            second.onPressedChanged: {
                if (!second.pressed) {
                    control.handleReleased(1, second.value);
                }
            }
            background: Loader {
                sourceComponent: bgDelegate
                property alias slider: __control
            }

            // Marks display for double handle mode
            Item {
                anchors.fill: parent
                visible: control.markVisible

                Row {
                    id: __marksRangeHorizontal
                    visible: control.orientation === Qt.Horizontal
                    anchors.top: parent.top
                    anchors.topMargin: 6
                    anchors.left: parent.left
                    anchors.leftMargin: __private.handleSize / 2 - 2
                    anchors.right: parent.right
                    anchors.rightMargin: __private.handleSize / 2 - 2
                    height: 30
                    spacing: (parent.width - __private.handleSize - ((__marksRangeRepeater.count - 1) * 4)) / Math.max(1, __marksRangeRepeater.count - 1)

                    Repeater {
                        id: __marksRangeRepeater
                        model: Math.round((control.max - control.min) / control.stepSize) + 1
                        delegate: Item {
                            width: 4
                            height: 6

                            Rectangle {
                                width: 4
                                height: 6
                                radius: 2
                                color: control.colorMarkLine
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            AntText {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.bottom
                                anchors.topMargin: 10
                                text: control.stepSize * index + control.min
                                color: control.colorMarkText
                                font.pixelSize: control.fontMarkSize
                            }
                        }
                    }
                }

                Column {
                    id: __marksRangeVertical
                    visible: control.orientation === Qt.Vertical
                    anchors.left: parent.left
                    anchors.leftMargin: 6
                    anchors.top: parent.top
                    anchors.topMargin: __private.handleSize / 2 - 2
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: __private.handleSize / 2 - 2
                    width: 30
                    spacing: (parent.height - __private.handleSize - ((__marksRangeRepeaterVertical.count - 1) * 4)) / Math.max(1, __marksRangeRepeaterVertical.count - 1)

                    Repeater {
                        id: __marksRangeRepeaterVertical
                        model: Math.round((control.max - control.min) / control.stepSize) + 1
                        delegate: Item {
                            width: 6
                            height: 4

                            Rectangle {
                                width: 6
                                height: 4
                                radius: 2
                                color: control.colorMarkLine
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            AntText {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.right
                                anchors.leftMargin: 10
                                text: control.max - (control.stepSize * index)
                                color: control.colorMarkText
                                font.pixelSize: control.fontMarkSize
                            }
                        }
                    }
                }
            }
        }
    }

    Loader {
        id: __sliderLoader
        anchors.fill: parent
        sourceComponent: (__private.initialHandleCount === 2) ? __rangeSliderComponent : __sliderComponent
        active: __private.initialHandleCount <= 2 && !control.editable
        visible: active
        onLoaded: __private.fromValueUpdate();
    }

    Accessible.role: Accessible.Slider
    Accessible.name: control.ariaConstrual
    Accessible.description: control.ariaConstrual
    Accessible.onIncreaseAction: control.increase();
    Accessible.onDecreaseAction: control.decrease();

    onInitialValueChanged: __private.fromValueUpdate();

    function decrease(index = 0) {
        if (__private.initialHandleCount > 2) {
            if (index >= 0 && index < __private.handlesValues.length) {
                let newValue = Math.max(control.min, __private.handlesValues[index] - (control.stepSize > 0 ? control.stepSize : 1));
                __private.updateHandleValue(index, newValue);
                control.handleMoved(index, newValue);
            }
        } else {
            if (__sliderLoader.item) {
                if (__private.initialHandleCount === 2) {
                    if (index === 0) {
                        __sliderLoader.item.first.decrease();
                    } else {
                        __sliderLoader.item.second.decrease();
                    }
                } else {
                    __sliderLoader.item.decrease();
                }
            }
        }
    }

    function increase(index = 0) {
        if (__private.initialHandleCount > 2) {
            if (index >= 0 && index < __private.handlesValues.length) {
                let newValue = Math.min(control.max, __private.handlesValues[index] + (control.stepSize > 0 ? control.stepSize : 1));
                __private.updateHandleValue(index, newValue);
                control.handleMoved(index, newValue);
            }
        } else {
            if (__sliderLoader.item) {
                if (__private.initialHandleCount === 2) {
                    if (index === 0) {
                        __sliderLoader.item.first.increase();
                    } else {
                        __sliderLoader.item.second.increase();
                    }
                } else {
                    __sliderLoader.item.increase();
                }
            }
        }
    }

    QtObject {
        id: __private

        property list<real> handlesValues: []
        property int selectedIndex: -1
        property int minHandleIndex: -1
        property int maxHandleIndex: -1
        property real singleHandleVisualPosition: 0
        // 0: single handle, 2: double handle (RangeSlider), >2: multi-handle
        property int initialHandleCount: Array.isArray(control.initialValue) ? control.initialValue.length : 1
        // Create a temporary handle to get its size for mark calculations
        property Item tempHandle: Loader {
            sourceComponent: control.handleDelegate
            active: false
        }
        property real handleSize: tempHandle.item ? tempHandle.item.implicitWidth : 14

        function initHandles() {
            if (Array.isArray(control.initialValue) && control.initialValue.length > 0) {
                // Create a new array from initialValue, filtering out invalid values
                let newValues = [];
                for (let i = 0; i < control.initialValue.length; i++) {
                    let val = control.initialValue[i];
                    // Only add valid numbers
                    if (val !== undefined && val !== null && !isNaN(Number(val))) {
                        newValues.push(Number(val));
                    }
                }
                // If no valid values, use default
                if (newValues.length === 0) {
                    newValues = [control.min];
                }
                newValues.sort(function(a, b) { return a - b; });
                __private.handlesValues = newValues;
            } else {
                // Handle non-array or empty array case
                let val = Array.isArray(control.initialValue) ? control.initialValue[0] : control.initialValue;
                if (val === undefined || val === null || isNaN(Number(val))) {
                    val = control.min;
                }
                __private.handlesValues = [Number(val)];
            }
            control.handleCount = __private.handlesValues.length;
            updateMinMaxIndices();
        }

        function fromValueUpdate() {
            if (__private.initialHandleCount > 2) {
                initHandles();
            } else {
                if (__sliderLoader.item) {
                    if (__private.initialHandleCount === 2) {
                        if (Array.isArray(control.initialValue) && control.initialValue.length >= 2) {
                            let val1 = control.initialValue[0];
                            let val2 = control.initialValue[1];
                            // Validate values
                            if (val1 === undefined || val1 === null || isNaN(Number(val1))) {
                                val1 = control.min;
                            }
                            if (val2 === undefined || val2 === null || isNaN(Number(val2))) {
                                val2 = control.min;
                            }
                            __sliderLoader.item.setValues(Number(val1), Number(val2));
                        }
                    } else {
                        // Single handle mode
                        let val = Array.isArray(control.initialValue) && control.initialValue.length > 0  ? control.initialValue[0] : control.initialValue;
                        // Validate value
                        if (val === undefined || val === null || isNaN(Number(val))) {
                            val = control.min;
                        }
                        __sliderLoader.item.value = Number(val);
                    }
                }
            }
        }

        function addHandle(value) {
            if (control.maxHandle > 0 && __private.handlesValues.length >= control.maxHandle) {
                return;
            }
            value = Math.max(control.min, Math.min(control.max, value));
            // Apply snap if snapMode is not SnapNone
            if (control.snapMode !== AntSlider.SnapNone && control.stepSize > 0) {
                let steps = Math.round((value - control.min) / control.stepSize);
                let snappedValue = control.min + steps * control.stepSize;
                // Check if there's an existing handle at the snapped position
                let existingIndex = __private.handlesValues.findIndex(v => Math.abs(v - snappedValue) < 0.0001);
                if (existingIndex !== -1) {
                    // There's already a handle at this position
                    // Try to snap to the next available position
                    if (steps > 0) {
                        // Try to snap to previous step
                        let prevValue = snappedValue - control.stepSize;
                        if (prevValue >= control.min && prevValue < value) {
                            snappedValue = prevValue;
                        } else {
                            // Try to snap to next step
                            let nextValue = snappedValue + control.stepSize;
                            if (nextValue <= control.max && nextValue > value) {
                                snappedValue = nextValue;
                            }
                        }
                    } else {
                        // At the minimum, try to go to next step
                        let nextValue = snappedValue + control.stepSize;
                        if (nextValue <= control.max) {
                            snappedValue = nextValue;
                        }
                    }
                    // Re-check if the new snapped position is still occupied
                    existingIndex = __private.handlesValues.findIndex(v => Math.abs(v - snappedValue) < 0.0001);
                    if (existingIndex !== -1) {
                        // Still occupied, don't add
                        return;
                    }
                }
                value = snappedValue;
            }
            // Find insertion position to keep sorted
            let insertIndex = __private.handlesValues.findIndex(v => v > value);
            if (insertIndex === -1) {
                insertIndex = __private.handlesValues.length;
            }
            // Check minimum gap constraint (1% of range)
            let minGap = (control.max - control.min) * 0.01;
            if (insertIndex > 0 && value < __private.handlesValues[insertIndex - 1] + minGap) {
                value = __private.handlesValues[insertIndex - 1] + minGap;
            }
            if (insertIndex < __private.handlesValues.length && value > __private.handlesValues[insertIndex] - minGap) {
                value = __private.handlesValues[insertIndex] - minGap;
            }
            // Check if still valid after gap adjustment
            if (value < control.min || value > control.max) {
                return;
            }
            let newArr = __private.handlesValues.slice();
            newArr.splice(insertIndex, 0, value);
            __private.handlesValues = newArr;
            control.handleCount = __private.handlesValues.length;
            updateMinMaxIndices();
            control.handleAdded(insertIndex);
            selectHandle(insertIndex);
        }

        function deleteHandle(index) {
            if (index < 0 || index >= __private.handlesValues.length) {
                return;
            }
            if (control.minHandle > 0 && __private.handlesValues.length <= control.minHandle) {
                return;
            }
            let newArr = __private.handlesValues.slice();
            newArr.splice(index, 1);
            __private.handlesValues = newArr;
            control.handleCount = __private.handlesValues.length;
            if (__private.selectedIndex === index) {
                __private.selectedIndex = -1;
            } else if (__private.selectedIndex > index) {
                __private.selectedIndex--;
            }
            updateMinMaxIndices();
            control.handleDeleted(index);
        }

        function updateHandleValue(index, newValue) {
            if (index < 0 || index >= __private.handlesValues.length) {
                return;
            }
            newValue = Math.max(control.min, Math.min(control.max, newValue));
            // Apply step size if set
            if (control.stepSize > 0) {
                let steps = Math.round((newValue - control.min) / control.stepSize);
                newValue = control.min + steps * control.stepSize;
                newValue = Math.max(control.min, Math.min(control.max, newValue));
            }
            // Enforce boundary constraints with adjacent handles
            // Add minimum gap (1% of range) to prevent complete overlap
            let minGap = (control.max - control.min) * 0.01;
            if (index > 0) {
                // Cannot go below the left (previous) handle + min gap
                newValue = Math.max(newValue, __private.handlesValues[index - 1] + minGap);
            }
            if (index < __private.handlesValues.length - 1) {
                // Cannot go above the right (next) handle - min gap
                newValue = Math.min(newValue, __private.handlesValues[index + 1] - minGap);
            }
            let newArr = __private.handlesValues.slice();
            newArr[index] = newValue;
            __private.handlesValues = newArr;
            updateMinMaxIndices();
            control.handleMoved(index, newValue);
        }

        function selectHandle(index) {
            if (index >= 0 && index < __private.handlesValues.length) {
                __private.selectedIndex = index;
            }
        }

        function updateMinMaxIndices() {
            if (handlesValues.length === 0) {
                __private.minHandleIndex = -1;
                __private.maxHandleIndex = -1;
                __private.singleHandleVisualPosition = 0;
            } else if (handlesValues.length === 1) {
                __private.minHandleIndex = 0;
                __private.maxHandleIndex = 0;
                __private.singleHandleVisualPosition = getHandleVisualPosition(0);
            } else {
                __private.minHandleIndex = 0;
                __private.maxHandleIndex = __private.handlesValues.length - 1;
                __private.singleHandleVisualPosition = getHandleVisualPosition(0);
            }
        }

        function getHandleVisualPosition(index) {
            if (index < 0 || index >= __private.handlesValues.length) {
                return 0;
            }
            return (handlesValues[index] - control.min) / (control.max - control.min);
        }

        Component.onCompleted: {
            if (__private.initialHandleCount > 2 && __private.handlesValues.length === 0) {
                initHandles();
            }
        }
    }
}
