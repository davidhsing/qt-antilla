import QtQuick
import Antilla.Basic

Item {
    id: control

    property bool animationEnabled: AntTheme.animationEnabled
    property int defaultButtonWidth: 28
    property int defaultButtonHeight: 28
    property int defaultButtonSpacing: 8
    property int defaultSelectWidth: 80
    property int defaultInputWidth: 50
    property int currentPageIndex: 0
    property int total: 0
    property int pageTotal: pageSize > 0 ? Math.ceil(total / pageSize) : 0
    property int pageMaxButton: 7
    property int pageSize: 10
    property var pageSizeModel: []
    property string prevButtonTooltip: qsTr('上一页')
    property string nextButtonTooltip: qsTr('下一页')
    property string prevMoreTooltip: qsTr('前5页')
    property string nextMoreTooltip: qsTr('后5页')
    property bool quickJumperVisible: false
    property string quickJumperPrefix: qsTr('跳至')
    property string quickJumperSuffix: ''
    property Component prevButtonDelegate: ActionButton {
        iconSource: AntIcon.LeftOutlined
        tooltipText: control.prevButtonTooltip
        disabled: control.currentPageIndex === 0
        onClicked: control.gotoPrevPage();
    }
    property Component nextButtonDelegate: ActionButton {
        iconSource: AntIcon.RightOutlined
        tooltipText: control.nextButtonTooltip
        disabled: control.currentPageIndex === (control.pageTotal - 1)
        onClicked: control.gotoNextPage();
    }
    property Component quickJumperDelegate: Row {
        height: control.defaultButtonHeight
        spacing: control.defaultButtonSpacing

        AntText {
            anchors.verticalCenter: parent.verticalCenter
            text: control.quickJumperPrefix
            font {
                family: control.themeSource.fontFamily
                pixelSize: control.themeSource.fontSize
            }
            color: AntTheme.Primary.colorTextBase
            visible: !!control.quickJumperPrefix
        }

        AntInput {
            width: control.defaultInputWidth
            height: control.defaultButtonHeight
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: AntInput.AlignHCenter
            animationEnabled: control.animationEnabled
            enabled: control.enabled
            inputMethodHints: Qt.ImhDigitsOnly
            validator: IntValidator { top: 99999; bottom: 0 }
            onEditingFinished: {
                control.gotoPageIndex(parseInt(text) - 1);
                clear();
            }
        }

        AntText {
            anchors.verticalCenter: parent.verticalCenter
            text: control.quickJumperSuffix
            font {
                family: AntTheme.Primary.fontPrimaryFamily
                pixelSize: AntTheme.Primary.fontPrimarySize
            }
            color: AntTheme.Primary.colorTextBase
            visible: !!control.quickJumperSuffix
        }
    }
    property var themeSource: AntTheme.AntPagination

    objectName: '__AntPagination__'
    implicitWidth: __row.width
    implicitHeight: __row.height
    onPageSizeChanged: {
        const __pageTotal = (pageSize > 0 ? Math.ceil(total / pageSize) : 0);
        if (currentPageIndex > __pageTotal) {
            currentPageIndex = __pageTotal - 1;
        }
    }

    Component.onCompleted: currentPageIndexChanged();

    component PaginationButton: AntButton {
        padding: 0
        width: control.defaultButtonWidth
        height: control.defaultButtonHeight
        animationEnabled: false
        effectEnabled: false
        enabled: control.enabled
        text: (pageIndex + 1)
        checked: control.currentPageIndex === pageIndex
        font.bold: checked
        colorText: {
            if (enabled) {
                return checked ? control.themeSource.colorButtonTextActive : control.themeSource.colorButtonText;
            }
            return control.themeSource.colorButtonTextDisabled;
        }
        colorBg: {
            if (enabled) {
                if (checked) {
                    return control.themeSource.colorButtonBg;
                }
                return down ? control.themeSource.colorButtonBgActive : (hovered ? control.themeSource.colorButtonBgHover : control.themeSource.colorButtonBg);
            }
            return checked ? control.themeSource.colorButtonBgDisabled : 'transparent';
        }
        colorBorder: checked ? control.themeSource.colorBorderActive : 'transparent'
        onClicked: {
            control.currentPageIndex = pageIndex;
        }
        property int pageIndex: 0

        Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
        Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
        Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
    }

    component PaginationMoreButton: AntIconButton {
        id: __moreRoot
        padding: 0
        width: control.defaultButtonWidth
        height: control.defaultButtonHeight
        animationEnabled: false
        effectEnabled: false
        enabled: control.enabled
        colorBg: 'transparent'
        colorBorder: 'transparent'
        iconSource: __moreRoot.isPrev ? AntIcon.DoubleLeftOutlined : AntIcon.DoubleRightOutlined

        property bool iconVisible: (enabled && (down || hovered))
        property bool isPrev: false
        property alias tooltipText: __moreTooltip.text

        onIconVisibleChanged: __seqAnimation.restart();

        SequentialAnimation {
            id: __seqAnimation
            alwaysRunToEnd: true
            NumberAnimation {
                target: __moreRoot
                property: 'opacity'
                from: 0.0
                to: 1.0
                duration: control.animationEnabled ? AntTheme.Primary.durationSlow : 0
            }
        }

        AntToolTip {
            id: __moreTooltip
            arrowVisible: false
            visible: parent.enabled && parent.hovered && text !== ''
            animationEnabled: control.animationEnabled
        }
    }

    component ActionButton: Item {
        id: __actionRoot
        width: __actionButton.width
        height: __actionButton.height

        signal clicked()
        property bool disabled: false
        property alias iconSource: __actionButton.iconSource
        property alias tooltipText: __tooltip.text

        AntIconButton {
            id: __actionButton
            padding: 0
            width: control.defaultButtonWidth
            height: control.defaultButtonHeight
            animationEnabled: control.animationEnabled
            enabled: control.enabled && !__actionRoot.disabled
            effectEnabled: false
            colorBorder: 'transparent'
            colorBg: enabled ? (down ? control.themeSource.colorActionBgActive : (hovered ? control.themeSource.colorActionBgHover : control.themeSource.colorActionBg)) : control.themeSource.colorActionBg
            onClicked: __actionRoot.clicked();

            AntToolTip {
                id: __tooltip
                arrowVisible: false
                visible: parent.hovered && parent.enabled && text !== ''
                animationEnabled: control.animationEnabled
            }
        }

        HoverHandler {
            enabled: __actionRoot.disabled
            cursorShape: Qt.ForbiddenCursor
        }
    }

    Row {
        id: __row
        spacing: control.defaultButtonSpacing

        Loader {
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.prevButtonDelegate
        }

        PaginationButton {
            pageIndex: 0
            visible: control.pageTotal > 0
        }

        PaginationMoreButton {
            isPrev: true
            tooltipText: control.prevMoreTooltip
            visible: control.pageTotal > control.pageMaxButton && (control.currentPageIndex + 1) > __private.pageButtonHalfCount
            onClicked: control.gotoPrev5Page();
        }

        Repeater {
            id: __repeater
            model: (control.pageTotal < 2) ? 0 : ((control.pageTotal >= control.pageMaxButton) ? (control.pageMaxButton - 2) : (control.pageTotal - 2))
            delegate: Loader {
                sourceComponent: PaginationButton {
                    pageIndex: {
                        if ((control.currentPageIndex + 1) <= __private.pageButtonHalfCount) {
                            return index + 1;
                        }
                        else if (control.pageTotal - (control.currentPageIndex + 1) <= (control.pageMaxButton - __private.pageButtonHalfCount)) {
                            return (control.pageTotal - __repeater.count + index - 1);
                        } else {
                            return (control.currentPageIndex + index + 2 - __private.pageButtonHalfCount);
                        }
                    }
                }
                required property int index
            }
        }

        PaginationMoreButton {
            isPrev: false
            tooltipText: control.nextMoreTooltip
            visible: control.pageTotal > control.pageMaxButton && (control.pageTotal - (control.currentPageIndex + 1) > (control.pageMaxButton - __private.pageButtonHalfCount))
            onClicked: control.gotoNext5Page();
        }

        PaginationButton {
            pageIndex: control.pageTotal - 1
            visible: control.pageTotal > 1
        }

        Loader {
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.nextButtonDelegate
        }

        AntSelect {
            anchors.verticalCenter: parent.verticalCenter
            animationEnabled: control.animationEnabled
            clearable: false
            model: control.pageSizeModel
            width: control.defaultSelectWidth
            height: control.defaultButtonHeight
            visible: count > 0
            onActivated: () => {
                control.pageSize = currentValue;
            }
        }

        Loader {
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.quickJumperVisible ? control.quickJumperDelegate : null
        }
    }

    function gotoPageIndex(index: int) {
        if (index <= 0) {
            control.currentPageIndex = 0;
        } else if (index < pageTotal) {
            control.currentPageIndex = index;
        } else {
            control.currentPageIndex = (pageTotal - 1);
        }
    }

    function gotoPrevPage() {
        if (currentPageIndex > 0) {
            currentPageIndex--;
        }
    }

    function gotoPrev5Page() {
        if (currentPageIndex > 5) {
            currentPageIndex -= 5;
        } else {
            currentPageIndex = 0;
        }
    }

    function gotoNextPage() {
        if (currentPageIndex < pageTotal) {
            currentPageIndex++;
        }
    }

    function gotoNext5Page() {
        if ((currentPageIndex + 5) < pageTotal) {
            currentPageIndex += 5;
        } else {
            currentPageIndex = pageTotal - 1;
        }
    }

    QtObject {
        id: __private
        property int pageButtonHalfCount: Math.ceil(control.pageMaxButton / 2)
    }
}
