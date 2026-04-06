import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

Item {
    id: control

    signal firstMoved()
    signal firstReleased()
    signal secondMoved()
    signal secondReleased()

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
    property var value: range ? [0, 0] : 0
    readonly property var currentValue: {
        if (__sliderLoader.item) {
            return range ? [__sliderLoader.item.first.value, __sliderLoader.item.second.value] : __sliderLoader.item.value;
        }
        return value;
    }
    property bool range: false
    readonly property bool hovered: __sliderLoader.item ? __sliderLoader.item.hovered : false
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
        x: {
            if (control.orientation === Qt.Horizontal) {
                return slider.leftPadding + visualPosition * (slider.availableWidth - width);
            }
            return slider.topPadding + (slider.availableWidth - width) / 2;
        }
        y: {
            if (control.orientation === Qt.Horizontal) {
                return slider.topPadding + (slider.availableHeight - height) / 2;
            }
            return slider.leftPadding + visualPosition * (slider.availableHeight - height);
        }
        implicitWidth: active ? 18 : 14
        implicitHeight: active ? 18 : 14
        radius: height / 2
        color: control.colorHandle
        border.color: {
            if (control.enabled) {
                if (AntTheme.isDark) {
                    return active ? AntTheme.AntSlider.colorHandleBorderHoverDark : AntTheme.AntSlider.colorHandleBorderDark;
                } else {
                    return active ? AntTheme.AntSlider.colorHandleBorderHover : AntTheme.AntSlider.colorHandleBorder;
                }
            } else {
                return AntTheme.AntSlider.colorHandleBorderDisabled;
            }
        }
        border.width: active ? 4 : 2

        property bool down: pressed
        property bool active: __hoverHandler.hovered || down

        Behavior on implicitWidth { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }
        Behavior on implicitHeight { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }
        Behavior on border.width { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }
        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
        Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

        HoverHandler {
            id: __hoverHandler
            cursorShape: control.hoverCursorShape
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
                x: {
                    if (control.orientation === Qt.Horizontal) {
                        return range ? (slider.first.visualPosition * parent.width) : 0;
                    }
                    return 0;
                }
                y: {
                    if (control.orientation === Qt.Horizontal) {
                        return 0;
                    }
                    return range ? (slider.second.visualPosition * parent.height) : slider.visualPosition * parent.height;
                }
                width: {
                    if (control.orientation === Qt.Horizontal) {
                        return range ? (slider.second.visualPosition * parent.width - x) : slider.visualPosition * parent.width;
                    }
                    return parent.width;
                }
                height: {
                    if (control.orientation === Qt.Horizontal) {
                        return parent.height;
                    }
                    return range ? (slider.first.visualPosition * parent.height - y) : ((1.0 - slider.visualPosition) * parent.height);
                }
                color: colorTrack
                radius: parent.radius

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
            }
        }
    }
    property string ariaConstrual: ''

    objectName: '__AntSlider__'
    onValueChanged: __private.fromValueUpdate();

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
            }
            background: Loader {
                sourceComponent: bgDelegate
                property alias slider: __control
                property alias visualPosition: __control.visualPosition
            }
            onMoved: control.firstMoved();
            onPressedChanged: {
                if (!pressed) {
                    control.firstReleased();
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
            }
            first.onMoved: control.firstMoved();
            first.onPressedChanged: {
                if (!first.pressed) {
                    control.firstReleased();
                }
            }
            second.handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __control
                property alias visualPosition: __control.second.visualPosition
                property alias pressed: __control.second.pressed
            }
            second.onMoved: control.secondMoved();
            second.onPressedChanged: {
                if (!second.pressed) {
                    control.secondReleased();
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
        sourceComponent: control.range ? __rangeSliderComponent : __sliderComponent
        onLoaded: __private.fromValueUpdate();
    }

    Accessible.role: Accessible.Slider
    Accessible.name: control.ariaConstrual
    Accessible.description: control.ariaConstrual
    Accessible.onIncreaseAction: increase();
    Accessible.onDecreaseAction: decrease();

    function decrease(first = true) {
        if (__sliderLoader.item) {
            if (range) {
                if (first) {
                    __sliderLoader.item.first.decrease();
                } else {
                    __sliderLoader.item.second.decrease();
                }
            } else {
                __sliderLoader.item.decrease();
            }
        }
    }

    function increase(first = true) {
        if (range) {
            if (first) {
                __sliderLoader.item.first.increase();
            } else {
                __sliderLoader.item.second.increase();
            }
        } else {
            __sliderLoader.item.decrease();
        }
    }

    QtObject {
        id: __private

        function fromValueUpdate() {
            if (__sliderLoader.item) {
                if (range) {
                    __sliderLoader.item.setValues(...value);
                } else {
                    __sliderLoader.item.value = value;
                }
            }
        }
    }
}
