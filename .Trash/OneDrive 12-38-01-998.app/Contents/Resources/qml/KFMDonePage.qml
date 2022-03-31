/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"

    onVisibleChanged: { if (visible) viewActivityCenterButton.forceActiveFocus(); }

    property string fullImageLocation: "file:///" + imageLocation

    // On this dialog the info area is the item that will absorb the difference between longer and
    // shorter text items that come up during localization. It will get a scroll bar when needed
    property int availableSpaceForInfoArea: root.height -
                                            header.height -                   // the header's padding is built in to it's height
                                            footerSection.height - 32 -       // 32 is the footer section padding
                                            16;                               // 16 is the padding that we want on the bottom of the infoArea

    function openMobileUpsellPage() {
        Qt.openUrlExternally("https://aka.ms/Vu1ncw");
    }

    function chooseLinkTextColor(mouseArea) {
        var color = Colors.common.hyperlink;

        if (mouseArea.containsPress) {
            color = Colors.common.hyperlink_pressed;
        }
        else if (mouseArea.containsMouse) {
            color = Colors.common.hyperlink_hovering;
        }

        return color;
    }

    WizardPageHeader {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        title.text: _("MoveWindowTitleDone")
        subtitle.text: _("MoveWindowSecondaryTextDone")
        image.source: (Qt.platform.os === "osx") ? fullImageLocation + "fre_done.svg" : fullImageLocation + "done_graphic.svg"

        // we don't need to set the width because the fill mode will scale the width after we set the height
        image.height: infoArea.visible ? 214 : 248
        image.anchors.topMargin: 18
        image.fillMode: Image.PreserveAspectFit

        property bool wasAnnounced : false
        function announceOnce() {
            if (!header.wasAnnounced) {
                header.wasAnnounced = true;
                wizardWindow.announceTextChange(header.title, _("MoveWindowTitleDone"), Accessible.AnnouncementProcessing_ImportantAll);
            }
        }

        onVisibleChanged: {
            if (visible) {
                header.announceOnce();
            }
        }
    }

    Rectangle {
        id: infoArea
        objectName: "infoArea"
        color: Colors.common.background
        border.color: scrollView.focus && scrollView.isScrollable ? Colors.move_window.scrollViewBorderColor : Colors.common.background
        height: Math.min(availableSpaceForInfoArea, infoAreaText.height)

        anchors {
            top: header.bottom
            topMargin: 16

            right: parent.right
            rightMargin: 24

            left: parent.left
            leftMargin: 24

            bottom: footerSection.top
            bottomMargin: 16
        }

        // Set the visibility to false if no text to show.
        // Otherwise, if there is no text but visible is "true" this item
        // is included in TAB navigation, which we don't want when there's no text
        visible: (pageModel.infoAreaText.hyperlinkedText !== "")

        ScrollViewWithAcc {
            id: scrollView
            objectName: "infoAreaScrollView"
            property bool isScrollable: (infoAreaText.height > scrollView.height)

            // Do not announce the ScrollView itself (or its scrollbars)
            // in Accessibility. The underlying text will be short enough
            // that it won't need scrolling while narrating.
            Accessible.ignored: true

            anchors {
                fill: parent
            }
            clip: true

            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            Keys.onLeftPressed: nil
            Keys.onRightPressed: nil

            activeFocusOnTab: (infoAreaText.height > scrollView.height)

            TextWithLink {
                id: infoAreaText
                objectName: "infoAreaText"
                embeddedLinkModel: pageModel.infoAreaText

                font.family: "Segoe UI"
                font.pixelSize: 14
                width: scrollView.width - 6 // scroll view width - width of scroll bar
                wrapMode: Text.WordWrap

                color: Colors.common.text_secondary

                Accessible.ignored: !visible
                Accessible.readOnly: true
                Accessible.focusable: true

                onLinkActivated: {
                    pageModel.handleClientAction(link);
                }

                callback: function(text, index) {
                    pageModel.onEmbeddedLinkActivated(text, index);
                }
            }
        }
    }

    Column {
        id: footerSection

        spacing: 20

        anchors {
            right: parent.right
            left: parent.left

            bottom: parent.bottom
            bottomMargin: 30
        }

        FabricButton {
            id: viewActivityCenterButton
            visible: true
            focus: true
            onClicked: pageModel.onViewSyncProgress()
            buttonText: _("MoveWindowFinishedButtonText")

            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            Accessible.onPressAction: onClicked()
            Keys.onEnterPressed: onClicked()
            Keys.onReturnPressed: onClicked()
            Keys.onSpacePressed: onClicked()
        }

        SimpleButtonLink {
            id: getAppTextLink

            visible: !infoArea.visible

            width: textcontrol.paintedWidth
            height: textcontrol.paintedHeight

            textcontrol.text: _("MoveWindowGetMobileApp")
            textcontrol.font.family: "Segoe UI"
            textcontrol.font.pixelSize: 12
            textcontrol.color: chooseLinkTextColor(mousearea)
            textcontrol.linkColor: chooseLinkTextColor(mousearea)

            anchors {
                horizontalCenter: viewActivityCenterButton.horizontalCenter
            }

            callback: function() {
                openMobileUpsellPage()
            }
        }
    }
}
