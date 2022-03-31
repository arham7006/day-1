/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Window 2.2
import QtQml 2.2

// Footer on the bottom of the ActivityCenter.
Rectangle {
    id: footerBar

    property bool isOnlineMode
    property bool isPaused
    property bool isRTL

    color: Colors.activity_center.footer.background

    // If button text needs two lines, the footer height will increase
    height: Math.max(84, Math.min(100, Math.max(openFolderButton.height, centerButton.height, moreButton.height) + 16))

    // Rule - A line above the top of the footer to provide visual separation
    Rectangle {
        anchors.bottom: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: Colors.activity_center.footer.rule
    }

    // All three buttons need to have same height
    // If button text needs two lines, button will use tallest button height
    // Left Button - "Open Folder"
    IconAndTextButton {
        id: openFolderButton
        enabled: isOnlineMode || isPaused
        height: Math.max(openFolderButton.implicitHeight, centerButton.implicitHeight, moreButton.implicitHeight, 68)

        // Anchored to the left side of the footer, with a 20 pixel margin
        anchors.leftMargin: 20
        anchors.left: parent.left

        KeyNavigation.right: centerButton

        Keys.onReturnPressed: openFolderButton.clicked()
        Keys.onEnterPressed:  openFolderButton.clicked()
        Accessible.onPressAction: openFolderButton.clicked()

        onClicked: footerModel.OpenFolder_Clicked()
        imageControl.source: "file:///" + imageLocation + "folderIcon.svg"
        textControl.text: footerModel.buttonText_OpenFolder
    }

    // Center Button - "View Online" or "Go Premium"
    IconAndTextButton {
        // determine if button should be "Go Premium" or "View Online"  (Always "View Online" if disabled)
        property bool hasPremiumUpsell: footerModel.hasPremiumUpsell

        // determine if the in-line DIME upsell purchase experience is enabled
        property bool isDimeEnabled: footerModel.isDimeEnabled

        id: centerButton

        // Anchored between the open folder and more buttons
        anchors.left: openFolderButton.right
        anchors.right: moreButton.left
        height: Math.max(openFolderButton.implicitHeight, centerButton.implicitHeight, moreButton.implicitHeight, 68)

        KeyNavigation.left: openFolderButton
        KeyNavigation.right: moreButton

        Keys.onReturnPressed: centerButton.clicked()
        Keys.onEnterPressed:  centerButton.clicked()
        Accessible.onPressAction: centerButton.clicked()
        enabled: hasPremiumUpsell || isOnlineMode

        onClicked: hasPremiumUpsell ? footerModel.GoPremium_Clicked() : footerModel.ViewOnline_Clicked()
        imageControl.source: "file:///" + imageLocation + (hasPremiumUpsell ? "premiumIcon.svg" : "globeIcon.svg")
        textControl.text: hasPremiumUpsell ? footerModel.buttonText_GoPremium : footerModel.buttonText_ViewOnline

        // Ensure that the vanilla 'Go Premium' button and the 'View Online' button have an additional accessibility
        // description to let the user know that interacting with the button will open a link in a new browser tab.
        // Otherwise, assume that the button action launches the in-line DIME premium upsell purchase flow, which takes
        // place entirely within the OneDrive native app and does not need this accessibility description.
        Accessible.description: (!hasPremiumUpsell || (hasPremiumUpsell && !isDimeEnabled)) ? footerModel.accessibleDescription_LinkButton : ""
    }

    // Right Button - "More"
    //  Opens the context Menu with more options such as "Pause", "Settings", "Quit OneDrive", etc
    IconAndTextButton {
        id: moreButton

        // Anchored to the right side of the footer, with a 20 pixel margin
        anchors.right: parent.right
        anchors.rightMargin: 20
        height: Math.max(openFolderButton.implicitHeight, centerButton.implicitHeight, moreButton.implicitHeight, 68)

        KeyNavigation.left: centerButton

        onClicked: moreButtonClicked(false)
        Keys.onReturnPressed: moreButtonClicked(true)
        Keys.onEnterPressed: moreButtonClicked(true)
        Accessible.onPressAction:  moreButtonClicked(true)

        // Note: Keys.onSpacePressed is not set here as it will cause two space events to be produced.
        //  Look in QML's BasicButton::Keys.onReleased to see the event duplication that causes this (BasicButton is the parent of Button)
        //  So we omit defining the action of space here, since the onReleased event of space will call the onClicked action.
        Keys.onReleased: {
            if (event.key === Qt.Key_Space) {
                moreButtonClicked(true)

                // set event to accepted so that we don't get a duplicated event
                event.accepted = true;
            }
        }

        imageControl.source: "file:///" + imageLocation + "settingsIcon.svg"
        imageControl.rotation: 90
        textControl.text: footerModel.buttonText_More
    }

    // The Context Menu with more options such as "Pause", "Settings", "Quit OneDrive", etc
    //  It can be opened by either right clicking on the systray cloud, or by clicking the "More" button in Activity Center
    ActivityCenterContextMenu {
        id: contextMenu
        instantiator.model: menuItemsModel
        isRTL: parent.isRTL

        // Set focus to footer when context menu closed
        onClosed: {
            moreButton.forceActiveFocus();
        }
    }

    // Close the context menu when AC is closed and show it when the taskbar icon is right-clicked
    Window.onVisibilityChanged: {
        if (Window.visibility === Window.Hidden) {
            contextMenu.close();
        }
    }

    function showContextMenu() {
        contextMenu.showMenu(false, footerBar);
    }

    function moreButtonClicked(isKeyboard) {
        footerModel.More_Clicked();
        contextMenu.showMenu(isKeyboard, footerBar);
    }
}
