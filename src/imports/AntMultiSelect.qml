import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

AntSelect {
    id: control

    signal searched(input: string)
    signal selected(option: var)
    signal tagRemoved(option: var)

    property var options: []
    property var filterOption: (input, option) => true
    property var initValue: []
    property alias text: __input.text
    property string prefix: ''
    property string suffix: ''
    property bool genDefaultKey: true
    property var selectedKeys: []
    property bool searchEnabled: true
    property string placeholderText: ''
    readonly property alias tagCount: __tagListModel.count
    property int maxTagCount: -1
    property int tagSpacing: 5
    property color colorTagText: themeSource.colorTagText
    property color colorTagBg: themeSource.colorTagBg
    property AntRadius radiusTagBg: AntRadius { all: themeSource.radiusTagBg }
    property AntRadius radiusPopupBg: AntRadius { all: themeSource.radiusPopupBg }
    property var activeValue: []

    property Component prefixDelegate: AntText {
        font: control.font
        text: control.prefix
        color: control.themeSource.colorText
    }
    property Component suffixDelegate: AntText {
        font: control.font
        text: control.suffix
        color: control.themeSource.colorText
    }
    property Component tagDelegate: AntRectangleInternal {
        id: __tag

        required property int index
        required property var tagData

        implicitWidth: __row.implicitWidth + 16
        implicitHeight: Math.max(__text.implicitHeight, __closeIcon.implicitHeight)
        color: control.colorTagBg
        radius: control.radiusTagBg.all
        topLeftRadius: control.radiusTagBg.topLeft
        topRightRadius: control.radiusTagBg.topRight
        bottomLeftRadius: control.radiusTagBg.bottomLeft
        bottomRightRadius: control.radiusTagBg.bottomRight

        MouseArea {
            anchors.fill: parent
        }

        Row {
            id: __row
            anchors.centerIn: parent
            spacing: 5

            AntText {
                id: __text
                anchors.verticalCenter: parent.verticalCenter
                text: __tag.tagData ? (__tag.tagData[control.textRole] || __tag.tagData.label) : ''
                font: control.font
                color: control.colorTagText

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
            }

            AntIconText {
                id: __closeIcon
                anchors.verticalCenter: parent.verticalCenter
                colorIcon: __hoverHander.hovered ? control.themeSource.colorTagCloseHover : control.themeSource.colorTagClose
                iconSize: control.themeSource.fontSize - 2
                iconSource: AntIcon.CloseOutlined
                verticalAlignment: Text.AlignVCenter

                Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

                HoverHandler {
                    id: __hoverHander
                    cursorShape: (control.enabled && !control.readOnly) ? Qt.PointingHandCursor : Qt.ArrowCursor
                }

                TapHandler {
                    id: __tapHander
                    onTapped: {
                        if (control.enabled && !control.readOnly) {
                            control.removeTagAtIndex(__tag.index);
                        }
                    }
                }
            }
        }
    }

    Behavior on colorTagText { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    Behavior on colorTagBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

    Component.onCompleted: {
        if (!Array.isArray(control.initValue) || control.initValue.length === 0 || !control.options || control.options.length === 0) {
            return;
        }
        if (genDefaultKey) {
            control.options.forEach((item) => {
                if (!item.hasOwnProperty('key')) {
                    item.key = item.label;
                }
            });
        }
        for (let j = 0; j < control.initValue.length; j++) {
            const targetValue = control.initValue[j];
            for (let k = 0; k < control.options.length; k++) {
                const item = control.options[k];
                if (item && item[control.valueRole] === targetValue) {
                    const key = item.key;
                    __private.insert(key, item);
                    break;
                }
            }
        }
    }

    function findKey(key: string) {
        return __private.getData(key);
    }

    function filter() {
        model = options.filter(option => filterOption(text, option) === true);
    }

    function removeTagAtKey(key: string) {
        __private.remove(key);
    }

    function removeTagAtIndex(index: int) {
        if (index >= 0 && index < __tagListModel.count) {
            __private.removeAtIndex(index);
        }
    }

    function clearTag() {
        __private.clear();
    }

    function clearInput() {
        __input.clear();
        __input.textEdited();
    }

    function openPopup() {
        if (!__popup.opened)
            __popup.open();
    }

    function closePopup() {
        __popup.close();
    }

    objectName: '__AntMultiSelect__'
    themeSource: AntTheme.AntMultiSelect
    font {
        family: themeSource.fontFamily
        pixelSize: themeSource.fontSize
    }
    leftPadding: 2
    clearable: false
    contentItem: Item {
        implicitHeight: Math.max(__flow.implicitHeight, 18)

        Loader {
            id: __prefixLoader
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.prefixDelegate
        }

        Loader {
            id: __suffixLoader
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.suffixDelegate
        }

        AntInput {
            id: __input
            topPadding: 0
            bottomPadding: 0
            leftPadding: 0
            rightPadding: 0
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: __flow.left
            anchors.leftMargin: 2
            anchors.right: __flow.right
            background: Item { }
            animationEnabled: control.animationEnabled
            colorText: control.themeSource.colorText
            placeholderTextColor: control.themeSource.colorTextDisabled
            placeholderText: (__tagListModel.count > 0 || length > 0) ? '' : control.placeholderText
            font: control.font
            readOnly: !control.searchEnabled || control.readOnly
            onTextEdited: {
                control.searched(text);
                control.filter();
                if (control.model.length > 0)
                    control.openPopup();
                else
                    control.closePopup();
            }
            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Backspace) {
                    if (length === 0 && __tagListModel.count > 0) {
                        control.removeTagAtIndex(__tagListModel.count - 1);
                    }
                }
            }

            HoverHandler {
                cursorShape: control.readOnly ? Qt.ArrowCursor : (control.searchEnabled ? Qt.IBeamCursor : Qt.ArrowCursor)
            }

            TapHandler {
                onTapped: {
                    if (control.readOnly) {
                        return;
                    }
                    if (control.popup.opened) {
                        control.popup.close();
                    } else {
                        control.popup.open();
                    }
                }
            }
        }

        Flow {
            id: __flow
            anchors.left: __prefixLoader.right
            anchors.leftMargin: 4
            anchors.right: __suffixLoader.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            spacing: control.tagSpacing
            onPositioningComplete: {
                const item = __tagRepeater.itemAt(__tagListModel.count - 1);
                const newLeftPadding = item ? (item.x + item.width + 5) : 0;
                const newTopPadding = item ? item.y : 0;
                // 只在值变化时才设置，避免无限循环
                if (__input.leftPadding !== newLeftPadding) {
                    __input.leftPadding = newLeftPadding;
                }
                if (__input.topPadding !== newTopPadding) {
                    __input.topPadding = newTopPadding;
                }
            }

            Repeater {
                id: __tagRepeater
                model: ListModel { id: __tagListModel }
                delegate: control.tagDelegate
            }
        }
    }
    popup: AntPopup {
        id: __popup
        y: control.height + 2
        implicitWidth: control.width
        implicitHeight: Math.min(control.defaultPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
        leftPadding: 4
        rightPadding: 4
        topPadding: 6
        bottomPadding: 6
        animationEnabled: control.animationEnabled
        radiusBg: control.radiusPopupBg
        colorBg: AntTheme.isDark ? control.themeSource.colorPopupBgDark : control.themeSource.colorPopupBg
        enter: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 0.0
                to: 1.0
                easing.type: Easing.OutQuad
                duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'height'
                from: 0
                to: __popup.implicitHeight
                easing.type: Easing.OutQuad
                duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
            }
        }
        exit: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 1.0
                to: 0.0
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'height'
                from: Math.min(control.defaultPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
                to: 0
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
            }
        }
        contentItem: ListView {
            id: __popupListView
            clip: true
            model: control.popup.visible ? control.model : null
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            delegate: T.ItemDelegate {
                id: __popupDelegate

                required property var model
                required property int index
                property string key: model.key
                property bool selected: __private.selectedKeysMap.has(key)

                width: __popupListView.width
                height: implicitContentHeight + topPadding + bottomPadding
                leftPadding: 8
                rightPadding: 8
                topPadding: 5
                bottomPadding: 5
                enabled: (model.enabled ?? true) && ((!selected && control.maxTagCount >= 0) ? (__tagListModel.count < control.maxTagCount) : true)
                contentItem: AntText {
                    text: __popupDelegate.model[control.textRole]
                    color: __popupDelegate.enabled ? control.themeSource.colorItemText :
                                                     control.themeSource.colorItemTextDisabled
                    font {
                        family: control.themeSource.fontFamily
                        pixelSize: control.themeSource.fontSize
                        weight: selected ? Font.DemiBold : Font.Normal
                    }
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter

                    AntIconText {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        colorIcon: control.themeSource.colorIconSelect
                        iconSize: 16
                        iconSource: AntIcon.CheckOutlined
                        visible: __popupDelegate.enabled && selected
                    }
                }
                background: Rectangle {
                    radius: control.radiusItemBg
                    color: {
                        if (__popupDelegate.selected) {
                            return control.themeSource.colorItemBgActive;
                        } else {
                            if (__popupDelegate.enabled)
                                return hovered ? control.themeSource.colorItemBgHover :
                                                 control.themeSource.colorItemBg;
                            else
                                return control.themeSource.colorItemBgDisabled;
                        }
                    }

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
                }
                onClicked: {
                    if (!control.enabled || control.readOnly) {
                        return;
                    }
                    control.currentIndex = index;
                    const data = __popupDelegate.model;
                    const key = data.key;
                    if (__private.contains(key)) {
                        __private.remove(key);
                    } else {
                        __private.insert(key, data);
                    }
                }

                HoverHandler {
                    cursorShape: control.hoverCursorShape
                }

                Loader {
                    y: __popupDelegate.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: control.tooltipVisible
                    sourceComponent: AntToolTip {
                        arrowVisible: false
                        visible: __popupDelegate.hovered
                        animationEnabled: control.animationEnabled
                        text: __popupDelegate.model[control.textRole]
                        position: AntToolTip.PositionBottom
                    }
                }
            }
            T.ScrollBar.vertical: AntScrollBar {
                animationEnabled: control.animationEnabled
                visible: __popup.opened && __popupListView.contentHeight > __popupListView.height
            }
        }

        Binding on height { when: __popup.opened; value: __popup.implicitHeight }
    }

    QtObject {
        id: __private

        property var selectedKeysMap: new Map

        function contains(key) {
            return selectedKeysMap.has(key);
        }

        function clear() {
            selectedKeysMap.forEach((value, key) => control.tagRemoved(value));
            __tagListModel.clear();
            selectedKeysMap = new Map;
            selectedKeysMapChanged();
        }

        function insert(key, data) {
            const cleanData = (typeof data === 'object' && data !== null) ? Object.assign({}, data) : {};
            __tagListModel.append({ '__related__': key, 'tagData': cleanData });
            selectedKeysMap.set(key, data);
            selectedKeysMapChanged();
            control.selected(data);
        }

        function remove(key) {
            for (let i = 0; i < __tagListModel.count; i++) {
                if (__tagListModel.get(i).__related__ === key) {
                    const relatedKey = __tagListModel.get(i).__related__;
                    const data = selectedKeysMap.get(relatedKey);
                    __tagListModel.remove(i);
                    selectedKeysMap.delete(relatedKey);
                    selectedKeysMapChanged();
                    control.tagRemoved(data);
                    break;
                }
            }
        }

        function removeAtIndex(index) {
            const relatedKey = __tagListModel.get(index).__related__;
            const data = selectedKeysMap.get(relatedKey);
            __tagListModel.remove(index);
            selectedKeysMap.delete(relatedKey);
            selectedKeysMapChanged();
            control.tagRemoved(data);
        }

        function getData(key) {
            if (selectedKeysMap.has(key)) {
                return selectedKeysMap.get(key);
            }
        }

        function updateSelectedKeys() {
            control.selectedKeys = [...selectedKeysMap.keys()];
        }

        function updateSelectedItemsByValues() {
            if (control.activeValue !== undefined && control.activeValue !== null && Array.isArray(control.activeValue) && control.options && control.options.length > 0) {
                __private.clear();
                for (let j = 0; j < control.activeValue.length; j++) {
                    const targetValue = control.activeValue[j];
                    for (let k = 0; k < control.options.length; k++) {
                        const item = control.options[k];
                        if (item && item[control.valueRole] === targetValue) {
                            const key = item.key;
                            __private.insert(key, item);
                            break;
                        }
                    }
                }
            }
        }

        onSelectedKeysMapChanged: updateSelectedKeys();
    }

    onActiveValueChanged: {
        __private.updateSelectedItemsByValues();
    }

    onOptionsChanged: {
        if (genDefaultKey) {
            options.forEach((item, index) => {
                if (!item.hasOwnProperty('key')) {
                    item.key = item.label;
                }
            });
        }
        __private.updateSelectedItemsByValues();
        filter();
    }

    onFilterOptionChanged: {
        filter();
    }
}
