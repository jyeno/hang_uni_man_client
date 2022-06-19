import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import br.uni.hangman

ApplicationWindow {
    title: "HangUniMan"
    visible: true

    Image {
        anchors.fill: parent
        source: "background"
    }

    Component {
        id: gameComponent

        Game {
        }
    }

    Component {
        id: roomComponent

        Room {
        }
    }

    Component {
        id: initialMenuComponent

        Item {
            ColumnLayout {
                anchors.centerIn: parent
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Play Solo")
                    onClicked: Core.startGame(Core.PlayModality.Solo)
                }
                Button {
                    Layout.fillWidth: true
                    text: qsTr("New Room")
                    onClicked: roomCreationDialog.open()
                }
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Join Room")
                    onClicked: Core.rooms();
                }
                Button {
                    Layout.fillWidth: true
                    text: qsTr("History")
                    enabled: false
                }
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Exit")
                    onClicked: {
                        Core.logout();
                        Qt.quit();
                    }
                }
            }

            ToolButton {
                text: qsTr("Help")
                anchors.right: parent.right
                anchors.top: parent.top
                // TODO help
            }
        }
    }

    StackView {
        id: stack

        initialItem: initialMenuComponent
        anchors.fill: parent
    }

    Dialog {
        id: roomSelectorDialog

        title: qsTr("Join a room")
        anchors.centerIn: Overlay.overlay
        onAccepted: Core.selectRoom(roomListView.model[roomListView.currentIndex].uid);
        footer: DialogButtonBox {
            Button {
                text: qsTr("Join")
                enabled: roomListView.currentIndex !== -1
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }
            Button {
                text: qsTr("Cancel")
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }
        }

        ListView {
            id: roomListView

            delegate: Rectangle {
                width: parent.width
                height: 50
                border { color: "lightsteelblue"; width: 1}
                color: ListView.isCurrentItem ? "black" : "red"
                Label {
                    anchors.fill: parent
                    text: modelData.name + " " + "(" + modelData.difficulty + ")" + " " + modelData.current_count + "/" + modelData.max_players
                }
            }
        }
    }

    Dialog {
        id: roomCreationDialog

        title: qsTr("Create new room")
        anchors.centerIn: Overlay.overlay
        width: parent.width / 2
        onOpened: roomNameTextField.forceActiveFocus()
        onAccepted: Core.createRoom(roomNameTextField.text, difficultyComboBox.currentValue)
        onClosed: {
            difficultyComboBox.currentIndex = 0;
            roomNameTextField.text = "";
        }

        footer: DialogButtonBox {
            Button {
                text: qsTr("Create")
                enabled: roomNameTextField.text !== ""
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }
            Button {
                text: qsTr("Cancel")
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }
        }

        ColumnLayout {
            anchors.fill: parent

            Label {
                text: qsTr("Selecione a dificuldade")
            }

            ComboBox {
                id: difficultyComboBox
                Layout.fillWidth: true

                textRole: "text"
                valueRole: "value"
                model: [
                    { text: "Médio", value: "medio" },
                    { text: "Fácil", value: "facil" },
                    { text: "Difícil", value: "dificil" },
                ]
            }

            Label {
                text: qsTr("Nome da sala")
            }

            TextField {
                id: roomNameTextField

                Layout.fillWidth: true
            }
        }
    }

    Dialog {
        id: playerCreationDialog

        title: qsTr("Register your username")
        anchors.centerIn: Overlay.overlay
        modal: true
        closePolicy: Popup.NoAutoClose
        onOpened: usernameTextField.forceActiveFocus()

        // TODO have selection of server and port

        TextField {
            id: usernameTextField
            anchors.fill: parent
            placeholderText: qsTr("Enter your username")
        }

        footer: DialogButtonBox {
            Button {
                text: qsTr("Register")
                enabled: usernameTextField.text !== ""
                onClicked: Core.login(usernameTextField.text);
            }
        }
    }

    Dialog {
        id: genericGoHomeDialog

        // TODO solve warning
        property alias text: label.text
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.Ok
        onClosed: {
            stack.pop(null);
        }

        Label {
            id: label
        }
    }

    Connections {
        function onRoomListChanged(room_list) {
            roomListView.model = room_list;
            roomListView.currentIndex = -1;
            roomSelectorDialog.open();
        }

        function onRoomCreated(room) {
            stack.push(roomComponent)
        }

        function onRoomChanged(room) {
            if (stack.depth == 1)
                stack.push(roomComponent)
        }

        function onRoomMessageReceived(messageObject) {
            stack.currentItem.messagesModel.append(messageObject);
        }

        function onGameStarted(game) {
            stack.push(gameComponent);
        }

        function onGameFinished(game) {
            // TODO use message dialog
            genericGoHomeDialog.title = qsTr("Hidden Word has been found!");
            genericGoHomeDialog.text = qsTr("The secret word is \"") + Core.data.hidden_word.toUpperCase() + qsTr("\" and the winner is ") + Core.data.winner + "!";
            genericGoHomeDialog.open()
        }

        function onPlayerEliminated() {
            genericGoHomeDialog.title = qsTr("Game has ended");
            genericGoHomeDialog.text = qsTr("You have lost, you do not have any more chances to guess")
            genericGoHomeDialog.open()
        }

        function onPlayerCreated(name) {
            playerCreationDialog.close();
        }

        function onErrorHappened(errorString) {

        }

        target: Core
    }

    Component.onCompleted: playerCreationDialog.open()
}
