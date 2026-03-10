import QtQuick
import QtQuick.Controls
import QtQuick.Effects

FocusScope {
    Image {
        source: "../Assets/dialog-error.png"
        anchors.right: falseText.left
        anchors.rightMargin: 7
        y: -6
    }

    Text {
        id: falseText
        text: "Login failed. Check kiosk configuration."
        color: "white"
        font.pointSize: 10
        font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
        renderType: Text.NativeRendering
        x: -100

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowVerticalOffset: 1
            shadowColor: "#000"
            shadowBlur: 0.3
        }
    }

    Button {
        id: falseButton
        hoverEnabled: true
        width: 92
        height: 27

        x: -45
        y: 70

        Image {
            id: img
            source: {
                if (falseButton.hovered) return "../Assets/ok-hover.png"

                return "../Assets/ok-focus.png"
            }
        }

        onClicked: {
            loginError.visible = false
            kioskPanel.visible = true
            rightPanel.visible = true
        }

        Keys.onReturnPressed: {
            loginError.visible = false
            kioskPanel.visible = true
            rightPanel.visible = true
        }

        Keys.onEnterPressed: {
            loginError.visible = false
            kioskPanel.visible = true
            rightPanel.visible = true
        }
    }
}
