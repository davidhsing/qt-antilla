import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

Item {
    id: control

    signal actived(key: string)

    property bool animationEnabled: AntTheme.animationEnabled
    property bool borderVisible: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property var initModel: []
    property alias count: __listModel.count
    property alias spacing: __listView.spacing
    property bool accordion: false
    property var activeKey: accordion ? '' : []
    property var defaultActiveKey: []
    property var expandIcon: AntIcon.RightOutlined || ''
    property font titleFont: Qt.font({
        family: AntTheme.AntCollapse.fontFamily,
        pixelSize: AntTheme.AntCollapse.fontSizeTitle
    })
    property color colorBg: AntTheme.AntCollapse.colorBg
    property color colorIcon: AntTheme.AntCollapse.colorIcon
    property color colorTitle: AntTheme.AntCollapse.colorTitle
    property color colorTitleBg: AntTheme.AntCollapse.colorTitleBg
    property font contentFont: Qt.font({
        family: AntTheme.AntCollapse.fontFamily,
        pixelSize: AntTheme.AntCollapse.fontSizeContent
    })
    property color colorContent: AntTheme.AntCollapse.colorContent
    property color colorContentBg: AntTheme.AntCollapse.colorContentBg
    property color colorBorder: AntTheme.isDark ? AntTheme.AntCollapse.colorBorderDark : AntTheme.AntCollapse.colorBorder
    property AntRadius radiusBg: AntRadius { all: AntTheme.AntCollapse.radiusBg }

    property Component titleDelegate: Row {
        leftPadding: 16
        rightPadding: 16
        height: Math.max(40, __icon.height, __title.height)
        spacing: 8

        AntIconText {
            id: __icon
            anchors.verticalCenter: parent.verticalCenter
            iconSource: control.expandIcon
            colorIcon: control.colorIcon
            rotation: isActive ? 90 : 0

            Behavior on rotation { enabled: control.animationEnabled; RotationAnimation { duration: AntTheme.Primary.durationFast } }
        }

        AntText {
            id: __title
            anchors.verticalCenter: parent.verticalCenter
            text: model.title
            elide: Text.ElideRight
            font: control.titleFont
            color: control.colorTitle
        }

        HoverHandler {
            cursorShape: control.hoverCursorShape
        }
    }
    property Component contentDelegate: AntCopyableText {
        padding: 16
        topPadding: 8
        bottomPadding: 8
        text: model.content
        font: control.contentFont
        wrapMode: Text.WordWrap
        color: control.colorContent
    }

    objectName: '__AntCollapse__'
    height: __listView.contentHeight
    onInitModelChanged: {
        clear();
        for (const object of initModel) {
            append(object);
        }
    }

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    Behavior on colorTitle { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    Behavior on colorTitleBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    Behavior on colorContent { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    Behavior on colorContentBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

    ListView {
        id: __listView
        property real realHeight: 0
        anchors.fill: parent
        interactive: false
        spacing: -1
        model: ListModel { id: __listModel }
        onContentHeightChanged: realHeight = Math.max(contentHeight, 0);
        onRealHeightChanged: cacheBuffer = realHeight;
        delegate: AntRectangleInternal {
            id: __rootItem
            width: __listView.width
            height: __column.height + ((detached && active) ? 1 : 0)
            topLeftRadius: (isFirst || detached) ? control.radiusBg.topLeft : 0
            topRightRadius: (isFirst || detached) ? control.radiusBg.topRight : 0
            bottomLeftRadius: (isLast || detached) ? control.radiusBg.bottomLeft : 0
            bottomRightRadius: (isLast || detached) ? control.radiusBg.bottomRight : 0
            color: control.colorBg
            border.color: control.colorBorder
            border.width: (!detached || !control.borderVisible) ? 0 : 1
            clip: true

            required property var model
            required property int index
            property bool isFirst: index === 0
            property bool isLast: (index + 1) === control.count
            property bool active: false
            property bool detached: __listView.spacing !== -1

            Component.onCompleted: {
                if (control.defaultActiveKey.indexOf(model.key) !== -1) {
                    active = true;
                }
            }

            Column {
                id: __column
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter

                AntRectangleInternal {
                    width: parent.width
                    height: __titleLoader.height
                    topLeftRadius: (isFirst || detached) ? control.radiusBg.topLeft : 0
                    topRightRadius: (isFirst || detached) ? control.radiusBg.topRight : 0
                    bottomLeftRadius: (isLast && !active) || (detached && !active) ? control.radiusBg.bottomLeft : 0
                    bottomRightRadius: (isLast && !active) || (detached && !active) ? control.radiusBg.bottomRight : 0
                    color: control.colorTitleBg
                    border.color: control.colorBorder
                    border.width: !control.borderVisible ? 0 : 1

                    Loader {
                        id: __titleLoader
                        width: parent.width
                        sourceComponent: titleDelegate
                        property alias model: __rootItem.model
                        property alias index: __rootItem.index
                        property alias isActive: __rootItem.active

                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            onTapped: {
                                if (control.accordion) {
                                    for (let i = 0; i < __listView.count; i++) {
                                        const item = __listView.itemAtIndex(i);
                                        if (item && item !== __rootItem) {
                                            item.active = false;
                                        }
                                    }
                                    __rootItem.active = !__rootItem.active;
                                } else {
                                    __rootItem.active = !__rootItem.active;
                                }
                                if (__rootItem.active)
                                    control.actived(__rootItem.model.key);
                                __private.calcActiveKey();
                            }
                        }
                    }
                }

                AntRectangleInternal {
                    width: parent.width - __rootItem.border.width * 2
                    height: active ? __contentLoader.height : 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    bottomLeftRadius: control.radiusBg.bottomLeft
                    bottomRightRadius: control.radiusBg.bottomRight
                    color: control.colorContentBg
                    clip: true

                    Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationFast } }

                    Loader {
                        id: __contentLoader
                        width: parent.width
                        anchors.centerIn: parent
                        sourceComponent: contentDelegate
                        property alias model: __rootItem.model
                        property alias index: __rootItem.index
                        property alias isActive: __rootItem.active
                    }
                }
            }
        }
    }

    Loader {
        anchors.fill: __listView
        active: spacing === -1
        sourceComponent: AntRectangleInternal {
            color: 'transparent'
            border.color: control.colorBorder
            border.width: !control.borderVisible ? 0 : 1
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
        }
    }

    function get(index) {
        return __listModel.get(index);
    }

    function set(index, object) {
        __listModel.set(index, object);
    }

    function setProperty(index, propertyName, value) {
        __listModel.setProperty(index, propertyName, value);
    }

    function move(from, to, count = 1) {
        __listModel.move(from, to, count);
    }

    function insert(index, object) {
        __listModel.insert(index, object);
    }

    function append(object) {
        __listModel.append(object);
    }

    function remove(index, count = 1) {
        __listModel.remove(index, count);
    }

    function clear() {
        __listModel.clear();
    }

    QtObject {
        id: __private
        function calcActiveKey() {
            if (control.accordion) {
                for (let i = 0; i < __listView.count; i++) {
                    const item = __listView.itemAtIndex(i);
                    if (item && item.active) {
                        control.activeKey = item.model.key;
                        break;
                    }
                }
            } else {
                let keys = [];
                for (let i = 0; i < __listView.count; i++) {
                    const item = __listView.itemAtIndex(i);
                    if (item && item.active) {
                        keys.push(item.model.key);
                    }
                }
                control.activeKey = keys;
            }
        }
    }
}
