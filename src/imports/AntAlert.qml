import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Item {
    id: control

    enum AlertType {
        TypeInfo = 0,
        TypeSuccess = 1,
        TypeWarning = 2,
        TypeError = 3
    }

    enum MarqueeDirection {
        DirectionLeft = 0,
        DirectionRight = 1
    }

    // 基础属性
    property bool animationEnabled: AntTheme.animationEnabled
    property bool borderVisible: true
    property bool closable: false
    property int delay: 0    // 毫秒
    property int type: AntAlert.TypeInfo
    property bool iconVisible: control.iconSource !== 0 && control.iconSource !== ''
    property int iconSize: 24
    property var iconSource: {
        switch (type) {
            case AntAlert.TypeInfo: return AntIcon.InfoCircleFilled
            case AntAlert.TypeSuccess: return AntIcon.CheckCircleFilled
            case AntAlert.TypeWarning: return AntIcon.ExclamationCircleFilled
            case AntAlert.TypeError: return AntIcon.CloseCircleFilled
            default: return AntIcon.InfoCircleFilled
        }
    }
    property bool titleVisible: !!control.titleText
    property string titleText: ''
    property bool descriptionVisible: !!control.descriptionText
    property string descriptionText: ''
    property bool extraVisible: true
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }
    property real contentRowSpacing: 10
    property real contentColumnSpacing: 8
    property var closeAlign: control.marqueeEnabled ? Qt.AlignRight : Qt.AlignTop | Qt.AlignRight
    property var extraAlign: control.marqueeEnabled ? Qt.AlignRight : Qt.AlignTop | Qt.AlignRight

    // 跑马灯属性
    property bool marqueeEnabled: false
    property int marqueeDelay: 0
    property int marqueeSpeed: 25000
    property int marqueeDirection: AntAlert.DirectionLeft

    // 主题相关
    property color colorBg: {
        switch (type) {
            case AntAlert.TypeInfo: return AntTheme.Primary.colorInfoBg
            case AntAlert.TypeSuccess: return AntTheme.Primary.colorSuccessBg
            case AntAlert.TypeWarning: return AntTheme.Primary.colorWarningBg
            case AntAlert.TypeError: return AntTheme.Primary.colorErrorBg
            default: return AntTheme.Primary.colorInfoBg
        }
    }

    property color colorBorder: control.themeSource.colorBorder
    property color colorIcon: {
        switch (type) {
            case AntAlert.TypeInfo: return AntTheme.Primary.colorInfo
            case AntAlert.TypeSuccess: return AntTheme.Primary.colorSuccess
            case AntAlert.TypeWarning: return AntTheme.Primary.colorWarning
            case AntAlert.TypeError: return AntTheme.Primary.colorError
            default: return control.themeSource.colorIcon
        }
    }
    property color colorTitle: control.themeSource.colorTitle
    property color colorDescription: control.themeSource.colorDescription
    property color colorMarquee: control.themeSource.colorMarquee

    // 字体属性
    property font titleFont: Qt.font({
        family: control.themeSource.titleFontFamily,
        pixelSize: parseInt(control.themeSource.titleFontSize),
    })
    property font descriptionFont: Qt.font({
        family: control.themeSource.descriptionFontFamily,
        pixelSize: parseInt(control.themeSource.descriptionFontSize)
    })
    property font marqueeFont: Qt.font({
        family: control.themeSource.marqueeFontFamily,
        pixelSize: parseInt(control.themeSource.marqueeFontSize)
    })

    // 边距属性
    property AntMargin marginIcon: AntMargin { all: 0 }
    property AntMargin marginContent: AntMargin { left: 16 }
    property AntMargin marginExtra: AntMargin { top: 4; right: 6 }

    // 委托属性
    property Component extraDelegate: Item { }
    property Component iconDelegate: AntIconText {
        iconSource: control.iconSource
        iconSize: control.iconSize
        colorIcon: control.colorIcon
        height: control.iconSize
        verticalAlignment: Text.AlignVCenter
    }
    property Component titleDelegate: AntText {
        text: control.titleText
        color: control.colorTitle
        font: control.titleFont
        visible: !!control.titleText
    }
    property Component descriptionDelegate: AntText {
        text: control.descriptionText
        color: control.colorDescription
        font: control.descriptionFont
        visible: !!control.descriptionText
    }
    property Component closeDelegate: AntIconButton {
        iconSource: AntIcon.CloseOutlined
        iconSize: 14
        colorIcon: control.themeSource.colorClose
        type: AntIconButton.TypeLink
        visible: control.closable
        onClicked: control.close()
    }
    property Component bgDelegate: AntRectangleInternal {
        anchors.fill: parent
        color: control.colorBg
        border.color: control.colorBorder
        border.width: control.borderVisible ? 1 : 0
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
        implicitHeight: __mainLayout.implicitHeight

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
        Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationFast } }
    }
    property var themeSource: AntTheme.AntAlert

    signal closed()

    objectName: '__AntAlert__'
    implicitWidth: parent.width
    implicitHeight: Math.max(__bgLoader.implicitHeight, __mainLayout.implicitHeight)

    Loader {
        id: __bgLoader
        anchors.fill: parent
        sourceComponent: bgDelegate
    }

    RowLayout {
        id: __mainLayout
        anchors.fill: parent
        anchors.margins: control.marginContent.all
        anchors.topMargin: control.marginContent.top
        anchors.bottomMargin: control.marginContent.bottom
        anchors.leftMargin: control.marginContent.left
        anchors.rightMargin: control.marginContent.right
        spacing: control.contentRowSpacing

        // 主容器
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: control.marqueeEnabled
            Layout.minimumHeight: __contentColumn.implicitHeight
            spacing: control.contentRowSpacing

            // 图标
            Loader {
                id: __iconLoader
                Layout.alignment: control.marqueeEnabled ? Qt.AlignVCenter : Qt.AlignTop
                Layout.fillHeight: control.marqueeEnabled
                Layout.topMargin: control.marginIcon.top
                Layout.bottomMargin: control.marginIcon.bottom
                Layout.leftMargin: control.marginIcon.left
                Layout.rightMargin: control.marginIcon.right
                sourceComponent: control.iconDelegate
                active: control.iconVisible
                visible: active
            }

            // 标题和描述
            ColumnLayout {
                id: __contentColumn
                Layout.fillWidth: true
                spacing: control.contentColumnSpacing
                visible: !control.marqueeEnabled

                Loader {
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    sourceComponent: control.titleDelegate
                    active: control.titleVisible
                    visible: active
                }

                Loader {
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    sourceComponent: control.descriptionDelegate
                    active: control.descriptionVisible
                    visible: active
                }
            }

            // 跑马灯
            Item {
                id: __marqueeContainer
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                visible: control.marqueeEnabled

                AntText {
                    id: __marqueeText
                    anchors.verticalCenter: parent.verticalCenter
                    text: control.titleText + (!control.descriptionText ? '' : (' ' + control.descriptionText))
                    color: control.colorMarquee
                    font: control.marqueeFont
                }

                NumberAnimation {
                    id: __marqueeAnimation
                    target: __marqueeText
                    property: 'x'
                    duration: control.marqueeSpeed
                    easing.type: Easing.Linear
                    onFinished: {
                        if (control.marqueeDirection === AntAlert.DirectionLeft) {
                            __marqueeText.x = __marqueeContainer.width;
                        } else {
                            __marqueeText.x = -__marqueeText.width;
                        }
                        restart();
                    }
                }
            }
        }

        // 额外操作区
        Loader {
            Layout.alignment: control.extraAlign
            Layout.topMargin: control.marginExtra.top
            Layout.bottomMargin: control.marginExtra.bottom
            Layout.leftMargin: control.marginExtra.left
            Layout.rightMargin: control.marginExtra.right
            sourceComponent: control.extraDelegate
            active: control.extraVisible
            visible: active
        }

        // 关闭按钮
        Loader {
            Layout.alignment: control.closeAlign
            sourceComponent: control.closeDelegate
            active: control.closable
            visible: active
        }
    }

    // 跑马灯控制
    Timer {
        id: __marqueeTimer
        interval: control.marqueeDelay
        running: control.marqueeEnabled && control.visible && control.height > 0
        onTriggered: {
            if (control.marqueeDirection === AntAlert.DirectionLeft) {
                __marqueeText.x = __marqueeContainer.width;
                __marqueeAnimation.to = -__marqueeText.width;
            } else {
                __marqueeText.x = -__marqueeText.width;
                __marqueeAnimation.to = __marqueeContainer.width;
            }
            __marqueeAnimation.start();
        }
    }

    // 关闭动画
    NumberAnimation {
        target: control
        property: 'opacity'
        from: 1.0
        to: 0.0
        duration: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        easing.type: Easing.InQuad
        running: __private.closing
        onFinished: {
            __private.closing = false;
            control.visible = false;
            control.opacity = 1.0;
        }
    }

    // 延迟关闭
    Timer {
        id: __delayTimer
        interval: control.delay
        running: control.delay > 0 && control.visible && control.height > 0
        onTriggered: {
            control.close();
        }
    }

    Timer {
        id: __removeTimer
        interval: control.animationEnabled ? AntTheme.Primary.durationMid : 0
        running: false
        onTriggered: {
            __private.closing = false;
            control.height = 0;
            control.visible = false;
        }
    }

    function close(): void {
        if (animationEnabled && !__private.closing) {
            __private.closing = true;
            __removeTimer.start();
        } else {
            control.height = 0;
            control.visible = false;
        }
        control.closed();
    }

    QtObject {
        id: __private
        property bool closing: false
    }
}
