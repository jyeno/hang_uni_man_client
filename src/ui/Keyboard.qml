import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: keyboard
    implicitWidth: 300
    implicitHeight: 200

    property double columns: 10
    property double rows: 3
    property double rowSpacing: 0.01 * width
    property double columnSpacing: 0.02 * height

    ColumnLayout {
        Row { // qwertyuiop
            spacing: rowSpacing

            Repeater {
                model: [
                    {text: 'q', width: 1},
                    {text: 'w', width: 1},
                    {text: 'e', width: 1},
                    {text: 'r', width: 1},
                    {text: 't', width: 1},
                    {text: 'y', width: 1},
                    {text: 'u', width: 1},
                    {text: 'i', width: 1},
                    {text: 'o', width: 1},
                    {text: 'p', width: 1},
                ]

                delegate: Button {
                    text: modelData.text
                    width: modelData.width * keyboard.width / columns - rowSpacing
                    height: keyboard.height / rows - columnSpacing

                    // onClicked: root.clicked(text)
                }
            }
        }

        Row { // asdfghjkl
            spacing: rowSpacing

            Repeater {
                model: [
                    {text: '', width: 0.5},
                    {text: 'a', width: 1},
                    {text: 's', width: 1},
                    {text: 'd', width: 1},
                    {text: 'f', width: 1},
                    {text: 'g', width: 1},
                    {text: 'h', width: 1},
                    {text: 'j', width: 1},
                    {text: 'k', width: 1},
                    {text: 'l', width: 1},
                    {text: '', width: 0.5},
                ]

                delegate: Button {
                    text: modelData.text
                    width: modelData.width * keyboard.width / columns - rowSpacing
                    height: keyboard.height / rows - columnSpacing

                    // onClicked: root.clicked(text)
                }
            }
        }

        Row { // zxcvbnm
            spacing: rowSpacing

            Repeater {
                model: [
                    {text: '', width: 1.5},
                    {text: 'z', width: 1},
                    {text: 'x', width: 1},
                    {text: 'c', width: 1},
                    {text: 'v', width: 1},
                    {text: 'b', width: 1},
                    {text: 'n', width: 1},
                    {text: 'm', width: 1},
                    {text: '', width: 1.5},
                ]

                delegate: Button {
                    text: modelData.text
                    width: modelData.width * keyboard.width / columns - rowSpacing
                    height: keyboard.height / rows - columnSpacing

                    // onClicked: root.clicked(text)
                }
            }
        }
    }
}
