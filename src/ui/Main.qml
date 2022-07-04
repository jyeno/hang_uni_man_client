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
                onClicked: {
                    genericMessageDialog.title = qsTr("Help");
                    genericMessageDialog.text = qsTr("You have two have two ways to play the game:\n\n * Single player - play solo, trying to find the hidden word\n\n * Multiplayer - matchmaking you and others players, when the game start you will have to find the hidden word. Until the current player guess wrong, he will continue to be able to guess meanwhile others players will be waiting theirs time.\n\nMade by Jean Lima Andrade, Vitor Emanuel, Lucas Fonseca and Renan Souza for the network evaluation work.");
                    genericMessageDialog.open()
                }
            }
        }
    }

    StackView {
        id: stack

        initialItem: initialMenuComponent
        anchors.fill: parent
    }

    ListModel {
        id: roomListModel
    }

    Dialog {
        id: roomSelectorDialog

        title: qsTr("Join a room")
        anchors.centerIn: Overlay.overlay
        width: parent.width * 0.5
        height: parent.height * 0.5
        modal: true
        closePolicy: Popup.NoAutoClose
        onAccepted: Core.joinRoom(roomListView.currentItem.uid);
        footer: DialogButtonBox {
            Button {
                text: qsTr("Join")
                enabled: roomListView.currentIndex !== -1 && (roomListView.currentItem.isAvailable ?? falses)
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }
            Button {
                text: qsTr("Cancel")
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }
        }

        ListView {
            id: roomListView

            anchors.fill: parent
            clip: true
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            focus: true
            model: roomListModel
            delegate: Item {

                readonly property string uid: model.uid
                readonly property bool isAvailable: model.current_count < model.max_players

                width: roomListView.width
                height: 50

                MouseArea {
                    anchors.fill: parent
                    onClicked: roomListView.currentIndex = index
                }

                Label {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: model.name + " (" + model.difficulty + ") " + model.current_count + "/" + model.max_players
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
        id: genericMessageDialog

        property alias text: label.text
        property bool backMainMenu: false
        anchors.centerIn: Overlay.overlay
        standardButtons: Dialog.Ok
        closePolicy: Popup.NoAutoClose
        modal: true
        implicitWidth: parent.width * 0.85
        onClosed: {
            if (backMainMenu)
                stack.pop(null);

            backMainMenu = false;
        }

        Label {
            id: label
            anchors.fill: parent
            wrapMode: Text.WordWrap
        }
    }

    Connections {
        function onRoomListChanged(room_list) {
            roomListModel.clear();
            console.log("list: " + room_list.length);
            for (let i = 0; i < room_list.length; i += 1) {
                roomListModel.append(room_list[i]);
            }
            console.log("list: " + roomListView.model.count);
            roomSelectorDialog.open();
        }

        function onRoomCreated(room) {
            stack.push(roomComponent, { isCreator: true })
        }

        function onRoomChanged(room) {
            if (stack.depth == 1)
                stack.push(roomComponent, { isCreator: false })
        }

        function onRoomDeleted() {
            genericMessageDialog.title = qsTr("Going back to main menu")
            genericMessageDialog.text = qsTr("The creator of the room has exited, thus deleting the room")
            genericMessageDialog.backMainMenu = true;
            genericMessageDialog.open()
        }

        function onRoomMessageReceived(messageObject) {
            stack.currentItem.messagesModel.append(messageObject);
        }

        function onGameStarted(game) {
            stack.push(gameComponent);
        }

        function onGameFinished(game) {
            genericMessageDialog.title = qsTr("Hidden Word has been found!");
            genericMessageDialog.text = qsTr("The secret word is \"") + Core.data.hidden_word.toUpperCase() + qsTr("\" and the winner is ") + Core.data.winner + "!";
            genericMessageDialog.backMainMenu = true;
            genericMessageDialog.open()
        }

        function onPlayerEliminated() {
            genericMessageDialog.title = qsTr("You have lost you chances");
            genericMessageDialog.text = qsTr("You do not have chances anymore to guess letters and words")
            genericMessageDialog.backMainMenu = true;
            genericMessageDialog.open()
        }

        function onErrorHappened(errorString) {
            genericMessageDialog.title = qsTr("An error happened");
            genericMessageDialog.text = qsTr("Error, ") + errorString;
            genericMessageDialog.open()
        }

        function onPlayerCreated(name) {
            playerCreationDialog.close();
        }

        target: Core
    }

    Component.onCompleted: playerCreationDialog.open()
}
