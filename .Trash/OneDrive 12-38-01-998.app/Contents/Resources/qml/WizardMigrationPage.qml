/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

import MigrationPageViewModel 1.0

Rectangle {
    id: root
    objectName: "migrationPageRoot"

    anchors.fill: parent

    color: "transparent"

    onVisibleChanged: { if (visible) nextButton.forceActiveFocus(); }

    property bool atLeastOneFolderInError: (pageModel.desktopItem.folderItemState === "error") ||
                                           (pageModel.documentsItem.folderItemState === "error") ||
                                           (pageModel.picturesItem.folderItemState === "error")

    // On this dialog the info area is the item that will absorb the difference between longer and
    // shorter text items that come up during localization. It will get a scroll bar when needed
    property int availableSpaceForInfoArea: root.height -
                                            headerSection.height -            // the header's padding is built in to it's height
                                            folderSelectionArea.height - 32 - // 32 is the folder selection area anchors
                                            remainingSpace.height - 32 -      // 32 is the remaininSpace section padding
                                            footerSection.height - 32 -       // 32 is the footer section padding
                                            16;                               // 16 is the padding that we want on the bottom of the infoArea
    function atLeastOneFolderHasProgressValue() {
        return (pageModel.desktopItem.hasDeterminateProgress ||
                pageModel.documentsItem.hasDeterminateProgress ||
                pageModel.picturesItem.hasDeterminateProgress);
    }

    function onDialogClosed() {
        nextButton.forceActiveFocus();
    }

    state: pageModel.dialogState
    states: [
        State {
            name: "scanning"
            PropertyChanges { target: remainingSpace; visible: false; }
            PropertyChanges { target: infoAreaGraphic; visible: true }
        },
        State {
            name: "userInput"
            PropertyChanges { target: infoAreaText; color: pageModel.isSevereError ? Colors.move_window.cancelledSecondaryText : Colors.common.text_secondary }
            PropertyChanges { target: infoAreaGraphic; visible: false }
            PropertyChanges { target: infoAreaErrorIcon; visible: (pageModel.infoAreaText.hyperlinkedText !== "") }
            PropertyChanges { target: rotationAnimation; from: 0 }
            PropertyChanges { target: rotationAnimation; running: false }
            StateChangeScript {
                name: "onSwitchToUserInputState"
                script: {
                    heading.announceOnce();
                }
            }
        },
        State {
            name: "userInputDialog"
            PropertyChanges { target: infoAreaGraphic; visible: false }
            PropertyChanges { target: rotationAnimation; from: 0 }
            PropertyChanges { target: rotationAnimation; running: false }
        },
        State {
            name: "migrating"
            PropertyChanges { target: infoAreaGraphic; visible: false; }
        },
        State {
            name: "blocked"
            PropertyChanges { target: infoAreaText; color: Colors.move_window.cancelledSecondaryText }
            PropertyChanges { target: infoAreaErrorIcon; visible: true }
            PropertyChanges { target: tryAgainButton; visible: false; }
            PropertyChanges { target: infoAreaGraphic; visible: false }
            PropertyChanges { target: rotationAnimation; from: 0 }
            PropertyChanges { target: rotationAnimation; running: false }
        }
    ]

    Item {
        id: headerSection
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: childrenRect.height + 24

        Text {
            id: heading
            text: pageModel.title
            font.family: "Segoe UI Semibold"
            font.pixelSize: 26
            color: Colors.common.text

            horizontalAlignment: Text.Center
            wrapMode: Text.WordWrap
            anchors {
                top: parent.top
                topMargin: 30

                left: parent.left
                leftMargin: 24

                right: parent.right
                rightMargin: 24
            }

            Accessible.role: Accessible.StaticText
            Accessible.name: heading.text
            Accessible.readOnly: true
            Accessible.headingLevel: Accessible.HeadingLevel1
            Accessible.ignored: shouldIgnoreAccessible

            property bool wasAnnounced : false
            function announceOnce() {
                if (!heading.wasAnnounced) {
                    heading.wasAnnounced = true;
                    wizardWindow.announceTextChange(heading, pageModel.title, Accessible.AnnouncementProcessing_ImportantAll);
                }
            }
        }

        TextWithLink {
            id: secondaryText
            embeddedLinkModel: pageModel.secondaryText
            font.family: "Segoe UI"
            font.pixelSize: 14
            color: Colors.common.text_secondary
            Accessible.ignored: shouldIgnoreAccessible

            horizontalAlignment: Text.Center
            wrapMode: Text.WordWrap
            anchors {
                top: heading.bottom
                topMargin: 9

                left: parent.left
                leftMargin: 24

                right: parent.right
                rightMargin: 24
            }

            onLinkActivated: Qt.openUrlExternally(link)

            callback: function(text, index) {
                pageModel.onEmbeddedLinkActivated(text, index);
            }
        }
    }

    Rectangle {
        id: folderSelectionArea
        height: folderSelectionRow.height
        color: "transparent"

        anchors {
            left: parent.left
            leftMargin: 24

            right: parent.right
            rightMargin: 24

            top: headerSection.bottom
            topMargin: 28
        }

        Row {
            id: folderSelectionRow
            Accessible.ignored: true
            spacing: 4

            KnownFolderItem {
                id: desktopFolder
                isRTL: wizardWindow.isRTL
                isAccessibleIgnored: !parent.visible || shouldIgnoreAccessible
                folderType: MigrationPageViewModel.Desktop
                folderModel: pageModel.desktopItem
                imageSource: Qt.platform.os === "osx" ? fullImageLocation + "folder_image_desktop_mac.svg" : fullImageLocation + "folder_image_desktop.svg"
                enableUserInput: pageModel.dialogState === "userInput"
                showSizeWhileInProgress: root.atLeastOneFolderHasProgressValue()
            }

            KnownFolderItem {
                id: documentsFolder
                isRTL: wizardWindow.isRTL
                isAccessibleIgnored: !parent.visible || shouldIgnoreAccessible
                folderType: MigrationPageViewModel.Documents
                folderModel: pageModel.documentsItem
                imageSource: Qt.platform.os === "osx" ? fullImageLocation + "folder_image_documents_mac.svg" : fullImageLocation + "folder_image_documents.svg"
                enableUserInput: pageModel.dialogState === "userInput"
                showSizeWhileInProgress: root.atLeastOneFolderHasProgressValue()
            }

            KnownFolderItem {
                id: picturesFolder
                isRTL: wizardWindow.isRTL
                isAccessibleIgnored: !parent.visible || shouldIgnoreAccessible
                folderType: MigrationPageViewModel.Pictures
                folderModel: pageModel.picturesItem
                imageSource: Qt.platform.os === "osx" ? fullImageLocation + "folder_image_pictures_mac.svg" : fullImageLocation + "folder_image_pictures.svg"
                enableUserInput: pageModel.dialogState === "userInput"
                showSizeWhileInProgress: root.atLeastOneFolderHasProgressValue()
            }
        }
    }

    Text {
        id: remainingSpace
        visible: (remainingSpace.text !== "")

        font.family: "Segoe UI"
        font.pixelSize: 12
        wrapMode: Text.WordWrap
        // if the remaining space is negative (i.e. by moving a selected folder the user will
        // go over quota) then we want to display the text in red.
        color: pageModel.isInsufficientSpace ? Colors.move_window.cancelledSecondaryText : Colors.common.text_secondary
        text: pageModel.remainingSpaceText

        anchors {
            top: folderSelectionArea.bottom
            topMargin: 16
            left: parent.left
            leftMargin: 24
            right: parent.right
            rightMargin: 24
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: pageModel.remainingSpaceText
        Accessible.readOnly: true
        // Ignore when not visible or if text is empty
        Accessible.ignored: !visible || shouldIgnoreAccessible
    }

    Rectangle {
        id: infoArea
        objectName: "infoArea"
        color: "transparent"
        border.color: scrollView.focus && scrollView.isScrollable ? Colors.move_window.scrollViewBorderColor : "transparent"
        height: Math.max(infoAreaGraphic.sourceSize.height, Math.min(availableSpaceForInfoArea, infoAreaText.height))

        anchors {
            top: remainingSpace.text === "" ? folderSelectionArea.bottom : remainingSpace.bottom
            topMargin: 16

            right: parent.right
            rightMargin: 24

            left: parent.left
            leftMargin: 24
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
                left: (infoAreaGraphic.visible || infoAreaErrorIcon.visible) ? infoAreaGraphic.right : infoArea.left
                leftMargin: (infoAreaGraphic.visible || infoAreaErrorIcon.visible) ? 8 : 0
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
            clip: true

            contentWidth: infoAreaText.width

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
                font.pixelSize: 12
                width: scrollView.contentAllowedWidth
                wrapMode: Text.WordWrap

                color: Colors.move_window.title

                Accessible.ignored: !visible || shouldIgnoreAccessible
                Accessible.readOnly: true
                Accessible.focusable: true

                onLinkActivated: {
                    if (link.search("http") === 0) { // we found the http prefix at the begining of the string
                        Qt.openUrlExternally(link);
                   } else { // otherwise we assume this is a sc:// link that requests the client to do something
                       pageModel.handleClientAction(link);
                   }
                }

                callback: function(text, index) {
                    pageModel.onEmbeddedLinkActivated(text, index);
                }

                function announce() {
                    wizardWindow.announceTextChange(this, embeddedLinkModel.accessibleText, Accessible.AnnouncementProcessing_MostRecent);
                }

                onTextChanged: {
                    if (embeddedLinkModel.accessibleText !== "") {
                        heading.announceOnce();

                        if (!wizardWindow.isConfirmDialogUp && heading.wasAnnounced) {
                            this.announce();
                        }
                    }
                }
            }
        }

        Image {
            id: infoAreaErrorIcon
            visible: false
            source: pageModel.isSevereError ?
                        fullImageLocation + "errorIcon.svg" :
                        fullImageLocation + "infoIcon.svg"
            sourceSize.height: 22
            sourceSize.width: 22
            anchors {
                left: infoArea.left
                top: infoArea.top
            }

            Accessible.ignored: true
        }

        Image {
            id: infoAreaGraphic
            source: fullImageLocation + "loading_spinner.svg"
            sourceSize.height: 22
            sourceSize.width: 22
            anchors {
                left: infoArea.left
                top: infoArea.top
            }

            NumberAnimation on rotation {
                id: rotationAnimation;
                easing.type: Easing.InOutQuad
                from: -45;
                to: 315;
                duration: 1500;
                loops: Animation.Infinite
            }
            Accessible.ignored: true
        }
    }

    Rectangle {
        id: footerSection
        color: "transparent"
        height: Math.max(remainingSpace.height, nextButton.height)

        anchors {
            bottom: parent.bottom
            bottomMargin: 32

            left: parent.left
            leftMargin: 24

            right: parent.right
            rightMargin: 24
        }

        FabricButton {
            id: tryAgainButton
            onClicked: pageModel.onTryAgainButtonClicked()
            visible: atLeastOneFolderInError && ((pageModel.dialogState === "userInput") || (pageModel.dialogState === "userInputDialog"))
            enabled: visible
            buttonStyle: "secondary"
            buttonText: _("TryAgainButtonText")

            Accessible.role: Accessible.Button
            Accessible.name: _("TryAgainButtonText")
            Accessible.ignored: !visible || shouldIgnoreAccessible
            Accessible.onPressAction: pageModel.onTryAgainButtonClicked()
            Keys.onReturnPressed: tryAgainButton.clicked()
            Keys.onEnterPressed:  tryAgainButton.clicked()

            anchors {
                verticalCenter: parent.verticalCenter
                right: nextButton.left
                rightMargin: 8
            }
        }

        FabricButton {
            id: nextButton
            onClicked: pageModel.onNextButtonClicked()
            buttonText: pageModel.nextButtonText
            visible: true
            enabled: pageModel.isNextButtonEnabled

            property int previousWidth: 0
            implicitWidth: {
                // If text changes, then we do not want to keep changing width. We only grow button, we won't shrink.
                previousWidth = Math.max(previousWidth, minWidth, (contentItem.paintedWidth + (2 * buttonPadding)));
                return previousWidth;
            }

            Accessible.role: Accessible.Button
            Accessible.name: pageModel.nextButtonText
            Accessible.ignored: !visible || shouldIgnoreAccessible
            Accessible.onPressAction: pageModel.onNextButtonClicked()
            Accessible.disabled: !enabled

            Keys.onReturnPressed: nextButton.clicked()
            Keys.onEnterPressed:  nextButton.clicked()

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 8
            }
        }
    }
}
