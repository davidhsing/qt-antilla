import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

Item {
    id: control

    signal menuClicked(deep: int, key: string, keyPath: var, data: var)

    property bool animationEnabled: AntTheme.animationEnabled
    property bool borderVisible: false
    property bool compactMode: false
    property int compactWidth: 50
    property bool popupMode: false
    property int popupWidth: 200
    property int popupOffset: 4
    property int popupMaxHeight: control.height
    property int defaultMenuIconSize: control.themeSource.fontIconSize
    property int defaultMenuIconSpacing: 8
    property int defaultMenuTextSize: control.themeSource.fontTextSize
    property int defaultMenuWidth: 300
    property int defaultMenuHeight: 40
    property int defaultMenuSpacing: 4
    property var defaultSelectedKey: []
    property var initModel: []
    property bool hoverToExpand: false
    property bool keepIconPlace: true
    property bool tooltipVisible: false
    property AntMargin marginContent: AntMargin { all: 5; right: 8 }
    property alias scrollBar: __menuScrollBar
    property color colorBorder: control.themeSource.colorBorder
    property AntRadius radiusMenuBg: AntRadius { all: control.themeSource.radiusMenuBg }
    property AntRadius radiusPopupBg: AntRadius { all: control.themeSource.radiusPopupBg }
    property string ariaConstrual: ''

    property Component menuIconDelegate: AntIconText {
        color: menuButton.colorText
        iconSize: menuButton.iconSize
        iconSource: menuButton.iconSource
        verticalAlignment: Text.AlignVCenter

        Behavior on x {
            enabled: control.animationEnabled
            NumberAnimation { easing.type: Easing.OutCubic; duration: AntTheme.Primary.durationMid }
        }
        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    }
    property Component menuLabelDelegate: AntText {
        text: menuButton.text
        font: menuButton.font
        color: menuButton.colorText
        elide: Text.ElideRight

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    }
    property Component menuBgDelegate: AntRectangleInternal {
        radius: control.radiusMenuBg.all
        topLeftRadius: control.radiusMenuBg.topLeft
        topRightRadius: control.radiusMenuBg.topRight
        bottomLeftRadius: control.radiusMenuBg.bottomLeft
        bottomRightRadius: control.radiusMenuBg.bottomRight
        color: menuButton.colorBg
        border.color: menuButton.colorBorder

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
        Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
    }
    property Component menuContentDelegate: Item {
        id: __menuContentItem
        property var __menuButton: menuButton

        Loader {
            id: __iconLoader
            x: menuButton.iconStart
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: menuButton.iconDelegate
            active: menuButton.keepIconPlace || __private.hasDirectIcon
            visible: active
            property var model: __menuButton.model
            property alias menuButton: __menuContentItem.__menuButton
        }

        Loader {
            id: __labelLoader
            anchors.left: (menuButton.keepIconPlace || __private.hasDirectIcon) ? __iconLoader.right : parent.left
            anchors.leftMargin: (menuButton.keepIconPlace || __private.hasDirectIcon) ? menuButton.iconSpacing : 0
            anchors.right: menuButton.expandedVisible ? __expandedIcon.left : parent.right
            anchors.rightMargin: menuButton.iconSpacing
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: menuButton.labelDelegate
            property var model: __menuButton.model
            property alias menuButton: __menuContentItem.__menuButton
        }

        AntIconText {
            id: __expandedIcon
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            visible: menuButton.expandedVisible
            iconSource: (control.compactMode || control.popupMode) ? AntIcon.RightOutlined : AntIcon.DownOutlined
            colorIcon: menuButton.colorText
            transform: Rotation {
                origin {
                    x: __expandedIcon.width / 2
                    y: __expandedIcon.height / 2
                }
                axis {
                    x: 1
                    y: 0
                    z: 0
                }
                angle: (control.compactMode || control.popupMode) ? 0 : (menuButton.expanded ? 180 : 0)
                Behavior on angle { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }
            }
            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
        }
    }
    property var themeSource: AntTheme.AntMenu

    objectName: '__AntMenu__'
    implicitWidth: compactMode ? compactWidth : defaultMenuWidth
    implicitHeight: __listView.contentHeight + control.marginContent.top + control.marginContent.bottom
    clip: true

    onInitModelChanged: {
        __listView.model = initModel;
        if (!control.keepIconPlace) {
            __private.hasDirectIcon = __private.checkDirectIcon(control.initModel);
        }
    }

    component MenuButton: AntButton {
        id: __menuButtonImpl

        property var iconSource: 0 ?? ''
        property int iconSize: control.themeSource.fontIconSize
        property int iconSpacing: 5
        property int iconStart: 0
        property bool expanded: false
        property bool expandedVisible: false
        property bool isCurrent: false
        property bool isGroup: false
        property bool keepIconPlace: false
        property var model: undefined
        property var iconDelegate: null
        property var labelDelegate: null
        property var contentDelegate: null
        property var bgDelegate: null

        hoverCursorShape: (isGroup && !control.compactMode) ? Qt.ArrowCursor : Qt.PointingHandCursor
        animationEnabled: control.animationEnabled
        effectEnabled: false
        colorBorder: 'transparent'
        colorText: {
            if (!enabled) {
                return control.themeSource.colorTextDisabled;
            }
            if (isGroup) {
                return (isCurrent && control.compactMode) ? control.themeSource.colorTextActive : control.themeSource.colorTextDisabled;
            }
            return isCurrent ? control.themeSource.colorTextActive : control.themeSource.colorText;
        }
        colorBg: {
            if (!enabled) {
                return control.themeSource.colorBgDisabled;
            }
            if (isGroup) {
                return (isCurrent && control.compactMode) ? control.themeSource.colorBgActive : control.themeSource.colorBgDisabled;
            } else if (isCurrent)
                return control.themeSource.colorBgActive;
            else if (hovered) {
                return control.themeSource.colorBgHover;
            }
            return control.themeSource.colorBg;
        }
        contentItem: Loader {
            sourceComponent: __menuButtonImpl.contentDelegate
            property alias model: __menuButtonImpl.model
            property alias menuButton: __menuButtonImpl
        }
        background: Loader {
            sourceComponent: __menuButtonImpl.bgDelegate
            property alias model: __menuButtonImpl.model
            property alias menuButton: __menuButtonImpl
        }
        onClicked: {
            if (expandedVisible) {
                expanded = !expanded;
            }
        }
    }

    Behavior on width {
        enabled: control.animationEnabled
        NumberAnimation {
            easing.type: Easing.OutCubic
            duration: AntTheme.Primary.durationMid
        }
    }

    Behavior on implicitWidth {
        enabled: control.animationEnabled
        NumberAnimation {
            easing.type: Easing.OutCubic
            duration: AntTheme.Primary.durationMid
        }
    }

    Component {
        id: __menuDelegate

        Item {
            id: __rootItem
            width: ListView.view.width
            height: {
                switch (menuType) {
                case 'item':
                case 'group':
                    return __layout.height;
                case 'divider':
                    return __dividerLoader.height;
                default:
                    return __layout.height;
                }
            }
            clip: true
            Component.onCompleted: {
                if (menuType == 'item' || menuType == 'group') {
                    layerPopup = __private.createPopupList(view.menuDeep);
                    for (let i = 0; i < menuChildren.length; i++) {
                        __childrenListView.model.push(menuChildren[i]);
                    }
                    if (control.defaultSelectedKey.length != 0) {
                        if (control.defaultSelectedKey.indexOf(menuKey) != -1) {
                            __rootItem.expandParent();
                            __menuButton.clicked();
                        }
                    }
                }
                if (__rootItem.menuKey !== '' && __rootItem.menuKey === __private.gotoMenuKey) {
                    __rootItem.expandParent();
                    __menuButton.clicked();
                }
            }

            required property var modelData
            property alias model: __rootItem.modelData
            property var view: ListView.view
            property var menuControl: control
            property string menuKey: model.key || ''
            property string menuType: model.type || 'item'
            property bool menuEnabled: model.enabled === undefined ? true : model.enabled
            property string menuLabel: model.label || ''
            property int menuHeight: model.height || defaultMenuHeight
            property int menuIconSize: model.iconSize || defaultMenuIconSize
            property var menuIconSource: model.iconSource || 0
            property int menuIconSpacing: model.iconSpacing || defaultMenuIconSpacing
            property var menuChildren: model.children || []
            property int menuChildrenLength: menuChildren ? menuChildren.length : 0
            property var menuIconDelegate: model.iconDelegate ?? control.menuIconDelegate
            property var menuLabelDelegate: model.labelDelegate ?? control.menuLabelDelegate
            property var menuContentDelegate: model.contentDelegate ?? control.menuContentDelegate
            property var menuBgDelegate: model.bgDelegate ?? control.menuBgDelegate
            property bool menuKeepIconPlace: model.keepIconPlace !== undefined ? model.keepIconPlace : control.keepIconPlace

            property var parentMenu: view.menuDeep === 0 ? null : view.parentMenu
            property var keyPath: parentMenu ? [...parentMenu.keyPath, menuKey] : [menuKey]
            property bool isCurrent: __private.selectedItem === __rootItem || isCurrentParent
            property bool isCurrentParent: false
            property var layerPopup: null

            Timer {
                id: __hoverExitTimer
                interval: 100
                onTriggered: {
                    // 检查是否鼠标进入了子菜单 popup
                    if (__rootItem.layerPopup && __rootItem.layerPopup.popupHoverHandler &&
                        !__rootItem.layerPopup.popupHoverHandler.hovered) {
                        // 鼠标没有进入子菜单，关闭子菜单
                        __rootItem.layerPopup.close();
                    }
                }
            }

            function handleMenuClick() {
                control.menuClicked(view.menuDeep, menuKey, keyPath, model);
            }

            function expandMenu() {
                if (__menuButton.expandedVisible) {
                    __menuButton.expanded = true;
                }
                __rootItem.handleMenuClick();
            }

            /*! 查找当前菜单的根菜单 */
            function findRootMenu() {
                let parent = parentMenu;
                while (parent !== null) {
                    if (parent.parentMenu === null)
                        return parent;
                    parent = parent.parentMenu;
                }
                /*! 根菜单返回自身 */
                return __rootItem;
            }
            /*! 展开当前菜单的所有父菜单 */
            function expandParent() {
                let parent = parentMenu;
                while (parent !== null) {
                    if (parent.parentMenu === null) {
                        parent.expandMenu();
                        return;
                    }
                    parent.expandMenu();
                    parent = parent.parentMenu;
                }
            }
            /*! 清除当前菜单的所有子菜单 */
            function clearIsCurrentParent() {
                isCurrentParent = false;
                for (let i = 0; i < __childrenListView.count; i++) {
                    let item = __childrenListView.itemAtIndex(i);
                    if (item)
                        item.clearIsCurrentParent();
                }
            }
            /*! 选中当前菜单的所有父菜单 */
            function selectedCurrentParentMenu() {
                for (let i = 0; i < __listView.count; i++) {
                    let item = __listView.itemAtIndex(i);
                    if (item)
                        item.clearIsCurrentParent();
                }
                let parent = parentMenu;
                while (parent !== null) {
                    parent.isCurrentParent = true;
                    if (parent.parentMenu === null)
                        return;
                    parent = parent.parentMenu;
                }
            }

            Connections {
                target: __private
                enabled: __rootItem.menuKey !== ''
                ignoreUnknownSignals: true

                function onGotoMenu(key) {
                    if (__rootItem.menuKey === key) {
                        __rootItem.expandParent();
                        __menuButton.clicked();
                    }
                }

                function onSetData(key, data) {
                    if (__rootItem.menuKey === key) {
                        __rootItem.model = data;
                        __rootItem.modelChanged();
                    }
                }

                function onSetDataProperty(key, propertyName, value) {
                    if (__rootItem.menuKey === key) {
                        __rootItem.model[propertyName] = value;
                        __rootItem.modelChanged();
                    }
                }
            }

            Loader {
                id: __dividerLoader
                height: 5
                width: parent.width
                active: __rootItem.menuType == 'divider'
                sourceComponent: AntDivider {
                    animationEnabled: control.animationEnabled
                }
            }

            Rectangle {
                id: __layout
                width: parent.width
                height: __menuButton.height + ((control.compactMode || control.popupMode) ? 0 : __childrenListView.height)
                anchors.top: parent.top
                color: (view.menuDeep === 0 || control.compactMode || control.popupMode) ? 'transparent' : control.themeSource.colorChildBg
                visible: menuType == 'item' || menuType == 'group'

                MenuButton {
                    id: __menuButton
                    width: parent.width
                    height: __rootItem.menuHeight + control.defaultMenuSpacing
                    topInset: control.defaultMenuSpacing / 2
                    leftPadding: 15 + (control.compactMode || control.popupMode ? 0 : iconSize * __rootItem.view.menuDeep)
                    bottomInset: control.defaultMenuSpacing / 2
                    enabled: __rootItem.menuEnabled
                    radiusBg: control.radiusMenuBg
                    text: (control.compactMode && __rootItem.view.menuDeep === 0) ? '' : __rootItem.menuLabel
                    checkable: true
                    font.pixelSize: control.defaultMenuTextSize
                    iconSize: __rootItem.menuIconSize
                    iconSource: __rootItem.menuIconSource
                    iconSpacing: __rootItem.menuIconSpacing
                    iconStart: (control.compactMode && __rootItem.view.menuDeep === 0) ? (width - iconSize - leftPadding - rightPadding) / 2 : 0
                    keepIconPlace: __rootItem.menuKeepIconPlace
                    expandedVisible: {
                        if (__rootItem.menuType == 'group' ||
                                (control.compactMode && __rootItem.view.menuDeep === 0))
                            return false;
                        else
                            return __rootItem.menuChildrenLength > 0
                    }
                    isCurrent: __rootItem.isCurrent
                    isGroup: __rootItem.menuType == 'group'
                    model: __rootItem.model
                    iconDelegate: __rootItem.menuIconDelegate
                    labelDelegate: __rootItem.menuLabelDelegate
                    contentDelegate: __rootItem.menuContentDelegate
                    bgDelegate: __rootItem.menuBgDelegate
                    onHoveredChanged: {
                        if (control.hoverToExpand) {
                            if (__rootItem.menuChildrenLength > 0 && hovered) {
                                // 鼠标进入有子菜单的项，关闭比当前层级更深的所有菜单
                                __private.closeInactiveMenus(view.menuDeep);
                                // 更新当前悬停项
                                __private.hoveredMenuItem = __rootItem;
                                __rootItem.handleMenuClick();
                                if (__rootItem.menuControl.compactMode || __rootItem.menuControl.popupMode) {
                                    const h = __rootItem.layerPopup.topPadding +
                                            __rootItem.layerPopup.bottomPadding +
                                            __childrenListView.realHeight + 6;
                                    const pos = mapToItem(null, 0, 0);
                                    const pos2 = mapToItem(__rootItem.menuControl, 0, 0);
                                    if ((pos.y + h) > __private.window.height) {
                                        __rootItem.layerPopup.y = Math.max(0, pos2.y - ((pos.y + h) - __private.window.height));
                                    } else {
                                        __rootItem.layerPopup.y = pos2.y;
                                    }
                                    __rootItem.layerPopup.current = __childrenListView;
                                    __rootItem.layerPopup.open();
                                }
                            } else if (hovered && __rootItem.menuChildrenLength === 0) {
                                // 鼠标进入没有子菜单的项
                                // popupList[i] 对应的是 menuDeep = i+1 的菜单项打开的子菜单
                                // 所以要关闭从当前层级的子菜单开始的所有 popup
                                __private.closeInactiveMenus(view.menuDeep - 1);
                            } else if (!hovered) {
                                // 鼠标离开当前项，延迟检查是否关闭子菜单
                                if (__rootItem.layerPopup && __rootItem.layerPopup.opened && __rootItem.__hoverExitTimer) {
                                    // 停止之前的 timer（如果有）
                                    __rootItem.__hoverExitTimer.stop();
                                    // 启动延迟检查，给用户时间移动到子菜单
                                    __rootItem.__hoverExitTimer.restart();
                                }
                            }
                        }
                    }
                    onClicked: {
                        __rootItem.handleMenuClick();
                        if (__rootItem.menuChildrenLength == 0) {
                            __private.selectedItem = __rootItem;
                            __rootItem.selectedCurrentParentMenu();
                            if (__rootItem.menuControl.compactMode || __rootItem.menuControl.popupMode) {
                                __rootItem.layerPopup.closeWithParent();
                            }
                        } else {
                            if (__rootItem.menuControl.compactMode || __rootItem.menuControl.popupMode) {
                                const h = __rootItem.layerPopup.topPadding +
                                        __rootItem.layerPopup.bottomPadding +
                                        __childrenListView.realHeight + 6;
                                const pos = mapToItem(null, 0, 0);
                                const pos2 = mapToItem(__rootItem.menuControl, 0, 0);
                                if ((pos.y + h) > __private.window.height) {
                                    __rootItem.layerPopup.y = Math.max(0, pos2.y - ((pos.y + h) - __private.window.height));
                                } else {
                                    __rootItem.layerPopup.y = pos2.y;
                                }
                                __rootItem.layerPopup.current = __childrenListView;
                                __rootItem.layerPopup.open();
                            }
                        }
                    }

                    AntToolTip {
                        visible: control.tooltipVisible ? parent.hovered : false
                        animationEnabled: control.animationEnabled
                        position: control.compactMode || control.popupMode ? AntToolTip.PositionRight : AntToolTip.PositionBottom
                        text: __rootItem.menuLabel
                        delay: 500
                    }
                }

                ListView {
                    id: __childrenListView
                    visible: __rootItem.menuEnabled
                    parent: {
                        if (__rootItem.layerPopup && __rootItem.layerPopup.current === __childrenListView)
                            return __rootItem.layerPopup.contentItem;
                        else
                            return __layout;
                    }
                    height: {
                        if (__rootItem.menuType == 'group' || __menuButton.expanded)
                            return realHeight;
                        else if (parent != __layout)
                            return parent.height;
                        else
                            return 0;
                    }
                    anchors.top: parent ? (parent == __layout ? __menuButton.bottom : parent.top) : undefined
                    anchors.left: parent ? parent.left : undefined
                    anchors.right: parent ? parent.right : undefined
                    boundsBehavior: Flickable.StopAtBounds
                    interactive: __childrenListView.visible
                    model: []
                    delegate: __menuDelegate
                    onContentHeightChanged: cacheBuffer = contentHeight;
                    T.ScrollBar.vertical: AntScrollBar {
                        id: childrenScrollBar
                        visible: (control.compactMode || control.popupMode) && childrenScrollBar.size !== 1
                        animationEnabled: control.animationEnabled
                    }
                    clip: true
                    /* 子 ListView 从父 ListView 的深度累加可实现自动计算 */
                    property int menuDeep: __rootItem.view.menuDeep + 1
                    property var parentMenu: __rootItem
                    property int realHeight: contentHeight

                    Behavior on height {
                        enabled: control.animationEnabled
                        NumberAnimation { duration: AntTheme.Primary.durationFast }
                    }

                    Connections {
                        target: control
                        function onCompactModeChanged() {
                            if (__rootItem.layerPopup) {
                                __rootItem.layerPopup.current = null;
                                __rootItem.layerPopup.close();
                            }
                        }
                        function onPopupModeChanged() {
                            if (__rootItem.layerPopup) {
                                __rootItem.layerPopup.current = null;
                                __rootItem.layerPopup.close();
                            }
                        }
                    }
                }
            }
        }
    }

    Item {
        id: __private

        signal gotoMenu(key: string)
        signal setData(key: string, data: var)
        signal setDataProperty(key: string, propertyName: string, value: var)

        property string gotoMenuKey: ''
        property var window: Window.window
        property var selectedItem: null
        property var popupList: []
        property bool hasDirectIcon: false
        property var hoveredMenuItem: null  // 当前鼠标悬停的菜单项
        property var activeMenuPath: []    // 当前激活的菜单路径（每个元素是菜单项的 key）

        function createPopupList(deep) {
            /*! 为每一层创建一个弹窗 */
            if (popupList[deep] === undefined) {
                let parentPopup = deep > 0 ? popupList[deep - 1] : null;
                popupList[deep] = __popupComponent.createObject(control, {
                    parentPopup: parentPopup,
                    deep: deep
                });
            }
            return popupList[deep];
        }

        // 获取指定 popup 的子 popup
        function getChildPopup(popup) {
            if (!popup) return null;
            let popupDeep = popup.deep;
            if (popupDeep !== undefined && popupList[popupDeep + 1] !== undefined) {
                // 检查下一个层级的 popup 是否以当前 popup 为父级
                let childPopup = popupList[popupDeep + 1];
                if (childPopup.parentPopup === popup) {
                    return childPopup;
                }
            }
            return null;
        }

        // 检查是否有任何一个 popup 被 hover
        function hasAnyPopupHovered() {
            for (let i = 0; i < popupList.length; i++) {
                if (popupList[i] && popupList[i].popupHoverHandler && popupList[i].popupHoverHandler.hovered) {
                    return true;
                }
            }
            return false;
        }

        // 关闭所有子菜单（包括 deep >= 0 的所有 popup）
        function closeAllSubMenus() {
            for (let i = 0; i < popupList.length; i++) {
                if (popupList[i]) {
                    popupList[i].close();
                }
            }
        }

        // 关闭不在激活路径上的菜单
        function closeInactiveMenus(keepDeep) {
            for (let i = keepDeep + 1; i < popupList.length; i++) {
                if (popupList[i]) {
                    popupList[i].close();
                }
            }
        }

        // 检查直接下级菜单项是否有图标的函数（不递归）  
        function checkDirectIcon(model) {
            if (!model || !Array.isArray(model)) {
                return false;
            }
            for (let i = 0; i < model.length; i++) {
                const item = model[i];
                const icon = item.iconSource !== 0 && ((typeof item.iconSource === 'string' && item.iconSource !== '') || (typeof item.iconSource === 'object' && item.iconSource.toString() !== ''));
                if (icon) {
                    return true;
                }
            }
            return false;
        }
    }

    Loader {
        width: 1
        height: parent.height
        anchors.right: parent.right
        active: control.borderVisible
        sourceComponent: Rectangle {
            color: control.colorBorder
        }
    }

    MouseArea {
        anchors.fill: parent
        onWheel: (wheel) => wheel.accepted = true;
    }

    Component {
        id: __popupComponent

        AntPopup {
            width: control.popupWidth
            height: current ? Math.min(control.popupMaxHeight, current.realHeight + topPadding + bottomPadding) : 0
            padding: 5
            animationEnabled: control.animationEnabled
            radiusBg: control.radiusPopupBg
            contentItem: Item {
                clip: true

                HoverHandler {
                    id: __popupHoverHandler
                }

                Timer {
                    id: __hoverTimer
                    interval: 100
                    onTriggered: {
                        if (control.hoverToExpand && !__popupHoverHandler.hovered) {
                            // 检查是否有任何一个 popup 被 hover
                            if (!__private.hasAnyPopupHovered()) {
                                // 没有任何 popup 被鼠标 hover，关闭所有子菜单（deep > 0）
                                __private.closeAllSubMenus();
                            }
                        }
                    }
                }

                Connections {
                    target: __popupHoverHandler
                    function onHoveredChanged() {
                        if (!__popupHoverHandler.hovered) {
                            __hoverTimer.restart();
                        } else {
                            __hoverTimer.stop();
                        }
                    }
                }
            }
            onAboutToShow: {
                let toX = control.width + control.popupOffset;
                if (parentPopup) {
                    toX += parentPopup.width + control.popupOffset;
                }
                const pos = mapToItem(null, toX, 0);
                if (pos.x + width > __private.window.width) {
                    if (parentPopup) {
                        x = parentPopup.x - parentPopup.width - control.popupOffset;
                    } else {
                        x = -width - control.popupOffset;
                    }
                } else {
                    x = toX;
                }
            }
            property var current: null
            property var parentPopup: null
            property int deep: -1
            property alias popupHoverHandler: __popupHoverHandler
            function closeWithParent() {
                close();
                let p = parentPopup;
                while (p) {
                    p.close();
                    p = p.parentPopup;
                }
            }
            function closeWithChildren() {
                close();
                let childPopup = __private.getChildPopup(this);
                while (childPopup) {
                    childPopup.close();
                    childPopup = __private.getChildPopup(childPopup);
                }
            }
        }
    }

    ListView {
        id: __listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: control.marginContent.top
        anchors.bottomMargin: control.marginContent.bottom
        anchors.leftMargin: control.marginContent.left
        anchors.rightMargin: control.marginContent.right
        boundsBehavior: Flickable.StopAtBounds
        model: []
        delegate: __menuDelegate
        onContentHeightChanged: cacheBuffer = contentHeight;
        T.ScrollBar.vertical: AntScrollBar {
            id: __menuScrollBar
            anchors.rightMargin: -8
            policy: T.ScrollBar.AsNeeded
            animationEnabled: control.animationEnabled
        }
        property int menuDeep: 0
    }

    Accessible.role: Accessible.Tree
    Accessible.description: control.ariaConstrual

    function gotoMenu(key) {
        __private.gotoMenuKey = key;
        __private.gotoMenu(key);
    }

    function get(index) {
        if (index >= 0 && index < __listView.model.length) {
            return __listView.model[index];
        }
        return undefined;
    }

    function set(index, object) {
        if (index >= 0 && index < __listView.model.length) {
            __listView.model[index] = object;
            __listView.modelChanged();
        }
    }

    function setProperty(index, propertyName, value) {
        if (index >= 0 && index < __listView.model.length) {
            __listView.model[index][propertyName] = value;
            __listView.modelChanged();
        }
    }

    /*
    function getData(key) {
        const findItemFunc = list => {
            for (const item of list) {
                if (item.hasOwnProperty('key') && item.key === key) {
                    return item;
                } else {
                    if (item.hasOwnProperty('children')) {
                        const data = findItemFunc(item.children);
                        if (data !== undefined) {
                            return data;
                        }
                    }
                }
            }
            return undefined;
        }

        return findItemFunc(__listView.model);
    }
    */

    function setData(key, data) {
        const setItemFunc = list => {
            for (let i = 0; i < list.length; i++) {
                let item = list[i];
                if (item.hasOwnProperty('key') && item.key === key) {
                    list[i] = data;
                    return true;
                } else {
                    if (item.hasOwnProperty('children')) {
                        if (setItemFunc(item.children)) {
                            return true;
                        }
                    }
                }
            }
            return false;
        }
        if (setItemFunc(__listView.model)) {
            __private.setData(key, data);
        }
    }

    function setDataProperty(key, propertyName, value) {
        const setItemFunc = list => {
            for (let i = 0; i < list.length; i++) {
                let item = list[i];
                if (item.hasOwnProperty('key') && item.key === key) {
                    list[i][propertyName] = value;
                    return true;
                } else {
                    if (item.hasOwnProperty('children')) {
                        if (setItemFunc(item.children)) {
                            return true;
                        }
                    }
                }
            }
            return false;
        }
        if (setItemFunc(__listView.model)) {
            __private.setDataProperty(key, propertyName, value);
        }
    }

    function move(from, to, count = 1) {
        if (from >= 0 && from < __listView.model.length && to >= 0 && to < __listView.model.length) {
            const objects = __listView.model.splice(from, count);
            __listView.model.splice(to, 0, ...objects);
            __listView.modelChanged();
        }
    }

    function insert(index, object) {
        __listView.model.splice(index, 0, object);
        __listView.modelChanged();
    }

    function append(object) {
        __listView.model.push(object);
        __listView.modelChanged();
    }

    function remove(index, count = 1) {
        if (index >= 0 && index < __listView.model.length) {
            __listView.model.splice(index, count);
            __listView.modelChanged();
        }
    }

    function clear() {
        __private.gotoMenuKey = '';
        __listView.model = [];
    }
}
