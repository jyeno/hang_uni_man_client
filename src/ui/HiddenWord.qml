import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: hiddenWord

    required property var model

    // TODO put some kind of scroll in case of the word being too big for the current window size
    RowLayout {
        anchors.centerIn: parent

        Repeater {
            model: hiddenWord.model

            ColumnLayout {
                Text {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.capitalization: Font.AllUppercase
                    text: modelData.found ? modelData.letter : ""
                }

                ToolSeparator {
                    orientation: Qt.Horizontal
                    contentItem: Rectangle {
                        implicitWidth: parent.vertical ? 1 : 24
                        implicitHeight: parent.vertical ? 24 : 1
                        color: "#c7d8a9"
                    }
                }
            }
        }
    }
}
