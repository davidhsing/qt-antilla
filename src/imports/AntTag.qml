import QtQuick
import Antilla.Basic

Rectangle {
    id: control

    enum TagState {
        StateDefault = 0,
        StateSuccess = 1,
        StateProcessing = 2,
        StateError = 3,
        StateWarning  = 4
    }

    signal closed()

    property bool animationEnabled: AntTheme.animationEnabled
    property int tagState: AntTag.StateDefault
    property string text: ''
    property font font: Qt.font({
        family: control.themeSource.fontFamily,
        pixelSize: control.themeSource.fontSize
    })
    property int adjustWidth: 16
    property int adjustHeight: 8
    property bool rotating: false
    property var iconSource: 0 ?? ''
    property int iconSize: AntTheme.AntButton.fontSize
    property var closeIconSource: 0 ?? ''
    property int closeIconSize: AntTheme.AntButton.fontSize
    property alias spacing: __row.spacing
    property string presetColor: ''
    property color colorText: presetColor == '' ? control.themeSource.colorDefaultText : __private.isCustom ? '#fff' : __private.colorArray[5]
    property color colorBg: presetColor == '' ? control.themeSource.colorDefaultBg : __private.isCustom ? presetColor : __private.colorArray[0]
    property color colorBorder: presetColor == '' ? control.themeSource.colorDefaultBorder : __private.isCustom ? 'transparent' : __private.colorArray[2]
    property color colorIcon: colorText
    property var themeSource: AntTheme.AntTag

    objectName: '__AntTag__'
    implicitWidth: __row.implicitWidth + control.adjustWidth
    implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight, __closeIcon.implicitHeight) + control.adjustHeight
    color: colorBg
    border.color: colorBorder
    radius: control.themeSource.radiusBg
    onTagStateChanged: {
        switch (tagState) {
        case AntTag.StateSuccess: presetColor = '#52c41a'; break;
        case AntTag.StateProcessing: presetColor = '#1677ff'; break;
        case AntTag.StateError: presetColor = '#ff4d4f'; break;
        case AntTag.StateWarning: presetColor = '#faad14'; break;
        case AntTag.StateDefault:
        default: presetColor = '';
        }
    }
    onPresetColorChanged: {
        let preset = -1;
        switch (presetColor) {
        case 'red': preset = AntColorGenerator.Preset_Red; break;
        case 'volcano': preset = AntColorGenerator.Preset_Volcano; break;
        case 'orange': preset = AntColorGenerator.Preset_Orange; break;
        case 'gold': preset = AntColorGenerator.Preset_Gold; break;
        case 'yellow': preset = AntColorGenerator.Preset_Yellow; break;
        case 'lime': preset = AntColorGenerator.Preset_Lime; break;
        case 'green': preset = AntColorGenerator.Preset_Green; break;
        case 'cyan': preset = AntColorGenerator.Preset_Cyan; break;
        case 'blue': preset = AntColorGenerator.Preset_Blue; break;
        case 'geekblue': preset = AntColorGenerator.Preset_Geekblue; break;
        case 'purple': preset = AntColorGenerator.Preset_Purple; break;
        case 'magenta': preset = AntColorGenerator.Preset_Magenta; break;
        }

        if (tagState == AntTag.StateDefault) {
            __private.isCustom = preset == -1 ? true : false;
            __private.presetColor = preset == -1 ? '#000' : antColorGenerator.presetToColor(preset);
        } else {
            __private.isCustom = false;
            __private.presetColor = presetColor;
        }
    }

    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

    AntColorGenerator {
        id: antColorGenerator
    }

    Row {
        id: __row
        anchors.centerIn: parent
        spacing: 5

        AntIconText {
            id: __icon
            anchors.verticalCenter: parent.verticalCenter
            color: control.colorIcon
            iconSize: control.iconSize
            iconSource: control.iconSource
            verticalAlignment: Text.AlignVCenter
            visible: iconSource != 0

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

            NumberAnimation on rotation {
                id: __animation
                running: control.rotating
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1000
            }
        }

        AntCopyableText {
            id: __text
            anchors.verticalCenter: parent.verticalCenter
            text: control.text
            font: control.font
            color: control.colorText

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
        }

        AntIconText {
            id: __closeIcon
            anchors.verticalCenter: parent.verticalCenter
            color: hovered ? control.themeSource.colorCloseIconHover : control.themeSource.colorCloseIcon
            iconSize: control.closeIconSize
            iconSource: control.closeIconSource
            verticalAlignment: Text.AlignVCenter
            visible: iconSource != 0

            property alias hovered: __hoverHander.hovered
            property alias down: __tapHander.pressed

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }

            HoverHandler {
                id: __hoverHander
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                id: __tapHander
                onTapped: control.closed();
            }
        }
    }

    QtObject {
        id: __private
        property bool isCustom: false
        property color presetColor: '#000'
        property var colorArray: AntThemeFunctions.genColor(presetColor, !AntTheme.isDark, AntTheme.Primary.colorBgBase)
    }
}
