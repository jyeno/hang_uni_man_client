import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import br.uni.hangman

Item {
    id: roomItem

    required property bool isCreator
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

                readonly property bool isLastIndex: index == playersListView.model.length - 1

                text: modelData + (isLastIndex ? qsTr(" [creator]") : "")
                width: playersListView.width
                swipe.enabled: roomItem.isCreator && !isLastIndex

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
            visible: roomItem.isCreator
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
                id: sendMessageRowLayout
                Layout.fillWidth: true

                function sendMessageAndResetText() {
                    Core.sendRoomMessage(messageTextField.text);
                    messageTextField.text = "";
                }

                TextField {
                    id: messageTextField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Type your message...")
                    onAccepted: sendMessageRowLayout.sendMessageAndResetText()
                }

                ToolButton {
                    text: qsTr("Send")
                    enabled: messageTextField.text !== ""
                    onClicked: sendMessageRowLayout.sendMessageAndResetText()
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
