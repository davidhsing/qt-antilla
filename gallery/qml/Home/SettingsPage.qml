import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Basic
import Antilla.Basic

AntWindow {
    id: root
    width: 550
    height: 600
    minimumWidth: 550
    minimumHeight: 600
    captionBar.minimizeButtonVisible: false
    captionBar.maximizeButtonVisible: false
    captionBar.winTitle: qsTr('设置')
    captionBar.winIconDelegate: Item {
        Image {
            width: 16
            height: 16
            anchors.centerIn: parent
            source: 'qrc:/Gallery/images/antilla_icon.svg'
        }
    }
    captionBar.closeCallback: () => settingsLoader.visible = false;

    Item {
        anchors.fill: parent

        AntShadow {
            anchors.fill: backRect
            source: backRect
        }

        Rectangle {
            id: backRect
            anchors.fill: parent
            radius: 6
            color: AntTheme.Primary.colorBgBase
            border.color: AntThemeFunctions.alpha(AntTheme.Primary.colorTextBase, 0.2)
        }

        Item {
            anchors.fill: parent

            ShaderEffect {
                anchors.fill: parent
                vertexShader: 'qrc:/Gallery/shaders/effect2.vert.qsb'
                fragmentShader: 'qrc:/Gallery/shaders/effect2.frag.qsb'
                opacity: 0.5

                property vector3d iResolution: Qt.vector3d(width, height, 0)
                property real iTime: 0

                Timer {
                    running: true
                    repeat: true
                    interval: 10
                    onTriggered: parent.iTime += 0.03;
                }
            }
        }

        component MySlider: RowLayout {
            height: 30
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            spacing: 20

            property alias label: __label
            property alias slider: __slider
            property bool scaleVisible: false

            AntText {
                id: __label
                Layout.preferredWidth: AntTheme.Primary.fontPrimarySize * 6
                Layout.fillHeight: true
                verticalAlignment: Text.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Loader {
                    width: parent.width
                    active: scaleVisible
                    sourceComponent: Item {
                        Row {
                            anchors.top: parent.top
                            anchors.topMargin: 6
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: (parent.width - 14 - ((__repeater.count - 1) * 4)) / (__repeater.count - 1)

                            Repeater {
                                id: __repeater
                                model: Math.round((__slider.max - __slider.min) / __slider.stepSize) + 1
                                delegate: Rectangle {
                                    width: 4
                                    height: 6
                                    radius: 2
                                    color: __slider.colorBg

                                    AntText {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.top: parent.bottom
                                        anchors.topMargin: 8
                                        text: (__slider.stepSize) * index + __slider.min
                                    }
                                }
                            }
                        }
                    }
                }

                AntSlider {
                    id: __slider
                    anchors.fill: parent
                    min: 0.0
                    max: 1.0
                    stepSize: 0.1
                }
            }
        }

        component SettingsItem: Item {
            id: settingsItem
            width: parent.width
            height: column.height

            property string title: value
            property Component itemDelegate: Item { }

            Column {
                id: column
                width: parent.width
                spacing: 10

                AntText {
                    text: settingsItem.title
                }

                Rectangle {
                    width: parent.width
                    height: itemLoader.height + 40
                    radius: 6
                    color: AntThemeFunctions.alpha(AntTheme.Primary.colorBgBase, 0.6)
                    border.color: AntThemeFunctions.alpha(AntTheme.Primary.colorTextBase, 0.1)

                    Loader {
                        id: itemLoader
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 20
                        anchors.verticalCenter: parent.verticalCenter
                        sourceComponent: settingsItem.itemDelegate
                    }
                }
            }
        }

        Flickable {
            anchors.fill: parent
            anchors.topMargin: root.captionBar.height
            anchors.bottomMargin: 20
            clip: true
            contentHeight: contentColumn.height
            ScrollBar.vertical: AntScrollBar {
                anchors.right: parent.right
                anchors.rightMargin: 5
            }

            Column {
                id: contentColumn
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.right: parent.right
                anchors.rightMargin: 20
                spacing: 20

                SettingsItem {
                    title: qsTr('常规设置')
                    itemDelegate: Column {
                        spacing: 10

                        MySlider {
                            id: themeSpeed
                            label.text: qsTr('动画基础速度')
                            slider.min: 20
                            slider.max: 200
                            slider.stepSize: 1
                            slider.onFirstReleased: {
                                const base = slider.currentValue;
                                AntTheme.installThemePrimaryAnimationBase(base, base * 2, base * 3);
                            }
                            slider.handleToolTipDelegate: AntToolTip {
                                arrowVisible: true
                                delay: 100
                                text: themeSpeed.slider.currentValue
                                visible: handlePressed || handleHovered
                            }
                            Component.onCompleted: {
                                slider.value = AntTheme.Primary.durationFast;
                            }
                        }

                        MySlider {
                            id: effectSpeed
                            label.text: qsTr('菜单切换速度')
                            slider.min: 0
                            slider.max: 2000
                            slider.stepSize: 1
                            slider.value: gallerySwitchEffect.duration
                            slider.onFirstReleased: {
                                gallerySwitchEffect.duration = slider.currentValue;
                            }
                            slider.handleToolTipDelegate: AntToolTip {
                                arrowVisible: true
                                delay: 100
                                text: effectSpeed.slider.currentValue
                                visible: handlePressed || handleHovered
                            }
                        }

                        MySlider {
                            id: bgOpacitySlider
                            label.text: qsTr('背景透明度')
                            slider.value: galleryBackground.opacity
                            slider.snapMode: AntSlider.SnapOnRelease
                            slider.onFirstMoved: {
                                galleryBackground.opacity = slider.currentValue;
                            }
                            slider.handleToolTipDelegate: AntToolTip {
                                arrowVisible: true
                                delay: 100
                                text: bgOpacitySlider.slider.currentValue.toFixed(1)
                                visible: handlePressed || handleHovered
                            }
                        }

                        MySlider {
                            label.text: qsTr('字体大小')
                            slider.min: 12
                            slider.max: 24
                            slider.stepSize: 4
                            slider.value: AntTheme.Primary.fontPrimarySizeHeading5
                            slider.snapMode: AntSlider.SnapAlways
                            slider.onFirstReleased: {
                                AntTheme.installThemePrimaryFontSizeBase(slider.currentValue);
                            }
                            scaleVisible: true
                        }

                        MySlider {
                            label.text: qsTr('圆角大小')
                            slider.min: 0
                            slider.max: 24
                            slider.stepSize: 2
                            slider.value: AntTheme.Primary.radiusPrimary
                            slider.snapMode: AntSlider.SnapAlways
                            slider.onFirstReleased: {
                                AntTheme.installThemePrimaryRadiusBase(slider.currentValue);
                            }
                            scaleVisible: true
                        }
                    }
                }

                SettingsItem {
                    title: qsTr('菜单切换特效')
                    itemDelegate: Column {
                        spacing: 10

                        ButtonGroup { id: effectTypeGroup }

                        Repeater {
                            model: [
                                { 'label': qsTr('无'), 'value': AntSwitchEffect.TypeNone, 'duration': 0 },
                                { 'label': qsTr('透明度特效'), 'value': AntSwitchEffect.TypeOpacity, 'duration': 200 },
                                { 'label': qsTr('模糊特效'), 'value': AntSwitchEffect.TypeBlurry, 'duration': 350 },
                                {
                                    'label': qsTr('遮罩特效'),
                                    'value': AntSwitchEffect.TypeMask,
                                    'duration': 800,
                                    'maskScaleEnabled': true,
                                    'maskRotationEnabled': true,
                                    'maskSource': 'qrc:/Antilla/resources/images/star.png'
                                },
                                {
                                    'label': qsTr('百叶窗特效'),
                                    'value': AntSwitchEffect.TypeBlinds,
                                    'duration': 800,
                                    'maskSource': 'qrc:/Antilla/resources/images/hblinds.png'
                                },
                                {
                                    'label': qsTr('3D翻转特效'),
                                    'value': AntSwitchEffect.Type3dFlip,
                                    'duration': 800,
                                    'maskSource': 'qrc:/Antilla/resources/images/smoke.png'
                                },                            {
                                    'label': qsTr('雷电特效'),
                                    'value': AntSwitchEffect.TypeThunder,
                                    'duration': 800,
                                    'maskSource': 'qrc:/Antilla/resources/images/stripes.png'
                                },
                            ]
                            delegate: AntRadio {
                                text: modelData.label
                                ButtonGroup.group: effectTypeGroup
                                onClicked: {
                                    gallerySwitchEffect.type = modelData.value;
                                    gallerySwitchEffect.duration = modelData.duration;
                                    gallerySwitchEffect.maskScaleEnabled = modelData.maskScaleEnabled ?? false;
                                    gallerySwitchEffect.maskRotationEnabled = modelData.maskRotationEnabled ?? false;
                                    gallerySwitchEffect.maskSource = modelData.maskSource ?? '';
                                }
                                Component.onCompleted: {
                                    checked = gallerySwitchEffect.type === modelData.value;
                                }
                            }
                        }
                    }
                }

                SettingsItem {
                    title: qsTr('窗口效果')
                    itemDelegate: Column {
                        spacing: 10

                        ButtonGroup { id: specialEffectGroup }

                        Repeater {
                            delegate: AntRadio {
                                text: modelData.label
                                ButtonGroup.group: specialEffectGroup
                                onClicked: {
                                    let oldEffect = galleryWindow.specialEffect;
                                    if (!galleryWindow.setSpecialEffect(modelData.value)) {
                                        galleryWindow.setSpecialEffect(oldEffect);
                                    }
                                }
                                Component.onCompleted: {
                                    checked = galleryWindow.specialEffect === modelData.value;
                                }
                            }
                            Component.onCompleted: {
                                if (Qt.platform.os === 'windows'){
                                    model = [
                                                { 'label': qsTr('无'), 'value': AntWindow.EffectNone },
                                                { 'label': qsTr('模糊'), 'value': AntWindow.EffectWinDwmBlur },
                                                { 'label': qsTr('亚克力'), 'value': AntWindow.EffectWinAcrylicMaterial },
                                                { 'label': qsTr('云母'), 'value': AntWindow.EffectWinMica },
                                                { 'label': qsTr('云母变体'), 'value': AntWindow.EffectWinMicaAlt }
                                            ];
                                } else if (Qt.platform.os === 'osx') {
                                    model = [
                                                { 'label': qsTr('无'), 'value': AntWindow.EffectNone },
                                                { 'label': qsTr('模糊'), 'value': AntWindow.EffectMacBlurEffect },
                                            ];
                                }
                            }
                        }
                    }
                }

                SettingsItem {
                    title: qsTr('应用主题')
                    itemDelegate: Column {
                        spacing: 10

                        ButtonGroup { id: themeGroup }

                        Repeater {
                            model: [
                                { 'label': qsTr('浅色'), 'value': AntTheme.Light },
                                { 'label': qsTr('深色'), 'value': AntTheme.Dark },
                                { 'label': qsTr('跟随系统'), 'value': AntTheme.System }
                            ]
                            delegate: AntRadio {
                                id: darkModeRadio
                                text: modelData.label
                                ButtonGroup.group: themeGroup
                                onClicked: {
                                    if (modelData.value === AntTheme.System) {
                                        AntTheme.darkMode = AntTheme.System;
                                    } else if (modelData.value === AntTheme.Dark) {
                                        if (AntTheme.isDark) {
                                            AntTheme.darkMode = AntTheme.Dark;
                                        } else {
                                            galleryWindow.captionBar.themeCallback();
                                        }
                                    } else if (modelData.value === AntTheme.Light && AntTheme.isDark) {
                                        if (AntTheme.isDark) {
                                            galleryWindow.captionBar.themeCallback();
                                        } else {
                                            AntTheme.darkMode = AntTheme.Light;
                                        }
                                    }
                                }
                                Component.onCompleted: {
                                    checked = AntTheme.darkMode === modelData.value;
                                }

                                Connections {
                                    target: AntTheme
                                    function onDarkModeChanged() {
                                        darkModeRadio.checked = AntTheme.darkMode === modelData.value;
                                    }
                                }
                            }
                        }
                    }
                }

                SettingsItem {
                    title: qsTr('导航模式')
                    itemDelegate: AntRadioBlock {
                        id: navMode
                        model: [
                            { label: qsTr('默认'), value: false },
                            { label: qsTr('紧凑'), value: true }
                        ]
                        onClicked:
                            (index, radioData) => {
                                galleryMenu.compactMode = radioData.value;
                            }
                        Component.onCompleted: {
                            currentCheckedIndex = galleryMenu.compactMode ? 1 : 0;
                        }

                        Connections {
                            target: galleryMenu
                            function onCompactModeChanged() {
                                navMode.currentCheckedIndex = galleryMenu.compactMode ? 1 : 0;
                            }
                        }
                    }
                }
            }
        }
    }
}
