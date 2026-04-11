import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Antilla.Basic

Item {
    id: control
    clip: true

    enum TabPosition {
        PositionTop = 0,
        PositionBottom = 1,
        PositionLeft = 2,
        PositionRight = 3
    }

    enum TabType {
        TypeDefault = 0,
        TypeCard = 1,
        TypeCardEditable = 2
    }

    enum TabSize {
        SizeAuto = 0,
        SizeFixed = 1
    }

    property bool animationEnabled: AntTheme.animationEnabled
    property var initModel: []
    property alias count: __tabModel.count
    property alias currentIndex: __tabView.currentIndex
    property int tabType: AntTabs.TypeDefault
    property int tabSize: AntTabs.SizeAuto
    property int tabPosition: AntTabs.PositionTop
    property bool tabAddable: false
    property bool tabCentered: false
    property bool tabCardMovable: false
    property int defaultTabWidth: 80
    property int defaultTabHeight: control.themeSource.fontSize + 16
    property int defaultTabSpacing: 2
    property int defaultTabBgRadius: control.themeSource.radiusTabBg
    property int defaultHighlightWidth: __private.isHorizontal ? 40 : 20
    property var tabAddCallback: () => {
        append({ title: `New Tab ${__tabView.count + 1}` });
        positionViewAtEnd();
    }
    property var tabCloseCallback: (index, data) => {
        remove(index);
    }
    property Component addButtonDelegate: AntCaptionButton {
        id: __addButton
        animationEnabled: control.animationEnabled
        iconSize: control.themeSource.fontSize
        iconSource: AntIcon.PlusOutlined
        colorIcon: control.themeSource.colorTabCloseHover
        hoverCursorShape: Qt.PointingHandCursor
        radiusBg.all: control.themeSource.radiusButtonBg
        onClicked: tabAddCallback();
    }
    property Component tabDelegate: tabType === AntTabs.TypeDefault ? __defaultTabDelegate : __cardTabDelegate
    property Component contentDelegate: Item { }
    property Component highlightDelegate: Item {
        Loader {
            id: __highlight
            width: __private.isHorizontal ? defaultHighlightWidth : 2
            height: __private.isHorizontal ? 2 : defaultHighlightWidth
            anchors {
                bottom: control.tabPosition === AntTabs.PositionTop ? parent.bottom : undefined
                right: control.tabPosition === AntTabs.PositionLeft ? parent.right : undefined
            }
            state: __content.state
            states: [
                State {
                    name: 'top'
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: parent.bottom
                        anchors.left: undefined
                        anchors.right: undefined
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: 'bottom'
                    AnchorChanges {
                        target: __highlight
                        anchors.top: parent.top
                        anchors.bottom: undefined
                        anchors.left: undefined
                        anchors.right: undefined
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: 'left'
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: undefined
                        anchors.left: undefined
                        anchors.right: parent.right
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: parent.verticalCenter
                    }
                },
                State {
                    name: 'right'
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: undefined
                        anchors.left: parent.left
                        anchors.right: undefined
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            ]
            active: control.tabType === AntTabs.TypeDefault
            sourceComponent: Rectangle {
                color: AntTheme.isDark ? control.themeSource.colorHighlightDark : control.themeSource.colorHighlight
            }
        }
    }
    property var themeSource: AntTheme.AntTabs

    objectName: '__AntTabs__'
    onInitModelChanged: {
        clear();
        for (const object of initModel) {
            append(object);
        }
    }

    function flick(xVelocity: real, yVelocity: real) {
        __tabView.flick(xVelocity, yVelocity);
    }

    function positionViewAtBeginning() {
        __tabView.positionViewAtBeginning();
    }

    function positionViewAtIndex(index, mode) {
        __tabView.positionViewAtIndex(index, mode);
    }

    function positionViewAtEnd() {
        __tabView.positionViewAtEnd();
    }

    function get(index) {
        return __tabModel.get(index);
    }

    function set(index, object) {
        /*! 默认为true */
        if (object.editable === undefined)
            object.editable = true;
        __tabModel.set(index, object);
    }

    function setProperty(index, propertyName, value) {
        __tabModel.setProperty(index, propertyName, value);
    }

    function move(from, to, count = 1) {
        __tabModel.move(from, to, count);
    }

    function insert(index, object) {
        /*! 默认为true */
        if (object.editable === undefined)
            object.editable = true;
        __tabModel.insert(index, object);
    }

    function append(object) {
        /*! 默认为true */
        if (object.editable === undefined)
            object.editable = true;
        __tabModel.append(object);
    }

    function remove(index, count = 1) {
        __tabModel.remove(index, count);
    }

    function clear() {
        __tabModel.clear();
    }

    Component {
        id: __defaultTabDelegate

        AntIconButton {
            id: __tabItem
            width: (!__private.isHorizontal && control.tabSize === AntTabs.SizeAuto) ? Math.max(__private.tabMaxWidth, tabWidth) : tabWidth
            height: tabHeight
            leftPadding: 5
            rightPadding: 5
            iconSize: tabIconSize
            iconSource: tabIcon
            text: tabTitle
            animationEnabled: control.animationEnabled
            effectEnabled: false
            colorBg: 'transparent'
            colorBorder: 'transparent'
            colorText: {
                if (isCurrent) {
                    return AntTheme.isDark ? control.themeSource.colorHighlightDark : control.themeSource.colorHighlight;
                } else {
                    return down ? control.themeSource.colorTabActive : (hovered ? control.themeSource.colorTabHover : control.themeSource.colorTab);
                }
            }
            font {
                family: control.themeSource.fontFamily
                pixelSize: control.themeSource.fontSize
            }
            contentItem: Item {
                implicitWidth: control.tabSize === AntTabs.SizeAuto ? (__text.width + calcIconWidth) : __tabItem.tabFixedWidth
                implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight)

                property int calcIconWidth: __icon.empty ? 0 : (__icon.implicitWidth + __tabItem.tabIconSpacing)

                AntIconText {
                    id: __icon
                    width: empty ? 0 : implicitWidth
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: __tabItem.colorIcon
                    iconSize: __tabItem.iconSize
                    iconSource: __tabItem.iconSource
                    cursorShape: Qt.PointingHandCursor
                    verticalAlignment: Text.AlignVCenter

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
                }

                AntText {
                    id: __text
                    width: control.tabSize === AntTabs.SizeAuto ? implicitWidth : Math.max(0, __tabItem.tabFixedWidth - 5 - parent.calcIconWidth)
                    anchors.left: __icon.right
                    anchors.leftMargin: __icon.empty ? 0 : __tabItem.tabIconSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    text: __tabItem.text
                    font: __tabItem.font
                    color: __tabItem.colorText
                    elide: Text.ElideRight
                    cursorShape: Qt.PointingHandCursor

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
                }
            }
            onTabWidthChanged: {
                if (index === 0) {
                    __private.tabMaxWidth = 0;
                }
                __private.tabMaxWidth = Math.max(__private.tabMaxWidth, __tabItem.tabWidth);
            }
            onClicked: __tabView.currentIndex = index;

            required property int index
            required property var model
            property alias modelData: __tabItem.model
            property bool isCurrent: __tabView.currentIndex === index
            property string tabKey: modelData.key || ''
            property var tabIcon: modelData.iconSource || 0
            property int tabIconSize: modelData.iconSize || control.themeSource.fontSize
            property int tabIconSpacing: modelData.iconSpacing || 5
            property string tabTitle: modelData.title || ''
            property int tabFixedWidth: modelData.tabWidth || defaultTabWidth
            property int tabWidth: control.tabSize === AntTabs.SizeAuto ? (implicitContentWidth + leftPadding + rightPadding) :
                                                                             implicitContentWidth
            property int tabHeight: modelData.tabHeight || defaultTabHeight
        }
    }

    Component {
        id: __cardTabDelegate

        Item {
            id: __tabContainer
            width: __tabItem.width
            height: __tabItem.height

            required property int index
            required property var model
            property alias modelData: __tabContainer.model
            property alias tabItem: __tabItem
            property bool isCurrent: __tabView.currentIndex === index
            property string tabKey: modelData.key || ''
            property var tabIcon: modelData.iconSource || 0
            property int tabIconSize: modelData.iconSize || control.themeSource.fontSize
            property int tabIconSpacing: modelData.iconSpacing || 5
            property string tabTitle: modelData.title || ''
            property int tabFixedWidth: modelData.tabWidth || defaultTabWidth
            property int tabWidth: __tabItem.calcWidth
            property int tabHeight: modelData.tabHeight || defaultTabHeight

            property bool tabEditable: modelData.editable && control.tabType === AntTabs.TypeCardEditable

            onTabWidthChanged: {
                if (__private.needResetTabMaxWidth) {
                    __private.needResetTabMaxWidth = false;
                    __private.tabMaxWidth = 0;
                }
                __private.tabMaxWidth = Math.max(__private.tabMaxWidth, __tabItem.calcWidth);
            }

            AntRectangle {
                id: __tabItem
                width: (!__private.isHorizontal && control.tabSize === AntTabs.SizeAuto) ? Math.max(__private.tabMaxWidth, tabWidth) : tabWidth
                height: tabHeight
                z: __dragHandler.drag.active ? 1 : 0
                color: {
                    if (AntTheme.isDark) {
                        return isCurrent ? control.themeSource.colorTabCardBgCheckedDark : control.themeSource.colorTabCardBgDark;
                    } else {
                        return isCurrent ? control.themeSource.colorTabCardBgChecked : control.themeSource.colorTabCardBg;
                    }
                }
                border.color: control.themeSource.colorTabCardBorder
                topLeftRadius: control.tabPosition === AntTabs.PositionTop || control.tabPosition === AntTabs.PositionLeft ? defaultTabBgRadius : 0
                topRightRadius: control.tabPosition === AntTabs.PositionTop || control.tabPosition === AntTabs.PositionRight ? defaultTabBgRadius : 0
                bottomLeftRadius: control.tabPosition === AntTabs.PositionBottom || control.tabPosition === AntTabs.PositionLeft ? defaultTabBgRadius : 0
                bottomRightRadius: control.tabPosition === AntTabs.PositionBottom || control.tabPosition === AntTabs.PositionRight ? defaultTabBgRadius : 0

                property bool down: false
                property bool hovered: false
                property int calcIconWidth: __icon.empty ? 0 : (__icon.implicitWidth + __tabContainer.tabIconSpacing)
                property int calcCloseWidth: __close.visible ? (__close.implicitWidth + 5) : 0
                property real calcWidth: control.tabSize === AntTabs.SizeAuto ? (__text.width + calcIconWidth + calcCloseWidth + 10)
                                                                                 : __tabContainer.tabFixedWidth
                property real calcHeight: Math.max(__icon.implicitHeight, __text.implicitHeight, __close.height)
                property color colorText: {
                    if (isCurrent) {
                        return AntTheme.isDark ? control.themeSource.colorHighlightDark : control.themeSource.colorHighlight;
                    } else {
                        return down ? control.themeSource.colorTabActive : (hovered ? control.themeSource.colorTabHover : control.themeSource.colorTab);
                    }
                }

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }

                MouseArea {
                    id: __dragHandler
                    anchors.fill: parent
                    hoverEnabled: true
                    drag.target: control.tabCardMovable ? __tabItem : null
                    drag.axis: __private.isHorizontal ? Drag.XAxis : Drag.YAxis
                    onEntered: __tabItem.hovered = true;
                    onExited: __tabItem.hovered = false;
                    onClicked: __tabView.currentIndex = index;
                    onPressed:
                        (mouse) => {
                            __tabView.currentIndex = index;
                            __tabItem.down = true;
                            if (control.tabCardMovable) {
                                const pos = __tabView.mapFromItem(__tabContainer, 0, 0);
                                __tabItem.parent = __tabView;
                                __tabItem.x = pos.x;
                                __tabItem.y = pos.y;
                            }
                        }
                    onPositionChanged: move();
                    onReleased: {
                        __keepMovingTimer.stop();
                        __tabItem.down = false;
                        __tabItem.parent = __tabContainer;
                        __tabItem.x = __tabItem.y = 0;
                        __tabView.forceLayout();
                    }

                    function move() {
                        if (pressed && control.tabCardMovable) {
                            if (!__keepMovingTimer.running) {
                                __keepMovingTimer.restart();
                            }
                            const pos = __tabView.mapFromItem(__tabItem, width / 2, height / 2);
                            const item = __tabView.itemAt(pos.x + __tabView.contentX + 1, pos.y + __tabView.contentY + 1);
                            if (item) {
                                if (item.index !== __tabContainer.index) {
                                    __tabModel.move(item.index, __tabContainer.index, 1);
                                }
                            }
                        }
                    }

                    Timer {
                        id: __keepMovingTimer
                        repeat: true
                        interval: 100
                        onTriggered: __dragHandler.move();
                    }
                }

                AntIconText {
                    id: __icon
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    color: __tabItem.colorText
                    iconSize: tabIconSize
                    iconSource: tabIcon
                    verticalAlignment: Text.AlignVCenter
                    width: empty ? 0 : implicitWidth

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
                }

                AntText {
                    id: __text
                    anchors.left: __icon.right
                    anchors.leftMargin: __icon.empty ? 0 : __tabContainer.tabIconSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    text: tabTitle
                    font {
                        family: control.themeSource.fontFamily
                        pixelSize: control.themeSource.fontSize
                    }
                    color: __tabItem.colorText
                    elide: Text.ElideRight

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
                }

                AntCaptionButton {
                    id: __close
                    visible: __tabContainer.tabEditable
                    enabled: visible
                    implicitWidth: visible ? (implicitContentWidth + leftPadding + rightPadding) : 0
                    topPadding: 0
                    bottomPadding: 0
                    leftPadding: 2
                    rightPadding: 2
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    animationEnabled: control.animationEnabled
                    hoverCursorShape: Qt.PointingHandCursor
                    iconSize: tabIconSize
                    iconSource: AntIcon.CloseOutlined
                    colorIcon: hovered ? control.themeSource.colorTabCloseHover : control.themeSource.colorTabClose
                    onClicked: {
                        control.tabCloseCallback(__tabContainer.index, __tabContainer.model);
                    }

                    HoverHandler {
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }

    Connections {
        target: control
        function onTabTypeChanged() {
            __private.needResetTabMaxWidth = true;
        }
        function onTabSizeChanged() {
            __private.needResetTabMaxWidth = true;
        }
    }

    QtObject {
        id: __private
        property bool isHorizontal: control.tabPosition === AntTabs.PositionTop || control.tabPosition === AntTabs.PositionBottom
        property int tabMaxWidth: 0
        property bool needResetTabMaxWidth: false
    }

    MouseArea {
        anchors.fill: __tabView
        onWheel: function(wheel) {
            if (__private.isHorizontal) {
                __tabView.flick(wheel.angleDelta.y * 6.5, 0);
            } else {
                __tabView.flick(0, wheel.angleDelta.y * 6.5);
            }
        }
        onClicked: {
            forceActiveFocus();
        }
    }

    ListView {
        id: __tabView
        width: {
            if (__private.isHorizontal) {
                const maxWidth = control.width - (__addButtonLoader.width + 5) * (control.tabCentered ? 2 : 1);
                return (control.tabCentered ? Math.min(contentWidth, maxWidth) : maxWidth);
            } else {
                return __private.tabMaxWidth;
            }
        }
        height: {
            if (__private.isHorizontal) {
                return defaultTabHeight;
            } else {
                const maxHeight = control.height - (__addButtonLoader.height + 5) * (control.tabCentered ? 2 : 1);
                return (control.tabCentered ? Math.min(contentHeight, maxHeight) : maxHeight)
            }
        }
        clip: true
        onContentWidthChanged: if (__private.isHorizontal) cacheBuffer = contentWidth;
        onContentHeightChanged: if (!__private.isHorizontal) cacheBuffer = contentHeight;
        spacing: defaultTabSpacing
        move: Transition {
            NumberAnimation { properties: 'x,y'; duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0 }
        }
        model: ListModel { id: __tabModel }
        delegate: tabDelegate
        highlight: highlightDelegate
        highlightMoveDuration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        orientation: __private.isHorizontal ? Qt.Horizontal : Qt.Vertical
        boundsBehavior: Flickable.StopAtBounds
        state: control.tabCentered ? (__content.state + 'Center') : __content.state
        states: [
            State {
                name: 'top'
                AnchorChanges {
                    target: __tabView
                    anchors.top: control.top
                    anchors.bottom: undefined
                    anchors.left: control.left
                    anchors.right: undefined
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: 'topCenter'
                AnchorChanges {
                    target: __tabView
                    anchors.top: control.top
                    anchors.bottom: undefined
                    anchors.left: undefined
                    anchors.right: undefined
                    anchors.horizontalCenter: control.horizontalCenter
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: 'bottom'
                AnchorChanges {
                    target: __tabView
                    anchors.top: undefined
                    anchors.bottom: control.bottom
                    anchors.left: control.left
                    anchors.right: undefined
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: 'bottomCenter'
                AnchorChanges {
                    target: __tabView
                    anchors.top: undefined
                    anchors.bottom: control.bottom
                    anchors.left: undefined
                    anchors.right: undefined
                    anchors.horizontalCenter: control.horizontalCenter
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: 'left'
                AnchorChanges {
                    target: __tabView
                    anchors.top: control.top
                    anchors.bottom: undefined
                    anchors.left: control.left
                    anchors.right: undefined
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: 'leftCenter'
                AnchorChanges {
                    target: __tabView
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.left: control.left
                    anchors.right: undefined
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: control.verticalCenter
                }
            },
            State {
                name: 'right'
                AnchorChanges {
                    target: __tabView
                    anchors.top: control.top
                    anchors.bottom: undefined
                    anchors.left: undefined
                    anchors.right: control.right
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: 'rightCenter'
                AnchorChanges {
                    target: __tabView
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.left: undefined
                    anchors.right: control.right
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: control.verticalCenter
                }
            }
        ]
    }

    Loader {
        id: __addButtonLoader
        active: control.tabAddable
        x: {
            switch (tabPosition) {
            case AntTabs.PositionTop:
            case AntTabs.PositionBottom:
                return Math.min(__tabView.x + __tabView.contentWidth + 5, control.width - width);
            case AntTabs.PositionLeft:
                return Math.max(0, __tabView.width - width);
            case AntTabs.PositionRight:
                return Math.max(0, __tabView.x);
            }
        }
        y: {
            switch (tabPosition) {
            case AntTabs.PositionTop:
                return Math.max(0, __tabView.y + __tabView.height - height);
            case AntTabs.PositionBottom:
                return __tabView.y;
            case AntTabs.PositionLeft:
            case AntTabs.PositionRight:
                return Math.min(__tabView.y + __tabView.contentHeight + 5, control.height - height);
            }
        }
        z: 10
        sourceComponent: addButtonDelegate
    }

    Item {
        id: __content
        state: {
            switch (tabPosition) {
            case AntTabs.PositionTop: return 'top';
            case AntTabs.PositionBottom: return 'bottom';
            case AntTabs.PositionLeft: return 'left';
            case AntTabs.PositionRight: return 'right';
            }
        }
        states: [
            State {
                name: 'top'
                AnchorChanges {
                    target: __content
                    anchors.top: __tabView.bottom
                    anchors.bottom: control.bottom
                    anchors.left: control.left
                    anchors.right: control.right
                }
            },
            State {
                name: 'bottom'
                AnchorChanges {
                    target: __content
                    anchors.top: control.top
                    anchors.bottom: __tabView.top
                    anchors.left: control.left
                    anchors.right: control.right
                }
            },
            State {
                name: 'left'
                AnchorChanges {
                    target: __content
                    anchors.top: control.top
                    anchors.bottom: control.bottom
                    anchors.left: __tabView.right
                    anchors.right: control.right
                }
            },
            State {
                name: 'right'
                AnchorChanges {
                    target: __content
                    anchors.top: control.top
                    anchors.bottom: control.bottom
                    anchors.left: control.left
                    anchors.right: __tabView.left
                }
            }
        ]

        Repeater {
            model: __tabModel
            delegate: Loader {
                id: __contentLoader
                anchors.fill: parent
                sourceComponent: contentDelegate
                visible: __tabView.currentIndex === index
                required property int index
                required property var model
            }
        }
    }
}
