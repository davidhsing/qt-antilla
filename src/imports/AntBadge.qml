import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Item {
    id: control

    enum BadgeState {
        StateSuccess = 1,
        StateProcessing = 2,
        StateError = 3,
        StateWarning  = 4,
        StateDefault = 5
    }

    property bool animationEnabled: AntTheme.animationEnabled
    property int badgeState: AntBadge.StateError
    property bool stateEffect: badgeState === AntBadge.StateProcessing
    property string presetColor: ''
    property int count: 0
    property var iconSource: 0 ?? ''
    property bool dot: false
    property bool zeroVisible: false
    property int overflowCount: 99
    property font font: Qt.font({
        family: __private.isNumber ? AntTheme.Primary.fontPrimaryFamily : 'Antilla-Icons',
        pixelSize: __private.isNumber ? 12 : 16
    })
    property color colorBg: presetColor == '' ? (!__private.isNumber ? 'transparent' : AntTheme.Primary.colorError) : (__private.isCustom ? presetColor : __private.colorArray[5])
    property alias colorBorder: __border.border.color
    property color colorText: 'white'

    property bool __parentIsLayout: parent instanceof Row || parent instanceof Column || parent instanceof Grid ||
                                    parent instanceof RowLayout || parent instanceof ColumnLayout || parent instanceof GridLayout ||
                                    parent instanceof Flow

    objectName: '__AntBadge__'
    width: __badge.width
    height: __badge.height
    anchors.left: __parentIsLayout ? undefined : parent.right
    anchors.leftMargin: __parentIsLayout ? 0 : -width / 2
    anchors.bottom: __parentIsLayout ? undefined : parent.top
    anchors.bottomMargin: __parentIsLayout ? 0 : -height / 2

    onCountChanged: {
        const max = Math.min(count, overflowCount);
        if (max !== __private.lastCount) {
            if (max > __private.lastCount) {
                __numberList.model = [__private.lastCount, max];
                __upAnimation.restart();
            } else {
                __numberList.model = [max, __private.lastCount];
                __downAnimation.restart();
            }
            __private.lastCount = max;
        }
    }
    onBadgeStateChanged: {
        switch (badgeState) {
        case AntBadge.StateSuccess: presetColor = '#52c41a'; break;
        case AntBadge.StateProcessing: presetColor = '#1677ff'; break;
        case AntBadge.StateError: presetColor = '#ff4d4f'; break;
        case AntBadge.StateWarning: presetColor = '#faad14'; break;
        case AntBadge.StateDefault: presetColor = '#888888'; break;
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

        if (badgeState === AntBadge.StateError) {
            __private.isCustom = preset == -1 ? true : false;
            __private.presetColor = preset == -1 ? '#000' : antColorGenerator.presetToColor(preset);
        } else {
            __private.isCustom = false;
            __private.presetColor = presetColor;
        }
    }

    AntColorGenerator { id: antColorGenerator }

    QtObject {
        id: __private
        property bool isCustom: false
        property color presetColor: '#000'
        property var colorArray: AntThemeFunctions.genColor(presetColor, !AntTheme.isDark, AntTheme.Primary.colorBgBase)
        property int lastCount: control.count
        property bool isNumber: control.iconSource === 0 || control.iconSource === ''
    }

    Rectangle {
        id: __effect
        visible: control.stateEffect
        x: __border.x + (__border.width - width) / 2
        y: __border.y + (__border.height - height) / 2
        radius: height / 2
        color: 'transparent'
        border.color: __badge.color

        ParallelAnimation {
            running: __effect.visible
            loops: Animation.Infinite

            NumberAnimation {
                target: __effect
                property: 'width'
                from: __border.width + 2
                to: __border.width + 8
                easing.type: Easing.OutQuart
                duration: 1000
            }

            NumberAnimation {
                target: __effect
                property: 'height'
                from: __border.height + 2
                to: __border.height + 8
                easing.type: Easing.OutQuart
                duration: 1000
            }

            NumberAnimation {
                target: __effect
                property: 'opacity'
                from: 0.4
                to: 0
                duration: 1000
            }
        }
    }

    Rectangle {
        id: __border
        visible: __badge.visible
        width: __badge.width + 2
        height: __badge.height + 2
        anchors.centerIn: __badge
        radius: height / 2
        color: 'transparent'
        border.width: 2
        border.color: !__private.isNumber ? 'transparent' : 'white'
        scale: __badge.scale
    }

    Rectangle {
        id: __badge
        visible: scale !== 0
        width: control.dot ? 8 : Math.max(__content.width + 12, height)
        height: control.dot ? 8 : 20
        anchors.centerIn: parent
        radius: height / 2
        color: control.colorBg
        scale: (control.dot || control.count > 0 || control.zeroVisible || !__private.isNumber) ? 1 : 0

        Behavior on scale {
            enabled: control.animationEnabled
            NumberAnimation {
                duration: AntTheme.Primary.durationMid
                easing.type: Easing.InOutBack
            }
        }

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
        Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }
        Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }

        Item {
            visible: !control.dot
            anchors.fill: parent

            AntText {
                id: __content
                visible: (control.count > 0 || control.zeroVisible || !__private.isNumber) && !__upAnimation.running && !__downAnimation.running
                font: control.font
                text: control.iconSource === 0 ? (control.count > control.overflowCount ? `${control.overflowCount}+` : control.count) :
                                                 String.fromCharCode(control.iconSource)
                color: control.colorText
                anchors.centerIn: parent
            }

            ListView {
                id: __numberList
                visible: (control.count > 0 || control.zeroVisible || !__private.isNumber) && control.iconSource === 0 && !__content.visible
                anchors.fill: parent
                interactive: false
                clip: true
                delegate: AntText {
                    width: __numberList.width
                    height: __numberList.height
                    text: modelData
                    color: control.colorText
                    font: control.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                NumberAnimation on contentY {
                    id: __upAnimation
                    from: 0
                    to: __numberList.height
                    duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
                    easing.type: Easing.InOutBack
                }

                NumberAnimation on contentY {
                    id: __downAnimation
                    from: __numberList.height
                    to: 0
                    duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
                    easing.type: Easing.InOutBack
                }
            }
        }
    }
}
