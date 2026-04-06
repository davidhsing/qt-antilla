import QtQuick
import Antilla.Basic

Item {
    id: control

    enum ScrollDirection {
        DirectionVertical = 0,
        DirectionHorizontal = 1
    }

    enum IndicatorPosition {
        PositionTop = 0,
        PositionBottom = 1,
        PositionLeft = 2,
        PositionRight = 3
    }

    property bool animationEnabled: AntTheme.animationEnabled
    property var initModel: []
    property int currentIndex: -1
    property int direction: AntCarousel.DirectionHorizontal
    property int speed: 500
    property bool infinite: true
    property bool autoplay: false
    property int autoplaySpeed: 3000
    property bool draggable: true
    property bool indicatorVisible: true
    property int indicatorPosition: AntCarousel.PositionBottom
    property int indicatorSpacing: 6
    property bool arrowVisible: false
    property AntRadius radiusIndicator: AntRadius { all: AntTheme.AntCarousel.radiusIndicator }
    property Component contentDelegate: Item { }
    property Component indicatorDelegate: AntRectangleInternal {
        width: isHorizontal ? __width : __height
        height: isHorizontal ? __height : __width
        color: isCurrent ? AntTheme.AntCarousel.colorIndicatorActive : (hovered ? AntTheme.AntCarousel.colorIndicatorHover : AntTheme.AntCarousel.colorIndicator)
        radius: control.radiusIndicator.all
        topLeftRadius: control.radiusIndicator.topLeft
        topRightRadius: control.radiusIndicator.topRight
        bottomLeftRadius: control.radiusIndicator.bottomLeft
        bottomRightRadius: control.radiusIndicator.bottomRight

        required property int index
        required property var model
        property bool isHorizontal: control.indicatorPosition === AntCarousel.PositionTop || control.indicatorPosition === AntCarousel.PositionBottom
        property bool isCurrent: index === control.currentIndex
        property bool hovered: __hoverHandler.hovered

        property int __width: isCurrent ? __private.indicatorWidth + 10 : __private.indicatorWidth
        property int __height: 4

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
        Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }

        HoverHandler {
            id: __hoverHandler
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            onTapped: {
                control.switchTo(index);
            }
        }
    }
    property Component prevDelegate: AntIconButton {
        padding: 5
        animationEnabled: control.animationEnabled
        iconSource: __private.isHorizontal ? AntIcon.LeftOutlined : AntIcon.UpOutlined
        iconSize: 20
        colorIcon: hovered ? AntTheme.AntCarousel.colorArrowHover : AntTheme.AntCarousel.colorArrow
        type: AntButton.TypeLink
        onClicked: control.switchToPrev();
    }
    property Component nextDelegate: AntIconButton {
        padding: 5
        animationEnabled: control.animationEnabled
        iconSource: __private.isHorizontal ? AntIcon.RightOutlined : AntIcon.DownOutlined
        iconSize: 20
        colorIcon: hovered ? AntTheme.AntCarousel.colorArrowHover : AntTheme.AntCarousel.colorArrow
        type: AntButton.TypeLink
        onClicked: control.switchToNext();
    }

    objectName: '__AntCarousel__'
    onInfiniteChanged: __private.updateModel();
    onInitModelChanged: __private.updateModel();

    Timer {
        id: __resetTimer
        interval: 33
        onTriggered: {
            __listView.positionViewAtIndex(control.infinite ? 1 : 0, ListView.SnapPosition);
        }
    }

    Timer {
        id: __autoplayTimer
        repeat: true
        interval: control.autoplaySpeed
        running: control.autoplay
        onTriggered: {
            control.switchToNext();
        }
    }

    ListView {
        id: __listView
        anchors.fill: parent
        clip: true
        interactive: control.draggable
        orientation: __private.isHorizontal ? Qt.Horizontal : Qt.Vertical
        snapMode: ListView.SnapOneItem
        highlightMoveDuration: control.speed
        highlightRangeMode: ListView.StrictlyEnforceRange
        boundsBehavior: ListView.StopAtBounds
        model: ListModel { id: __listModel }
        delegate: Item {
            id: __rootItem
            width: __listView.width
            height: __listView.height

            required property var model
            required property int index

            Loader {
                anchors.fill: parent
                sourceComponent: control.contentDelegate
                property alias model: __rootItem.model
                property int index: __private.getRealModelIndex(__rootItem.index)
            }
        }
        onCurrentIndexChanged: {
            control.currentIndex = __private.getRealModelIndex(currentIndex);
        }
        onOrientationChanged: {
            positionViewAtIndex(control.infinite ? 1 : 0, ListView.SnapPosition);
        }
        onFlickStarted: __private.updateInfiniteIndex();
        onDragStarted: __private.updateInfiniteIndex();
        onMovementEnded: __private.updateInfiniteIndex();

        Loader {
            active: control.indicatorPosition === AntCarousel.PositionTop && control.indicatorVisible
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:  parent.top
            anchors.topMargin: 10
            sourceComponent: Row {
                spacing: control.indicatorSpacing
                Repeater {
                    model: control.initModel
                    delegate: control.indicatorDelegate
                }
            }
        }

        Loader {
            active: control.indicatorPosition === AntCarousel.PositionBottom && control.indicatorVisible
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            sourceComponent: Row {
                spacing: control.indicatorSpacing
                Repeater {
                    model: control.initModel
                    delegate: control.indicatorDelegate
                }
            }
        }

        Loader {
            active: control.indicatorPosition === AntCarousel.PositionLeft && control.indicatorVisible
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            sourceComponent: Column {
                spacing: control.indicatorSpacing
                Repeater {
                    model: control.initModel
                    delegate: control.indicatorDelegate
                }
            }
        }

        Loader {
            active: control.indicatorPosition === AntCarousel.PositionRight && control.indicatorVisible
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            sourceComponent: Column {
                spacing: control.indicatorSpacing
                Repeater {
                    model: control.initModel
                    delegate: control.indicatorDelegate
                }
            }
        }

        Loader {
            active: control.arrowVisible && prevVisible
            anchors.verticalCenter: __private.isHorizontal ? parent.verticalCenter : undefined
            anchors.horizontalCenter: !__private.isHorizontal ? parent.horizontalCenter : undefined
            anchors.top: !__private.isHorizontal ? parent.top : undefined
            anchors.left: __private.isHorizontal ? parent.left : undefined
            sourceComponent: control.prevDelegate
            property bool prevVisible: control.infinite || control.currentIndex !== 0
        }

        Loader {
            active: control.arrowVisible && nextVisible
            anchors.verticalCenter: __private.isHorizontal ? parent.verticalCenter : undefined
            anchors.horizontalCenter: !__private.isHorizontal ? parent.horizontalCenter : undefined
            anchors.bottom: !__private.isHorizontal ? parent.bottom : undefined
            anchors.right: __private.isHorizontal ? parent.right : undefined
            sourceComponent: control.nextDelegate
            property bool nextVisible: control.infinite || control.currentIndex !== __listModel.count - 1
        }
    }

    function switchTo(index, animated = true) {
        if (animated)
            __listView.currentIndex = infinite ? index + 1 : index;
        else
            __listView.positionViewAtIndex(infinite ? 1 : 0, ListView.SnapPosition);
    }

    function switchToPrev() {
        if (infinite && __listView.currentIndex === 0) {
            __listView.positionViewAtIndex(__listView.count - 2, ListView.SnapPosition);
            __listView.decrementCurrentIndex();
        } else {
            __listView.decrementCurrentIndex();
        }
    }

    function switchToNext() {
        if (infinite && __listView.currentIndex === __listView.count - 1) {
            __listView.positionViewAtIndex(1, ListView.SnapPosition);
            __listView.incrementCurrentIndex();
        } else {
            __listView.incrementCurrentIndex();
        }
    }

    function getSuitableIndicatorWidth(contentWidth, indicatorMaxWidth = 18) {
        let indicatorWidth = 0;
        let totalWidth = 0;
        do {
            if (indicatorWidth >= indicatorMaxWidth) {
                break;
            }
            totalWidth = (++indicatorWidth) * __listModel.count + indicatorSpacing * (__listModel.count - 1) + indicatorMaxWidth;
        } while (totalWidth < contentWidth);
        return indicatorWidth;
    }

    QtObject {
        id: __private
        property bool isHorizontal: control.direction === AntCarousel.DirectionHorizontal
        property int indicatorWidth: control.getSuitableIndicatorWidth(__listView.width)

        function updateInfiniteIndex() {
            if (control.infinite) {
                if (__listView.currentIndex === 0) {
                    __listView.positionViewAtIndex(count - 2, ListView.SnapPosition);
                } else if (__listView.currentIndex === count - 1) {
                    __listView.positionViewAtIndex(1, ListView.SnapPosition);
                }
            }
        }

        function updateModel() {
            if (control.initModel.length > 0) {
                const model = control.infinite ? [control.initModel[control.initModel.length - 1], ...control.initModel, control.initModel[0]] : [...control.initModel];
                __listModel.clear();
                for (const item of model) {
                    __listModel.append(item);
                }
                __resetTimer.restart();
            } else {
                __listModel.clear();
            }
        }

        function getVirtualModelIndex(index) {
            if (control.infinite) {
                if (index === 0) {
                    return 1;
                } else if (index === (__listModel.count - 2)) {
                    return __listModel.count - 1;
                } else {
                    return index + 1;
                }
            } else {
                return index;
            }
        }

        function getRealModelIndex(index) {
            if (control.infinite) {
                if (index === 0) {
                    return __listModel.count - 3;
                } else if ((index) === (__listModel.count - 1)) {
                    return 0;
                } else {
                    return index - 1;
                }
            } else {
                return index;
            }
        }
    }
}
