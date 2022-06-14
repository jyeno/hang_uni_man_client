import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"
    }

    HiddenWord {
        Layout.alignment: Qt.AlignHCenter
        word: "Word"
    }

    Keyboard {
        Layout.fillWidth: true
    }
}
