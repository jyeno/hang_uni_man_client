import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import br.uni.hangman

// needs for this screen
// user feedback on who is on it
// messages
// button on the right to the owner of the room
Item {
    id: roomItem
    property alias messagesModel: messagesListView.model

    ColumnLayout {
        anchors.fill: parent
        Label {
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Difficulty: ") + Core.data.difficulty
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 20
            text: qsTr("Members (") + Core.data.players.length + "/" + Core.data.max_players + qsTr(")")
        }

        ListView {
            id: playersListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: Core.data.players

            delegate: SwipeDelegate {
                id: swipeDelegate
                text: modelData
                width: playersListView.width

                ListView.onRemove: SequentialAnimation {
                    PropertyAction {
                        target: swipeDelegate
                        property: "ListView.delayRemove"
                        value: true
                    }
                    NumberAnimation {
                        target: swipeDelegate
                        property: "height"
                        to: 0
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAction {
                        target: swipeDelegate
                        property: "ListView.delayRemove"
                        value: false
                    }
                }

                // use delegatechooser to not allow last index to be deleted
                swipe.right: Label {
                    id: deleteLabel
                    text: qsTr("Delete")
                    color: "white"
                    verticalAlignment: Label.AlignVCenter
                    padding: 12
                    height: parent.height
                    anchors.right: parent.right

                    SwipeDelegate.onClicked: Core.kickPlayerRoom(index)

                    required property int index

                    background: Rectangle {
                        color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                    }
                }
            }
        }
        Button {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            text: qsTr("Start Game!")
            onClicked: Core.startGame(Core.PlayModality.Multiplayer)
        }
    }

    Drawer {
        width: parent.width * 0.5
        height: parent.height

        ColumnLayout {
            anchors.fill: parent
            ListView {
                id: messagesListView

                Layout.fillWidth: true
                Layout.fillHeight: true

                model: ListModel {
                    id: messagesModel
                }
                delegate: Label {
                    font.pixelSize: 20
                    wrapMode: Text.Wrap
                    text: "[" + owner + "]: " + message
                }
            }
            RowLayout {
                Layout.fillWidth: true

                function sendMessageAndResetText() {
                    Core.sendRoomMessage(messageTextField.text);
                    messageTextField.text = "";
                }

                TextField {
                    id: messageTextField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Type your message...")
                    onAccepted: sendMessageAndResetText()
                }

                ToolButton {
                    text: qsTr("Send")
                    enabled: messageTextField.text !== ""
                    onClicked: sendMessageAndResetText()
                }
            }
        }
    }

    Dialog {
        id: backToMenuDialog

        anchors.centerIn: Overlay.overlay
        title: "Back to main menu"
        onAccepted: {
            Core.exitRoom();
            stack.pop(null);
        }

        Label {
            text: "Do you want to exit this room and go back to main menu?"
        }

        standardButtons: Dialog.Ok | Dialog.Cancel
    }

    ToolButton {
        text: "X"
        anchors {
            left: parent.left
            top: parent.top
        }
        onClicked: backToMenuDialog.open()
    }
}
