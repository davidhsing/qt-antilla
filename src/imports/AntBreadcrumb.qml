import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

Item {
    id: control

    signal clicked(index: int, data: var)
    signal menuClicked(deep: int, key: string, keyPath: var, data: var)

    property bool animationEnabled: AntTheme.animationEnabled
    property bool allowHoverTap: true
    property bool copyable: false
    property var initModel: []
    readonly property int count: __listModel.count
    property string separator: '/'
    property int spacing: 4
    property font titleFont
    property int defaultIconSize: control.themeSource.fontIconSize
    property int defaultMenuWidth: 120
    property AntRadius radiusItemBg: AntRadius { all: control.themeSource.radiusItemBg }

    property Component itemDelegate: AntRectangleInternal {
        id: __itemDelegate

        implicitWidth: __itemRow.implicitWidth + 8
        implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight) + 4
        color: (isCurrent || !__hoverHandler.hovered || !control.allowHoverTap) ? control.themeSource.colorBgLast : control.themeSource.colorBg;
        radius: control.radiusItemBg.all
        topLeftRadius: control.radiusItemBg.topLeft
        topRightRadius: control.radiusItemBg.topRight
        bottomLeftRadius: control.radiusItemBg.bottomLeft
        bottomRightRadius: control.radiusItemBg.bottomRight

        property int __index: index
        property var menu: model.menu ?? {}
        property var menuItem: menu.items ?? []

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

        Row {
            id: __itemRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            AntIconText {
                id: __icon
                anchors.verticalCenter: parent.verticalCenter
                iconSize: model.iconSize
                iconSource: model.loading ? AntIcon.LoadingOutlined : model.iconSource
                colorIcon: (isCurrent || __hoverHandler.hovered) ? control.themeSource.colorIconLast : control.themeSource.colorIcon;
                verticalAlignment: Text.AlignVCenter

                NumberAnimation on rotation {
                    running: model.loading
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1000
                    onRunningChanged: {
                        if (!running && !model.loading) {
                            __icon.rotation = 0;
                        }
                    }
                }

                Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
            }

            AntCopyableText {
                id: __text
                anchors.verticalCenter: parent.verticalCenter
                text: model.title
                font: control.titleFont
                enabled: isCurrent
                color: __icon.color
                copyable: control.copyable

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
            }

            Loader {
                anchors.verticalCenter: parent.verticalCenter
                active: __itemDelegate.menuItem.length > 0
                sourceComponent: AntIconText {
                    color: isCurrent || __hoverHandler.hovered ? control.themeSource.colorIconLast : control.themeSource.colorIcon;
                    iconSource: AntIcon.DownOutlined
                    verticalAlignment: Text.AlignVCenter

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
                }
            }
        }

        HoverHandler {
            id: __hoverHandler
            cursorShape: (isCurrent || !control.allowHoverTap) ? Qt.ArrowCursor : Qt.PointingHandCursor
            onHoveredChanged: {
                if (hovered && control.allowHoverTap) {
                    __private.hover(index);
                }
            }
        }

        TapHandler {
            id: __tapHandler
            enabled: !isCurrent && control.allowHoverTap
            onTapped: control.clicked(index, model);
        }

        Loader {
            active: __itemDelegate.menuItem.length > 0
            sourceComponent: AntContextMenu {
                id: __menu
                parent: __itemDelegate
                tooltipVisible: true
                initModel: __itemDelegate.menuItem
                defaultMenuWidth: __itemDelegate.menu.width ?? control.defaultMenuWidth
                closePolicy: AntPopup.NoAutoClose | AntPopup.CloseOnPressOutsideParent | AntPopup.CloseOnEscape
                onHoveredChanged: {
                    if (hovered) {
                        x = (parent.width - implicitWidth) / 2;
                        y = parent.height + 2;
                        open();
                    }
                }
                onMenuClicked: (deep, key, keyPath, data) => control.menuClicked(deep, key, keyPath, data);
                Component.onCompleted: AntApi.setPopupAllowAutoFlip(this);
                property bool hovered: __hoverHandler.hovered

                Connections {
                    target: __private
                    function onHover(index) {
                        if (__itemDelegate.__index !== index && __menu.opened) {
                            __menu.close();
                        }
                    }
                }
            }
        }
    }
    property Component separatorDelegate: AntText {
        text: model.separator ?? ''
        color: control.themeSource.colorIcon
    }
    property var themeSource: AntTheme.AntBreadcrumb

    objectName: '__AntBreadcrumb__'
    height: 30
    titleFont {
        family: control.themeSource.fontFamily
        pixelSize: control.themeSource.fontTextSize
    }
    onInitModelChanged: reset();

    ListView{
        id: __listView
        width: parent.width
        height: parent.height
        orientation: ListView.Horizontal
        model: ListModel { id: __listModel }
        clip: true
        spacing: control.spacing
        boundsBehavior: ListView.StopAtBounds
        add: Transition {
            NumberAnimation {
                properties: 'opacity'
                from: 0
                to: 1
                duration: control.animationEnabled ? AntTheme.Primary.durationFast : 0
            }
        }
        remove: Transition {
            NumberAnimation {
                properties: 'opacity'
                from: 1
                to: 0
                duration: control.animationEnabled ? AntTheme.Primary.durationFast : 0
            }
        }
        delegate: Item {
            id: __rootItem
            width: __row.implicitWidth
            height: __listView.height

            required property int index
            required property var model
            property bool isCurrent: (index + 1) === __listModel.count

            Row {
                id: __row
                width: parent.width
                height: parent.height
                spacing: control.spacing

                Loader {
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: model.itemDelegate
                    property alias index: __rootItem.index
                    property alias model: __rootItem.model
                    property alias isCurrent: __rootItem.isCurrent
                }

                Loader {
                    anchors.verticalCenter: parent.verticalCenter
                    active: index + 1 !== __listModel.count
                    sourceComponent: model.separatorDelegate
                    property alias index: __rootItem.index
                    property alias model: __rootItem.model
                    property alias isCurrent: __rootItem.isCurrent
                }
            }
        }
    }

    function get(index) {
        return __listModel.get(index);
    }

    function set(index, object) {
        __listModel.set(index, __private.initObject(object));
    }

    function setProperty(index, propertyName, value) {
        __listModel.setProperty(index, propertyName, value);
    }

    function move(from, to, count = 1) {
        __listModel.move(from, to, count);
    }

    function insert(index, object) {
        __listModel.insert(index, __private.initObject(object));
    }

    function append(object) {
        __listModel.append(__private.initObject(object));
    }

    function remove(index, count = 1) {
        __listModel.remove(index, count);
    }

    function clear() {
        __listModel.clear();
    }

    function clearButFirst() {
        if (__listModel.count > 1) {
            __listModel.remove(1, __listModel.count - 1);
        }
    }

    function reset() {
        clear();
        for (const object of initModel) {
            append(object);
        }
    }

    function getPath() {
        let path = '';
        for (let i = 0; i < __listModel.count; i++) {
            path += __listModel.get(i).title + ((i + 1 !== count) ? __listModel.get(i).separator : '');
        }
        return path;
    }

    QtObject {
        id: __private
        signal hover(index: int)
        function initObject(object) {
            if (!object.hasOwnProperty('title')) object.title = '';

            if (!object.hasOwnProperty('iconSource')) object.iconSource = 0;
            if (!object.hasOwnProperty('iconUrl')) object.iconUrl = '';
            if (!object.hasOwnProperty('iconSize')) object.iconSize = control.defaultIconSize;
            if (!object.hasOwnProperty('loading')) object.loading = false;

            if (!object.hasOwnProperty('separator')) object.separator = control.separator;
            if (!object.hasOwnProperty('itemDelegate')) object.itemDelegate = control.itemDelegate;
            if (!object.hasOwnProperty('separatorDelegate')) object.separatorDelegate = control.separatorDelegate;

            if (!object.hasOwnProperty('menu')) object.menu = {};

            return object;
        }
    }
}
