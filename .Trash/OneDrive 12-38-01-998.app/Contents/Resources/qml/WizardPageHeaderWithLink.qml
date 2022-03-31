/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.0

// WizardPageHeaderWithLink
//
// Styled title and subtitle for wizard pages
// Consumers need to do the following when adding it:
//    Define the anchors of the object
//    Define the text of the primary header via titleText
//    Define the embeddedLinkModel and onLinkActivated via subtitleText
//    Define the source of image (or set visible to false)

Rectangle {
    id: root
    color: "transparent"
    height: childrenRect.height + titleText.anchors.topMargin + subtitle.anchors.topMargin
    property alias title: titleText
    property alias subtitle: subtitleText
    property alias image: wizardImage
    property string accessibleImageDescription: ""

    Text {
        id: titleText
        font.family: "Segoe UI Semibold"
        font.pixelSize: 26
        color: Colors.common.text
        wrapMode: Text.WordWrap

        horizontalAlignment: Text.Center
        anchors {
            top: parent.top
            topMargin: 30

            left: parent.left
            leftMargin: 35

            right: parent.right
            rightMargin: 35
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: titleText.text
        Accessible.readOnly: true
        Accessible.headingLevel: Accessible.HeadingLevel1
    }

    TextWithLink {
        id: subtitleText

        font.family: "Segoe UI"
        font.pixelSize: 14
        color: Colors.common.text_secondary

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        anchors {
            top: titleText.bottom
            topMargin: 9

            left: parent.left
            leftMargin: 35

            right: parent.right
            rightMargin: 35
        }

        callback: function(text, index) {
            subtitleText.onLinkActivated(text);
        }

        Accessible.ignored: !subtitleText.visible
    }

    Image {
        id: wizardImage
        sourceSize.height: 252
        sourceSize.width: 470

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: subtitleText.bottom

        Accessible.role: Accessible.Graphic
        Accessible.ignored: (root.accessibleImageDescription === "")
        Accessible.description: root.accessibleImageDescription
    }
}
