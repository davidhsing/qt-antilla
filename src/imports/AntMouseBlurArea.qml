import QtQuick

MouseArea {
    id: root

    objectName: '__AntMouseBlurArea__'

    anchors.fill: parent
    onPressed: (mouse) => {
        // Only steal focus if not clicking on a focusable field
        const clickedItem = childAt(mouse.x, mouse.y);
        if (!clickedItem || !clickedItem.hasOwnProperty('focus')) {
            forceActiveFocus();
        }
        mouse.accepted = false;
    }
    z: -10
}
