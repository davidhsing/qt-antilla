import QtQuick
import QtQuick.Controls.Basic as T
import Antilla.Basic

T.TextField {
    id: control

    signal cleared()

    enum IconPosition {
        PositionLeft = 0,
        PositionRight = 1
    }

    property bool animationEnabled: AntTheme.animationEnabled
    readonly property bool active: hovered || activeFocus
    property var iconSource: 0 ?? ''
    property int iconSize: control.themeSource.fontIconSize
    property int iconPosition: AntInput.PositionLeft
    property var clearable: false ?? ''
    property var clearIconSource: AntIcon.CloseCircleFilled ?? ''
    property int clearIconSize: control.themeSource.fontClearIconSize
    property int clearIconPosition: AntInput.PositionRight
    property int clearLeftMargin: 5
    property int clearRightMargin: 5
    property bool readOnlyBg: false
    readonly property int leftIconPadding: (iconPosition === AntInput.PositionLeft) ? __private.iconSize : 0
    readonly property int rightIconPadding: (iconPosition === AntInput.PositionRight) ? __private.iconSize : 0
    readonly property int leftClearIconPadding: {
        if (clearIconPosition === AntInput.PositionLeft) {
            return leftIconPadding > 0 ? (__private.clearIconSize + 5) : __private.clearIconSize;
        }
        return 0;
    }
    readonly property int rightClearIconPadding: {
        if (clearIconPosition === AntInput.PositionRight) {
            return rightIconPadding > 0 ? (__private.clearIconSize + 5) : __private.clearIconSize;
        }
        return 0;
    }
    property bool danger: false
    property color colorIcon: enabled ? control.themeSource.colorIcon : control.themeSource.colorIconDisabled
    property color colorText: enabled ? control.themeSource.colorText : control.themeSource.colorTextDisabled
    property color colorBorder: danger ? (active ? control.themeSource.colorErrorBorderHover : control.themeSource.colorErrorBorder) : ((!enabled || (readOnly && control.readOnlyBg)) ? control.themeSource.colorBorderDisabled : (active ? control.themeSource.colorBorderHover : control.themeSource.colorBorder))
    property color colorBg: (!enabled || (readOnly && control.readOnlyBg)) ? control.themeSource.colorBgDisabled : control.themeSource.colorBg
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }
    property string ariaConstrual: ''
    property var themeSource: AntTheme.AntInput

    property Component iconDelegate: AntIconText {
        iconSource: control.iconSource
        iconSize: control.iconSize
        colorIcon: control.colorIcon
    }
    property Component clearIconDelegate: AntIconText {
        iconSource: control.length > 0 ? control.clearIconSource : 0
        iconSize: control.clearIconSize
        colorIcon: {
            if (control.enabled) {
                return __tapHandler.pressed ? control.themeSource.colorClearIconActive : (__hoverHandler.hovered ? control.themeSource.colorClearIconHover : control.themeSource.colorClearIcon);
            }
            return control.themeSource.colorClearIconDisabled;
        }

        Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }

        HoverHandler {
            id: __hoverHandler
            enabled: (control.clearable === 'active' || control.clearable === true) && !control.readOnly
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            id: __tapHandler
            enabled: (control.clearable === 'active' || control.clearable === true) && !control.readOnly
            onTapped: {
                control.clear();
                control.cleared();
            }
        }
    }
    property Component bgDelegate: AntRectangleInternal {
        color: control.colorBg
        border.color: (!enabled || (readOnly && control.readOnlyBg)) ? control.themeSource.colorBorderDisabled : control.colorBorder
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }

    objectName: '__AntInput__'
    focus: true
    padding: 6
    leftPadding: 10 + leftIconPadding + leftClearIconPadding
    rightPadding: 10 + rightIconPadding + rightClearIconPadding
    implicitWidth: contentWidth + leftPadding + rightPadding
    implicitHeight: contentHeight + topPadding + bottomPadding
    color: colorText
    placeholderTextColor: enabled ? control.themeSource.colorPlaceholderText : control.themeSource.colorPlaceholderTextDisabled
    selectedTextColor: control.themeSource.colorTextSelected
    selectionColor: control.themeSource.colorSelection
    font {
        family: control.themeSource.fontFamily
        pixelSize: control.themeSource.fontSize
    }
    background: Loader {
        sourceComponent: control.bgDelegate
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }

    Loader {
        id: __iconLoader
        active: control.iconSource !== 0 && control.iconSource !== ''
        anchors.left: control.iconPosition === AntInput.PositionLeft ? parent.left : undefined
        anchors.right: control.iconPosition === AntInput.PositionRight ? parent.right : undefined
        anchors.margins: 5
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: control.iconDelegate
    }

    Loader {
        id: __clearIconLoader
        active: control.enabled && !control.readOnly && control.clearIconSource !== 0 && control.clearIconSource !== '' && (control.clearable === true || (control.clearable === 'active' && control.active))
        anchors.left: {
            if (control.clearIconPosition === AntInput.PositionLeft) {
                return __iconLoader.active && control.iconPosition === AntInput.PositionLeft ? __iconLoader.right : parent.left;
            }
            return undefined;
        }
        anchors.right: {
            if (control.clearIconPosition === AntInput.PositionRight) {
                return __iconLoader.active && control.iconPosition === AntInput.PositionRight ? __iconLoader.left : parent.right;
            }
            return undefined;
        }
        anchors.leftMargin: control.clearLeftMargin
        anchors.rightMargin: control.clearRightMargin
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: control.clearIconDelegate
    }

    Accessible.role: Accessible.EditableText
    Accessible.editable: control.readOnly
    Accessible.description: control.ariaConstrual

    QtObject {
        id: __private
        property int iconSize: __iconLoader.active ? __iconLoader.width : 0
        property int clearIconSize: __clearIconLoader.active ? __clearIconLoader.width : 0
    }
}
