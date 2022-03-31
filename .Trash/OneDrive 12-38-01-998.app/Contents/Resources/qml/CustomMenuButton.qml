/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/
import Colors 1.0
import QtQml 2.2
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

// This file contains formatted Button used by ActivityCenterListItem and VersionHistoryListItem.
// Developer must change the following for each CustomMenuButton:
//     callback (function)
//
// Developers can customize the following properties when using it:
// Define the usual properties for a button
//     height
//     width
// Update the visual contentItem Image property
//     size
//
// Developer can also change the following properties for additional customization:
//     accessibleName
//     primarycolor
//     hovercolor
//     pressedcolor
//     text

Button {
    id: menuButton
    property int buttonWidth: 36
    property int buttonHeight: 36
    property int imageSize: 40

    property color primarycolor: "transparent"
    property color hovercolor: Colors.activity_center.context_menu.button_hover
    property color pressedcolor: Colors.activity_center.context_menu.button_pressed
    property color bordercolor: Colors.activity_center.list.border_focus

    property bool isUsingKeyboard: false
    property var accessibleName: listModel.menuButtonAccessibleName

    activeFocusOnTab: true
    focusPolicy: Qt.TabFocus // Accepts focus by tabbing to avoid mouse click changing focus
    hoverEnabled: true

    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    width: buttonWidth
    height: buttonHeight

    // consuming code should set callback property to a function to run for clicks
    property var callback: genericCallback

    function genericCallback(isShortcut) {
        print("CustomMenuButton: no click handler set");
    }

    function doCallback(isShortcut) {
        if (typeof(callback) === "function") {
            callback(isShortcut);
        } else {
            print("CustomMenuButton: callback is not a function");
        }
    }

    onClicked: doCallback(false)
    Keys.onReturnPressed: doCallback(true)
    Keys.onEnterPressed: doCallback(true)

    Accessible.name: accessibleName
    Accessible.ignored: !visible
    Accessible.onPressAction: doCallback(true)

    // This text is only used for accessibility. QT Button pulls the accessibility string from the button text.
    // We are overwritting the content Item below so the text isnt shown on the screen.
    text: accessibleName

    background: Rectangle {
        anchors.fill: parent
        color : menuButton.pressed ? pressedcolor : (menuButton.hovered ? hovercolor : primarycolor)
        border.color: (isUsingKeyboard && menuButton.activeFocus && !menuButton.pressed) ? bordercolor : primarycolor
        border.width: (Qt.platform.os === "osx") ? 1 : 2
    }

    contentItem: Image {
        anchors.fill: parent
        source: "file:///" + imageLocation + "overflowIcon.svg";
        width: imageSize
        height: imageSize
        sourceSize.width:  imageSize
        sourceSize.height: imageSize
    }

    ToolTip {
        id: menuToolTip
        visible: (parent.hovered || parent.activeFocus)
        delay: 400

        contentItem: Text{
            height: 14
            color: Colors.tool_tip.text
            text: accessibleName
            font.family: "Segoe UI"
            font.pixelSize: 12
        }

        background: Rectangle {
            anchors.fill: parent
            color : (Qt.platform.os === "osx") ? Colors.tool_tip.background_mac : Colors.tool_tip.background
            border.color: (Qt.platform.os === "osx") ? Colors.activity_center.common.mac_border : Colors.tool_tip.border
            border.width: 1
        }
    }
}
