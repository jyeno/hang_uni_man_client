import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    required property string word

    Label {
        text: word
    }
}
