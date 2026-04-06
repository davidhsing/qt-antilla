import QtQuick
import QtQuick.Layouts
import Antilla.Basic

Item {
    id: control

    enum ImageStyle {
        ImageNone = 0,
        ImageDefault = 1,
        ImageSimple = 2
    }

    property int imageStyle: AntEmpty.ImageDefault
    property string imageSource: {
        switch (imageStyle) {
            case AntEmpty.ImageNone: return '';
            case AntEmpty.ImageDefault: return 'qrc:/Antilla/resources/images/empty-default.svg';
            case AntEmpty.ImageSimple: return 'qrc:/Antilla/resources/images/empty-simple.svg';
            default: return '';
        }
    }
    property int imageWidth: {
        switch (imageStyle) {
            case AntEmpty.ImageNone: return width / 3;
            case AntEmpty.ImageDefault: return 92;
            case AntEmpty.ImageSimple: return 64;
            default: return 0;
        }
    }
    property int imageHeight: {
        switch (imageStyle) {
            case AntEmpty.ImageNone: return height / 3;
            case AntEmpty.ImageDefault: return 76;
            case AntEmpty.ImageSimple: return 41;
            default: return 0;
        }
    }
    property bool descriptionVisible: !!control.descriptionText
    property string descriptionText: ''
    property int descriptionSpacing: 12
    property font descriptionFont: Qt.font({
        family: AntTheme.AntEmpty.fontFamily,
        pixelSize: AntTheme.AntEmpty.fontSize
    })
    property color colorDescription: AntTheme.AntEmpty.colorDescription

    property Component imageDelegate: Image {
        width: control.imageWidth
        height: control.imageHeight
        source: control.imageSource
        sourceSize: Qt.size(width, height)
    }
    property Component descriptionDelegate: AntText {
        text: control.descriptionText
        font: control.descriptionFont
        color: control.colorDescription
        horizontalAlignment: Text.AlignHCenter
    }

    objectName: '__AntEmpty__'
    implicitWidth: 200
    implicitHeight: 200

    ColumnLayout {
        anchors.centerIn: parent
        spacing: control.descriptionSpacing

        Loader {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: active
            Layout.preferredWidth: active ? control.imageWidth : 0
            Layout.preferredHeight: active ? control.imageHeight : 0
            sourceComponent: control.imageDelegate
            active: control.imageSource !== '' && control.imageStyle !== AntEmpty.ImageNone
            visible: active
        }

        Loader {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            sourceComponent: control.descriptionDelegate
            active: control.descriptionVisible
            visible: active
        }
    }
}
