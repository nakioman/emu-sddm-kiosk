import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

Rectangle {
    id: container

    property alias name: name.text
    property alias icon: icon.source

    width: 60
    height: 64

    color: "transparent"

    MouseArea {
        id: containerarea
        anchors.fill: parent
        hoverEnabled: true
    }

    Image {
        id: containerimg

        anchors {
            left: parent.left
            leftMargin: -12
            top: parent.top
            topMargin: -11
        }

        source: {
            if (containerarea.containsMouse && container.focus) return "../Assets/list-hover-focus.png"
            if (containerarea.containsMouse  && !container.focus) return "../Assets/list-hover.png"
            if (!containerarea.containsMouse && container.focus) return "../Assets/list-focus.png"

            return "../Assets/list.png"
        }
    }

    Item {
        id: users
        anchors.left: container.left
        anchors.leftMargin: -7

        Image {
            id: icon
            width: 46
            height: icon.width
            smooth: true

            onStatusChanged: {
                if (icon.status == Image.Error)
                    icon.source = "../Assets/user1.png"
                else
                    "/var/lib/AccountsService/icons/" + name
            }

            x: 12
            y: 5
            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: mask
            }
        }

        Item {
            id: mask
            width: icon.width
            height: icon.height
            layer.enabled: true
            visible: false

            Rectangle {
                width: icon.width
                height: icon.height
                color: "black"
            }
        }

        Text {
            id: name
            renderType: Text.NativeRendering
            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
            font.pointSize: 10
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            clip: true
            font.kerning: false

            color: "white"

            anchors {
                horizontalCenter: icon.horizontalCenter
                top: icon.bottom
                topMargin: 18
            }

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowVerticalOffset: 1
                shadowHorizontalOffset: 1
                shadowColor: "black"
                shadowBlur: 0.3
            }
        }
    }
}
