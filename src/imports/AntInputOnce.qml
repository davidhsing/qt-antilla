import QtQuick
import Antilla.Basic

Item {
    id: control

    signal finished(input: string)

    property bool animationEnabled: AntTheme.animationEnabled
    property int length: 6
    property int characterLength: 1
    property int currentIndex: 0
    property string currentInput: ''
    property int itemWidth: 45
    property int itemHeight: 32
    property alias itemSpacing: __row.spacing
    property var itemValidator: IntValidator { top: 9; bottom: 0 }
    property int itemInputMethodHints: Qt.ImhHiddenText
    property bool itemPassword: false
    property string itemPasswordCharacter: ''
    property bool danger: false
    property var formatter: (text) => text

    property color colorItemText: enabled ? control.themeSource.colorText : control.themeSource.colorTextDisabled
    property color colorItemBorder: enabled ? control.themeSource.colorBorder : control.themeSource.colorBorderDisabled
    property color colorItemBorderActive: enabled ? control.themeSource.colorBorderHover : control.themeSource.colorBorderDisabled
    property color colorItemBg: enabled ? control.themeSource.colorBg : control.themeSource.colorBgDisabled
    property AntRadius radiusBg: AntRadius { all: control.themeSource.radiusBg }

    property Component dividerDelegate: Item { }
    property var themeSource: AntTheme.AntInput

    objectName: '__AntInputOnce__'
    width: __row.width
    height: __row.height
    onCurrentIndexChanged: {
        const item = __repeater.itemAt(currentIndex << 1);
        if (item && item.index % 2 == 0)
            item.item.selectThis();
    }

    Component {
        id: __inputDelegate

        AntInput {
            id: __rootItem
            width: control.itemWidth
            height: control.itemHeight
            animationEnabled: control.animationEnabled
            verticalAlignment: AntInput.AlignVCenter
            horizontalAlignment: AntInput.AlignHCenter
            enabled: control.enabled
            danger: control.danger
            colorText: control.colorItemText
            colorBorder: danger ? (active ? control.themeSource.colorErrorBorderHover : control.themeSource.colorErrorBorder) : (active ? control.colorItemBorderActive : control.colorItemBorder)
            colorBg: control.colorItemBg
            radiusBg: control.radiusBg
            validator: control.itemValidator
            inputMethodHints: control.itemInputMethodHints
            echoMode: control.itemPassword ? AntInput.Password : AntInput.Normal
            passwordCharacter:control.itemPasswordCharacter
            onReleased: __timer.restart();
            onTextEdited: {
                text = control.formatter(text);
                const isFull = length >= control.characterLength;
                if (isFull) selectAll();

                if (isBackspace) isBackspace = false;

                const input = control.getInput();
                control.currentInput = input;

                if (isFull) {
                    if (control.currentIndex < (control.length - 1))
                        control.currentIndex++;
                    else
                        control.finished(input);
                }
            }

            property int __index: index
            property bool isBackspace: false

            function selectThis() {
                forceActiveFocus();
                selectAll();
            }

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Backspace) {
                    clear();
                    const input = control.getInput();
                    control.currentInput = input;
                    isBackspace = true;
                    if (control.currentIndex != 0)
                        control.currentIndex--;
                } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    if (control.currentIndex < (control.length - 1))
                        control.currentIndex++;
                    else
                        control.finished(control.getInput());
                }
            }

            Timer {
                id: __timer
                interval: 100
                onTriggered: {
                    control.currentIndex = __rootItem.__index >> 1;
                    __rootItem.selectAll();
                }
            }
        }
    }

    Row {
        id: __row
        spacing: 8

        Repeater {
            id: __repeater
            model: control.length * 2 - 1
            delegate: Loader {
                sourceComponent: index % 2 == 0 ? __inputDelegate : dividerDelegate
                required property int index
            }
        }
    }

    function setInput(inputs) {
        for (let i = 0; i < inputs.length; i++) {
            setInputAtIndex(i, input);
        }
    }

    function setInputAtIndex(index, input) {
        const item = __repeater.itemAt(index << 1);
        if (item) {
            currentIndex = index;
            item.item.text = formatter(input);
        }
    }

    function getInput() {
        let input = '';
        for (let i = 0; i < __repeater.count; i++) {
            const item = __repeater.itemAt(i);
            if (item && item.index % 2 == 0) {
                input += item.item.text;
            }
        }
        return input;
    }

    function getInputAtIndex(index) {
        const item = __repeater.itemAt(index << 1);
        if (item) {
            return item.item.text;
        }
        return '';
    }
}
