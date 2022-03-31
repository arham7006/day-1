/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0

// Fabric Button
//
//      A QML implementation of the Office UI fabric button
//
//      See some examples on the public web: https://dev.office.com/fabric#/components/button
//      And internal: http://odux/fabric/?page=components
//
//      This button has two versions, primary and standard. Primary is blue and standard is grey.
//      If the user of this button doesn't set the type, primary is assumed.
//
//      People who want to use this button need to provide:
//      1. Button text
//      2. OnClicked handler
//      3. the button style "primary" or "standard"
//
//      Optionally you may customize the min size of the button and the padding.

Button {
    id: button

    property string buttonStyle: "primary"
    property int minWidth: 80
    property int buttonPadding: 20
    property alias buttonText: buttonTextControl.text
    property int buttonRadius: 0

    // min width of 80. The fabric spec indicates buttons should not be smaller than 80
    implicitWidth: Math.max(minWidth, (contentItem.paintedWidth + (2 * buttonPadding)))
    // The fabric spec says buttons should have height 30
    implicitHeight: 30

    // This text is only used for accessibility. QT Button pulls the
    // accessibility string from the button text. We are overwritting
    // the content Item below so the text isnt shown on the screen.
    text: buttonText
    Accessible.ignored: !visible
    background: Rectangle {
        color: chooseButtonColor(button, buttonStyle)
        border.color:  button.activeFocus ?
                        ((buttonStyle === "primary") ?
                             Colors.fabric_button.primary.focused_border :
                             Colors.fabric_button.standard.focused_border) :
                        "transparent"
        border.width: 1

        radius: buttonRadius
    }

    contentItem: Text {
            id: buttonTextControl
            font.family: "Segoe UI"
            font.weight: Font.DemiBold
            font.pixelSize: 14
            color: chooseButtonTextColor(button, buttonStyle)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
    }

    function chooseButtonTextColor(buttonParam, style) {
        var color = "pink";
        // the primary button only has two text colors
        if (style === "primary") {
            color = (buttonParam.enabled) ?
                        Colors.fabric_button.primary.text :
                        Colors.fabric_button.primary.text_disabled;
        }
        // the "standard" button has a lot more text colors
        else {
            if (buttonParam.enabled) {
                if (buttonParam.down) {
                    color = Colors.fabric_button.standard.text_down;
                }
                else if (buttonParam.hovered) {
                    color = Colors.fabric_button.standard.text_hovered;
                }
                // the standard button is enabled but not down or hovered
                else {
                    color = Colors.fabric_button.standard.text;
                }
            }
            // disabled standard button
            else {
                color = Colors.fabric_button.standard.text_disabled;
            }
        }
        return color;
    }

    function chooseButtonColor(buttonParam, style) {
        var color = "pink";
        if (buttonParam.enabled) {
            if (buttonParam.down) {
                color = (style === "primary") ?
                            Colors.fabric_button.primary.down :
                            Colors.fabric_button.standard.down;
            }
            else if (buttonParam.hovered) {
                color = (style === "primary") ?
                            Colors.fabric_button.primary.hovered :
                            Colors.fabric_button.standard.hovered;
            }
            else if (buttonParam.activeFocus) {
                color = (style === "primary") ?
                            Colors.fabric_button.primary.hovered :
                            Colors.fabric_button.standard.hovered;
            }
            // button is enabled but not down or hovered
            else {
                color = (style === "primary") ?
                            Colors.fabric_button.primary.background :
                            Colors.fabric_button.standard.background;
            }
        }
        // disabled
        else {
            color = (style === "primary") ?
                        Colors.fabric_button.primary.disabled :
                        Colors.fabric_button.standard.disabled;
        }
        return color;
    }
}
