import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import QtQuick.Effects
import Qt.labs.folderlistmodel
import "Components"

Item {
    id: root
    width: Screen.width
    height: Screen.height

    FontLoader {
        id: segoeui
        source: Qt.resolvedUrl("fonts/segoeui.ttf")
    }

    FontLoader {
        id: segoeuil
        source: Qt.resolvedUrl("fonts/segoeuil.ttf")
    }

    // Kiosk entries parsed from sessions/ directory
    ListModel {
        id: kioskModel
    }

    // Map session basenames to sessionModel indices
    property var sessionIndexMap: ({})

    // Build session index map from SDDM's sessionModel
    Repeater {
        model: sessionModel
        delegate: Item {
            Component.onCompleted: {
                if (model.file) {
                    var filepath = model.file.toString()
                    var filename = filepath.split("/").pop().replace(".desktop", "")
                    sessionIndexMap[filename] = index
                }
            }
        }
    }

    // Scan sessions/ folder for .desktop files
    FolderListModel {
        id: sessionFolderModel
        folder: Qt.resolvedUrl("sessions")
        nameFilters: ["*.desktop"]
        showDirs: false
        sortField: FolderListModel.Name
    }

    // Build kiosk entries from the folder model
    Repeater {
        model: sessionFolderModel
        delegate: Item {
            Component.onCompleted: {
                var baseName = model.fileBaseName
                kioskModel.append({
                    name: baseName,
                    icon: Qt.resolvedUrl("Assets/" + baseName + ".png").toString(),
                    sessionCommand: baseName
                })
            }
        }
    }

    function kioskLogin(sessionCommand) {
        var idx = sessionIndexMap[sessionCommand]
        if (idx === undefined) idx = sessionModel.lastIndex

        kioskPanel.visible = false
        rightPanel.visible = false
        welcomePanel.visible = true

        sddm.login(config.kiosk_user, config.kiosk_pass, idx)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            welcomePanel.visible = false
            kioskPanel.visible = true
            rightPanel.visible = true
            loginError.visible = true
            loginError.focus = true
        }
        function onLoginSucceeded() {}
    }

    Rectangle {
        id: background
        anchors.fill: parent
        width: parent.width
        height: parent.height

        MediaPlayer {
            id: startupSound
            autoPlay: true
            source: Qt.resolvedUrl("Assets/Startup-Sound.wav")
            audioOutput: AudioOutput {}
        }

        Image {
            anchors.fill: parent
            width: parent.width
            height: parent.height
            source: config.background
        }
    }

    // Kiosk entry grid
    Item {
        id: kioskPanel
        anchors.fill: parent

        Rectangle {
            width: 180 * Math.min(kioskGridView.count, 5)
            height: 125
            color: "transparent"
            clip: false

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            ListView {
                id: kioskGridView
                anchors.fill: parent
                model: kioskModel
                orientation: ListView.Horizontal
                interactive: false
                spacing: 120
                focus: true
                currentIndex: 0
                keyNavigationEnabled: true

                Keys.onReturnPressed: {
                    var entry = kioskModel.get(currentIndex)
                    if (entry) kioskLogin(entry.sessionCommand)
                }
                Keys.onEnterPressed: {
                    var entry = kioskModel.get(currentIndex)
                    if (entry) kioskLogin(entry.sessionCommand)
                }

                delegate: KioskEntry {
                    name: model.name
                    icon: model.icon
                    sessionCommand: model.sessionCommand
                    isCurrent: ListView.isCurrentItem

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            kioskGridView.currentIndex = index
                            kioskLogin(model.sessionCommand)
                        }
                    }
                }
            }
        }
    }

    // Welcome / loading panel (shown during login)
    TruePass {
        id: welcomePanel
        visible: false
        z: 10
        anchors.centerIn: parent
    }

    // Login error overlay
    FalsePass {
        id: loginError
        visible: false
        z: 10
        anchors.centerIn: parent
    }

    Image {
        source: config.branding
        z: 2

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Item {
        id: rightPanel
        z: 2

        anchors {
            bottom: parent.bottom
            right: parent.right
            rightMargin: 92
            bottomMargin: 62
        }

        PowerPanel {
            id: powerPanel
        }
    }
}
