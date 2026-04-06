import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Antilla.Basic
import '../../Controls'

Item {
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        AntText {
            text: qsTr('公共主题变量')
            font {
                pixelSize: AntTheme.Primary.fontPrimarySizeHeading2
                weight: Font.DemiBold
            }
        }

        AntText {
            text: qsTr('以下是 index.json 中定义的所有公共主题变量（Design Tokens），这些变量可以在整个应用中使用。')
            font.pixelSize: AntTheme.Primary.fontPrimarySize
            wrapMode: Text.WordWrap
        }

        ThemeToken {
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: '#'
        }
    }
}
