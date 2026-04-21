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

        property bool isLeft: control.position == AntNotification.PositionLeft ||
                              control.position == AntNotification.PositionTopLeft ||
                              control.position == AntNotification.PositionBottomLeft
        property bool isRight: control.position == AntNotification.PositionRight ||
                               control.position == AntNotification.PositionTopRight ||
                               control.position == AntNotification.PositionBottomRight
        property bool isTop: control.position == AntNotification.PositionTop ||
                             control.position == AntNotification.PositionTopLeft ||
                             control.position == AntNotification.PositionTopRight
        property bool isBottom: control.position == AntNotification.PositionBottom ||
                                control.position == AntNotification.PositionBottomLeft ||
                                control.position == AntNotification.PositionBottomRight

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
                object.position = AntNotification.PositionTopRight;
            }
            return object;
        }
    }

    ColumnLayout {
        id: __columnLayout
        anchors {
            left: __private.isLeft ? parent.left : undefined
            right: __private.isRight ? parent.right : undefined
            top: __private.isTop ? parent.top : undefined
            bottom: __private.isBottom ? parent.bottom : undefined
            horizontalCenter: control.position == AntNotification.PositionTop||
                              control.position == AntNotification.PositionBottom ? parent.horizontalCenter : undefined
            verticalCenter: control.position == AntNotification.PositionLeft ||
                            control.position == AntNotification.PositionRight ? parent.verticalCenter : undefined
            margins: 10
            topMargin: control.topMargin
        }
        spacing: 0

        Repeater {
            id: __repeater

            property bool collapsed: control.stackMode && __listModel.count > control.stackThreshold && !__hoverHandler.hovered

            model: ListModel { id: __listModel }
            delegate: Item {
                id: __rootItem
                z: -index
                Layout.preferredWidth: __content.width
                Layout.preferredHeight: __content.height
                Layout.leftMargin: __private.isLeft ? (-__content.width - 20) : 0
                Layout.rightMargin: __private.isRight ? (-__content.width - 20) : 0
                Layout.topMargin: index == 0 ? 0 : (__repeater.collapsed ? collapseTopMargin : control.spacing)
                Layout.alignment: __private.isLeft ? Qt.AlignLeft : Qt.AlignRight

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
                property real collapseTopMargin: index == 0 ? 10 : (index == 1 || index == 2) ? (10 - __content.height) : (- __content.height)

                function removeSelf() {
                    __content.height = 0;
                    __removeTimer.start();
                }

                NumberAnimation on Layout.leftMargin {
                    running: control.animationEnabled && __private.isLeft
                    to: 0
                    easing.type: Easing.OutQuad
                    duration: AntTheme.Primary.durationMid
                }

                NumberAnimation on Layout.rightMargin {
                    running: control.animationEnabled && __private.isRight
                    to: 0
                    duration: AntTheme.Primary.durationMid
                }

                Behavior on Layout.topMargin { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }

                Timer {
                    id: __timer
                    running: control.pauseOnHover ? !__hoverHandler.hovered : true
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
                            active: control.closable
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
                        active: control.progressVisible
                        sourceComponent: AntProgress {
                            percent: (__rootItem.duration - __timer.time) / __rootItem.duration * 100
                            animationEnabled: false
                            infoVisible: false
                        }
                    }
                }
            }
        }

        HoverHandler {
            id: __hoverHandler
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
