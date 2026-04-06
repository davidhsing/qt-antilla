import QtQuick
import QtQuick.Effects
import Antilla.Basic

Item {
    id: control

    enum TextSize {
        SizeFixed = 0,
        SizeAuto = 1
    }

    property int size: 30
    property var iconSource: 0 ?? ''
    property bool imageMipmap: false
    property var imageSource: ''
    property var fallbackImageSource: ''
    property bool emptyAsError: false
    property string textSource: ''
    property font textFont: Qt.font({
        family: AntTheme.Primary.fontPrimaryFamily,
        pixelSize: control.size / 2
    })
    property int textSize: AntAvatar.SizeFixed
    property int textGap: 4
    property color colorBg: AntTheme.Primary.colorTextQuaternary
    property color colorIcon: 'white'
    property color colorText: 'white'
    property AntRadius radiusBg: AntRadius { all: control.width / 2 }

    objectName: '__AntAvatar__'
    width: __loader.width
    height: __loader.height

    Component {
        id: __iconImpl

        AntRectangleInternal {
            width: control.size
            height: control.size
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            color: control.colorBg

            AntIconText {
                id: __iconSource
                anchors.centerIn: parent
                iconSource: control.iconSource
                iconSize: control.size * 0.7
                colorIcon: control.colorIcon
            }
        }
    }

    Component {
        id: __imageImpl

        AntRectangleInternal {
            width: control.size
            height: control.size
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            color: control.colorBg

            Rectangle {
                id: __mask
                anchors.fill: parent
                radius: parent.radius
                layer.enabled: true
                visible: false
            }

            AntImage {
                id: __imageSource
                anchors.fill: parent
                mipmap: control.imageMipmap
                source: control.imageSource
                fallback: control.fallbackImageSource
                sourceSize: Qt.size(width, height)
                emptyAsError: control.emptyAsError
                layer.enabled: true
                visible: false
            }

            MultiEffect {
                anchors.fill: __imageSource
                maskEnabled: true
                maskSource: __mask
                source: __imageSource
            }
        }
    }

    Component {
        id: __textImpl

        Rectangle {
            id: __bg
            width: Math.max(control.size, __textSource.implicitWidth + control.textGap * 2);
            height: width
            radius: control.radiusBg
            color: control.colorBg
            Component.onCompleted: calcBestSize();

            function calcBestSize() {
                if (control.textSize === AntAvatar.SizeFixed) {
                    __textSource.font.pixelSize = control.size / 2;
                } else {
                    let bestSize = control.size / 2;
                    __fontMetrics.font.pixelSize = bestSize;
                    while ((__fontMetrics.advanceWidth(control.textSource) + control.textGap * 2 > control.size)) {
                        bestSize -= 1;
                        __fontMetrics.font.pixelSize = bestSize;
                        if (bestSize <= 1) break;
                    }
                    __textSource.font.pixelSize = bestSize;
                }
            }

            FontMetrics {
                id: __fontMetrics
                font.family: __textSource.font.family
            }

            AntText {
                id: __textSource
                anchors.centerIn: parent
                color: control.colorText
                text: control.textSource
                smooth: true
                font: control.textFont

                Connections {
                    target: control
                    function onTextSourceChanged() {
                        __bg.calcBestSize();
                    }
                }
            }
        }
    }

    Loader {
        id: __loader
        sourceComponent: {
            if (control.iconSource !== 0 && control.iconSource !== '')
                return __iconImpl;
            else if ((typeof control.imageSource == 'string' && control.imageSource !== '') || (typeof control.imageSource == 'object' && control.imageSource.toString() !== ''))
                return __imageImpl;
            else
                return __textImpl;
        }
    }
}
