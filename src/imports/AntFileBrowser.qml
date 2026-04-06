import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import Antilla.Basic

Item {
    id: control

    enum BrowserMode {
        ModeOpenFile,
        ModeOpenFiles,
        ModeOpenFolder,
        ModeSaveFile
    }

    property int mode: AntFileBrowser.ModeOpenFile
    property string defaultFolder: ''
    property string inputText: ''
    property string inputPlaceholder: ''
    property bool inputEnabled: true
    property bool inputReadOnly: false
    property bool inputReadOnlyBg: false
    property bool buttonEnabled: true
    property string buttonText: qsTr('浏览')
    property int buttonType: control.danger ? AntButton.TypeOutlined : AntButton.TypeDefault
    property var buttonIconSource: 0 ?? ''
    property int buttonWidth: 80
    property bool danger: false
    property int spacing: 8
    property bool convertNative: true
    property string initFolder: ''
    property alias defaultSuffix: __fileDialog.defaultSuffix
    property alias nameFilters: __fileDialog.nameFilters
    property string pathJoiner: ';'

    // Delegates
    property Component inputDelegate: AntInput {
        text: control.inputText
        placeholderText: control.inputPlaceholder
        enabled: control.inputEnabled
        readOnly: control.inputReadOnly
        readOnlyBg: control.inputReadOnlyBg
        danger: control.danger
    }
    property Component buttonDelegate: AntIconButton {
        text: control.buttonText
        iconSource: control.buttonIconSource
        enabled: control.buttonEnabled
        type: control.buttonType
        danger: control.danger
    }

    implicitWidth: parent.width
    implicitHeight: __layout.implicitHeight

    signal pathSelected(path: string)
    signal pathsSelected(paths: var)

    RowLayout {
        id: __layout
        anchors.fill: parent
        spacing: control.spacing

        Loader {
            id: __inputLoader
            Layout.fillWidth: true
            sourceComponent: control.inputDelegate
            onLoaded: {
                // Check if item has properties before binding
                if (item.hasOwnProperty('text') && item.hasOwnProperty('textChanged') && typeof item.textChanged.connect === 'function') {
                    item.textChanged.connect(() => {
                        control.inputText = item.text;
                    });
                }
            }
        }

        Loader {
            id: __buttonLoader
            sourceComponent: control.buttonDelegate
            Layout.preferredWidth: control.buttonWidth
            onLoaded: {
                // Check if item has properties before binding
                if (item.hasOwnProperty('clicked') && typeof item.clicked.connect === 'function') {
                    item.clicked.connect(__private.openDialog);
                }
            }
        }
    }

    FileDialog {
        id: __fileDialog
        visible: false
        fileMode: (control.mode === AntFileBrowser.ModeSaveFile) ? FileDialog.SaveFile : ((control.mode === AntFileBrowser.ModeOpenFile) ? FileDialog.OpenFile : FileDialog.OpenFiles)
        defaultSuffix: control.defaultSuffix
        nameFilters: control.nameFilters
        onAccepted: {
            if (control.mode === AntFileBrowser.ModeOpenFiles) {
                const paths = selectedFiles.map(url => control.convertNative ? __private.toNativePath(url, false) : url.toString());
                control.inputText = paths.join(control.pathJoiner);
                control.pathsSelected(paths);
            } else {
                control.inputText = control.convertNative ? __private.toNativePath(selectedFile, false) : selectedFile.toString();
                control.pathSelected(control.inputText);
            }
        }
    }

    FolderDialog {
        id: __folderDialog
        visible: false
        onAccepted: {
            control.inputText = control.convertNative ? __private.toNativePath(selectedFolder.toString(), false) : selectedFolder.toString();
            control.pathSelected(control.inputText);
        }
    }

    QtObject {
        id: __private

        function openDialog(): void {
            // Set the current folder right before opening the dialog
            // This ensures each instance uses its own initFolder
            let targetFolder;
            if (control.mode === AntFileBrowser.ModeOpenFolder) {
                targetFolder = __private.toUniformPath(control.initFolder || control.inputText, true);
                __folderDialog.currentFolder = targetFolder;
                __folderDialog.open();
            } else {
                if (control.mode === AntFileBrowser.ModeOpenFile || control.mode === AntFileBrowser.ModeSaveFile) {
                    targetFolder = __private.toUniformPath(control.initFolder || control.inputText, true);
                }
                __fileDialog.currentFolder = targetFolder;
                __fileDialog.open();
            }
        }

        function toNativePath(url: url, protocol: bool): string {
            if (!url) {
                return url;
            }
            let urlString = (typeof url === 'string') ? url : url.toString();
            if (protocol) {
                // Add file:/// prefix if not present
                if (!urlString.startsWith('file:///')) {
                    if (urlString.startsWith('file:/') && !urlString.startsWith('file://')) {
                        // Handle case where it starts with file:/ but not file:///
                        urlString = 'file:///' + urlString.substring(6);
                    } else {
                        urlString = 'file:///' + urlString;
                    }
                }
            } else {
                // Remove file:/// prefix if present
                if (urlString.startsWith('file:///')) {
                    urlString = urlString.substring(8);
                } else if (urlString.startsWith('file:/')) {
                    urlString = urlString.substring(6);
                }
            }
            // Decode URL escaped characters
            urlString = decodeURIComponent(urlString);
            if (Qt.platform.os === 'windows') {
                urlString = urlString.replace(/\//g,  '\\');
            }
            return urlString;
        }

        function toUniformPath(path: url, protocol: bool): string {
            if (!path) {
                return path;
            }
            let pathString = (typeof path === 'string') ? path : path.toString();
            pathString = pathString.replace(/\\/g, '/');
            if (protocol) {
                // Add file:/// prefix if not present
                if (!pathString.startsWith('file:///')) {
                    if (pathString.startsWith('file:/') && !pathString.startsWith('file://')) {
                        // Handle case where it starts with file:/ but not file:///
                        pathString = 'file:///' + pathString.substring(6);
                    } else {
                        pathString = 'file:///' + pathString;
                    }
                }
            } else {
                // Remove file:/// prefix if present
                if (pathString.startsWith('file:///')) {
                    pathString = pathString.substring(8);
                } else if (pathString.startsWith('file:/')) {
                    pathString = pathString.substring(6);
                }
            }
            return pathString;
        }
    }
}
