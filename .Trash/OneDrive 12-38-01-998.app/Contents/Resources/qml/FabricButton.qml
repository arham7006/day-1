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
//      3. the button style "primary" or "standard" or "upsell"
//
//      Optionally you may customize the min size of the button and the padding.

Button {
    id: button

    property string buttonStyle: "primary"
    property int minWidth: 80
    property int buttonPadding: 20
    property alias buttonText: buttonTextControl.text

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
        border.color: chooseBorderColor(button, buttonStyle)
        border.width: 1
        radius: 2

        Rectangle {
            id: focusBorder
            visible: button.activeFocus
            anchors.fill: parent
            anchors.margins: 2
            color: "transparent"
            border.color: chooseInnerBorderColor(button, buttonStyle)
            border.width: 1
            radius: 1
        }
    }

    contentItem: Text {
            id: buttonTextControl
            font.family: "Segoe UI Semibold"
            font.pixelSize: 14
            color: chooseButtonTextColor(button, buttonStyle)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
    }

    function chooseBorderColor(buttonParam, style) {
        var color = "pink";
        if (buttonParam.enabled)
        {
            if (style === "primary") {
                color = "transparent"
            }
            else if (style === "upsell") {
                color = Colors.fabric_button.upsell.focused_border;
            }
            else {
                color = Colors.fabric_button.standard.focused_border;
            }
        } 
        else {
            color = "transparent"
        }

        return color;
    }

    // Inner border always matches the text color
    function chooseInnerBorderColor(buttonParam, style) {
        var color = "pink";
        if (buttonParam.down) {
            color = "transparent"
        }
        else {
            if (style === "primary") {
                color = Colors.fabric_button.primary.text
            }
            else if (style === "upsell") {
                color = Colors.fabric_button.upsell.text
            }
            else {
                color = Colors.fabric_button.standard.text;
            }
        }
        return color;
    }

    function chooseButtonTextColor(buttonParam, style) {
        var color = "pink";
        // the primary button only has two text colors
        if (style === "primary") {
            color = (buttonParam.enabled) ?
                        Colors.fabric_button.primary.text :
                        Colors.fabric_button.primary.text_disabled;
        }
        // the upsell button only has two text colors
        else if (style === "upsell") {
            color = (buttonParam.enabled) ?
                        Colors.fabric_button.upsell.text :
                        Colors.fabric_button.upsell.text_disabled;
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
                color = chooseButtonDownColor(style);
            }
            else if (buttonParam.hovered) {
                color = chooseButtonHoveredColor(style)
            }
            else {
                color = chooseButtonRestColor(style)
            }
        }
        else {
            color = chooseButtonDisabledColor(style)
        }
        return color;
    }

    function chooseButtonDownColor(style) {
        var color = "pink";
        if (style === "primary") {
            color = Colors.fabric_button.primary.down;
        } 
        else if (style ===  "upsell") {
            color = Colors.fabric_button.upsell.down;
        }
        else
        {
            color = Colors.fabric_button.standard.down;
        }
        return color;
    }

    function chooseButtonHoveredColor(style) {
        var color = "pink";
        if (style === "primary") {
            color = Colors.fabric_button.primary.hovered;
        } 
        else if (style ===  "upsell") {
            color = Colors.fabric_button.upsell.hovered;
        }
        else {
            color = Colors.fabric_button.standard.hovered;
        }
        return color;
    }

    function chooseButtonRestColor(style) {
        var color = "pink";
        if (style === "primary") {
            color = Colors.fabric_button.primary.background;
        } 
        else if (style ===  "upsell") {
            color = Colors.fabric_button.upsell.background;
        }
        else {
            color = Colors.fabric_button.standard.background;
        }
        return color;
    }

    function chooseButtonDisabledColor(style) {
        var color = "pink";
        if (style === "primary") {
            color = Colors.fabric_button.primary.disabled;
        } 
        else if (style ===  "upsell") {
            color = Colors.fabric_button.upsell.disabled;
        }
        else {
            color = Colors.fabric_button.standard.disabled;
        }
        return color;
    }
}
