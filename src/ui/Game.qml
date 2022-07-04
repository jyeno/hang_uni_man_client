import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import br.uni.hangman

Item {
    id: game

    property int total_chances

    ColumnLayout {
        anchors.fill: parent
        Repeater {
            model: Core.data.players

            Rectangle {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.fillWidth: true
                // maybe this rectangle should be outside repeater
                Layout.fillHeight: true
                color: "transparent"

                RowLayout {
                    anchors.centerIn: parent

                    Label {
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignTop
                        text: modelData.player
                        font.bold: index === Core.data.current_player
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    Repeater {
                        id: lifeRepeater

                        readonly property int remaining_chances: modelData.remaining_chances

                        model: game.total_chances

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            radius: 50
                            width: 30
                            height: 30
                            color: index <= (lifeRepeater.remaining_chances - 1) ? "grey" : "transparent"
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
            Layout.alignment: Qt.AlignVCenter
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
