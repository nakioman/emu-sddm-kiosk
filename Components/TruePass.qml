import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Rectangle {
    AnimatedImage {
        source: "../Assets/loading.gif"

        width: 40
        height: 40

        anchors.right: text.left
        anchors.rightMargin: 2
        y: -18
        z: 4
    }

    Text {
        id: text
        color: "white"
        font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
        text: "Welcome"
        renderType: Text.NativeRendering
        font.weight: Font.Normal
        font.pointSize: 20
        anchors.centerIn: parent
        font.kerning: false
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowVerticalOffset: 1
            shadowHorizontalOffset: 1
            shadowColor: "#99000000"
            shadowBlur: 0.1
        }
    }
}


