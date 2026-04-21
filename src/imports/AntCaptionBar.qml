import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Rectangle {
    id: control

    property var targetWindow: null
    property AntWindowAgent windowAgent: null
    property alias layoutDirection: __row.layoutDirection
    property var winIcon: ''
    property alias winIconWidth: __winIconLoader.width
    property alias winIconHeight: __winIconLoader.height
    property alias winIconVisible: __winIconLoader.visible
    property string winTitle: targetWindow?.title ?? ''
    property font winTitleFont: Qt.font({
        family: AntTheme.Primary.fontPrimaryFamily,
        pixelSize: 14
    })
    property color winTitleColor: AntTheme.Primary.colorTextBase
    property alias winTitleVisible: __winTitleLoader.visible
    property bool returnButtonEnabled: true
    property bool returnButtonVisible: false
    property bool themeButtonEnabled: true
    property bool themeButtonVisible: false
    property bool topButtonChecked: false
    property bool topButtonEnabled: true
    property bool topButtonVisible: false
    property bool minimizeButtonVisible: Qt.platform.os !== 'osx'
    property bool maximizeButtonVisible: Qt.platform.os !== 'osx'
    property bool closeButtonVisible: Qt.platform.os !== 'osx'
    property var returnCallback: () => { }
    property var themeCallback: () => {
        AntTheme.darkMode = AntTheme.isDark ? AntTheme.Light : AntTheme.Dark;
    }
    property var topCallback: checked => { }
    property var minimizeCallback: () => {
        if (targetWindow) {
            AntApi.setWindowState(targetWindow, Qt.WindowMinimized);
        }
    }
    property var maximizeCallback: () => {
        if (!targetWindow) {
            return;
        }
        if (targetWindow.visibility === Window.Maximized || targetWindow.visibility === Window.FullScreen) {
            targetWindow.showNormal();
        } else {
            targetWindow.showMaximized();
        }
    }
    property var closeCallback: () => {
        if (targetWindow) targetWindow.close();
    }
    property string ariaConstrual: winTitle

    property Component winIconDelegate: Image {
        source: control.winIcon
        sourceSize.width: width
        sourceSize.height: height
        mipmap: true
    }
    property Component winTitleDelegate: AntText {
        text: winTitle
        color: winTitleColor
        font: winTitleFont
    }
    property Component winAheadButtonsDelegate: Item { }
    property Component winPresetButtonsDelegate: Row {
        Connections {
            target: control
            function onWindowAgentChanged() {
                control.addInteractionItem(__themeButton);
                control.addInteractionItem(__topButton);
            }
        }

        AntCaptionButton {
            id: __themeButton
            height: parent.height
            iconSource: AntTheme.isDark ? AntIcon.MoonOutlined : AntIcon.SunOutlined
            iconSize: AntTheme.AntCaptionButton.fontSize
            colorIcon: control.winTitleColor
            enabled: control.themeButtonEnabled
            visible: control.themeButtonVisible
            forceState: true
            ariaConstrual: qsTr('明暗主题切换')
            onClicked: {
                control.themeCallback();
            }
        }

        AntCaptionButton {
            id: __topButton
            height: parent.height
            iconSource: AntIcon.PushpinOutlined
            iconSize: AntTheme.AntCaptionButton.fontSize
            colorIcon: control.winTitleColor
            enabled: control.topButtonEnabled
            visible: control.topButtonVisible
            forceState: true
            checkable: true
            checked: control.topButtonChecked
            ariaConstrual: qsTr('置顶')
            onClicked: {
                control.topCallback(checked);
            }
        }
    }
    property Component winExtraButtonsDelegate: Item { }
    property Component winButtonsDelegate: Row {
        Connections {
            target: control
            function onWindowAgentChanged() {
                if (windowAgent) {
                    windowAgent.setSystemButton(AntWindowAgent.Minimize, __minimizeButton);
                    windowAgent.setSystemButton(AntWindowAgent.Maximize, __maximizeButton);
                    windowAgent.setSystemButton(AntWindowAgent.Close, __closeButton);
                }
            }
        }

        AntCaptionButton {
            id: __minimizeButton
            height: parent.height
            forceState: true
            iconSource: AntIcon.LineOutlined
            iconSize: AntTheme.AntCaptionButton.fontSize
            colorIcon: control.winTitleColor
            visible: control.minimizeButtonVisible
            ariaConstrual: qsTr('最小化')
            onClicked: {
                control.minimizeCallback();
            }
        }

        AntCaptionButton {
            id: __maximizeButton
            height: parent.height
            forceState: true
            iconSize: AntTheme.AntCaptionButton.fontSize
            colorIcon: control.winTitleColor
            visible: control.maximizeButtonVisible
            ariaConstrual: qsTr('最大化')
            contentItem: AntIconText {
                iconSource: AntIcon.SwitcherTwotonePath3
                iconSize: __maximizeButton.iconSize
                colorIcon: __maximizeButton.colorIcon
                verticalAlignment: Text.AlignVCenter
                visible: targetWindow

                AntIconText {
                    anchors.centerIn: parent
                    iconSource: AntIcon.SwitcherTwotonePath2
                    iconSize: __maximizeButton.iconSize
                    colorIcon: __maximizeButton.colorIcon
                    verticalAlignment: Text.AlignVCenter
                    visible: targetWindow && targetWindow.visibility === Window.Maximized
                }
            }
            onClicked: {
                control.maximizeCallback();
            }
        }

        AntCaptionButton {
            id: __closeButton
            height: parent.height
            iconSource: AntIcon.CloseOutlined
            iconSize: AntTheme.AntCaptionButton.fontSize
            colorIcon: control.winTitleColor
            visible: control.closeButtonVisible
            forceState: true
            danger: true
            ariaConstrual: qsTr('关闭')
            onClicked: {
                control.closeCallback();
            }
        }
    }

    objectName: '__AntCaptionBar__'
    color: 'transparent'

    RowLayout {
        id: __row
        anchors.fill: parent
        spacing: 0

        AntCaptionButton {
            id: __returnButton
            Layout.alignment: Qt.AlignVCenter
            forceState: true
            iconSource: AntIcon.ArrowLeftOutlined
            iconSize: AntTheme.AntCaptionButton.fontSize
            colorIcon: control.winTitleColor
            enabled: control.returnButtonEnabled
            visible: control.returnButtonVisible
            onClicked: control.returnCallback();
            ariaConstrual: qsTr('返回')
        }

        Item {
            id: __title
            Layout.fillWidth: true
            Layout.fillHeight: true
            Component.onCompleted: {
                if (windowAgent) {
                    windowAgent.setTitleBar(__title);
                }
            }

            Row {
                height: parent.height
                anchors.left: Qt.platform.os === 'osx' ? undefined : parent.left
                anchors.leftMargin: Qt.platform.os === 'osx' ? 0 : 8
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: Qt.platform.os === 'osx' ? parent.horizontalCenter : undefined
                spacing: 5

                Loader {
                    id: __winIconLoader
                    width: 20
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: winIconDelegate
                }

                Loader {
                    id: __winTitleLoader
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: winTitleDelegate
                }
            }
        }

        Loader {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            sourceComponent: winAheadButtonsDelegate
        }

        Loader {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            sourceComponent: winPresetButtonsDelegate
        }

        Loader {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            sourceComponent: winExtraButtonsDelegate
        }

        Loader {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            sourceComponent: winButtonsDelegate
        }
    }

    Accessible.role: Accessible.TitleBar
    Accessible.name: control.ariaConstrual
    Accessible.description: control.ariaConstrual

    function addInteractionItem(item) {
        if (windowAgent) {
            windowAgent.setHitTestVisible(item, true);
        }
    }

    function removeInteractionItem(item) {
        if (windowAgent) {
            windowAgent.setHitTestVisible(item, false);
        }
    }
}
