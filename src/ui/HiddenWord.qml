import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: hiddenWord

    required property string model

    // TODO put some kind of scroll in case of the word being too big for the current window size
    RowLayout {
        id: wordHiddenLayout
        anchors.centerIn: parent

        Repeater {
            model: Array.from(hiddenWord.model)

            ColumnLayout {

                Label {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter | Qt.alignVCenter
                    font.bold: true
                    font.pixelSize: 40
                    font.capitalization: Font.AllUppercase
                    color: "steelblue"
                    text: modelData
                }

                ToolSeparator {
                    orientation: Qt.Horizontal

                    contentItem: Rectangle {
                        implicitWidth: parent.vertical ? 1 : 24
                        implicitHeight: parent.vertical ? 24 : 1
                        color: modelData !== " " ? "steelblue" : "black"
                    }
                }
            }
        }
    }

    Rectangle {
        color: "lightsteelblue"
        opacity: 0.3
        radius: 10
        anchors {
            left: wordHiddenLayout.left
            right: wordHiddenLayout.right
            top: wordHiddenLayout.top
            bottom: wordHiddenLayout.bottom
        }
    }
}
