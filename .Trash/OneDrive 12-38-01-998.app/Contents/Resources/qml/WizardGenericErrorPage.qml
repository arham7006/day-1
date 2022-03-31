/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: root
    anchors.fill: parent

    color: "transparent"

    onVisibleChanged: {
        if (visible) {
            primaryBtn.forceActiveFocus();

            wizardWindow.announceTextChange(heading, heading.text, Accessible.AnnouncementProcessing_ImportantAll);
        }
    }

    Text {
        id: heading
        text: pageModel.primaryText
        font.family: "Segoe UI Semibold"
        font.pixelSize: 26
        color: Colors.common.text

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        anchors {
            top: parent.top
            topMargin: 30

            left: parent.left
            leftMargin: 35

            right: parent.right
            rightMargin: 35
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: heading.text
        Accessible.readOnly: true
        Accessible.headingLevel: Accessible.HeadingLevel1
    }

    TextWithLink {
        id: secondaryText
        embeddedLinkModel: pageModel.secondaryText
        font.family: "Segoe UI"
        font.pixelSize: 14
        color: Colors.common.text_secondary

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        anchors {
            top: heading.bottom
            topMargin: 9

            left: parent.left
            leftMargin: 35

            right: parent.right
            rightMargin: 35
        }

        onLinkActivated: pageModel.onLinkClicked()
        callback: pageModel.onLinkClicked()
    }

    Rectangle {
        id: tertiaryTextArea
        color: Colors.common.background
        border.color: scrollView.focus && scrollView.isScrollable ? Colors.move_window.scrollViewBorderColor : Colors.common.background

        anchors {
            top: secondaryText.bottom
            topMargin: 20

            bottom: primaryBtn.top
            bottomMargin: 150

            right: parent.right
            rightMargin: 61

            left: parent.left
            leftMargin: 61
        }

        // Set the visibility to false if no text to show.
        // Otherwise, if there is no text but visible is "true" this item
        // is included in TAB navigation, which we don't want when there's no text
        visible: (pageModel.tertiaryText !== "")

        ScrollViewWithAcc {
            id: scrollView
            property bool isScrollable: (tertiaryText.height > scrollView.height)

            // Do not announce the ScrollView itself (or its scrollbars)
            // in Accessibility. The underlying text will be short enough
            // that it won't need scrolling while narrating.
            Accessible.ignored: true

            anchors.fill: parent

            clip: true

            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            contentWidth: tertiaryText.width

            Keys.onLeftPressed: nil
            Keys.onRightPressed: nil

            activeFocusOnTab: (tertiaryText.height > scrollView.height)

            Text {
                id: tertiaryText
                text: pageModel.tertiaryText
                font.family: "Consolas"
                font.pixelSize: 14
                color: Colors.common.text_secondary
                visible: (tertiaryText.text.length > 0)

                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap

                width: scrollView.contentAllowedWidth

                Accessible.role: Accessible.StaticText
                Accessible.name: tertiaryText.text
                Accessible.readOnly: true
                Accessible.ignored: !tertiaryText.visible
            }
        }
    }

    FabricButton {
        id: primaryBtn
        visible: !pageModel.shouldHideEmailInput
        width: contentItem.paintedWidth + 40
        height: contentItem.paintedHeight + 12

        buttonText: pageModel.buttonText

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30

        Accessible.role: Accessible.Button
        Accessible.name: primaryBtn.buttonText
        Accessible.ignored: !primaryBtn.visible
        Accessible.onPressAction: primaryBtn.clicked()
        Keys.onReturnPressed: primaryBtn.clicked()
        Keys.onEnterPressed:  primaryBtn.clicked()

        onClicked: pageModel.onPrimaryButtonClicked()
    }
}
