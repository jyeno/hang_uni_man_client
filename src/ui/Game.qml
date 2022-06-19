import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import br.uni.hangman

Item {
    id: game

    // TODO fix this, should be maximum amount of chances
    property int total_chances
    // TODO have alongside the life the player name, then if multiples players are playing the users can know
    // how much of life each other got
    ColumnLayout {
        anchors.fill: parent
        // TODO implement multiple players
        Repeater {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            model: Core.data.players

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                RowLayout {
                    anchors.fill: parent

                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        text: modelData.player
                        font.bold: true
                    }

                    Repeater {
                        id: lifeRepeater
                        property int remaining_chances: modelData.remaining_chances
                        // Layout.fillWidth: true
                        // Layout.fillHeight: true
                        model: game.total_chances

                        Rectangle {
                            radius: 50
                            width: 30
                            height: 30
                            color: index <= (lifeRepeater.remaining_chances - 1) ? "green" : "red"
                        }
                    }
                }
            }
        }

        HiddenWord {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            model: Core.data.hidden_word
        }

        Keyboard {
            Layout.fillWidth: true
        }
    }

    ToolButton {
        text: "X"
        anchors {
            left: parent.left
            top: parent.top
        }
        onClicked: backToMenuDialog.open()
    }

    ToolButton {
        text: "Guess Word"
        enabled: true
        anchors {
            right: parent.right
            top: parent.top
        }
        onClicked: wordGuessingDialog.open()
    }

    Dialog {
        id: wordGuessingDialog

        anchors.centerIn: Overlay.overlay
        title: "Guess Word"
        onAccepted: Core.gameGuessWord(wordGuessTextField.text)
        onOpened: wordGuessTextField.forceActiveFocus()
        onClosed: wordGuessTextField.text = ""

        footer: DialogButtonBox {
            Button {
                text: qsTr("Guess!")
                enabled: wordGuessTextField.text !== ""
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }
            Button {
                text: qsTr("Cancel")
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }
        }

        TextField {
            id: wordGuessTextField
            placeholderText: qsTr("Type your guess")
        }
    }
    Dialog {
        id: backToMenuDialog

        anchors.centerIn: Overlay.overlay
        title: "Back to main menu"
        onAccepted: {
            Core.exitGame();
            stack.pop(null);
        }

        Label {
            text: "Do you want to abort this match and go to main menu?"
        }

        standardButtons: Dialog.Ok | Dialog.Cancel
    }

    Component.onCompleted: game.total_chances = Core.data.players[0].remaining_chances
}
