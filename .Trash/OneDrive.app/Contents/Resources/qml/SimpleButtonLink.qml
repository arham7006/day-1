/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/

import QtQuick 2.7
import Colors 1.0

// SimpleButtonLink
// 
// Represents a simple item control that has generic link functionality
// Consumers need to do the following when adding it:
//     anchors
//     callback: a function to invoke when the button is clicked
//     Accessible.name
//     textcontrol.text
//     textcontrol.fontfamily
//     textcontrol.pixelSize
// 
// Properties defined for you
//     height and width of the button is scoped to the text
//     text color is defined based on if the mouse is hovered, enabled, disabled
//     text is underlined when focus is set
// If wordwrap: Text.WordWrap is used, the paintedWidth can exceed the set width if a word is too long

Item {
    id: root

    width: txt.paintedWidth
    height: txt.paintedHeight

    activeFocusOnTab: true

    Accessible.role: Accessible.Link
    Accessible.focusable: true
    Accessible.onPressAction: doCallback(true)

    property alias textcontrol: txt
    property alias mousearea: internalMouseArea

    // consuming code should set callback property to a function to run for clicks
    property var callback: genericCallback

    function genericCallback() {
        print("SimpleButtonLink: no click handler set");
    }

    function doCallback(isKeyboard) {
        if (typeof(callback) === "function") {
            callback(isKeyboard);
        } else {
            print("SimpleButtonLink: callback is not a function");
        }
    }

    Keys.onReturnPressed: doCallback(true);
    Keys.onEnterPressed: doCallback(true);
    Keys.onSpacePressed: doCallback(true);

    Text {
        id: txt
        anchors.centerIn: parent
        font.underline: (internalMouseArea.containsMouse || parent.activeFocus)
        color: getTextColor()
    }

    MouseArea {
        id: internalMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: doCallback(false)
        cursorShape: Qt.PointingHandCursor
    }

    function getTextColor()
    {
        if (!enabled) {
            return Colors.common.text_disabled;
        }
        else if (internalMouseArea.containsPress) {
            return Colors.common.hyperlink_pressed;
        }
        else if (internalMouseArea.containsMouse) {
            return Colors.common.hyperlink_hovering;
        }
        else {
            return Colors.common.hyperlink;
        }
    }
}
