/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0

// Fabric Dropdown
//
//      A QML implementation of the Office UI fabric dropdown
//
//      See some examples on the public web: https://developer.microsoft.com/en-us/fabric#/controls/web/dropdown
//
//      People who want to use this dropdown need to provide:
//      1. defaultInput
//      2. inError
//      3. callback: a function to invoke when the EnterKey is pressed while on textField
//      4. button.callback: a function to invoke when the button is clicked
//

Rectangle {
    id: dropdown

    width: 32
    height: 32

    property string defaultInput: ""
    property bool inError: false
    property alias textFieldText: textField.text
    property alias inputField: textField
    property alias button: chevronButton
    property string buttonAccName: ""

    color: Colors.fabric_textfield.background
    border.color:
            inError ? Colors.fabric_textfield.border_error :
                ((dropdown.focus || textField.focus) ?  Colors.fabric_textfield.border_selected :
                    ((dropdown.hovered || textField.hovered) ? Colors.fabric_textfield.border_hover :
                        Colors.fabric_textfield.border))

    // consuming code should set callback property to a function to run for clicks
    property var callback: genericCallback

    function genericCallback() {
        print("FabricDropdown: no click handler set");
    }

    function doCallback(text) {
        if (typeof(callback) === "function") {
            callback(text);
        } else {
            print("FabricDropdown: callback is not a function");
        }
    }

    Row {
        anchors.fill: parent

        TextField {
            id: textField
            placeholderText: _("FirstRunEmailInputPlaceholderText")
            height: parent.height
            width: (parent.width - chevronButton.width)

            // for RTL, cursor should appear on right
            horizontalAlignment: effectiveHorizontalAlignment

            text: defaultInput
            font.family: "Segoe UI"
            font.pixelSize: 14
            color: Colors.fabric_textfield.text
            background: Rectangle {
                color: "transparent"
            }

            Keys.onEnterPressed: doCallback(textField.text)
            Keys.onReturnPressed: doCallback(textField.text)

            Keys.onDownPressed: chevronButton.doCallback()
            Keys.onUpPressed: chevronButton.doCallback()

            Accessible.ignored: !visible
        }

        SimpleButton {
            id: chevronButton
            width: 40
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 2
            height: parent.height - 4

            // noop on Space pressed since Space is reserved for selecting item on menu
            performCallbackOnSpace: false

            useImage: true
            imagecontrol.source: "file:///" + imageLocation + "chevronUp.svg"
            imagecontrol.width: 32
            imagecontrol.height: 32
            imagecontrol.sourceSize.width:  32
            imagecontrol.sourceSize.height: 32

            primarycolor: Colors.fabric_textfield.background
            hovercolor: Colors.fabric_button.standard.hovered
            pressedcolor: Colors.common.text_secondary_hovering_alt
            focuscolor: Colors.common.text_secondary_hovering_alt

            Accessible.name: buttonAccName
            Accessible.ignored: !visible
        }
    }
}
