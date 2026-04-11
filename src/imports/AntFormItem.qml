import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Item {
    id: control

    // 枚举定义
    enum LabelAlign {
        AlignLeft = 0,
        AlignRight = 1
    }

    enum ValidationStatus {
        ValidationNone = 0,
        ValidationSuccess = 1,
        ValidationError = 2
    }

    // 基础属性
    property bool animationEnabled: AntTheme.animationEnabled
    property bool required: false
    property int requiredSpacing: 4
    property int orientation: Qt.Vertical
    property string labelText: ''
    property int labelAlign: AntFormItem.AlignLeft
    property int labelWidth: 100
    property int labelSpacing: (control.orientation === Qt.Vertical) ? 4 : 10
    property string colonText: ':'
    property bool colonVisible: false
    property int feedbackSpacing: 2
    property bool keepFeedbackPlace: true
    property AntMargin marginItem: AntMargin { all: 0 }

    // 提示属性
    property bool tooltipVisible: true
    property int tooltipSpacing: 2
    property bool tooltipArrowVisible: true
    property int tooltipArrowOffset: 4
    property int tooltipPosition: AntToolTip.PositionTop
    property var tooltipIconSource: AntIcon.QuestionCircleOutlined
    property int tooltipIconSize: control.themeSource.fontTooltipIconSize
    property string tooltipText: ''
    property int tooltipTextSize: control.themeSource.fontTooltipTextSize
    property color colorTooltipIcon: control.themeSource.colorTooltipIcon
    property color colorTooltipIconHover: control.themeSource.colorTooltipIconHover
    property color colorTooltipText: control.themeSource.colorTooltipText

    // 验证相关
    property var validator: null    // 接受无参数函数: () => ({valid: bool, message: string}) | bool | undefined

    // 主题
    property color colorLabelText: control.themeSource.colorLabelText
    property color colorLabelRequired: control.themeSource.colorLabelRequired
    property color colorFeedbackSuccess: control.themeSource.colorFeedbackSuccess
    property color colorFeedbackError: control.themeSource.colorFeedbackError
    property var themeSource: AntTheme.AntFormItem

    // 默认内容
    default property alias contentDelegate: __contentItem.data

    objectName: '__AntFormItem__'
    implicitWidth: __mainLoader.implicitWidth
    implicitHeight: __mainLoader.implicitHeight

    // 主布局加载器
    Loader {
        id: __mainLoader
        anchors.fill: parent
        sourceComponent: (control.orientation === Qt.Vertical) ? __verticalComponent : __horizontalComponent
    }

    // 垂直布局组件
    Component {
        id: __verticalComponent
        ColumnLayout {
            spacing: 0
            anchors.topMargin: control.marginItem.top
            anchors.bottomMargin: control.marginItem.bottom
            anchors.leftMargin: control.marginItem.left
            anchors.rightMargin: control.marginItem.right

            // 标签
            Loader {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
                sourceComponent: __labelComponent
            }

            // 标签间距
            Item {
                height: control.labelSpacing
                Layout.fillWidth: true
            }

            // 内容和反馈
            ColumnLayout {
                spacing: !control.keepFeedbackPlace ? 0 : control.feedbackSpacing
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignTop

                // 内容区域
                Item {
                    id: __verticalContentArea
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredHeight: childrenRect ? childrenRect.height : 0
                    Component.onCompleted: {
                        for (let i = 0; i < __contentItem.data.length; i++) {
                            __contentItem.data[i].parent = __verticalContentArea;
                        }
                    }
                }

                // 反馈文本
                Loader {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    sourceComponent: __feedbackComponent
                    active: control.keepFeedbackPlace
                    visible: active
                }
            }
        }
    }

    // 水平布局组件
    Component {
        id: __horizontalComponent
        RowLayout {
            id: __horizontalRowLayout
            anchors.topMargin: control.marginItem.top
            anchors.bottomMargin: control.marginItem.bottom
            anchors.leftMargin: control.marginItem.left
            anchors.rightMargin: control.marginItem.right
            spacing: control.labelSpacing

            // 计算最大高度
            property real maxContentHeight: 0

            // 标签区域
            Loader {
                id: __labelLoader
                Layout.alignment: (control.orientation === Qt.Vertical) ? Qt.AlignVCenter : Qt.AlignTop
                Layout.preferredWidth: control.labelWidth
                Layout.preferredHeight: __horizontalRowLayout.maxContentHeight
                sourceComponent: __labelComponent
            }

            // 内容和反馈列
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: !control.keepFeedbackPlace ? 0 : control.feedbackSpacing

                // 内容区域
                Item {
                    id: __horizontalContentArea
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onChildrenRectChanged: {
                        if (control.orientation === Qt.Horizontal) {
                            __horizontalRowLayout.recalcMaxHeight();
                        }
                    }
                    Component.onCompleted: {
                        for (let i = 0; i < __contentItem.data.length; i++) {
                            __contentItem.data[i].parent = __horizontalContentArea;
                        }
                        if (control.orientation === Qt.Horizontal) {
                            __horizontalRowLayout.recalcMaxHeight();
                        }
                    }
                }

                // 反馈文本
                Loader {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    sourceComponent: __feedbackComponent
                    active: control.keepFeedbackPlace
                    visible: active
                }
            }

            // 延迟计算函数
            function recalcMaxHeight(): void {
                Qt.callLater(function() {
                    const labelHeight = __labelLoader.item ? __labelLoader.item.implicitHeight : 0;
                    const contentHeight = __horizontalContentArea.childrenRect.height;
                    __horizontalRowLayout.maxContentHeight = Math.max(labelHeight, contentHeight, 0);
                    if (__labelLoader.item) {
                        __labelLoader.Layout.preferredHeight = __horizontalRowLayout.maxContentHeight;
                    }
                    __horizontalContentArea.Layout.preferredHeight = __horizontalRowLayout.maxContentHeight;
                });
            }
        }
    }

    // 子组件容器（隐藏）
    Item {
        id: __contentItem
        width: parent.width
        visible: false
    }

    // 标签组件
    Component {
        id: __labelComponent
        RowLayout {
            spacing: control.required ? control.requiredSpacing : 0
            visible: !!control.labelText

            Item {
                Layout.fillWidth: control.labelAlign === AntFormItem.AlignRight
            }

            // 必填星号
            AntText {
                Layout.alignment: Qt.AlignVCenter
                Layout.topMargin: parseInt(control.themeSource.fontLabelSize) / 3
                text: '*'
                color: control.colorLabelRequired
                font {
                    family: control.themeSource.fontLabelFamily
                    pixelSize: control.themeSource.fontLabelSize
                }
                verticalAlignment: Text.AlignVCenter
                visible: control.required
            }

            // 标签文本
            AntText {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillHeight: true
                text: control.labelText + (control.colonVisible ? control.colonText : '')
                color: control.colorLabelText
                font {
                    family: control.themeSource.fontLabelFamily
                    pixelSize: control.themeSource.fontLabelSize
                }
                verticalAlignment: Text.AlignVCenter
                visible: !!control.labelText
            }

            // 提示文本
            AntIconText {
                Layout.fillHeight: true
                Layout.leftMargin: control.tooltipSpacing
                iconSource: control.tooltipIconSource
                iconSize: control.tooltipIconSize
                colorIcon: control.colorTooltipIcon
                colorIconHover: control.colorTooltipIconHover
                verticalAlignment: Text.AlignVCenter
                visible: control.tooltipVisible && !!control.tooltipText

                AntToolTip {
                    arrowVisible: control.tooltipArrowVisible
                    arrowOffset: control.tooltipArrowOffset
                    text: control.tooltipText
                    colorText: control.colorTooltipText
                    font.pixelSize: control.tooltipTextSize
                    position: control.tooltipPosition
                    visible: parent.hovered
                }
            }

            Item {
                Layout.fillWidth: control.labelAlign === AntFormItem.AlignLeft
            }
        }
    }

    // 反馈文本组件
    Component {
        id: __feedbackComponent
        AntText {
            opacity: visible ? 1 : 0
            text: __private.feedbackText
            color: {
                switch (__private.validationStatus) {
                    case AntFormItem.ValidationSuccess:
                        return control.colorFeedbackSuccess;
                    case AntFormItem.ValidationError:
                        return control.colorFeedbackError;
                    default:
                        return control.themeSource.colorFeedbackNormal;
                }
            }
            font {
                family: control.themeSource.fontFeedbackFamily
                pixelSize: control.themeSource.fontFeedbackSize
            }
            visible: !!__private.feedbackText || control.keepFeedbackPlace

            Behavior on opacity {
                enabled: control.animationEnabled
                NumberAnimation { duration: AntTheme.Primary.durationFast }
            }

            Behavior on color {
                enabled: control.animationEnabled
                ColorAnimation { duration: AntTheme.Primary.durationMid }
            }
        }
    }

    // 公开的验证方法 - 校验所有一级子组件
    function validate(param): bool {
        let allValid = true;
        for (let i = 0; i < __contentItem.children.length; i++) {
            const child = __contentItem.children[i];
            // 如果子组件也有 validate 方法（例如嵌套的 FormItem），递归调用
            if (child.hasOwnProperty('validate') && typeof child.validate === 'function') {
                if (!child.validate(param)) {
                    allValid = false;
                }
            }
        }
        // 执行当前组件的验证
        __private.validateInternal(param);
        // 检查当前组件的验证状态
        if (__private.validationStatus === AntFormItem.ValidationError) {
            allValid = false;
        }
        return allValid;
    }

    QtObject {
        id: __private
        property int validationStatus: AntFormItem.ValidationNone
        property string feedbackText: ''

        function validateInternal(param): void {
            if (typeof control.validator !== 'function') {
                __private.validationStatus = AntFormItem.ValidationNone;
                __private.feedbackText = '';
                return;
            }
            try {
                // 调用 validator，如果提供了参数则传递参数，否则不传参数
                let result = (arguments.length > 0) ? control.validator(param) : control.validator();
                // 处理 undefined 返回值 - 清空反馈
                if (result === undefined) {
                    __private.validationStatus = AntFormItem.ValidationNone;
                    __private.feedbackText = '';
                    return;
                }
                // 支持返回布尔值
                if (typeof result === 'boolean') {
                    __private.validationStatus = result ? AntFormItem.ValidationSuccess : AntFormItem.ValidationError;
                    __private.feedbackText = result ? qsTr('校验通过') : qsTr('校验不通过');
                }
                // 支持返回对象 {valid: bool, message: string}
                else if (typeof result === 'object' && result !== null) {
                    __private.validationStatus = result.valid ? AntFormItem.ValidationSuccess : AntFormItem.ValidationError;
                    __private.feedbackText = result.message || '';
                }
            } catch (ex) {
                console.error('AntFormItem validation error:', ex);
                __private.validationStatus = AntFormItem.ValidationError;
                __private.feedbackText = qsTr('验证出错');
            }
        }
    }
}
