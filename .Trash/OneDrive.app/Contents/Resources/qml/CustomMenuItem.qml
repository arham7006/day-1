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
    Accessible.name: txt.text
    Accessible.ignored: !enabled

    property bool hasSeparator: false

    width: (parent != null) ? parent.width : 0

    function chooseBGColor(isHovering, aFocus, isPressed) {
        var color = primarycolor;
        if (isHovering) {
            color = hovercolor;
        }
        if (aFocus) {
            color = focuscolor;
        }
        if (isPressed) {
            color = pressedcolor;
        }
        return color;
    }

    LayoutMirroring.enabled: headerModel.isRTL
    LayoutMirroring.childrenInherit: headerModel.isRTL
    height: menuItemHeight
    activeFocusOnTab: true
    hoverEnabled: true
    background: Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: chooseBGColor(menuItem.hovered, menuItem.activeFocus, ma.containsPress)
        border.color: "transparent"

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
        onClicked: doCallback(false)
    }

    property color primarycolor: Colors.activity_center.context_menu.background
    property color hovercolor: Colors.activity_center.context_menu.item_hover
    property color pressedcolor: Colors.activity_center.context_menu.item_pressed
    property color focuscolor: Colors.activity_center.context_menu.item_focus

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
        color: menuItem.enabled ? (menuItem.activeFocus || menuItem.hovered ? Colors.common.text_hover : Colors.common.text) : Colors.common.text_disabled
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
    Keys.onSpacePressed: doCallback(false)
}
