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
// Consumers need to define the following when adding it:
// ** - color
// ** - font
// ** - width, height, anchors
// ** - wrapMode
// ** - embeddedLinkModel
// ** - onLinkActivated, function on mouse click
// ** - callback, function on keyboard EnterKey
//
TextEdit {
    id: root

    property QtObject embeddedLinkModel

    // Turn off underlines in links (we'll underline only on keyboard focus)
    property string anchorStyle : "a { color: \"" + Colors.common.hyperlink +  "\"; text-decoration: none } "
    property string styleSheet : "<style>" + anchorStyle + "</style>"

    text: (embeddedLinkModel.hyperlinkedText !== "") ? (styleSheet + embeddedLinkModel.hyperlinkedText) : ""

    // Called the first time the TextEdit is created.
    // Only once that's done can we call the model
    // to push the values for linkHoverColor and textDocument
    Component.onCompleted: {
        embeddedLinkModel.setDocumentObject(root.textDocument);
        embeddedLinkModel.linkHoverColor = Colors.common.hyperlink_pressed
    }

    readOnly: true
    onLinkActivated: print("EmbeddedLink: onLinkActivated is not defined")

    Accessible.role: (Qt.platform.os === "osx") ? Accessible.Pane : Accessible.StaticText
    Accessible.name: (Qt.platform.os === "osx") ? "" : embeddedLinkModel.accessibleText

    MouseArea {
        // this changes the cursor when the link is hovered.
        // https://bugreports.qt.io/browse/QTBUG-30804
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: root.hoveredLink ?
                         Qt.PointingHandCursor :
                         Qt.ArrowCursor
    }

    // Accessibility tree trick for Mac: text blocks with links in them on Mac need to show up
    // as a Pane with empty Accessible.name + the text itself as the first child + 2nd, 3rd child
    // etc being the links 
    Item {
        anchors.fill: parent
        visible: (Qt.platform.os === "osx")
        Accessible.ignored: !visible || root.Accessible.ignored
        Accessible.role: Accessible.StaticText
        Accessible.name: embeddedLinkModel.accessibleText
    }

    textFormat: Text.RichText

    property int tabIndex : 0

    // This section dynamically creates
    // invisible children inside the Text node,
    // one for each link. See EmbeddedLinkModel.h
    // for details.
    Repeater {
        model: embeddedLinkModel

        delegate: Item {
            z: 100
            id: linkItem
            activeFocusOnTab: true

            x: model.position.x
            y: model.position.y
            width: model.size.width
            height: model.size.height

            property int tabIndex : (index + 1)

            onActiveFocusChanged: {
                root.handleActiveFocusChange(linkItem)
            }

            function linkActivated() {
                root.doCallback(embeddedLinkModel.hyperlinkedText, linkItem.tabIndex);
                event.accepted = true;
            }

            Accessible.ignored: root.Accessible.ignored
            // TODO TFS 896365 (brchua) QAccessible::Link should prioritize pressAction before focus action
            Accessible.role: (Qt.platform.os === "osx") ? Accessible.Button : Accessible.Link
            Accessible.name: model.description
            Accessible.onPressAction: linkActivated()

            Keys.onEnterPressed: linkActivated()
            Keys.onReturnPressed: linkActivated()
            Keys.onSpacePressed: linkActivated()
        }
    }

    function handleActiveFocusChange(linkObject) {
        if (linkObject.activeFocus) {
            root.tabIndex = linkObject.tabIndex;
            embeddedLinkModel.setTabIndex(linkObject.tabIndex);
        } else {
            var anyLinkHasFocus = false;
            for (var i = 0; i < children.length; i++) {
                if (children[i].activeFocus) {
                    anyLinkHasFocus = true;
                    break;
                }
            }

            if (!anyLinkHasFocus) {
                root.tabIndex = 0;
                embeddedLinkModel.setTabIndex(0);
            }
        }
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
}
