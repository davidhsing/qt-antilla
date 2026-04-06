import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Loader {
    id: control

    enum LayoutType {
        TypeRow = 0,
        TypeRowLayout = 1,
        TypeColumn = 2,
        TypeColumnLayout = 3,
        TypeGrid = 4,
        TypeGridLayout = 5
    }

    property int layout: AntSpace.TypeRow
    property bool combineRadius: true
    property AntRadius radiusBg: AntRadius { all: AntTheme.Primary.radiusPrimary }

    /*! Row Column Grid */
    property Transition add: null
    property Transition populate: null
    property Transition move: null
    property real padding: 0
    property real leftPadding: 0
    property real rightPadding: 0
    property real topPadding: 0
    property real bottomPadding: 0

    /*! Row Column RowLayout ColunmLayout */
    property real spacing: -1

    /*! Row RowLayout ColunmLayout Grid GridLayout */
    property int layoutDirection: Qt.LeftToRight

    /*! RowLayout ColunmLayout */
    property bool uniformCellSizes: false

    /* Grid */
    property int horizontalItemAlignment: Qt.AlignHCenter
    property int verticalItemAlignment: Qt.AlignVCenter

    /* Grid GridLayout */
    property real rows: 0
    property real columns: 0
    property real rowSpacing: spacing
    property real columnSpacing: spacing
    property int flow: GridLayout.LeftToRight

    /*! GridLayout */
    property bool uniformCellWidths: false
    property bool uniformCellHeights: false

    default property list<QtObject> layoutData

    objectName: '__AntSpace__'
    sourceComponent: {
        switch (control.layout) {
            case AntSpace.TypeRow: return __row;
            case AntSpace.TypeRowLayout: return __rowLayout;
            case AntSpace.TypeColumn: return __column;
            case AntSpace.TypeColumnLayout: return __columnLayout;
            case AntSpace.TypeGrid: return __grid;
            case AntSpace.TypeGridLayout: return __gridLayout;
        }
    }

    Component {
        id: __row

        Row {
            add: control.add
            populate: control.add
            move: control.add
            padding: control.padding
            leftPadding: control.leftPadding
            rightPadding: control.rightPadding
            topPadding: control.topPadding
            bottomPadding: control.bottomPadding
            spacing: control.spacing
            layoutDirection: control.layoutDirection
            data: control.layoutData
            Component.onCompleted: {
                __private.createBindings(children);
                if (control.spacing < 0) {
                    __private.setupZOrderHandlers(children);
                }
            }
        }
    }

    Component {
        id: __rowLayout

        RowLayout {
            spacing: control.spacing
            layoutDirection: control.layoutDirection
            uniformCellSizes: control.uniformCellSizes
            data: control.layoutData
            Component.onCompleted: {
                __private.createBindings(children);
                if (control.spacing < 0) {
                    __private.setupZOrderHandlers(children);
                }
            }
        }
    }

    Component {
        id: __column

        Column {
            add: control.add
            populate: control.add
            move: control.add
            padding: control.padding
            leftPadding: control.leftPadding
            rightPadding: control.rightPadding
            topPadding: control.topPadding
            bottomPadding: control.bottomPadding
            spacing: control.spacing
            data: control.layoutData
            Component.onCompleted: {
                __private.createBindings(children);
                if (control.spacing < 0) {
                    __private.setupZOrderHandlers(children);
                }
            }
        }
    }

    Component {
        id: __columnLayout

        ColumnLayout {
            spacing: control.spacing
            layoutDirection: control.layoutDirection
            uniformCellSizes: control.uniformCellSizes
            data: control.layoutData
            Component.onCompleted: {
                __private.createBindings(children);
                if (control.spacing < 0) {
                    __private.setupZOrderHandlers(children);
                }
            }
        }
    }

    Component {
        id: __grid

        Grid {
            add: control.add
            populate: control.add
            move: control.add
            padding: control.padding
            leftPadding: control.leftPadding
            rightPadding: control.rightPadding
            topPadding: control.topPadding
            bottomPadding: control.bottomPadding
            rows: control.rows
            columns: control.columns
            spacing: control.spacing
            rowSpacing: control.rowSpacing
            columnSpacing: control.columnSpacing
            layoutDirection: control.layoutDirection
            horizontalItemAlignment: control.horizontalItemAlignment
            verticalItemAlignment: control.verticalItemAlignment
            data: control.layoutData
            Component.onCompleted: {
                __private.createBindings(children);
                if (control.spacing < 0) {
                    __private.setupZOrderHandlers(children);
                }
            }
        }
    }

    Component {
        id: __gridLayout

        GridLayout {
            flow: control.flow
            rows: control.rows
            columns: control.columns
            rowSpacing: control.rowSpacing
            columnSpacing: control.columnSpacing
            layoutDirection: control.layoutDirection
            uniformCellWidths: control.uniformCellWidths
            uniformCellHeights: control.uniformCellHeights
            data: control.layoutData
            Component.onCompleted: {
                __private.createBindings(children);
                if (control.spacing < 0) {
                    __private.setupZOrderHandlers(children);
                }
            }
        }
    }

    QtObject {
        id: __private
    
        // 用于存储每个子组件的原始 z 值
        property var originalZMap: ({})
    
        function updateZOrder(itemChildren, activeItem) {
            if (control.spacing >= 0 || !activeItem) {
                // spacing >= 0 时不需要调整 z-order
                return;
            }
            // 找到所有子项中的最大 z 值作为基准
            let maxZ = 0;
            itemChildren.forEach((item) => {
                if (item.z > maxZ) {
                    maxZ = item.z;
                }
            });
            // 活动项的 z 值设为 maxZ + 1（提升一层），其他项恢复为原始 z 值
            itemChildren.forEach((item) => {
                const itemId = String(item);
                if (item === activeItem) {
                    // 如果当前不是最高层，则提升到最高层
                    if (item.z <= maxZ) {
                        __private.originalZMap[itemId] = item.z;  // 保存原始 z 值
                        item.z = maxZ + 1;
                    }
                } else {
                    // 如果有保存的原始 z 值，则恢复它
                    if (__private.originalZMap[itemId] !== undefined) {
                        item.z = __private.originalZMap[itemId];
                    }
                }
            });
        }
        
        function setupZOrderHandlers(itemChildren) {
            if (control.spacing >= 0) {
                return;
            }
            itemChildren.forEach((item) => {
                const itemId = String(item);
                // 初始化时保存每个组件的原始 z 值
                if (__private.originalZMap[itemId] === undefined) {
                    __private.originalZMap[itemId] = item.z;
                }
                // 为支持 hovered/active 属性的组件添加监听
                if (item.hasOwnProperty('hovered')) {
                    item.hoveredChanged.connect(() => {
                        if (item.hovered || item.active) {
                            updateZOrder(itemChildren, item);
                        } else {
                            updateZOrder(itemChildren, null);
                        }
                    });
                }
                if (item.hasOwnProperty('active')) {
                    item.activeChanged.connect(() => {
                        if (item.active || item.hovered) {
                            updateZOrder(itemChildren, item);
                        } else {
                            updateZOrder(itemChildren, null);
                        }
                    });
                }
            });
        }
    
        function setItemRadiusBinding(instance, edge, hasDirection) {
            if (instance.hasOwnProperty('radiusBg')) {
                instance.radiusBg.all = 0;
                instance.radiusBg.topLeft = 0;
                instance.radiusBg.topRight = 0;
                instance.radiusBg.bottomLeft = 0;
                instance.radiusBg.bottomRight = 0;
                switch (edge) {
                    case 'left':
                        instance.radiusBg.topLeft = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.topLeft : 0) :
                                    Qt.binding(() => control.radiusBg.topLeft);
                        instance.radiusBg.bottomLeft = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.bottomLeft : 0) :
                                    Qt.binding(() => control.radiusBg.bottomLeft);
                        instance.radiusBg.topRight = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.topRight : 0) :
                                    Qt.binding(() => control.radiusBg.topRight);
                        instance.radiusBg.bottomRight = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.bottomRight : 0) :
                                    Qt.binding(() => control.radiusBg.bottomRight);
                        break;
                    case 'right':
                        instance.radiusBg.topRight = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.topRight : 0) :
                                    Qt.binding(() => control.radiusBg.topRight);
                        instance.radiusBg.bottomRight = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.bottomRight : 0) :
                                    Qt.binding(() => control.radiusBg.bottomRight);
                        instance.radiusBg.topLeft = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.topLeft : 0) :
                                    Qt.binding(() => control.radiusBg.topLeft);
                        instance.radiusBg.bottomLeft = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.bottomLeft : 0) :
                                    Qt.binding(() => control.radiusBg.bottomLeft);
                        break;
                    case 'top':
                        instance.radiusBg.topLeft = Qt.binding(() => control.radiusBg.topLeft);
                        instance.radiusBg.topRight = Qt.binding(() => control.radiusBg.topRight);
                        break;
                    case 'bottom':
                        instance.radiusBg.bottomLeft = Qt.binding(() => control.radiusBg.bottomLeft);
                        instance.radiusBg.bottomRight = Qt.binding(() => control.radiusBg.bottomRight);
                        break;
                    case 'topLeft':
                        instance.radiusBg.topLeft = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.topLeft : 0) :
                                    Qt.binding(() => control.radiusBg.topLeft);
                        instance.radiusBg.topRight = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.topRight : 0) :
                                    Qt.binding(() => control.radiusBg.topRight);
                        break;
                    case 'topRight':
                        instance.radiusBg.topRight = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.topRight : 0) :
                                    Qt.binding(() => control.radiusBg.topRight);
                        instance.radiusBg.topLeft = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.topLeft : 0) :
                                    Qt.binding(() => control.radiusBg.topLeft);
                        break;
                    case 'bottomLeft':
                        instance.radiusBg.bottomLeft = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.bottomLeft : 0) :
                                    Qt.binding(() => control.radiusBg.bottomLeft);
                        instance.radiusBg.bottomRight = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.bottomRight : 0) :
                                    Qt.binding(() => control.radiusBg.bottomRight);
                        break;
                    case 'bottomRight':
                        instance.radiusBg.bottomRight = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.LeftToRight ? control.radiusBg.bottomRight : 0) :
                                    Qt.binding(() => control.radiusBg.bottomRight);
                        instance.radiusBg.bottomLeft = hasDirection ?
                                    Qt.binding(() => control.layoutDirection === Qt.RightToLeft ? control.radiusBg.bottomLeft : 0) :
                                    Qt.binding(() => control.radiusBg.bottomLeft);
                        break;
                    default:
                        break;
                }
            }
        }

        function createBindings(itemChildren) {
            if (!control.combineRadius) {
                return;
            }
            const length = itemChildren.length;
            // 设置 z-order 处理器
            __private.setupZOrderHandlers(itemChildren);
            const createRowBinding = () => {
                itemChildren.forEach((item, i) => {
                    if (i === 0) {
                        __private.setItemRadiusBinding(item, 'left', true);
                    } else if (i === length - 1) {
                        __private.setItemRadiusBinding(item, 'right', true);
                    } else {
                        __private.setItemRadiusBinding(item, '');
                    }
                });
            };
            const createColumnBinding = () => {
                itemChildren.forEach((item, i) => {
                    if (i === 0) {
                        __private.setItemRadiusBinding(item, 'top');
                    } else if (i === length - 1) {
                        __private.setItemRadiusBinding(item, 'bottom');
                    } else {
                        __private.setItemRadiusBinding(item, '');
                    }
                });
            };
            const createGridBinding = () => {
                if (columns > 1 && rows > 1) {
                    itemChildren.forEach((item, i) => {
                        if (i === 0) {
                            __private.setItemRadiusBinding(item, 'topLeft');
                        } else if (i === (columns - 1)) {
                            __private.setItemRadiusBinding(item, 'topRight');
                        } else if (i === columns * (rows - 1)) {
                            __private.setItemRadiusBinding(item, 'bottomLeft');
                        } else if (i === length - 1) {
                            __private.setItemRadiusBinding(item, 'bottomRight');
                        } else {
                            __private.setItemRadiusBinding(item, '');
                        }
                    });
                } else {
                    if (rows === 1) {
                        createRowBinding();
                    } else if (columns === 1) {
                        createColumnBinding();
                    }
                }
            }
            const createGridLayoutBinding = () => {
                if (columns > 1 && rows > 1) {
                    /* 统一清空radius */
                    itemChildren.forEach(item => __private.setItemRadiusBinding(item, ''));
                    /*! 第一行的第一个和最后一个 */
                    let columnIndex = 0;
                    for (let i = 0; i < length; i++) {
                        const item1 = itemChildren[i];
                        if (i === 0) {
                            __private.setItemRadiusBinding(item1, 'topLeft', true);
                        }
                        if (columnIndex < columns) {
                            columnIndex += item1.Layout.columnSpan;
                            if (columnIndex >= columns) {
                                __private.setItemRadiusBinding(item1, 'topRight', true);
                                break;
                            }
                        }
                    }
                    /*! 最后一行的最后一个和第一个 */
                    columnIndex = 0;
                    for (let j = length - 1; j > 0; j--) {
                        const item2 = itemChildren[j];
                        if (j === length - 1) {
                            __private.setItemRadiusBinding(item2, 'bottomRight', true);
                        }
                        if (columnIndex < columns) {
                            columnIndex += item2.Layout.columnSpan;
                            if (columnIndex >= columns) {
                                __private.setItemRadiusBinding(item2, 'bottomLeft', true);
                                break;
                            }
                        }
                    }
                } else {
                    if (rows === 1) {
                        createRowBinding();
                    } else if (columns === 1) {
                        createColumnBinding();
                    }
                }
            }
            if (length > 0) {
                switch (control.layout) {
                    case AntSpace.TypeRow:
                    case AntSpace.TypeRowLayout:
                        createRowBinding();
                        break;
                    case AntSpace.TypeColumn:
                    case AntSpace.TypeColumnLayout:
                        createColumnBinding();
                        break;
                    case AntSpace.TypeGrid:
                        createGridBinding();
                        break;
                    case AntSpace.TypeGridLayout:
                        createGridLayoutBinding();
                        break;
                }
            }
        }
    }
}
