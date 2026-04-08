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
    property real stepSize: 0.0
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
    property int snapMode: AntSlider.SnapNone
    property int orientation: Qt.Horizontal
    property color colorBg: (enabled && hovered) ? AntTheme.AntSlider.colorBgHover : AntTheme.AntSlider.colorBg
    property color colorHandle: AntTheme.AntSlider.colorHandle
    property color colorTrack: {
        if (!enabled) {
            return AntTheme.AntSlider.colorTrackDisabled;
        }
        if (AntTheme.isDark) {
            return hovered ? AntTheme.AntSlider.colorTrackHoverDark : AntTheme.AntSlider.colorTrackDark;
        } else {
            return hovered ? AntTheme.AntSlider.colorTrackHover : AntTheme.AntSlider.colorTrack;
        }
    }
    property AntRadius radiusBg: AntRadius { all: AntTheme.AntSlider.radiusBg }
    property Component handleToolTipDelegate: Item { }
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
                    return active || __selected ? AntTheme.AntSlider.colorHandleBorderHoverDark : AntTheme.AntSlider.colorHandleBorderDark;
                } else {
                    return active || __selected ? AntTheme.AntSlider.colorHandleBorderHover : AntTheme.AntSlider.colorHandleBorder;
                }
            } else {
                return AntTheme.AntSlider.colorHandleBorderDisabled;
            }
        }
        border.width: active || __selected ? 4 : 2

        property bool down: pressed
        property bool active: __hoverHandler.hovered || down
        property bool __selected: false
        property real __handleValue: 0
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
            visible: !(__private.initialHandleCount > 2)
            enabled: !(__private.initialHandleCount > 2)
        }

        Keys.onPressed: (event) => {
            if (control.editable && __private.initialHandleCount > 2 && __selected && (event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace)) {
                __private.deleteHandle(handleIndex);
                event.accepted = true;
            }
        }

        Loader {
            sourceComponent: handleToolTipDelegate
            onLoaded: item.parent = __handleItem;
            property alias handleHovered: __hoverHandler.hovered
            property alias handlePressed: __handleItem.down
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

    objectName: '__AntSlider__'
    onInitialValueChanged: __private.fromValueUpdate();
    // Force init when component is completed to ensure proper initialization
    Component.onCompleted: {
        console.log("control Component.onCompleted, initialHandleCount:", __private.initialHandleCount, "initialValue:", JSON.stringify(initialValue));
        if (__private.initialHandleCount > 2 && __private.handlesValues.length === 0) {
            __private.initHandles();
        }
    }

    // Multi-handle mode container
    Item {
        id: __multiHandleContainer
        anchors.fill: parent
        visible: __private.initialHandleCount > 2

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
            model: __private.initialHandleCount > 2 ? __private.handlesValues.length : 0

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
                            return active || __selected ? AntTheme.AntSlider.colorHandleBorderHoverDark : AntTheme.AntSlider.colorHandleBorderDark;
                        } else {
                            return active || __selected ? AntTheme.AntSlider.colorHandleBorderHover : AntTheme.AntSlider.colorHandleBorder;
                        }
                    } else {
                        return AntTheme.AntSlider.colorHandleBorderDisabled;
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
                    onPressed: {
                        __private.selectHandle(handleIndex);
                        __handleItemMulti.forceActiveFocus();
                        // Record the value at press time
                        pressValue = __private.handlesValues[handleIndex];
                    }
                    onReleased: {
                        control.handleReleased(handleIndex, __private.handlesValues[handleIndex]);
                    }
                    onPositionChanged: {
                        // Use mouse position relative to the slider root (not the handle)
                        // Map global mouse pos to slider coordinate
                        let globalMouse = mapToGlobal(mouseX, mouseY);
                        let sliderLocal = __sliderRoot.mapFromGlobal(globalMouse.x, globalMouse.y);
                        let mousePos = control.orientation === Qt.Horizontal ? sliderLocal.x : sliderLocal.y;
                        let handleSize = control.orientation === Qt.Horizontal ? __handleItemMulti.width : __handleItemMulti.height;
                        let available = control.orientation === Qt.Horizontal ? __sliderRoot.availableWidth : __sliderRoot.availableHeight;
                        let padding = control.orientation === Qt.Horizontal ? __sliderRoot.leftPadding : __sliderRoot.topPadding;
                        // Map position so handle can reach full range (0 to 1)
                        // mousePos ranges from padding to padding + available
                        // handle center should be able to reach min and max
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
                    onLoaded: item.parent = __handleItemMulti;
                    property alias handleHovered: __hoverHandler.hovered
                    property alias handlePressed: __handleItemMulti.down
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
            }
            background: Loader {
                sourceComponent: bgDelegate
                property alias slider: __control
                property alias visualPosition: __control.visualPosition
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
        }
    }

    Loader {
        id: __sliderLoader
        anchors.fill: parent
        visible: !(__private.initialHandleCount > 2)
        sourceComponent: __private.initialHandleCount === 2 ? __rangeSliderComponent : __sliderComponent
        onLoaded: __private.fromValueUpdate();
    }

    Accessible.role: Accessible.Slider
    Accessible.name: control.ariaConstrual
    Accessible.description: control.ariaConstrual
    Accessible.onIncreaseAction: increase();
    Accessible.onDecreaseAction: decrease();

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

        function initHandles() {
            console.log("initHandles called, initialValue:", JSON.stringify(control.initialValue));
            if (Array.isArray(control.initialValue)) {
                // Create a new array from initialValue
                var newValues = [];
                for (var i = 0; i < control.initialValue.length; i++) {
                    newValues.push(control.initialValue[i]);
                }
                newValues.sort(function(a, b) { return a - b; });
                handlesValues = newValues;
            } else {
                handlesValues = [control.initialValue];
            }
            control.handleCount = handlesValues.length;
            console.log("initHandles set handlesValues to:", JSON.stringify(handlesValues), "length:", handlesValues.length, "handleCount:", control.handleCount);
            updateMinMaxIndices();
        }

        function fromValueUpdate() {
            if (initialHandleCount > 2) {
                initHandles();
            } else {
                if (__sliderLoader.item) {
                    if (initialHandleCount === 2) {
                        if (Array.isArray(control.initialValue) && control.initialValue.length >= 2) {
                            __sliderLoader.item.setValues(control.initialValue[0], control.initialValue[1]);
                        }
                    } else {
                        __sliderLoader.item.value = Array.isArray(control.initialValue) ? control.initialValue[0] : control.initialValue;
                    }
                }
            }
        }

        function addHandle(value) {
            if (control.maxHandle > 0 && handlesValues.length >= control.maxHandle) {
                return;
            }
            value = Math.max(control.min, Math.min(control.max, value));
            // Find insertion position to keep sorted
            let insertIndex = handlesValues.findIndex(v => v > value);
            if (insertIndex === -1) {
                insertIndex = handlesValues.length;
            }
            let newArr = handlesValues.slice();
            newArr.splice(insertIndex, 0, value);
            handlesValues = newArr;
            control.handleCount = handlesValues.length;
            updateMinMaxIndices();
            control.handleAdded(insertIndex);
            selectHandle(insertIndex);
        }

        function deleteHandle(index) {
            if (index < 0 || index >= handlesValues.length) {
                return;
            }
            if (control.minHandle > 0 && handlesValues.length <= control.minHandle) {
                return;
            }
            let newArr = handlesValues.slice();
            newArr.splice(index, 1);
            handlesValues = newArr;
            control.handleCount = handlesValues.length;
            if (selectedIndex === index) {
                selectedIndex = -1;
            } else if (selectedIndex > index) {
                selectedIndex--;
            }
            updateMinMaxIndices();
            control.handleDeleted(index);
        }

        function updateHandleValue(index, newValue) {
            if (index < 0 || index >= handlesValues.length) {
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
                newValue = Math.max(newValue, handlesValues[index - 1] + minGap);
            }
            if (index < handlesValues.length - 1) {
                // Cannot go above the right (next) handle - min gap
                newValue = Math.min(newValue, handlesValues[index + 1] - minGap);
            }
            let newArr = handlesValues.slice();
            newArr[index] = newValue;
            handlesValues = newArr;
            updateMinMaxIndices();
            control.handleMoved(index, newValue);
        }

        function selectHandle(index) {
            if (index >= 0 && index < handlesValues.length) {
                selectedIndex = index;
            }
        }

        function updateMinMaxIndices() {
            if (handlesValues.length === 0) {
                minHandleIndex = -1;
                maxHandleIndex = -1;
                singleHandleVisualPosition = 0;
            } else if (handlesValues.length === 1) {
                minHandleIndex = 0;
                maxHandleIndex = 0;
                singleHandleVisualPosition = getHandleVisualPosition(0);
            } else {
                minHandleIndex = 0;
                maxHandleIndex = handlesValues.length - 1;
                singleHandleVisualPosition = getHandleVisualPosition(0);
            }
        }

        function getHandleVisualPosition(index) {
            if (index < 0 || index >= handlesValues.length) {
                return 0;
            }
            return (handlesValues[index] - control.min) / (control.max - control.min);
        }

        Component.onCompleted: {
            console.log("__private Component.onCompleted, initialHandleCount:", initialHandleCount, "initialValue:", JSON.stringify(control.initialValue));
            if (initialHandleCount > 2 && handlesValues.length === 0) {
                initHandles();
            }
        }
    }
}
