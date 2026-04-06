import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Basic
import Antilla.Basic

AntWindow {
    id: root
    width: 400
    height: 180
    minimumWidth: 400
    minimumHeight: 180
    captionBar.minimizeButtonVisible: false
    captionBar.maximizeButtonVisible: false
    captionBar.winTitle: qsTr('关于')
    captionBar.winIconDelegate: Item {
        Image {
            width: 16
            height: 16
            anchors.centerIn: parent
            source: 'qrc:/Gallery/images/antilla_icon.svg'
        }
    }
    captionBar.closeCallback: () => aboutLoader.visible = false;

    Item {
        anchors.fill: parent

        MultiEffect {
            anchors.fill: backRect
            source: backRect
            shadowColor: AntTheme.Primary.colorTextBase
            shadowEnabled: true
        }

        Rectangle {
            id: backRect
            anchors.fill: parent
            radius: 6
            color: AntTheme.Primary.colorBgBase
            border.color: AntThemeFunctions.alpha(AntTheme.Primary.colorTextBase, 0.2)
        }

        Item {
            anchors.fill: parent

            ShaderEffect {
                anchors.fill: parent
                vertexShader: 'qrc:/Gallery/shaders/effect2.vert.qsb'
                fragmentShader: 'qrc:/Gallery/shaders/effect2.frag.qsb'
                opacity: 0.5

                property vector3d iResolution: Qt.vector3d(width, height, 0)
                property real iTime: 0

                Timer {
                    running: true
                    repeat: true
                    interval: 10
                    onTriggered: parent.iTime += 0.03;
                }
            }
        }

        Column {
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: captionBar.height
            spacing: 10

            Item {
                width: 80
                height: width
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    width: parent.width
                    height: width
                    anchors.centerIn: parent
                    source: 'qrc:/Gallery/images/antilla_icon.svg'
                }
            }

            AntText {
                anchors.horizontalCenter: parent.horizontalCenter
                font {
                    family: AntTheme.Primary.fontPrimaryFamily
                    pixelSize: AntTheme.Primary.fontPrimarySizeHeading3
                    bold: true
                }
                text: 'Antilla Gallery'
            }

            AntCopyableText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr('库版本: ') + AntApp.libVersion()
            }
        }
    }
}
