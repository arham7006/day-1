/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0

// CustomMenu is a formatted Menu object with a shadow background effect.
//
// How to use CustomMenu:
//  - Populate the menu with MenuItems where instantiating.
//
// Developer must change the following for each CustomMenu:
//  - menuWidth (int): define as width of the longest menu item and its margins
//  - menuHeight (int): define where used as (menuItemHeight) * (number of menu items)
//
// Note: declaring any default objects used here will override all formatting declared in this file.

Menu {
    id: menu
    property int menuWidth: 200
    property int menuHeight: 20
    property int menuShadowMargin: 4

    Accessible.focusable: true

    closePolicy: Popup.CloseOnPressOutsideParent | Popup.CloseOnEscape
    padding: 1

    background: Rectangle {
        implicitWidth: menuWidth

        // We want the background element of the Menu to be a rectangle with a drop shadow.
        // We build this by defining the Rectangle (see the white one below), and using a BorderImage to create the dropshadow effect.
        // The reason they are defined in this order, BorderImage first, Rectangle afterwards is so that the Rectangle gets painted on top of the BorderImage,
        // so the resulting painting is a white rectangle with blurry black edges (a.k.a the dropshadow).
        //
        // Since the Menu control only takes one QML Item as the background property, we group these 2 under a parent Rectangle which is transparent and is only used for sizing.
        BorderImage {
            id: borderimg
            source: "file:///" + imageLocation + "blurrect.png" //rectangle with Gaussian blur
            anchors { left: parent.left; top: parent.top; leftMargin: -menuShadowMargin; topMargin: -menuShadowMargin }
            width: parent.width + (2 * menuShadowMargin)
            height: parent.height + (2 * menuShadowMargin)
            border { left: 7; top: 7; right: 7; bottom: 7 }
            opacity: 0.5
            z: 1
        }

        // Rectangle lying on top of BorderImage with transparent border (light border in dark theme)
        Rectangle {
            color: Colors.activity_center.context_menu.background
            border.color: Colors.activity_center.context_menu.menu_border
            anchors.fill: parent
        }
    }
}

