/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2

// Developer must change the following for each UserInputField:
//  - placeholderText (string): placeholder text for the textedit component
//  - onTextChanged (function (text)): function to set model variables. If not set, the user input will not be stored anywhere


Rectangle
{
    id: root
    border.color: userInputField.activeFocus ? Colors.user_input_field.input_border_focused : Colors.user_input_field.input_border
    color: Colors.common.background
    property string placeholderText: "Replace me with your text"
    property bool hasText: userInputField.text

    property var onTextChanged: genericCallback()

    function genericCallback() {
        print("UserInputField: input field is not setting any text");
    }

    function doCallback(text) {
        if (typeof(onTextChanged) === "function") {
            onTextChanged(text);
        } else {
            print("UserInputField: onTextChanged is not a function");
        }
    }

    Flickable {
        id: flick
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentWidth: parent.width
        contentHeight: userInputField.implicitHeight
        clip: true

        function followCursor(r) {
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY + height <= r.y + r.height)
                contentY = r.y + r.height - height;
        }

        TextEdit {
            id: userInputField
            color: Colors.user_input_field.input_placeholder
            width: parent.width
            height: root.height
            padding: 8
            wrapMode: TextEdit.WordWrap
            horizontalAlignment: Text.AlignLeft
            readOnly: false
            textFormat: Qt.PlainText
            font.family: "Segoe UI"
            font.pixelSize: 14
            onCursorRectangleChanged: flick.followCursor(cursorRectangle)
            onTextChanged: doCallback(text)
            activeFocusOnTab: true

            Accessible.role: Accessible.EditableText
            Accessible.name: text
            Accessible.focusable: true
            Accessible.ignored: !root.visible

            Keys.onTabPressed: {
                // KeyNavigation priority does not work for TextInput by some reason,
                // Handling it manually
                userInputField.nextItemInFocusChain(true).forceActiveFocus();
            }
            Keys.onBacktabPressed: {
                // KeyNavigation priority does not work for TextInput by some reason,
                // Handling it manually
                userInputField.nextItemInFocusChain(false).forceActiveFocus();
            }
            KeyNavigation.priority: KeyNavigation.BeforeItem

            Text {
                padding: 8
                text: placeholderText
                color: Colors.user_input_field.input_placeholder
                visible: !userInputField.text && !userInputField.activeFocus
                font: userInputField.font
                anchors.left: parent.left
                width: parent.width
                wrapMode: TextEdit.WordWrap
                Accessible.focusable: false
                Accessible.ignored: true
            }
        }
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            Accessible.focusable : false
            Accessible.ignored: true
        }
    }
}