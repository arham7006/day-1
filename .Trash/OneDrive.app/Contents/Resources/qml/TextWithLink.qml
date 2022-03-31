/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7

// TextWithLink
//
// Uses cpp class EmbeddedLinkModel
//
// Represents a text element that can have embedded links within in.
// Note, screen readers will treat this as a single element.
// Consumers need to define the following when adding it:
// ** - minTabIndex, this should be 0 if you want the text itself to be focusable (before any specific links)
// **                otherwise, this defaults to 1 so the 1st link get 1st focused
// ** - color
// ** - font
// ** - width, height, anchors
// ** - wrapMode
// ** - embeddedLinkModel
// ** - onLinkActivated, function on mouse click
// ** - callback, function on keyboard EnterKey
//
// Note: Accessible.name should be the text stripped of any anchor tags
//

Text {
    id: infoText

    property QtObject embeddedLinkModel
    property int minTabIndex: 1

    text: embeddedLinkModel.theText
    linkColor: Colors.common.hyperlink
    onLinkActivated: print("EmbeddedLink: onLinkActivated is not defined")

    Accessible.role: Accessible.StaticText
    Accessible.name: embeddedLinkModel.accessibleText

    MouseArea {
        // this changes the cursor when the link is hovered.
        // https://bugreports.qt.io/browse/QTBUG-30804
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: infoText.hoveredLink ?
                         Qt.PointingHandCursor :
                         Qt.ArrowCursor
    }

    // consuming code should set callback property to a function to run for keyboard
    property var callback: genericCallback

    function genericCallback() {
        print("EmbeddedLink: no keyboard handler set");
    }

    function doCallback(text, index) {
        if (typeof(callback) === "function") {
            callback(text, index);
        } else {
            print("EmbeddedLink: callback is not a function");
        }
    }

    activeFocusOnTab: (embeddedLinkModel.linkCount >= 1)

    onFocusChanged: {
        embeddedLinkModel.linkHoverColor = Colors.common.hyperlink_pressed
    }

    onActiveFocusChanged: {
        if (activeFocus && (embeddedLinkModel.tabIndex === 0)) {
            // if this EmbeddedLink now has focus, we want to set tab index
            // to the minTabIndex
            //
            // ideally, we would detect if user hit BackTab and we set tab index to linkCount
            // for now, we accept BackTab behavior will give minTabIndex focus
            embeddedLinkModel.tabIndex = minTabIndex;
        }
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Tab) {
            embeddedLinkModel.tabIndex++;
            if (embeddedLinkModel.tabIndex > embeddedLinkModel.linkCount)
            {
                // reset to 0 so that no link is focused when we lose focus
                embeddedLinkModel.tabIndex = 0;

                // do not accept event so that we will yield focus to next element
            }
            else
            {
                event.accepted = true;
            }
        }
        else if(event.key === Qt.Key_Backtab) {
            embeddedLinkModel.tabIndex--;
            if (embeddedLinkModel.tabIndex < minTabIndex)
            {
                // reset to 0 so that no link is focused when we lose focus
                embeddedLinkModel.tabIndex = 0;

                // do not accept event so that we will yield focus to previous element
            }
            else
            {
                event.accepted = true;
            }
        }
        else if ((event.key === Qt.Key_Return) ||
                 (event.key === Qt.Key_Space)  ||
                 (event.key === Qt.Key_Enter)) {
            doCallback(embeddedLinkModel.theText, embeddedLinkModel.tabIndex);
            event.accepted = true;
        }
    }
}
