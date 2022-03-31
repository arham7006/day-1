/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

// This file contains formatted MenuItem objects. Since the menu styling will be uniform across menus in AC for consistency, colors are finalized.
// Text is anchored relative to CustomMenuItem. User actions return, space, and clicking all use developer-defined callback function.
// Keyboard up/down navigation between MenuItems are inherent to MenuItem object in QML.
// However, developer can still change the following properties for additional customization:
// - primarycolor
// - hovercolor
// - pressedcolor
// - focuscolor
//
// Developer must change the following for each CustomMenuItem:
// - textcontrol.txt (str)
// - callback (function)

MenuItem {
    id: menuItem

    property int menuItemHeight: 32
    property int menuItemMargin: 12
    property int menuItemWidth: txt.paintedWidth

    Accessible.onPressAction: doCallback(false)
    Accessible.name: text
    Accessible.disabled: !enabled

    property bool hasSeparator: false

    width: (parent != null) ? parent.width : 0

    function chooseBGColor(isHovering, isPressed, isActiveFocus) {
        var color = primarycolor;
        if (isHovering) {
            color = hovercolor;
        }
        if (isPressed) {
            color = pressedcolor;
        }
        if (isActiveFocus) {
            color = focuscolor;
        }

        return color;
    }

    LayoutMirroring.enabled: headerModel.isRTL
    LayoutMirroring.childrenInherit: headerModel.isRTL
    height: menuItemHeight
    activeFocusOnTab: true
    // set MenuItem hoverEnabled to be false to fix the bug when mouse hover over the menu item,
    // it will automatically get focus
    hoverEnabled: false
    background: Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: chooseBGColor(ma.containsMouse, ma.containsPress, menuItem.activeFocus)
        border.color: menuItem.activeFocus ? itemBorderColor : "transparent";
        Rectangle {
            visible: menuItem.hasSeparator
            width: parent.width
            height: visible ? 1 : 0
            color: "#CCCCCC"
            anchors.bottom: parent.bottom
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        onClicked: doCallback(false)
    }

    property color primarycolor: Colors.activity_center.context_menu.background
    property color hovercolor: Colors.activity_center.context_menu.item_hover
    property color pressedcolor: Colors.activity_center.context_menu.item_pressed
    property color focuscolor: Colors.activity_center.context_menu.item_focus
    property color itemBorderColor: Colors.activity_center.context_menu.item_border

    property alias textcontrol: txt
    property alias shortcut: keyshortcut

    text: txt.text
    contentItem: Text {
        id: txt
        text: "sample"
        horizontalAlignment: Text.AlignLeft
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 3
        font.family: "Segoe UI"
        font.pixelSize: 12
        color: menuItem.enabled ? (menuItem.activeFocus || menuItem.hovered || ma.containsMouse || ma.containsPress ? Colors.common.text_hover : Colors.common.text) : Colors.common.text_disabled
        anchors.left: parent.left
        anchors.leftMargin: parent.menuItemMargin
        anchors.right: parent.right
        anchors.rightMargin: parent.menuItemMargin
    }

    Shortcut {
        // make sure all items in a menu have a unique shortcut
        // otherwise, menu items with conflicting shortcut sequence will be ignored
        id: keyshortcut
        sequence: "sample"
        context: Qt.WindowShortcut
        onActivated: doCallback(true)
    }

    // consuming code should set callback property to a function to run for clicks
    property var callback: genericCallback

    function genericCallback(isShortcut) {
        print("CustomMenuItem: no click handler set");
    }

    function doCallback(isShortcut) {
        if (typeof(callback) === "function") {
            callback(isShortcut);
        } else {
            print("CustomMenuItem: callback is not a function");
        }
    }

    onTriggered: doCallback(false)
    Keys.onReturnPressed: doCallback(false)

    // Note: Keys.onSpacePressed is not set here as it will cause two space events to be produced.
    //  Look in QML's BasicButton::Keys.onReleased to see the event duplication that causes this (BasicButton is the parent of Button)
    //  So we omit defining the action of space here, since the onReleased event of space will call the onClicked action.
    Keys.onReleased: {
        if (event.key === Qt.Key_Space) {
            doCallback(false);

            // set event to accepted so that we don't get a duplicated event
            event.accepted = true;
        }
    }
}
