import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import br.uni.hangman

Item {
    id: keyboard
    enabled: Core.playerIndex == Core.data.current_player

    implicitWidth: 300
    implicitHeight: 200

    property double columns: 10
    property double rows: 3
    property double rowSpacing: 0.01 * width
    property double columnSpacing: 0.02 * height

    function disableLetterGuessed(letters_guessed: string) {
        const models = [ firstRowModel, secondRowModel, thirdRowModel ];
        for (let index_model = 0; index_model < models.length; index_model += 1) {
            const letters_model = models[index_model];
            for (let i = 0; i < letters_model.count; i += 1) {
                let element = letters_model.get(i);
                if (!element.guessed && letters_guessed.includes(element.letter)) {
                    element.guessed = true;
                    return;
                }
            }
        }
    }

    ColumnLayout {
        Row { // qwertyuiop
            spacing: rowSpacing

            Repeater {
                model: ListModel {
                    id: firstRowModel

                    ListElement {letter: 'Q'; guessed: false; width: 1}
                    ListElement {letter: 'W'; guessed: false; width: 1}
                    ListElement {letter: 'E'; guessed: false; width: 1}
                    ListElement {letter: 'R'; guessed: false; width: 1}
                    ListElement {letter: 'T'; guessed: false; width: 1}
                    ListElement {letter: 'Y'; guessed: false; width: 1}
                    ListElement {letter: 'U'; guessed: false; width: 1}
                    ListElement {letter: 'I'; guessed: false; width: 1}
                    ListElement {letter: 'O'; guessed: false; width: 1}
                    ListElement {letter: 'P'; guessed: false; width: 1}
                }

                delegate: Button {
                    text: model.letter
                    width: model.width * keyboard.width / columns - rowSpacing
                    height: keyboard.height / rows - columnSpacing
                    enabled: !model.guessed
                    onClicked: Core.gameGuessLetter(text[0])
                }
            }
        }

        Row { // asdfghjkl
            spacing: rowSpacing

            Repeater {
                model: ListModel {
                    id: secondRowModel

                    ListElement {letter: ''; guessed: true; width: 0.5}
                    ListElement {letter: 'A'; guessed: false; width: 1}
                    ListElement {letter: 'S'; guessed: false; width: 1}
                    ListElement {letter: 'D'; guessed: false; width: 1}
                    ListElement {letter: 'F'; guessed: false; width: 1}
                    ListElement {letter: 'G'; guessed: false; width: 1}
                    ListElement {letter: 'H'; guessed: false; width: 1}
                    ListElement {letter: 'J'; guessed: false; width: 1}
                    ListElement {letter: 'K'; guessed: false; width: 1}
                    ListElement {letter: 'L'; guessed: false; width: 1}
                    ListElement {letter: ''; guessed: true; width: 0.5}
                }

                delegate: Button {
                    text: model.letter
                    width: model.width * keyboard.width / columns - rowSpacing
                    height: keyboard.height / rows - columnSpacing
                    enabled: !model.guessed
                    onClicked: Core.gameGuessLetter(text[0])
                }
            }
        }

        Row { // zxcvbnm
            spacing: rowSpacing

            Repeater {
                model: ListModel {
                    id: thirdRowModel

                    ListElement {letter: ''; guessed: true; width: 1.5}
                    ListElement {letter: 'Z'; guessed: false; width: 1}
                    ListElement {letter: 'X'; guessed: false; width: 1}
                    ListElement {letter: 'C'; guessed: false; width: 1}
                    ListElement {letter: 'V'; guessed: false; width: 1}
                    ListElement {letter: 'B'; guessed: false; width: 1}
                    ListElement {letter: 'N'; guessed: false; width: 1}
                    ListElement {letter: 'M'; guessed: false; width: 1}
                    ListElement {letter: ''; guessed: true; width: 1.5}
                }

                delegate: Button {
                    text: model.letter
                    width: model.width * keyboard.width / columns - rowSpacing
                    height: keyboard.height / rows - columnSpacing
                    enabled: !model.guessed
                    onClicked: Core.gameGuessLetter(text[0])
                }
            }
        }
    }

    Connections {
        function onGameChanged(game) {
            keyboard.disableLetterGuessed(game.letters_guessed);
        }

        target: Core
    }
}
