//pragma Singleton

import QtQuick
import Antilla.Basic

QtObject {
    id: root

    property int themeIndex: 8
    property var primaryTokens: []
    property var componentTokens: new Object
    property var menus: []
    property var options: []
    property var updates: []
    property var galleryModel: [
        {
            key: 'HomePage',
            label: qsTr('首页'),
            iconSource: AntIcon.HomeOutlined,
            source: './Home/HomePage.qml'
        },
        {
            type: 'divider'
        },
        {
            key: 'General',
            label: qsTr('通用'),
            iconSource: AntIcon.ProductOutlined,
            children: [
                {
                    key: 'AntWindow',
                    label: qsTr('AntWindow 无边框窗口'),
                    source: './Examples/General/ExpWindow.qml',
                    desc: qsTr('添加 setMacSystemButtonsVisible() 函数。\n更新 [SpecialEffect] 枚举值。')
                },
                {
                    key: 'AntButton',
                    label: qsTr('AntButton 按钮'),
                    source: './Examples/General/ExpButton.qml',
                    desc: qsTr('新增 Link 类型按钮。')
                },
                {
                    key: 'AntIconButton',
                    label: qsTr('AntIconButton 图标按钮'),
                    source: './Examples/General/ExpIconButton.qml',
                    desc: qsTr('带图标的按钮。')
                },
                {
                    key: 'AntCaptionButton',
                    label: qsTr('AntCaptionButton 标题按钮'),
                    source: './Examples/General/ExpCaptionButton.qml',
                    desc: qsTr('一般用于窗口标题栏的按钮。')
                },
                {
                    key: 'AntIconText',
                    label: qsTr('AntIconText 图标文本'),
                    source: './Examples/General/ExpIconText.qml',
                    desc: qsTr('新增 empty 用于判断图标是否为空。\n新增 iconSource 支持内置图标和外部 url 链接。')
                },
                {
                    key: 'AntCopyableText',
                    label: qsTr('AntCopyableText 可复制文本'),
                    source: './Examples/General/ExpCopyableText.qml',
                    desc: qsTr('用于代替 Text 以提供可复制的文本。')
                },
                {
                    key: 'AntRectangle',
                    label: qsTr('AntRectangle 圆角矩形'),
                    source: './Examples/General/ExpRectangle.qml',
                    desc: qsTr('使用 AntRectangle 可以轻松实现任意四个对角方向上的圆角矩形。')
                },
                {
                    key: 'AntPopup',
                    label: qsTr('AntPopup 弹窗'),
                    source: './Examples/General/ExpPopup.qml',
                    desc: qsTr('代替内置 Popup 的弹出式窗口。')
                },
                {
                    key: 'AntText',
                    label: qsTr('AntText 文本'),
                    source: './Examples/General/ExpText.qml',
                    desc: qsTr('代替内置 Text 的来统一字体和文本。')
                },
                {
                    key: 'AntButtonBlock',
                    label: qsTr('AntButtonBlock 按钮块'),
                    source: './Examples/General/ExpButtonBlock.qml',
                    desc: qsTr('AntIconButton 的变体，用于将多个按钮组织成块，类似 AntRadioBlock。')
                },
                {
                    key: 'AntMouseMoveArea',
                    label: qsTr('AntMouseMoveArea 鼠标移动区域'),
                    source: './Examples/General/ExpMouseMoveArea.qml',
                    desc: qsTr('移动鼠标区域，提供对任意 Item 进行鼠标移动操作的区域。')
                },
                {
                    key: 'AntMouseResizeArea',
                    label: qsTr('AntMouseResizeArea 鼠标改变大小区域'),
                    source: './Examples/General/ExpMouseResizeArea.qml',
                    desc: qsTr('改变大小鼠标区域，提供对任意 Item 进行鼠标改变大小操作的区域。')
                },
                {
                    key: 'AntCaptionBar',
                    label: qsTr('AntCaptionBar 标题栏'),
                    source: './Examples/General/ExpCaptionBar.qml',
                    desc: qsTr('新增窗口额外按钮代理 winExtraButtonsDelegate。')
                },
                {
                    key: 'AntLabel',
                    label: qsTr('AntLabel 文本标签'),
                    source: './Examples/General/ExpLabel.qml',
                    addVersion: '0.5.6.0',
                    desc: qsTr('自带背景和圆角的文本。')
                },
                {
                    key: 'AntRadius',
                    label: qsTr('AntRadius 圆角半径'),
                    source: './Examples/General/ExpRadius.qml',
                    desc: qsTr('提供四方向的圆角半径类型。')
                },
                {
                    key: 'AntMargin',
                    label: qsTr('AntMargin 边距'),
                    source: './Examples/General/ExpMargin.qml',
                    addVersion: '0.5.0.0',
                    desc: qsTr('提供四方向的边距类型。')
                },
                {
                    key: 'AntPreserve',
                    label: qsTr('AntPreserve 保留区域'),
                    source: './Examples/General/ExpPreserve.qml',
                    addVersion: '0.7.0.0',
                    desc: qsTr('提供边缘保留区域的类型，用于指定从某处到某处的保留距离。')
                },
                {
                    key: 'AntStatusBar',
                    label: qsTr('AntStatusBar 状态栏'),
                    source: './Examples/General/ExpStatusBar.qml',
                    addVersion: '0.5.0.0',
                    desc: qsTr('状态栏组件,用于在窗口底部显示应用程序状态信息。')
                }
            ]
        },
        {
            key: 'Layout',
            label: qsTr('布局'),
            iconSource: AntIcon.BarsOutlined,
            children: [
                {
                    key: 'AntDivider',
                    label: qsTr('AntDivider 分割线'),
                    source: './Examples/Layout/ExpDivider.qml',
                    desc: qsTr('区隔内容的分割线。')
                },
                {
                    key: 'AntSpace',
                    label: qsTr('AntSpace 间距'),
                    source: './Examples/Layout/ExpSpace.qml',
                    addVersion: '0.5.6.0',
                    desc: qsTr('布局并设置组件之间的间距/圆角。')
                },
                {
                    key: 'AntFormItem',
                    label: qsTr('AntFormItem 表单项'),
                    source: './Examples/Layout/ExpFormItem.qml',
                    addVersion: '0.5.0.0',
                    desc: qsTr('包裹字段带校验的表单项。')
                },
                {
                    key: 'AntGroupBox',
                    label: qsTr('AntGroupBox 分组框'),
                    source: './Examples/Layout/ExpGroupBox.qml',
                    addVersion: '0.5.0.0',
                    desc: qsTr('用于将相关内容组织在一起的分组框。')
                }
            ]
        },
        {
            key: 'Navigation',
            label: qsTr('导航'),
            iconSource: AntIcon.SendOutlined,
            children: [
                {
                    key: 'AntMenu',
                    label: qsTr('AntMenu 菜单'),
                    source: './Examples/Navigation/ExpMenu.qml',
                    updateVersion: '0.5.0.0',
                    desc: qsTr('新增 setData() 函数。\n新增 setDataProperty() 函数。')
                },
                {
                    key: 'AntScrollBar',
                    label: qsTr('AntScrollBar 滚动条'),
                    source: './Examples/Navigation/ExpScrollBar.qml',
                    desc: qsTr('滚动条是一个交互式栏，用于滚动某个区域或视图到特定位置。')
                },
                {
                    key: 'AntPagination',
                    label: qsTr('AntPagination 分页'),
                    source: './Examples/Navigation/ExpPagination.qml',
                    desc: qsTr('分页器用于分隔长列表，每次只加载一个页面。')
                },
                {
                    key: 'AntContextMenu',
                    label: qsTr('AntContextMenu 上下文菜单'),
                    source: './Examples/Navigation/ExpContextMenu.qml',
                    desc: qsTr('上下文菜单，通常作为右键单击后显示的菜单。')
                },
                {
                    key: 'AntBreadcrumb',
                    label: qsTr('AntBreadcrumb 面包屑'),
                    source: './Examples/Navigation/ExpBreadcrumb.qml',
                    desc: qsTr('面包屑，显示当前页面在系统层级结构中的位置，并能向上返回。')
                },
                {
                    key: 'AntTrayIcon',
                    label: qsTr('AntTrayIcon 托盘图标'),
                    source: './Examples/Navigation/ExpTrayIcon.qml',
                    addVersion: '0.7.0.0',
                    desc: qsTr('系统托盘区图标，配合 AntMenu 实现自定义样式的托盘菜单。')
                }
            ]
        },
        {
            key: 'DataEntry',
            label: qsTr('数据录入'),
            iconSource: AntIcon.InsertRowBelowOutlined,
            children: [
                {
                    key: 'AntSwitch',
                    label: qsTr('AntSwitch 开关'),
                    source: './Examples/DataEntry/ExpSwitch.qml',
                    desc: qsTr('使用开关切换两种状态之间。')
                },
                {
                    key: 'AntSlider',
                    label: qsTr('AntSlider 滑动输入条'),
                    source: './Examples/DataEntry/ExpSlider.qml',
                    desc: qsTr('新增 handleToolTipDelegate 滑块文字提示代理。')
                },
                {
                    key: 'AntSelect',
                    label: qsTr('AntSelect 选择器'),
                    source: './Examples/DataEntry/ExpSelect.qml',
                    desc: qsTr('新增 clearIconDelegate。\n新增 bgDelegate代理。\n新增清除图标相关属性和信号。')
                },
                {
                    key: 'AntInput',
                    label: qsTr('AntInput 输入框'),
                    source: './Examples/DataEntry/ExpInput.qml',
                    desc: qsTr('新增 clearIconDelegate。\n新增 bgDelegate代理。\n新增清除图标相关属性和信号。')
                },
                {
                    key: 'AntInputInteger',
                    label: qsTr('AntInputInteger 整数输入框'),
                    source: './Examples/DataEntry/ExpInputInteger.qml',
                    desc: qsTr('等同于 AntInputNumber，但只支持整数。')
                },
                {
                    key: 'AntInputNumber',
                    label: qsTr('AntInputNumber 数字输入框'),
                    source: './Examples/DataEntry/ExpInputNumber.qml',
                    updateVersion: '0.5.0.0',
                    desc: qsTr('新增 colorPrefix, colorSuffix。\n新增 colorBeforeLabel, colorAfterLabel。')
                },
                {
                    key: 'AntInputOnce',
                    label: qsTr('AntInputOnce 一次性口令输入框'),
                    source: './Examples/DataEntry/ExpInputOnce.qml',
                    desc: qsTr('新增 setInput() 函数。\n新增 setInputAtIndex() 函数。')
                },
                {
                    key: 'AntRate',
                    label: qsTr('AntRate 评分'),
                    source: './Examples/DataEntry/ExpRate.qml',
                    desc: qsTr('新增 toolTipDelegate 星星上方的文字提示代理。')
                },
                {
                    key: 'AntRadio',
                    label: qsTr('AntRadio 单选框'),
                    source: './Examples/DataEntry/ExpRadio.qml',
                    desc: qsTr('用于在多个备选项中选中单个状态。')
                },
                {
                    key: 'AntRadioBlock',
                    label: qsTr('AntRadioBlock 单选块'),
                    source: './Examples/DataEntry/ExpRadioBlock.qml',
                    desc: qsTr('新增支持图标。')
                },
                {
                    key: 'AntCheckBox',
                    label: qsTr('AntCheckBox 多选框'),
                    source: './Examples/DataEntry/ExpCheckBox.qml',
                    desc: qsTr('收集用户的多项选择。')
                },
                {
                    key: 'AntColorPicker',
                    label: qsTr('AntColorPicker 颜色选择器'),
                    source: './Examples/DataEntry/ExpColorPicker.qml',
                    desc: qsTr('用于选择颜色的弹出式窗口。')
                },
                {
                    key: 'AntColorPickerPanel',
                    label: qsTr('AntColorPickerPanel 颜色选择器面板'),
                    source: './Examples/DataEntry/ExpColorPickerPanel.qml',
                    desc: qsTr('用于选择颜色的面板。')
                },
                {
                    key: 'AntAutoComplete',
                    label: qsTr('AntAutoComplete 自动完成'),
                    source: './Examples/DataEntry/ExpAutoComplete.qml',
                    desc: qsTr('输入框自动完成功能。')
                },
                {
                    key: 'AntMultiSelect',
                    label: qsTr('AntMultiSelect 多选器'),
                    source: './Examples/DataEntry/ExpMultiSelect.qml',
                    desc: qsTr('多选器，可多选的下拉选择器。'),
                },
                {
                    key: 'AntDateTimePicker',
                    label: qsTr('AntDateTimePicker 日期时间选择框'),
                    source: './Examples/DataEntry/ExpDateTimePicker.qml',
                    desc: qsTr('日期时间选择框，输入或选择日期的控件。')
                },
                {
                    key: 'AntTextArea',
                    label: qsTr('AntTextArea 文本域'),
                    source: './Examples/DataEntry/ExpTextArea.qml',
                    desc: qsTr('用于替代 TextArea，提供多行文本输入。')
                },
                {
                    key: 'AntTransfer',
                    label: qsTr('AntTransfer 穿梭框'),
                    source: './Examples/DataEntry/ExpTransfer.qml',
                    addVersion: '0.5.7.0',
                    desc: qsTr('双栏穿梭选择框。')
                },
                {
                    key: 'AntFileBrowser',
                    label: qsTr('AntFileBrowser 文件浏览选择'),
                    source: './Examples/DataEntry/ExpFileBrowser.qml',
                    addVersion: '0.5.0.0',
                    desc: qsTr('文件/文件夹浏览器，支持选择文件或文件夹。')
                }
            ]
        },
        {
            key: 'DataDisplay',
            label: qsTr('数据展示'),
            iconSource: AntIcon.FundProjectionScreenOutlined,
            children: [
                {
                    key: 'AntToolTip',
                    label: qsTr('AntToolTip 文字提示'),
                    source: './Examples/DataDisplay/ExpToolTip.qml',
                    desc: qsTr('简单的文字提示气泡框，用来代替内置 ToolTip。')
                },
                {
                    key: 'AntTourFocus',
                    label: qsTr('AntTourFocus 漫游焦点'),
                    source: './Examples/DataDisplay/ExpTourFocus.qml',
                    desc: qsTr('新增 penetrationEvent/focusRadius 属性。')
                },
                {
                    key: 'AntTourStep',
                    label: qsTr('AntTourStep 漫游式引导'),
                    source: './Examples/DataDisplay/ExpTourStep.qml',
                    desc: qsTr('新增 penetrationEvent/focusRadius 属性。\n优化步骤卡片显示逻辑。')
                },
                {
                    key: 'AntTabs',
                    label: qsTr('AntTabs 标签页'),
                    source: './Examples/DataDisplay/ExpTabs.qml',
                    desc: qsTr('AntTabs 是通过选项卡标签切换内容的组件。')
                },
                {
                    key: 'AntCollapse',
                    label: qsTr('AntCollapse 折叠面板'),
                    source: './Examples/DataDisplay/ExpCollapse.qml',
                    desc: qsTr('可以折叠/展开的内容区域。')
                },
                {
                    key: 'AntAvatar',
                    label: qsTr('AntAvatar 头像'),
                    source: './Examples/DataDisplay/ExpAvatar.qml',
                    desc: qsTr('用来代表用户或事物，支持图片、图标或字符展示。')
                },
                {
                    key: 'AntCard',
                    label: qsTr('AntCard 卡片'),
                    source: './Examples/DataDisplay/ExpCard.qml',
                    desc: qsTr('最基础的卡片容器，可承载文字、列表、图片、段落。')
                },
                {
                    key: 'AntTimeline',
                    label: qsTr('AntTimeline 时间轴'),
                    source: './Examples/DataDisplay/ExpTimeline.qml',
                    desc: qsTr('垂直展示的时间流信息。')
                },
                {
                    key: 'AntTag',
                    label: qsTr('AntTag 标签'),
                    source: './Examples/DataDisplay/ExpTag.qml',
                    desc: qsTr('进行标记和分类的小标签。')
                },
                {
                    key: 'AntTable',
                    label: qsTr('AntTable 表格'),
                    source: './Examples/DataDisplay/ExpTable.qml',
                    desc: qsTr('新增 getCellData 获取单元数据。\n新增 setCellData 设置单元数据。')
                },
                {
                    key: 'AntBadge',
                    label: qsTr('AntBadge 徽标数'),
                    source: './Examples/DataDisplay/ExpBadge.qml',
                    desc: qsTr('徽标数，图标右上角的圆形徽标数字。')
                },
                {
                    key: 'AntCarousel',
                    label: qsTr('AntCarousel 走马灯'),
                    source: './Examples/DataDisplay/ExpCarousel.qml',
                    desc: qsTr('走马灯，一组轮播的区域。')
                },
                {
                    key: 'AntImage',
                    label: qsTr('AntImage 图片'),
                    source: './Examples/DataDisplay/ExpImage.qml',
                    desc: qsTr('可预览的图片。')
                },
                {
                    key: 'AntImagePreview',
                    label: qsTr('AntImagePreview 图片预览'),
                    source: './Examples/DataDisplay/ExpImagePreview.qml',
                    desc: qsTr('用于预览的图片的基本工具，提供常用的图片变换(平移/缩放/翻转/旋转)操作。')
                },
                {
                    key: 'AntAnimatedImage',
                    label: qsTr('AntAnimatedImage 动态图片'),
                    source: './Examples/DataDisplay/ExpAnimatedImage.qml',
                    desc: qsTr('可预览的动态图片。')
                },
                {
                    key: 'AntCheckerBoard',
                    label: qsTr('AntCheckerBoard 棋盘格'),
                    source: './Examples/DataDisplay/ExpCheckerBoard.qml',
                    desc: qsTr('用于创建双色棋盘格。')
                },
                {
                    key: 'AntQrCode',
                    label: qsTr('AntQrCode 二维码'),
                    source: './Examples/DataDisplay/ExpQrCode.qml',
                    desc: qsTr('将文本转换生成二维码，支持自定义配色和 Logo 配置。')
                },
                {
                    key: 'AntTree',
                    label: qsTr('AntTree 树视图'),
                    source: './Examples/DataDisplay/ExpTree.qml',
                    desc: qsTr('多层次的结构列表。')
                },
                {
                    key: 'AntEmpty',
                    label: qsTr('AntEmpty 空状态'),
                    source: './Examples/DataDisplay/ExpEmpty.qml',
                    addVersion: '0.5.0.0',
                    desc: qsTr('显示一个表示空状态的图像和描述文本。')
                },
                {
                    key: 'AntShield',
                    label: qsTr('AntShield 徽章'),
                    source: './Examples/DataDisplay/ExpShield.qml',
                    addVersion: '0.5.0.0',
                    desc: qsTr('类似 GitHub Shields 的徽章组件。')
                },
                {
                    key: 'AntSpin',
                    label: qsTr('AntSpin 加载中'),
                    source: './Examples/DataDisplay/ExpSpin.qml',
                    addVersion: '0.5.0.0',
                    desc: qsTr('显示一个正在加载的状态的图像和提示文本。')
                }
            ]
        },
        {
            key: 'Effect',
            label: qsTr('效果'),
            iconSource: AntIcon.FireOutlined,
            children: [
                {
                    key: 'AntAcrylic',
                    label: qsTr('AntAcrylic 亚克力效果'),
                    source: './Examples/Effect/ExpAcrylic.qml',
                    desc: qsTr('使用 AntAcrylic 可以轻松实现亚克力/毛玻璃效果。')
                },
                {
                    key: 'AntSwitchEffect',
                    label: qsTr('AntSwitchEffect 切换特效'),
                    source: './Examples/Effect/ExpSwitchEffect.qml',
                    desc: qsTr('为两个组件之间增加切换/过渡特效。')
                },
                {
                    key: 'AntShadow',
                    label: qsTr('AntShadow 阴影效果'),
                    source: './Examples/Effect/ExpShadow.qml',
                    desc: qsTr('通用&统一的阴影特效。')
                },
                {
                    key: 'AntMaskOverlay',
                    label: qsTr('AntMaskOverlay 遮罩层'),
                    source: './Examples/Effect/ExpMaskOverlay.qml',
                    addVersion: '0.5.0.0',
                    desc: qsTr('提供半透明背景覆盖效果。')
                }
            ]
        },
        {
            key: 'Feedback',
            label: qsTr('反馈'),
            iconSource: AntIcon.MessageOutlined,
            children: [
                {
                    key: 'AntWatermark',
                    label: qsTr('AntWatermark 水印'),
                    source: './Examples/Feedback/ExpWatermark.qml',
                    desc: qsTr('可给页面的任意项加上水印，支持文本/图像水印。')
                },
                {
                    key: 'AntDrawer',
                    label: qsTr('AntDrawer 抽屉'),
                    source: './Examples/Feedback/ExpDrawer.qml',
                    desc: qsTr('新增 drawerSize(抽屉宽度) 属性。')
                },
                {
                    key: 'AntMessage',
                    label: qsTr('AntMessage 消息提示'),
                    source: './Examples/Feedback/ExpMessage.qml',
                    desc: qsTr('新增消息体代理 messageDelegate。\n新增 defaultIconSize。\n新增 spacing。\n新增 topMargin。')
                },
                {
                    key: 'AntProgress',
                    label: qsTr('AntProgress 进度条'),
                    source: './Examples/Feedback/ExpProgress.qml',
                    desc: qsTr('进度条，展示操作的当前进度。')
                },
                {
                    key: 'AntNotification',
                    label: qsTr('AntNotification 通知提醒框'),
                    source: './Examples/Feedback/ExpNotification.qml',
                    desc: qsTr('通知提醒框，全局展示通知提醒信息。')
                },
                {
                    key: 'AntPopconfirm',
                    label: qsTr('AntPopconfirm 气泡确认框'),
                    source: './Examples/Feedback/ExpPopconfirm.qml',
                    desc: qsTr('气泡确认框，弹出气泡式的确认框。')
                },
                {
                    key: 'AntPopover',
                    label: qsTr('AntPopover 气泡显示框'),
                    source: './Examples/Feedback/ExpPopover.qml',
                    addVersion: '0.5.0.0',
                    desc: qsTr('气泡显示框，弹出气泡式的显示框。')
                },
                {
                    key: 'AntModal',
                    label: qsTr('AntModal 对话框'),
                    source: './Examples/Feedback/ExpModal.qml',
                    desc: qsTr('展示一个对话框，提供标题、内容区、操作区。')
                },
                {
                    key: 'AntAlert',
                    label: qsTr('AntAlert 警告提示'),
                    source: './Examples/Feedback/ExpAlert.qml',
                    addVersion: '0.6.0.0',
                    desc: qsTr('静态的警告提示组件。')
                },
                {
                    key: 'AntResult',
                    label: qsTr('AntResult 结果'),
                    source: './Examples/Feedback/ExpResult.qml',
                    addVersion: '0.6.0.0',
                    desc: qsTr('用于反馈一系列操作任务的处理结果。')
                }
            ]
        },
        {
            key: 'Multimedia',
            label: qsTr('多媒体'),
            iconSource: AntIcon.ToolOutlined,
            children: [
                {
                    key: 'AntAudioDiagnosis',
                    label: qsTr('AntAudioDiagnosis 音频诊断器'),
                    source: './Examples/Multimedia/ExpAudioDiagnosis.qml',
                    addVersion: '0.5.0.0',
                    desc: qsTr('音频诊断器。')
                }
            ]
        },
        {
            key: 'Utils',
            label: qsTr('工具'),
            iconSource: AntIcon.ToolOutlined,
            children: [
                {
                    key: 'AntAsyncHasher',
                    label: qsTr('AntAsyncHasher 异步哈希器'),
                    source: './Examples/Utils/ExpAsyncHasher.qml',
                    desc: qsTr('可对任意数据(url/text/object)生成加密哈希的异步散列器。')
                }
            ]
        },
        {
            type: 'divider'
        },
        {
            key: 'Theme',
            label: qsTr('主题相关'),
            iconSource: AntIcon.SkinOutlined,
            type: 'group',
            children: [
                {
                    key: 'AntTheme',
                    label: qsTr('AntTheme 主题定制'),
                    source: './Examples/Theme/ExpTheme.qml',
                },
                {
                    key: 'ThemeTokens',
                    label: qsTr('ThemeTokens 主题变量'),
                    source: './Examples/Theme/ExpThemeTokens.qml',
                }
            ]
        }
    ]

    Component.onCompleted: {
        /*! 解析 Primary.tokens */
        for (const token in AntTheme.Primary) {
            primaryTokens.push({ label: `@${token}` });
        }
        /*! 解析 Component.tokens */
        const indexFile = `:/Antilla/theme/Index.json`;
        const indexObject = JSON.parse(AntApi.readFileToString(indexFile));
        for (const source in indexObject.__component__) {
            const __style__ = {};
            const parseImport = (name) => {
                const path = `:/Antilla/theme/${name}.json`;
                const fileContent = AntApi.readFileToString(path);
                if (!fileContent) {
                    console.warn("Failed to read file:", path);
                    return;
                }
                const object = JSON.parse(fileContent);
                const imports = object?.__init__?.__import__;
                const style = object.__style__;
                if (imports) {
                    imports.forEach(i => parseImport(i));
                }
                for (const token in style) {
                    __style__[token] = style[token];
                }
            }
            parseImport(source);

            const list = [];
            for (const token in __style__) {
                list.push({
                              'tokenName': token,
                              'tokenValue': {
                                  'token': token,
                                  'value': __style__[token],
                                  'rawValue': __style__[token],
                              },
                              'tokenCalcValue': token,
                          });
            }
            componentTokens[source] = list;
        }

        /*! 创建菜单等 */
        let __menus = [], __options = [], __updates = [];
        for (const item of galleryModel) {
            if (item && item.children) {
                let hasNew = false;
                let hasUpdate = false;
                item.children.sort((a, b) => a.key.localeCompare(b.key));
                item.children.forEach(
                            object => {
                                object.state = object.addVersion ? 'New' : object.updateVersion ? 'Update' : '';
                                if (object.state) {
                                    if (object.state === 'New') hasNew = true;
                                    if (object.state === 'Update') hasUpdate = true;
                                }
                                if (object.label) {
                                    __options.push({
                                                       'key': object.key,
                                                       'value': object.key,
                                                       'label': object.label,
                                                       'state': object.state,
                                                   });
                                    __updates.push({
                                                       'name': object.key,
                                                       'desc': object.desc ?? '',
                                                       'tagState': object.state,
                                                       'version': object.addVersion || object.updateVersion || '',
                                                   });
                                }
                            });
                if (hasNew)
                    item.badgeState = 'New';
                else
                    item.badgeState = hasUpdate ? 'Update' : '';
            }
            __menus.push(item);
        }
        menus = __menus;
        options = __options.sort((a, b) => a.key.localeCompare(b.key));
        updates = __updates.sort(
                    (a, b) => {
                        const parts1 = a.version.split('.').map(Number);
                        const parts2 = b.version.split('.').map(Number);
                        for (let i = 0; i < Math.max(parts1.length, parts2.length); i++) {
                            const num1 = parts1[i] || 0;
                            const num2 = parts2[i] || 0;

                            if (num1 > num2) return -1;
                            if (num1 < num2) return 1;
                        }
                        return 0;
                    });
    }
}
