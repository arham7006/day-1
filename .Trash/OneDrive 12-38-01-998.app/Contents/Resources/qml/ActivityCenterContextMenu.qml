/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import QtQuick 2.7
import QtQml 2.2

// The primary context menu for Activity Center.
// This is shown when right clicking on the OneDrive icon in taskbar, or when clicking on the "more" button within Activity Center.
CustomMenu {
    id: root

    property bool accessedByKeyboard: false
    property bool isRTL
    property int itemCount: 0 // for tracking number of items when submenus are expanded/collapsed
    property alias instantiator: menuInstatiator

    Instantiator {
        id: menuInstatiator
        delegate: newMenuItem

        // When an item is added/removed, resize the menu and ensure it's position is correct
        // Note: an item is added/removed when a sub-menu is expanded/collapsed, not just on initialization
        onObjectAdded: {
            root.insertItem(index, object);
            root.itemCount++;
            root.resize();
            root.reposition();
        }
        onObjectRemoved: {
            root.removeItem(index, object);
            root.itemCount--;
            root.resize();
            root.reposition();
        }
    }

    // Displays or "Shows" the menu and resizes it according to contained items
    function showMenu(isKeyboard, anchoredItem) {
        root.parent = anchoredItem;

        menuItemsModel.RefreshMenu();
        root.visible = !root.visible;

        root.resize();
        root.reposition();

        root.accessedByKeyboard = isKeyboard;
        if (isKeyboard) {
            for (var index = 0 ; index < root.itemCount; index++) {
                if (root.itemAt(index).enabled) break;
            }

            if (index < root.itemCount) {
                root.itemAt(index).forceActiveFocus();
            } else {
                // Fallback just focus the menu - can only happen if
                // all items are disabled - not expected in practice
                root.forceActiveFocus();
            }
        }
    }

    // Helper function to resize the menu after it has been populated with items
    function resize() {
        var maxWidth = 0;
        var height = 0;
        for (var index = 0; index < itemCount; index++) {
            var padding = root.itemAt(index).isSubMenu ? 20 : 0;
            var totalWidth = root.itemAt(index).menuItemWidth
                           + root.itemAt(index).menuItemMargin * 2 + padding;
            maxWidth = Math.max(maxWidth, totalWidth);
            height += root.itemAt(index).menuItemHeight;
        }
        root.menuWidth = maxWidth;
        root.menuHeight = height;
    }

    // Helper function to calculate and set position of the menu
    // Calculates the upper left of the menu (x,y) such that the bottom right corner (bottom left corner in RTL) of this menu
    // is at the upper right (upper left in RTL) corner of the parent item set in showMenu().
    function reposition() {
        root.x = root.isRTL ? 0 : parent.width - root.width;
        root.y = -root.menuHeight;
    }

    // Component for creating new items in the menu
    Component {
        id: newMenuItem
        CustomMenuItem {
            id: theItem

            property bool isSubMenu: model.isSubMenu

            textcontrol.text: root.accessedByKeyboard ? model.keyboardName : model.name
            textcontrol.font.family: "Segoe UI"

            shortcut.sequence: model.shortcut

            // don't use keyboardName as accessible text - otherwise Narrator announces <u> tags
            text: model.accessibleName

            enabled: !model.isDisabled

            Image {
                id:chevronButton
                height: 32
                width: 24
                source: model.isExpanded ? "file:///" + imageLocation + "chevronUp.svg" : "file:///" + imageLocation + "chevron.svg"
                visible: isSubMenu
                anchors.right: parent.right
                anchors.rightMargin: 5
            }

            Accessible.expandable: isSubMenu
            Accessible.expanded: model.isExpanded

            // used in QML code
            // QML looks to see if the Control has an accessible[ActionName]Action function defined
            function accessibleExpandAction() {
                menuItemsModel.expandSubMenu(model.index);
            }

            function accessibleCollapseAction() {
                menuItemsModel.collapseSubMenu();
            }

            hasSeparator: model.isSeparator
            callback: function(isShortcut)
            {
                if (!model.isDisabled)
                {
                    if (isSubMenu)
                    {
                        if (isShortcut && (model.cmdId !== 0))
                        {
                            // if the submenu header has a cmdId, invoke that command instead of showing submenu
                            menuItemsModel.invokeMenuCommand(model.cmdId);
                            root.close();
                        }
                        else if (model.isExpanded)
                        {
                            menuItemsModel.collapseSubMenu();
                        }
                        else
                        {
                            // In case we have two submenu options, collapse the other one first
                            menuItemsModel.collapseSubMenu();
                            menuItemsModel.expandSubMenu(model.index);

                            // force focus to first index of submenu
                            for (var index = model.index + 1 ; index < root.itemCount; index++) {
                                if (root.itemAt(index).enabled) break;
                            }

                            if (index < root.itemCount) {
                                root.itemAt(index).forceActiveFocus();
                            } else {
                                // Fallback just focus the menu - can only happen if
                                // all items are disabled - not expected in practice
                                root.forceActiveFocus();
                            }
                        }
                    }
                    else
                    {
                        menuItemsModel.invokeMenuCommand(model.cmdId);
                        root.close();
                    }
                }
            }
        }
    }
}

