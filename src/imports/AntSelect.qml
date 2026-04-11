import QtQuick
import QtQuick.Templates as T
import Antilla.Basic

T.ComboBox {
    id: control

    signal cleared()

    property bool animationEnabled: AntTheme.animationEnabled
    readonly property bool active: hovered || visualFocus || contentItem.hovered || contentItem.activeFocus
    property bool clearable: false
    property var clearIconSource: AntIcon.CloseCircleFilled ?? ''
    property int defaultPopupMaxHeight: 240
    property bool danger: false
    property int hoverCursorShape: Qt.PointingHandCursor
    property var initValue: null
    property var activeValue: null
    property bool loading: false
    property bool readOnly: false
    property bool tooltipVisible: false
    property alias placeholderText: __contentItem.placeholderText
    property color colorText: enabled ? ((popup.visible && !editable) ? control.themeSource.colorTextActive : control.themeSource.colorText) : control.themeSource.colorTextDisabled
    property color colorBorder: danger ? (active ? control.themeSource.colorErrorBorderHover : control.themeSource.colorErrorBorder) : (enabled ? (active ? control.themeSource.colorBorderHover : control.themeSource.colorBorder) : control.themeSource.colorBorderDisabled)
    property color colorBg: enabled ? control.themeSource.colorBg : control.themeSource.colorBgDisabled
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }
    property AntRadius radiusItemBg: AntRadius { all: control.themeSource.radiusItemBg }
    property AntRadius radiusPopupBg: AntRadius { all: control.themeSource.radiusPopupBg }
    property string ariaConstrual: ''
    property var themeSource: AntTheme.AntSelect

    property Component indicatorDelegate: AntIconText {
        leftPadding: 4
        colorIcon: {
            if (control.enabled) {
                if (__clearMouseArea.active) {
                    return __clearMouseArea.pressed ? control.themeSource.colorIndicatorActive :
                                                      __clearMouseArea.hovered ? control.themeSource.colorIndicatorHover :
                                                                                 control.themeSource.colorIndicator;
                } else {
                    return control.themeSource.colorIndicator;
                }
            } else {
                return control.themeSource.colorIndicatorDisabled;
            }
        }
        iconSize: control.themeSource.fontSize
        iconSource: {
            if (control.enabled && control.clearable && __clearMouseArea.active) {
                return control.clearIconSource;
            } else {
                return control.loading ? AntIcon.LoadingOutlined : AntIcon.DownOutlined
            }
        }

        Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }

        NumberAnimation on rotation {
            running: control.loading
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1000
        }

        MouseArea {
            id: __clearMouseArea
            anchors.fill: parent
            enabled: control.enabled && !control.readOnly
            hoverEnabled: true
            cursorShape: (hovered && !control.readOnly) ? control.hoverCursorShape : Qt.ArrowCursor
            onEntered: hovered = true;
            onExited: hovered = false;
            onClicked: function(mouse) {
                if (control.readOnly) {
                    mouse.accepted = true;
                    return;
                }
                if (active && control.clearable) {
                    if (control.editable) {
                        control.editText = '';
                    }
                    control.currentIndex = -1;
                    control.cleared();
                } else {
                    if (control.popup.opened) {
                        control.popup.close();
                    } else {
                        control.popup.open();
                    }
                }
                mouse.accepted = true;
            }
            property bool active: !control.loading && (control.displayText || control.editText) && control.hovered
            property bool hovered: false
        }
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

    Component.onCompleted: {
        if (control.initValue !== undefined && control.initValue !== null && control.model && control.count > 0) {
            for (let i = 0; i < control.count; i++) {
                const item = control.model[i];
                if (item && item[control.valueRole] === control.initValue) {
                    control.currentIndex = i;
                    return;
                }
            }
        }
    }

    objectName: '__AntSelect__'
    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    topPadding: 6
    bottomPadding: 6
    spacing: 8
    implicitWidth: implicitContentWidth + implicitIndicatorWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    currentIndex: -1
    textRole: 'label'
    valueRole: 'value'
    font {
        family: control.themeSource.fontFamily
        pixelSize: control.themeSource.fontSize
    }
    selectTextByMouse: control.editable
    delegate: T.ItemDelegate { }
    indicator: Loader {
        x: control.mirrored ? (control.padding + control.spacing) : (control.width - width - control.padding - control.spacing)
        y: control.topPadding + (control.availableHeight - height) / 2
        sourceComponent: indicatorDelegate
    }
    contentItem: AntInput {
        id: __contentItem
        topPadding: 0
        bottomPadding: 0
        text: control.editable ? control.editText : control.displayText
        placeholderText: control.placeholderText
        readOnly: !control.editable || control.readOnly
        autoScroll: control.editable
        font: control.font
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        selectByMouse: control.selectTextByMouse
        verticalAlignment: Text.AlignVCenter
        bgDelegate: null
        colorText: control.colorText

        HoverHandler {
            cursorShape: control.readOnly ? Qt.ArrowCursor : (control.editable ? Qt.IBeamCursor : control.hoverCursorShape)
        }

        TapHandler {
            onTapped: {
                if (!control.enabled || control.readOnly) {
                    return;
                }
                if (!control.editable) {
                    if (control.popup.opened) {
                        control.popup.close();
                    } else {
                        control.popup.open();
                    }
                } else {
                    __openPopupTimer.restart();
                }
            }
        }

        Timer {
            id: __openPopupTimer
            interval: 100
            onTriggered: {
                if (!control.popup.opened) {
                    control.popup.open();
                }
            }
        }
    }
    background: AntRectangleInternal {
        color: control.colorBg
        border.color: control.colorBorder
        border.width: control.visualFocus ? 2 : 1
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
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

                width: __popupListView.width
                height: implicitContentHeight + topPadding + bottomPadding
                leftPadding: 8
                rightPadding: 8
                topPadding: 5
                bottomPadding: 5
                enabled: model.enabled ?? true
                contentItem: AntText {
                    text: __popupDelegate.model[control.textRole]
                    color: __popupDelegate.enabled ? control.themeSource.colorItemText : control.themeSource.colorItemTextDisabled;
                    font {
                        family: control.themeSource.fontFamily
                        pixelSize: control.themeSource.fontSize
                        weight: highlighted ? Font.DemiBold : Font.Normal
                    }
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                background: AntRectangleInternal {
                    radius: control.radiusItemBg.all
                    topLeftRadius: control.radiusItemBg.topLeft
                    topRightRadius: control.radiusItemBg.topRight
                    bottomLeftRadius: control.radiusItemBg.bottomLeft
                    bottomRightRadius: control.radiusItemBg.bottomRight
                    color: {
                        if (__popupDelegate.enabled)
                            return highlighted ? control.themeSource.colorItemBgActive :
                                                 hovered ? control.themeSource.colorItemBgHover :
                                                           control.themeSource.colorItemBg;
                        else
                            return control.themeSource.colorItemBgDisabled;
                    }

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
                }
                highlighted: control.highlightedIndex === index
                onClicked: {
                    control.currentIndex = index;
                    control.activated(index);
                    control.popup.close();
                }

                HoverHandler {
                    cursorShape: control.readOnly ? Qt.ArrowCursor : control.hoverCursorShape
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

    MouseArea {
        id: __rootMouseArea
        anchors.fill: parent
        enabled: control.readOnly
        onClicked: function(mouse) {
            mouse.accepted = true;
        }
    }

    HoverHandler {
        cursorShape: control.readOnly ? Qt.ArrowCursor : control.hoverCursorShape
    }

    Accessible.role: Accessible.ComboBox
    Accessible.name: control.displayText
    Accessible.description: control.ariaConstrual

    QtObject {
        id: __private

        function updateCurrentIndexByValue() {
            if (control.activeValue !== undefined && control.activeValue !== null && control.model && control.count > 0) {
                for (let i = 0; i < control.count; i++) {
                    const item = control.model[i];
                    if (item && item[control.valueRole] === control.activeValue) {
                        control.currentIndex = i;
                        return;
                    }
                }
                control.currentIndex = -1;
            }
        }
    }

    onActiveValueChanged: {
        __private.updateCurrentIndexByValue();
    }

    onCurrentIndexChanged: {
        if (control.currentIndex >= 0 && control.currentIndex < control.count && control.model) {
            const item = control.model[control.currentIndex];
            if (item) {
                control.activeValue = item[control.valueRole];
            } else {
                control.activeValue = null;
            }
        } else {
            control.activeValue = null;
        }
    }

    onModelChanged: {
        Qt.callLater(function() {
            __private.updateCurrentIndexByValue();
        });
    }
}
