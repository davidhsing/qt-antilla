pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import Antilla.Basic

Item {
    id: control

    enum MessageType {
        TypeNone = 0,
        TypeInfo = 1,
        TypeSuccess = 2,
        TypeWarning = 3,
        TypeError = 4
    }

    signal closed(key: string)

    property bool animationEnabled: AntTheme.animationEnabled
    property int defaultIconSize: 18
    property bool closable: false
    property int spacing: 10
    property int topMargin: 12
    property int bgTopPadding: 12
    property int bgBottomPadding: 12
    property int bgLeftPadding: 12
    property int bgRightPadding: 12
    property color colorMessage: control.themeSource.colorMessage
    property color colorBg: AntTheme.isDark ? control.themeSource.colorBgDark : control.themeSource.colorBg
    property color colorBgShadow: control.themeSource.colorBgShadow
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }
    property font messageFont: Qt.font({
        family: control.themeSource.fontFamily,
        pixelSize: control.themeSource.fontSize
    })
    property int messageSpacing: 8

    property Component messageDelegate: AntText {
        font: control.messageFont
        color: control.colorMessage
        text: parent.message
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAnywhere
    }
    property var themeSource: AntTheme.AntMessage

    objectName: '__AntMessage__'

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
    Behavior on colorMessage { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }

    Column {
        anchors.top: parent.top
        anchors.topMargin: control.topMargin
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: control.spacing

        Repeater {
            id: __repeater
            model: ListModel { id: __listModel }
            delegate: Item {
                id: __rootItem
                width: __content.width
                height: __content.height
                anchors.horizontalCenter: parent.horizontalCenter

                required property int index
                required property string key
                required property bool loading
                required property string message
                required property int type
                required property int duration
                required property int iconSize
                required property int iconSource
                required property string colorIcon

                function removeSelf() {
                    __content.height = 0;
                    __removeTimer.start();
                }

                Timer {
                    id: __timer
                    running: true
                    interval: __rootItem.duration
                    onTriggered: {
                        __rootItem.removeSelf();
                    }
                }

                AntShadow {
                    anchors.fill: __rootItem
                    source: __bgRect
                    shadowColor: control.colorBgShadow
                }

                AntRectangleInternal {
                    id: __bgRect
                    anchors.fill: parent
                    radius: control.radiusBg.all
                    topLeftRadius: control.radiusBg.topLeft
                    topRightRadius: control.radiusBg.topRight
                    bottomLeftRadius: control.radiusBg.bottomLeft
                    bottomRightRadius: control.radiusBg.bottomRight
                    color: control.colorBg
                    visible: false
                }

                Item {
                    id: __content
                    width: __rowLayout.width + control.bgLeftPadding + control.bgRightPadding
                    height: 0
                    opacity: 0
                    clip: true

                    Component.onCompleted: {
                        opacity = 1;
                        height = Qt.binding(() => __rowLayout.height + control.bgTopPadding + control.bgBottomPadding);
                    }

                    Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }
                    Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }

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
                        width: Math.min(implicitWidth, control.width - control.bgLeftPadding - control.bgRightPadding)
                        anchors.centerIn: parent
                        spacing: control.messageSpacing

                        AntIconText {
                            Layout.alignment: Qt.AlignVCenter
                            iconSize: __rootItem.iconSize
                            iconSource: {
                                if (__rootItem.loading) {
                                    return AntIcon.LoadingOutlined;
                                }
                                if (__rootItem.iconSource !== 0 && __rootItem.iconSource !== '') {
                                    return __rootItem.iconSource;
                                }
                                switch (type) {
                                    case AntMessage.TypeInfo: return AntIcon.InfoCircleFilled;
                                    case AntMessage.TypeSuccess: return AntIcon.CheckCircleFilled;
                                    case AntMessage.TypeWarning: return AntIcon.ExclamationCircleFilled;
                                    case AntMessage.TypeError: return AntIcon.CloseCircleFilled;
                                    default: return 0;
                                }
                            }
                            colorIcon: {
                                if (__rootItem.loading) {
                                    return AntTheme.Primary.colorInfo;
                                }
                                if (__rootItem.colorIcon !== '') {
                                    return __rootItem.colorIcon;
                                }
                                switch (type) {
                                    case AntMessage.TypeInfo: return AntTheme.Primary.colorInfo;
                                    case AntMessage.TypeSuccess: return AntTheme.Primary.colorSuccess;
                                    case AntMessage.TypeWarning: return AntTheme.Primary.colorWarning;
                                    case AntMessage.TypeError: return AntTheme.Primary.colorError;
                                    default: return AntTheme.Primary.colorInfo;
                                }
                            }

                            NumberAnimation on rotation {
                                running: __rootItem.loading
                                from: 0
                                to: 360
                                loops: Animation.Infinite
                                duration: 1000
                                onRunningChanged: {
                                    if (!running && !__rootItem.loading) {
                                        rotation = 0;
                                    }
                                }
                            }
                        }

                        Loader {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            sourceComponent: control.messageDelegate
                            property alias index: __rootItem.index
                            property alias key: __rootItem.key
                            property alias message: __rootItem.message
                        }

                        Loader {
                            Layout.alignment: Qt.AlignVCenter
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
                }
            }
        }
    }

    QtObject {
        id: __private

        function initObject(object: var): var {
            if (!object.hasOwnProperty('key')) {
                object.key = '';
            }
            if (!object.hasOwnProperty('loading')) {
                object.loading = false;
            }
            if (!object.hasOwnProperty('message')) {
                object.message = '';
            }
            if (!object.hasOwnProperty('type')) {
                object.type = AntMessage.TypeNone;
            }
            if (!object.hasOwnProperty('duration')) {
                object.duration = 3000;
            }
            if (!object.hasOwnProperty('iconSize')) {
                object.iconSize = control.defaultIconSize;
            }
            if (!object.hasOwnProperty('iconSource')) {
                object.iconSource = 0;
            }
            object.colorIcon = !object.hasOwnProperty('colorIcon') ? '' : String(object.colorIcon);
            return object;
        }
    }

    function info(message: string, duration = 3000): void {
        control.open({
            'message': message,
            'type': AntMessage.TypeInfo,
            'duration': duration
        });
    }

    function success(message: string, duration = 3000): void {
        control.open({
            'message': message,
            'type': AntMessage.TypeSuccess,
            'duration': duration
        });
    }

    function error(message: string, duration = 3000): void {
        control.open({
            'message': message,
            'type': AntMessage.TypeError,
            'duration': duration
        });
    }

    function warning(message: string, duration = 3000): void {
        control.open({
            'message': message,
            'type': AntMessage.TypeWarning,
            'duration': duration
        });
    }

    function loading(message: string, duration = 3000): void {
        control.open({
            'loading': true,
            'message': message,
            'type': AntMessage.TypeInfo,
            'duration': duration
        });
    }

    function open(object): void {
        __listModel.append(__private.initObject(object));
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

    function getMessage(key: string): var {
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
