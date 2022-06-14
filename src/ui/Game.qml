import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: 5

                Text {
                    font.bold: true
                    text: "O"
                }
            }
        }

        HiddenWord {
            Layout.fillWidth: true
            Layout.fillHeight: true

            function makeInitialModelFromWord(word: string) {
                var m = Array.from(word);
                for (var i = 0; i < m.length; i += 1)
                    m[i] = {
                        "letter": m[i],
                        "found": false
                    };
                return m;
            }

            model: makeInitialModelFromWord("random")
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

    Dialog {
        id: backToMenuDialog

        anchors.centerIn: Overlay.overlay
        title: "Back to main menu"
        onAccepted: stack.pop()

        Label {
            text: "Do you want to abort this match and go to main menu?"
        }

        standardButtons: Dialog.Ok | Dialog.Cancel
    }
}
