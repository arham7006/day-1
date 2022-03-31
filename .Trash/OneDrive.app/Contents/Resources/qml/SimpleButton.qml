/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/

import QtQuick 2.7

// SimpleButton
//
// Represents a simple rectangle control that encapsulates the majority of button functionality
// Consumers need to do the following when adding it:
// Define the usual properties for a rectangle
//     height
//     width
//     anchors
//
//     callback: a function to invoke when the button is clicked
//     primarycolor, hovercolor, and pressedcolor: the default colors are intentionally ugly
//     focuscolor: the default is white.  Set to transparent if you want your own effect for focus
//     Accessible.name
//
//     useImage:  set to false to declare a text button.  Set to true to be an image button
//
// For text buttons, define the following properties:
//     textcontrol.text
//     textcontrol.pixelSize  (default is half the Rectangle height)
//
// For image buttons, define the following properties:
//     imagecontrol.width and imagecontrol.height
//     imagecontrol.source: points to the image file (url)

Rectangle {
    id: rootButtonRect

    property bool containsMouse: ma.containsMouse
    border.color: (focusunderline || !activeFocus) ? "transparent" : focuscolor
    border.width: 1
    color: ma.containsPress ? pressedcolor : (ma.containsMouse ? hovercolor : primarycolor)
    activeFocusOnTab: true

    property bool focusunderline: false;  // for text buttons, text is underline when focus is set

    Accessible.role: Accessible.Button
    Accessible.focusable: true
    Accessible.onPressAction: doCallback(true)

    // deliberately using an ugly color scheme so that the consumer won't forget to override
    property color primarycolor: "red"
    property color hovercolor: "pink"
    property color pressedcolor: "salmon"
    property color focuscolor: "white"

    property alias textcontrol: txt
    property alias imagecontrol: img
    property alias mousearea: ma

    // set useImage to true and then update imagecontrol.source and other imagecontrol.props as needed
    property bool useImage: false

    // consuming code should set callback property to a function to run for clicks
    property var callback: genericCallback

    function genericCallback() {
        print("SimpleButton: no click handler set");
    }

    function doCallback(isKeyboard) {
        if (typeof(callback) === "function") {
            callback(isKeyboard);
        } else {
            print("SimpleButton: callback is not a function");
        }
    }

    Keys.onReturnPressed: doCallback(true);
    Keys.onEnterPressed: doCallback(true);
    Keys.onSpacePressed: doCallback(true);

    Text {
        id: txt
        font.pixelSize: parent.height/2
        anchors.centerIn: parent
        font.underline: focusunderline && parent.activeFocus
        visible: !parent.useImage
        // Work around for a Qt bug where a second underline appears at (2x,2y) co-ordinates
        clip: true
    }

    Image {
        id: img
        width: parent.width/2
        height: parent.height/2
        visible: parent.useImage
        anchors.centerIn: parent
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        onClicked: doCallback(false)
        cursorShape: Qt.PointingHandCursor
    }
}
