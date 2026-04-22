pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Antilla.Basic

Item {
    id: control

    enum NotificationPosition {
        PositionTop = 0,
        PositionTopLeft = 1,
        PositionTopRight = 2,
        PositionBottom = 3,
        PositionBottomLeft = 4,
        PositionBottomRight = 5,
        PositionLeft = 6,
        PositionRight = 7
    }

    enum MessageType {
        TypeNone = 0,
        TypeInfo = 1,
        TypeSuccess = 2,
        TypeWarning = 3,
        TypeError = 4
    }

    signal closed(key: string)

    property bool animationEnabled: AntTheme.animationEnabled
    property int position: AntNotification.PositionTopRight
    property bool pauseOnHover: true
    property bool progressVisible: false
    property bool stackMode: true
    property int stackThreshold: 5
    property int defaultIconSize: 20
    property int maxWidth: 300
    property int spacing: 10
    property bool closable: true
    property int topMargin: 12
    property int bgTopPadding: 12
    property int bgBottomPadding: 12
    property int bgLeftPadding: 12
    property int bgRightPadding: 12
    property int iconSpacing: 8
    property color colorTitle: control.themeSource.colorTitle
    property color colorDescription: control.themeSource.colorDescription
    property color colorBg: AntTheme.isDark ? control.themeSource.colorBgDark : control.themeSource.colorBg
    property color colorBgShadow: control.themeSource.colorBgShadow
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }
    property font titleFont: Qt.font({
        family: control.themeSource.titleFontFamily,
        pixelSize: parseInt(control.themeSource.titleFontSize),
        bold: true
    })
    property font descriptionFont: Qt.font({
        family: control.themeSource.descriptionFontFamily,
        pixelSize: parseInt(control.themeSource.descriptionFontSize)
    })
    property int descriptionSpacing: 10

    property Component titleDelegate: AntText {
        text: parent.title
        font: control.titleFont
        color: control.colorTitle
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component descriptionDelegate: AntText {
        width: parent.width
        font: control.descriptionFont
        color: control.colorDescription
        text: parent.description
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property var themeSource: AntTheme.AntNotification

    objectName: '__AntNotification__'

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
    Behavior on colorTitle { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
    Behavior on colorDescription { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }

    QtObject {
        id: __private

        function isLeftPosition(position) {
            return position == AntNotification.PositionLeft || position == AntNotification.PositionTopLeft || position == AntNotification.PositionBottomLeft;
        }

        function isRightPosition(position) {
            return position == AntNotification.PositionRight || position == AntNotification.PositionTopRight || position == AntNotification.PositionBottomRight;
        }

        function isTopPosition(position) {
            return position == AntNotification.PositionTop || position == AntNotification.PositionTopLeft || position == AntNotification.PositionTopRight;
        }

        function isBottomPosition(position) {
            return position == AntNotification.PositionBottom || position == AntNotification.PositionBottomLeft || position == AntNotification.PositionBottomRight;
        }

        property bool isLeft: isLeftPosition(control.position)
        property bool isRight: isRightPosition(control.position)
        property bool isTop: isTopPosition(control.position)
        property bool isBottom: isBottomPosition(control.position)

        function initObject(object) {
            if (!object.hasOwnProperty('key')) {
                object.key = '';
            }
            if (!object.hasOwnProperty('loading')) {
                object.loading = false;
            }
            if (!object.hasOwnProperty('title')) {
                object.title = '';
            }
            if (!object.hasOwnProperty('description')) {
                object.description = '';
            }
            if (!object.hasOwnProperty('type')) {
                object.type = AntNotification.TypeNone;
            }
            if (!object.hasOwnProperty('duration')) {
                object.duration = 4500;
            }
            if (!object.hasOwnProperty('iconSize')) {
                object.iconSize = control.defaultIconSize;
            }
            if (!object.hasOwnProperty('iconSource')) {
                object.iconSource = 0;
            }
            if (!object.hasOwnProperty('colorIcon')) {
                object.colorIcon = '';
            } else {
                object.colorIcon = String(object.colorIcon);
            }
            if (!object.hasOwnProperty('maxWidth')) {
                object.maxWidth = -1;
            }
            if (!object.hasOwnProperty('position')) {
                object.position = control.position;
            }
            if (!object.hasOwnProperty('progressVisible')) {
                object.progressVisible = control.progressVisible;
            }
            if (!object.hasOwnProperty('closable')) {
                object.closable = control.closable;
            }
            return object;
        }
    }

    Item {
        id: __container
        anchors.fill: parent

        property bool __hasTopNotifications: false
        property bool __hasTopLeftNotifications: false
        property bool __hasTopRightNotifications: false
        property bool __hasBottomNotifications: false
        property bool __hasBottomLeftNotifications: false
        property bool __hasBottomRightNotifications: false
        property bool __hasLeftNotifications: false
        property bool __hasRightNotifications: false

        function __hasPosition(position) {
            for (let i = 0; i < __listModel.count; i++) {
                if (__listModel.get(i).position === position) {
                    return true;
                }
            }
            return false;
        }

        function __getLocalIndex(globalIndex, position) {
            let localIndex = 0;
            for (let i = 0; i < globalIndex; i++) {
                if (__listModel.get(i).position === position) {
                    localIndex++;
                }
            }
            return localIndex;
        }

        Component.onCompleted: {
            __updatePositionVisibility();
        }

        Connections {
            target: __listModel
            function onCountChanged() {
                __container.__updatePositionVisibility();
            }
        }

        function __updatePositionVisibility() {
            __hasTopNotifications = __hasPosition(AntNotification.PositionTop);
            __hasTopLeftNotifications = __hasPosition(AntNotification.PositionTopLeft);
            __hasTopRightNotifications = __hasPosition(AntNotification.PositionTopRight);
            __hasBottomNotifications = __hasPosition(AntNotification.PositionBottom);
            __hasBottomLeftNotifications = __hasPosition(AntNotification.PositionBottomLeft);
            __hasBottomRightNotifications = __hasPosition(AntNotification.PositionBottomRight);
            __hasLeftNotifications = __hasPosition(AntNotification.PositionLeft);
            __hasRightNotifications = __hasPosition(AntNotification.PositionRight);
        }

        // 顶部容器
        ColumnLayout {
            id: __topLayout
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                margins: 10
                topMargin: control.topMargin
            }
            spacing: 0
            visible: __private.isTop || parent.__hasTopNotifications
        }

        // 顶部左侧容器
        ColumnLayout {
            id: __topLeftLayout
            anchors {
                top: parent.top
                left: parent.left
                margins: 10
                topMargin: control.topMargin
            }
            spacing: 0
            visible: __private.isLeft || parent.__hasTopLeftNotifications
        }

        // 顶部右侧容器
        ColumnLayout {
            id: __topRightLayout
            anchors {
                top: parent.top
                right: parent.right
                margins: 10
                topMargin: control.topMargin
            }
            spacing: 0
            visible: __private.isRight || parent.__hasTopRightNotifications
        }

        // 底部容器
        ColumnLayout {
            id: __bottomLayout
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                margins: 10
            }
            spacing: 0
            visible: __private.isBottom || parent.__hasBottomNotifications
        }

        // 底部左侧容器
        ColumnLayout {
            id: __bottomLeftLayout
            anchors {
                bottom: parent.bottom
                left: parent.left
                margins: 10
            }
            spacing: 0
            visible: __private.isLeft || parent.__hasBottomLeftNotifications
        }

        // 底部右侧容器
        ColumnLayout {
            id: __bottomRightLayout
            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: 10
            }
            spacing: 0
            visible: __private.isRight || parent.__hasBottomRightNotifications
        }

        // 左侧容器
        ColumnLayout {
            id: __leftLayout
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                margins: 10
            }
            spacing: 0
            visible: __private.isLeft || parent.__hasLeftNotifications
        }

        // 右侧容器
        ColumnLayout {
            id: __rightLayout
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: 10
            }
            spacing: 0
            visible: __private.isRight || parent.__hasRightNotifications
        }

        Repeater {
            id: __repeater
            model: ListModel { id: __listModel }

            property bool collapsed: false  // 暂时禁用堆叠模式，因为多位置堆叠比较复杂

            delegate: Item {
                id: __rootItem
                z: -index

                parent: {
                    switch (position) {
                        case AntNotification.PositionTop:
                            return __topLayout;
                        case AntNotification.PositionTopLeft:
                            return __topLeftLayout;
                        case AntNotification.PositionTopRight:
                            return __topRightLayout;
                        case AntNotification.PositionBottom:
                            return __bottomLayout;
                        case AntNotification.PositionBottomLeft:
                            return __bottomLeftLayout;
                        case AntNotification.PositionBottomRight:
                            return __bottomRightLayout;
                        case AntNotification.PositionLeft:
                            return __leftLayout;
                        case AntNotification.PositionRight:
                            return __rightLayout;
                        default:
                            return __topRightLayout;
                    }
                }

                property int __localIndex: __container.__getLocalIndex(index, position)

                Layout.preferredWidth: __content.width
                Layout.preferredHeight: __content.height
                Layout.leftMargin: __private.isLeftPosition(position) ? (-__content.width - 20) : 0
                Layout.rightMargin: __private.isRightPosition(position) ? (-__content.width - 20) : 0
                Layout.topMargin: __localIndex == 0 ? 0 : (control.stackMode && __repeater.collapsed ? collapseTopMargin : control.spacing)
                Layout.alignment: __private.isLeftPosition(position) ? Qt.AlignLeft : Qt.AlignRight

                required property int index
                required property string key
                required property bool loading
                required property string title
                required property string description
                required property int type
                required property int duration
                required property int iconSize
                required property int iconSource
                required property string colorIcon
                required property int maxWidth
                required property int position
                required property bool progressVisible
                required property bool closable

                property real collapseTopMargin: __localIndex == 0 ? 10 : (__localIndex == 1 || __localIndex == 2) ? (10 - __content.height) : (- __content.height)

                function removeSelf() {
                    __content.height = 0;
                    __removeTimer.start();
                }

                NumberAnimation on Layout.leftMargin {
                    running: control.animationEnabled && __private.isLeftPosition(position)
                    to: 0
                    easing.type: Easing.OutQuad
                    duration: AntTheme.Primary.durationMid
                }

                NumberAnimation on Layout.rightMargin {
                    running: control.animationEnabled && __private.isRightPosition(position)
                    to: 0
                    duration: AntTheme.Primary.durationMid
                }

                Behavior on Layout.topMargin { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }

                Timer {
                    id: __timer
                    running: control.pauseOnHover ? !__rootItem.__hovered : true
                    interval: 25
                    repeat: true
                    onTriggered: {
                        time += 25;
                        if (time >= __rootItem.duration) {
                            stop();
                            __rootItem.removeSelf();
                        }
                    }
                    property int time: 0
                }

                HoverHandler {
                    id: __itemHoverHandler
                }

                property bool __hovered: __itemHoverHandler.hovered

                AntShadow {
                    anchors.fill: __rootItem
                    source: __bgRect
                    shadowColor: control.colorBgShadow
                    shadowEnabled: __repeater.collapsed ? index <= 2 : true
                }

                AntRectangleInternal {
                    id: __bgRect
                    anchors.fill: parent
                    color: control.colorBg
                    radius: control.radiusBg.all
                    topLeftRadius: control.radiusBg.topLeft
                    topRightRadius: control.radiusBg.topRight
                    bottomLeftRadius: control.radiusBg.bottomLeft
                    bottomRightRadius: control.radiusBg.bottomRight
                    visible: false
                }

                Item {
                    id: __content
                    width: __rowLayout.width + control.bgLeftPadding + control.bgRightPadding
                    height: __rowLayout.height + control.bgTopPadding + control.bgBottomPadding
                    opacity: 0
                    clip: true

                    Component.onCompleted: {
                        opacity = 1;
                    }

                    Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }

                    Timer {
                        id: __removeTimer
                        running: false
                        interval: control.animationEnabled ? AntTheme.Primary.durationMid : 0
                        onTriggered: {
                            control.closed(__rootItem.key);
                            __listModel.remove(__rootItem.index);
                        }
                    }

                    RowLayout {
                        id: __rowLayout
                        width: Math.min(__rootItem.maxWidth > 0 ? __rootItem.maxWidth : control.maxWidth, control.width - control.bgLeftPadding - control.bgRightPadding)
                        anchors.centerIn: parent
                        spacing: control.iconSpacing

                        AntIconText {
                            Layout.alignment: Qt.AlignTop
                            Layout.topMargin: 5
                            iconSize: __rootItem.iconSize
                            iconSource: {
                                if (__rootItem.loading) return AntIcon.LoadingOutlined;
                                if (__rootItem.iconSource != 0) return __rootItem.iconSource;
                                switch (type) {
                                    case AntNotification.TypeInfo: return AntIcon.InfoCircleFilled;
                                    case AntNotification.TypeSuccess: return AntIcon.CheckCircleFilled;
                                    case AntNotification.TypeWarning: return AntIcon.ExclamationCircleFilled;
                                    case AntNotification.TypeError: return AntIcon.CloseCircleFilled;
                                    default: return 0;
                                }
                            }
                            colorIcon: {
                                if (__rootItem.loading) return AntTheme.Primary.colorInfo;
                                if (__rootItem.colorIcon !== '') return __rootItem.colorIcon;
                                switch ((type)) {
                                    case AntNotification.TypeInfo: return AntTheme.Primary.colorInfo;
                                    case AntNotification.TypeSuccess: return AntTheme.Primary.colorSuccess;
                                    case AntNotification.TypeWarning: return AntTheme.Primary.colorWarning;
                                    case AntNotification.TypeError: return AntTheme.Primary.colorError;
                                    default: return AntTheme.Primary.colorInfo;
                                }
                            }

                            NumberAnimation on rotation {
                                running: __rootItem.loading
                                from: 0
                                to: 360
                                loops: Animation.Infinite
                                duration: 1000
                            }
                        }

                        Item {
                            Layout.alignment: Qt.AlignTop
                            Layout.topMargin: 5
                            Layout.fillWidth: true
                            Layout.preferredHeight: __messageLoader.height + __descriptionLoader.height + control.descriptionSpacing

                            Loader {
                                id: __messageLoader
                                width: parent.width
                                sourceComponent: control.titleDelegate
                                property alias index: __rootItem.index
                                property alias key: __rootItem.key
                                property alias title: __rootItem.title
                            }

                            Loader {
                                id: __descriptionLoader
                                width: parent.width
                                anchors.top: __messageLoader.bottom
                                anchors.topMargin: control.descriptionSpacing
                                sourceComponent: control.descriptionDelegate
                                property alias index: __rootItem.index
                                property alias key: __rootItem.key
                                property alias description: __rootItem.description
                            }
                        }

                        Loader {
                            Layout.alignment: Qt.AlignTop
                            Layout.topMargin: 5
                            active: __rootItem.closable
                            sourceComponent: AntCaptionButton {
                                topPadding: 2
                                bottomPadding: 2
                                leftPadding: 4
                                rightPadding: 4
                                radiusBg.all: 2
                                animationEnabled: control.animationEnabled
                                hoverCursorShape: Qt.PointingHandCursor
                                iconSource: AntIcon.CloseOutlined
                                colorIcon: hovered ? control.themeSource.colorCloseHover : control.themeSource.colorClose
                                onClicked: {
                                    __timer.stop();
                                    __rootItem.removeSelf();
                                }
                            }
                        }
                    }

                    Loader {
                        width: parent.width - __bgRect.radius * 2
                        height: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        active: __rootItem.progressVisible
                        sourceComponent: AntProgress {
                            percent: (__rootItem.duration - __timer.time) / __rootItem.duration * 100
                            animationEnabled: false
                            infoVisible: false
                        }
                    }
                }
            }
        }
    }

    function info(title: string, description: string, duration = 4500, maxWidth = -1): void {
        control.open({
            'title': title,
            'description': description,
            'type': AntNotification.TypeInfo,
            'duration': duration,
            'maxWidth': maxWidth
        });
    }

    function success(title: string, description: string, duration = 4500, maxWidth = -1): void {
        control.open({
            'title': title,
            'description': description,
            'type': AntNotification.TypeSuccess,
            'duration': duration,
            'maxWidth': maxWidth
        });
    }

    function error(title: string, description: string, duration = 4500, maxWidth = -1): void {
        control.open({
            'title': title,
            'description': description,
            'type': AntNotification.TypeError,
            'duration': duration,
            'maxWidth': maxWidth
        });
    }

    function warning(title: string, description: string, duration = 4500, maxWidth = -1): void {
        control.open({
            'title': title,
            'description': description,
            'type': AntNotification.TypeWarning,
            'duration': duration,
            'maxWidth': maxWidth
        });
    }

    function loading(title: string, description: string, duration = 4500, maxWidth = -1): void {
        control.open({
            'loading': true,
            'title': title,
            'description': description,
            'type': AntNotification.TypeInfo,
            'duration': duration,
            'maxWidth': maxWidth
        });
    }

    function open(object): void {
        __listModel.insert(0, __private.initObject(object));
    }

    function close(key: string): void {
        for (let i = 0; i < __listModel.count; i++) {
            const object = __listModel.get(i);
            if (object.key && object.key === key) {
                const item = __repeater.itemAt(i);
                if (item)
                    item.removeSelf();
                break;
            }
        }
    }

    function clear(): void {
        __listModel.clear();
    }

    function getNotification(key: string): var {
        for (let i = 0; i < __listModel.count; i++) {
            const object = __listModel.get(i);
            if (object.key && object.key === key) {
                return object;
            }
        }
        return undefined;
    }

    function setProperty(key: string, property: string, value: var): void {
        for (let i = 0; i < __listModel.count; i++) {
            const object = __listModel.get(i);
            if (object.key && object.key === key) {
                __listModel.setProperty(i, property, value);
                break;
            }
        }
    }
}
