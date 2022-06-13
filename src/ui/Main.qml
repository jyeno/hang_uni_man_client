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

    StackView {
        id: stackView

        anchors.fill: parent

        Item {
            anchors.fill: parent
            ColumnLayout {
                anchors.centerIn: parent
                Button {
                    Layout.fillWidth: true
                    text: "play solo"
                }
                Button {
                    Layout.fillWidth: true
                    text: "new room"
                }
                Button {
                    Layout.fillWidth: true
                    text: "rooms"
                }
                Button {
                    Layout.fillWidth: true
                    text: "history"
                    enabled: false
                }
                Button {
                    Layout.fillWidth: true
                    text: "exit"
                    onClicked: Qt.quit()
                }
            }

            ToolButton {
                text: "Help"
                anchors.right: parent.right
                anchors.top: parent.top
            }
        }
    }

    Dialog {
        id: usernameDialog

        title: "Register your username"
        anchors.centerIn: Overlay.overlay
        modal: true
        closePolicy: Popup.NoAutoClose
        onAccepted: {
            // TODO validation
            console.log("login was successful? " + Core.login(usernameTextField.text));
        }

        TextField {
            id: usernameTextField
            anchors.fill: parent
            placeholderText: "Enter your username"
        }

        footer: DialogButtonBox {
            Button {
                text: qsTr("Register")
                enabled: usernameTextField.text !== ""
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }
        }
    }

    Component.onCompleted: usernameDialog.open()
}
