import QtQuick
import QtQuick.Templates as T
import QtQuick.Layouts
import Antilla.Basic

T.Control {
    id: control

    signal change(nextTargetKeys: var, direction: string, moveKeys: var)

    property bool animationEnabled: AntTheme.animationEnabled
    property var dataSource: []
    readonly property alias sourceKeys: __private.sourceKeys
    property var targetKeys: []
    property alias sourceCheckedKeys: __sourceList.checkedKeys
    property alias targetCheckedKeys: __targetList.checkedKeys
    property alias defaultSourceCheckedKeys: __sourceList.defaultCheckedKeys
    property alias defaultTargetCheckedKeys: __targetList.defaultCheckedKeys
    readonly property alias sourceCount: __sourceList.totalCount
    readonly property alias targetCount: __targetList.totalCount
    readonly property int sourceCheckedCount: sourceCheckedKeys.length
    readonly property int targetCheckedCount: targetCheckedKeys.length
    property var titleNames: [qsTr('源'), qsTr('目标')]
    property bool titleNamesVisible: false
    property var operations: ['>', '<']
    property bool searchVisible: false
    property var filterOption: (value, record) => String(record.title).includes(value)
    property string itemsSuffix: qsTr('项')
    property string emptyDescription: qsTr('暂无数据')
    property string searchPlaceholder: qsTr('搜索')
    property var pagination: false ?? {}
    property bool unidirection: false
    property font titleFont: Qt.font({
        family: themeSource.fontFamilyTitle,
        pixelSize: parseInt(themeSource.fontSizeTitle)
    })

    property color colorTitle: themeSource.colorColumnHeaderTitle
    property color colorText: themeSource.colorText
    property color colorBg: themeSource.colorBg
    property color colorBorder: themeSource.colorBorder
    property AntRadius radiusBg: AntRadius { all: themeSource.radiusBg }
    property var themeSource: AntTheme.AntTransfer

    property alias sourceTableView: __sourceList.view
    property alias targetTableView: __targetList.view

    property Component titleDelegate: RowLayout {
        AntText {
            Layout.alignment: Qt.AlignLeft
            leftPadding: 8
            font: control.titleFont
            text: numberText + control.itemsSuffix
            color: control.colorTitle
            verticalAlignment: Text.AlignVCenter
            property string numberText: onLeft ? `${control.sourceCheckedCount}/${control.sourceCount} ` :
                                                 `${control.targetCheckedCount}/${control.targetCount} `
        }

        AntText {
            Layout.alignment: Qt.AlignRight
            rightPadding: 8
            font: control.titleFont
            text: title
            color: control.colorTitle
            verticalAlignment: Text.AlignVCenter
        }
    }
    property Component searchInputDelegate: AntInput {
        iconSource: AntIcon.SearchOutlined
        placeholderText: control.searchPlaceholder
        clearable: true
        onTextChanged: control.filter(text, onLeft ? 'left' : 'right');
    }
    property Component rightActionDelegate: AntButton {
        padding: 8
        topPadding: 4
        bottomPadding: 4
        text: control.operations[0]
        type: AntButton.TypePrimary
        enabled: control.sourceCheckedKeys.length > 0 && control.enabled
        onClicked: {
            targetKeys = [...sourceCheckedKeys, ...targetKeys];
            control.clearChecked('left');
            control.change(targetKeys, 'right', [...sourceCheckedKeys]);
        }
    }
    property Component leftActionDelegate: AntButton {
        padding: 8
        topPadding: 4
        bottomPadding: 4
        text: control.operations[1]
        type: AntButton.TypePrimary
        enabled: control.targetCheckedKeys.length > 0 && control.enabled && !control.unidirection
        visible: !control.unidirection
        onClicked: {
            const targetKeysSet = new Set;
            targetCheckedKeys.forEach(key => targetKeysSet.add(key));
            targetKeys = targetKeys.filter(key => !targetKeysSet.has(key));
            control.clearChecked('right');
            control.change(targetKeys, 'left', targetKeysSet.keys());
        }
    }
    property Component emptyDelegate: AntEmpty { descriptionText: control.emptyDescription }

    objectName: '__AntTransfer__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    spacing: 4
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize)
    }
    contentItem: RowLayout {
        spacing: control.spacing

        TransferList {
            id: __sourceList
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: !control.titleNamesVisible ? '' : control.titleNames[0]
            onLeft: true
        }

        Column {
            Layout.alignment: Qt.AlignVCenter
            spacing: 8

            Loader {
                sourceComponent: control.rightActionDelegate
            }

            Loader {
                sourceComponent: control.leftActionDelegate
            }
        }

        TransferList {
            id: __targetList
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: !control.titleNamesVisible ? '' : control.titleNames[1]
            onLeft: false
        }
    }

    onTargetKeysChanged: __private.resetData();

    function clearChecked(direction = 'left'): void {
        if (direction === 'left') {
            sourceTableView.clearCheckedKeys();
        } else {
            targetTableView.clearCheckedKeys();
        }
    }

    function filter(text: string, direction = 'left'): void {
        if (direction === 'left') {
            __sourceList.filterString = text;
            __sourceList.filter();
        } else {
            __targetList.filterString = text;
            __targetList.filter();
        }
    }

    QtObject {
        id: __private

        property alias sourceData: __sourceList.initData
        property var sourceKeys: []
        property alias targetData: __targetList.initData

        function resetData() {
            const targetKeysSet = new Set;
            const __sourceData = [], __sourceKeys = [], __targetData = [];
            targetKeys.forEach(key => targetKeysSet.add(key));
            control.dataSource.forEach(object => {
                if (object.hasOwnProperty('key')) {
                    if (targetKeysSet.has(object.key)) {
                        __targetData.push(object);
                    } else {
                        __sourceData.push(object);
                        __sourceKeys.push(object.key);
                    }
                }
            });
            sourceData = __sourceData;
            sourceKeys = __sourceKeys;
            targetData = __targetData;
            __sourceList.filter();
            __targetList.filter();
        }
    }

    component TransferList: T.Control {
        id: __transferListRoot

        property var initData: []
        property var filteredData: []
        property string filterString: ''

        property alias totalCount: __pagination.total
        property alias view: __transferView
        property alias onLeft: __transferView.onLeft
        property alias title: __transferView.title
        property alias rowCount: __transferView.rowCount
        property alias checkedKeys: __transferView.checkedKeys
        property alias defaultCheckedKeys: __transferView.defaultCheckedKeys
        property alias initModel: __transferView.initModel

        padding: background.border.width
        topPadding: Math.max(8, control.radiusBg.topLeft, control.radiusBg.topRight)
        bottomPadding: Math.max(8, control.radiusBg.bottomLeft, control.radiusBg.bottomRight)
        contentItem: ColumnLayout {
            spacing: 0

            Loader {
                Layout.leftMargin: 8
                Layout.rightMargin: 8
                Layout.fillWidth: true
                active: control.searchVisible
                visible: active
                sourceComponent: control.searchInputDelegate
                property bool onLeft: __transferView.onLeft
            }

            AntTable {
                id: __transferView
                Layout.fillWidth: true
                Layout.fillHeight: true
                animationEnabled: control.animationEnabled
                color: control.colorBg
                colorColumnHeaderBg: 'transparent'
                columnResizable: false
                rowHeaderVisible: false
                defaultColumnHeaderHeight: 32
                minimumRowHeight: 32
                topLeftRadius: 0
                topRightRadius: 0
                columnHeaderFilterIconDelegate: null
                columnHeaderTitleDelegate: Loader {
                    sourceComponent: control.titleDelegate
                    property bool onLeft: __transferView.onLeft
                    property string title: __transferView.title
                }
                columns: [
                    {
                        width: __transferView.width,
                        title: __transferView.title,
                        delegate: __textDelegate,
                        dataIndex: 'title',
                        selectionType: 'checkbox',
                    }
                ]

                property bool onLeft: true
                property string title: ''

                Component {
                    id: __textDelegate

                    AntText {
                        leftPadding: 8
                        font: control.font
                        text: cellData
                        color: enabled ? control.colorText : control.themeSource.colorTextDisabled
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            onTapped: {
                                __transferView.toggleForRows([row]);
                            }
                        }
                    }
                }

                Loader {
                    anchors.top: parent.top
                    anchors.topMargin: parent.defaultColumnHeaderHeight
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: parent.rowCount === 0
                    sourceComponent: control.emptyDelegate
                }
            }

            Loader {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                active: typeof control.pagination === 'object'
                visible: active
                sourceComponent: AntDivider { }
            }

            AntPagination {
                id: __pagination
                Layout.topMargin: 8
                Layout.alignment: Qt.AlignHCenter
                visible: typeof control.pagination === 'object'
                total: __transferListRoot.filteredData.length
                pageSize: control.pagination?.pageSize ?? 10
                pageMaxButton: control.pagination?.pageMaxButton ?? 7
                quickJumperVisible: control.pagination?.quickJumperVisible ?? false
                defaultButtonSpacing: control.pagination?.defaultButtonSpacing ?? 8
                onCurrentPageIndexChanged: __transferListRoot.refreshData();
            }
        }
        background: AntRectangleInternal {
            color: control.colorBg
            border.color: control.colorBorder
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
        }

        function filter(): void {
            let data = initData;
            if (control.searchVisible && filterString !== '') {
                data = data.filter(item => control.filterOption(filterString, item));
            }
            filteredData = data;
            refreshData();
        }

        function refreshData(): void {
            if (typeof control.pagination === 'object') {
                const start = __pagination.currentPageIndex * __pagination.pageSize;
                const end = start + __pagination.pageSize;
                __transferView.initModel = filteredData.slice(start, end);
            } else {
                __transferView.initModel = filteredData;
            }
        }
    }
}
