/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQml 2.2

import "HelperFunctions.js" as HelperFunctions

// Errors view in the Activity Center, comprised of a back-link banner
// and a list of error items
Rectangle {
    id: errorViewRoot

    // Called when the errors list is closed, handling to be set in ActivityCenter.qml based on desired behavior
    signal onErrorsViewClosed()

    property var messageColors: (errorsModel.isWarningsOnly) ? Colors.errors_list.warning : Colors.errors_list.error

    // Called by the loader so that references are only used once the qml is loaded,
    // Sets the key handler and active focus setter for the provided loader, to expose to ActivityCenter.qml
    // errorsViewRect = Loader with "property var keyHandler" and "signal setFocusOnChanged"
    function setHandlers(errorsViewRect) 
    {
        errorsViewRect.keyHandler = errorsList;

        errorsViewRect.setFocusOnViewChanged.connect( function() {
            // Sets focus on the header banner so Narrator reads out a value when changing views
            // And so that other list views don't hold on to arrow presses
            errorListHeaderMouseArea.forceActiveFocus(); });
    }

    color: "transparent" // Allow base color to show through

    // Header for errors, hosts a [<] back link and text with the number of errors
    Rectangle {
        id: errorHeader
        anchors.top: parent.top
        height: 44
        anchors.left: parent.left
        anchors.right: parent.right
        
        color: (errorListHeaderMouseArea.containsMouse || errorListHeaderMouseArea.activeFocus) ?
            messageColors.background_hover :
            messageColors.background

        border.color: errorListHeaderMouseArea.activeFocus ? Colors.activity_center.error.border_alert_focus : "transparent"
        border.width: 1

        Text {
            anchors.fill: parent
            text: errorsModel.errorCountText
            
            color: errorListHeaderMouseArea.containsMouse ?
                messageColors.text_hover :
                messageColors.text

            font.family: "Segoe UI Semibold"
            font.pixelSize: 14
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Image {
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            height: 32
            width: 32
            sourceSize.width:  32
            sourceSize.height: 32
            source: headerModel.isRTL ?
                "file:///" + imageLocation + "forwardArrow.svg" : // RTL should use the forward arrow
                "file:///" + imageLocation + "backArrow.svg"  // LTR should use back arrow
        }

        MouseArea {
            id: errorListHeaderMouseArea
            anchors.fill: parent
            hoverEnabled: true

            function closeErrorsView() {
                errorsModel.SetErrorViewOpened(false);
                onErrorsViewClosed();
            }

            activeFocusOnTab: true
            Accessible.focusable: true
            Accessible.onPressAction: closeErrorsView()
            Accessible.name: errorsModel.errorExitBannerAccessibleText
            Accessible.ignored: !visible
            Accessible.role: Accessible.Button

            Keys.onReturnPressed: closeErrorsView();
            Keys.onSpacePressed: closeErrorsView();
            onClicked: closeErrorsView()
        }
    }

    ListView {
        id: errorsList
        objectName: "errorsList"

        anchors.top: errorHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        // Remove the model when hidden to prevent perf hit - data being loaded for all items on close
        model: isErrorViewCurrentlyVisible ? errorsModel : undefined
        delegate: ErrorsListItem { }
        clip: true
        activeFocusOnTab: true

        ScrollBar.vertical: ScrollBar {
            active: true
            onActiveChanged: { active = true; /* Keeps scrollbar visible always */}
            Accessible.ignored: ((errorsList.count == 0) || !parent.visible)
        }

        Accessible.role: Accessible.List
        Accessible.focusable: true
        Accessible.ignored: ((errorsList.count == 0) || !visible)
        Accessible.name: errorsModel.errorListAccessibleText

        highlightFollowsCurrentItem: true

        function updateIndexAndScrollToItem(theIndex) {
            var newIndex = Math.max(theIndex, 0);
            newIndex = Math.min(newIndex, (errorsList.count - 1));

            errorsList.currentIndex = newIndex;
            errorsList.positionViewAtIndex(newIndex, ListView.Visible);
        }

        Keys.onPressed: {
            if (errorsList.count > 0) {
                var newIndex = -1;
                var itemHeight = 68; // Min item height
                var pageIncrement = errorsList.height / itemHeight; // How many items to scroll
                if (event.key === Qt.Key_End) {
                    newIndex = errorsList.count - 1;
                    updateIndexAndScrollToItem(newIndex);
                }
                else if (event.key === Qt.Key_Home) {
                    newIndex = 0;
                    updateIndexAndScrollToItem(newIndex);
                }
                else if (event.key === Qt.Key_PageUp) {
                    newIndex = errorsList.currentIndex - pageIncrement;
                    updateIndexAndScrollToItem(newIndex);
                }
                else if (event.key === Qt.Key_PageDown) {
                    newIndex = errorsList.currentIndex + pageIncrement;
                    updateIndexAndScrollToItem(newIndex);
                }
            }
        }
    }

}
