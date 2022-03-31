/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4
import ViewModel 1.0

import "fabricMdl2.js" as FabricMDL

Rectangle {
    id: root

    color: Colors.common.background
    opacity: (confirmRestoreDialog.visible || interruptDialog.visible) ? 0.6 : 1.0

    // On this dialog the info area is the item that will absorb the difference between longer and
    // shorter text items that come up during localization. It will get a scroll bar when needed
    property int availableSpaceForInfoArea: root.height -
                                            headerSection.height -            // the header's padding is built in to it's height
                                            folderSelectionArea.height - 32 - // 32 is the folder selection area anchors
                                            footerSection.height - 32 -       // 32 is the footer section padding
                                            16;                               // 16 is the padding that we want on the bottom of the infoArea
    property string fullImageLocation: "file:///" + imageLocation
    property bool atLeastOneFolderInError: viewModel.documentsFolderItemState === "error" ||
                                           viewModel.picturesFolderItemState === "error" ||
                                           viewModel.desktopFolderItemState === "error"
    property bool nextDisabledByQuota: viewModel.nextDisabledByQuota
    property bool showDonePageInfoText: (areAnyFoldersSkipped || !viewModel.allFoldersMigrated)
    property bool areAnyFoldersSkipped: (viewModel.desktopSkipped ||
                                         viewModel.picturesSkipped ||
                                         viewModel.documentsSkipped)
    property bool isConfirmDialogUp: (confirmRestoreDialog.visible || interruptDialog.visible)

    function atLeastOneFolderHasProgressValue() {
        return (viewModel.hasDesktopProgressValue ||
                viewModel.hasDocumentsProgressValue ||
                viewModel.hasPicturesProgressValue);
    }

    LayoutMirroring.enabled: viewModel.isRTL
    LayoutMirroring.childrenInherit: true

    Accessible.role: Accessible.Pane
    Accessible.focusable: true
    Accessible.focused: false
    Accessible.name: "Microsoft OneDrive"
    Accessible.ignored: true

    width: 591
    height: 528

    state: viewModel.dialogState

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

    states: [
        State {
            name: "scanning"
            PropertyChanges { target: remainingSpace; visible: false; }
            PropertyChanges { target: infoAreaGraphic; visible: true }
        },
        State {
            name: "userInput"
            PropertyChanges { target: infoAreaText; color: (viewModel.errorSeverity === ViewModel.RedError) ? Colors.move_window.cancelledSecondaryText : Colors.common.text_secondary }
            PropertyChanges { target: infoAreaGraphic; visible: false }
            PropertyChanges { target: infoAreaErrorIcon; visible: (viewModel.infoAreaText !== "") }
            PropertyChanges { target: rotationAnimation; from: 0 }
            PropertyChanges { target: rotationAnimation; running: false }
        },
        State {
            name: "userInputDialog"
            PropertyChanges { target: infoAreaGraphic; visible: false }
            PropertyChanges { target: rotationAnimation; from: 0 }
            PropertyChanges { target: rotationAnimation; running: false }
            StateChangeScript {
                name: "onSwitchToUserInputDialogState"
                script: {
                    interruptDialog.open();
                }
            }
        },
        State {
            name: "migrating"
            PropertyChanges { target: infoAreaGraphic; visible: false; }
            StateChangeScript {
                name: "onSwitchToMigratingState"
                script: {
                    infoAreaText.forceActiveFocus();
                }
            }
        },
        State {
            name: "finished"
            PropertyChanges { target: folderSelectionRow; visible: false; Accessible.ignored: true; }
            PropertyChanges { target: folderSelectionArea; height: finishedImage.height; }
            PropertyChanges { target: finishedImage; visible: true; }
            PropertyChanges { target: infoAreaGraphic; visible: false; }
            PropertyChanges { target: infoAreaText; color: (viewModel.errorSeverity === ViewModel.RedError) ? Colors.move_window.cancelledSecondaryText : Colors.common.text_secondary }
            PropertyChanges { target: viewActivityCenterButton; visible: true; }
            PropertyChanges { target: getAppTextLink; visible: !showDonePageInfoText; }
            PropertyChanges { target: footerSection; visible: false; }
            PropertyChanges { target: scrollView; Accessible.ignored: true; }
            PropertyChanges { target: infoAreaText; Accessible.ignored: true; }
            StateChangeScript {
                name: "onSwitchedToFinishedState"
                script: {
                    title.forceActiveFocus();
                }
            }
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

    ConfirmDialog {
        id: interruptDialog
        isRTL: viewModel.isRTL

        // we break Windows paradigm here since we want the default button to be on the right for Wizards
        defaultButtonOnLeft: false

        dialogTitleText: viewModel.interruptDialogTitle
        dialogBodyText: viewModel.interruptDialogBody

        button1Text: viewModel.interruptDialogPrimaryButtonText
        button2Text: viewModel.interruptDialogSecondaryButtonText
        xButtonAltText: viewModel.xButtonAccessibleName

        modal: true

        onButton2Clicked: reject()
        onDismissed: reject()

        onRejected: {
            // Skip
            viewModel.handleInterruptDialogResult(0);
        }

        onButton1Clicked: {
            // Try again
            viewModel.handleInterruptDialogResult(1);
        }

        closePolicy: Popup.CloseOnEscape
    }

    ConfirmDialog {
        id: confirmRestoreDialog
        isRTL: viewModel.isRTL

        // we break Windows paradigm here since we want the default 'Cancel' button to be on the right
        defaultButtonOnLeft: false

        dialogTitleText: viewModel.confirmDialogTitle

        button1Text: viewModel.confirmDialogPrimaryButtonText
        button2Text: viewModel.confirmDialogSecondaryButtonText
        xButtonAltText: viewModel.xButtonAccessibleName

        modal: true

        onButton2Clicked: {
            viewModel.onActionLinkActivated(confirmRestoreDialog.folderType);
        }

        onClosed: {
            // Restore focus to the folder that
            // started the action
            if (folderType === ViewModel.Desktop) {
                desktopFolder.forceActiveFocus();
            } else if (folderType === ViewModel.Documents) {
                documentsFolder.forceActiveFocus();
            } else if (folderType === ViewModel.Pictures) {
                picturesFolder.forceActiveFocus();
            }
        }

        contentItem: Rectangle {
            id: confirmRestoreDialogContent

            LayoutMirroring.enabled: viewModel.isRTL
            LayoutMirroring.childrenInherit: true
            color: "transparent"

            Grid {
                id: bulletPointsGrid

                columns: 2
                spacing: 8

                property int margin : 20
                property int bulletTextWidth : confirmRestoreDialogContent.width - bulletIcon1.paintedWidth - (margin * 2)
                property string sampleText: "sampleText"

                anchors {
                    left: parent.left
                    leftMargin: margin
                    right: parent.right
                    rightMargin: margin
                }

                Text {
                    id: bulletIcon1
                    horizontalAlignment: Text.AlignHCenter
                    text: "•"
                    color: Colors.move_window.folderItemPrimaryText

                    font.family: "Segoe UI"
                    font.weight: Font.Light
                    font.pixelSize: 12
                }

                Rectangle {
                    width: bulletPointsGrid.bulletTextWidth
                    height: bulletPoint1.paintedHeight
                    color: "transparent"
                    Text {
                        id: bulletPoint1

                        anchors.left: parent.left
                        anchors.right: parent.right

                        text: viewModel.loadConfirmDialogBodyItem(confirmRestoreDialog.folderType, 0);
                        horizontalAlignment: Text.AlignLeft

                        font.family: "Segoe UI"
                        font.weight: Font.Light
                        wrapMode: Text.WordWrap
                        color: Colors.move_window.folderItemPrimaryText
                        font.pixelSize: 12

                        Accessible.role: Accessible.StaticText
                        Accessible.name: text
                        Accessible.readOnly: true
                    }
                }

                Text {
                    id: bulletIcon2
                    horizontalAlignment: Text.AlignHCenter
                    text: "•"
                    color: Colors.move_window.folderItemPrimaryText

                    font.family: "Segoe UI"
                    font.weight: Font.Light
                    font.pixelSize: 12
                }

                Rectangle {
                    width: bulletPointsGrid.bulletTextWidth
                    height: bulletPoint2.paintedHeight
                    color: "transparent"
                    Text {
                        id: bulletPoint2

                        anchors.left: parent.left
                        anchors.right: parent.right

                        text: viewModel.loadConfirmDialogBodyItem(confirmRestoreDialog.folderType, 1);
                        horizontalAlignment: Text.AlignLeft

                        font.family: "Segoe UI"
                        font.weight: Font.Light
                        wrapMode: Text.WordWrap
                        color: Colors.move_window.folderItemPrimaryText
                        font.pixelSize: 12

                        Accessible.role: Accessible.StaticText
                        Accessible.name: text
                        Accessible.readOnly: true
                    }
                }
            }
        }
    }

    Rectangle {
        id: headerSection
        color: Colors.common.background

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: childrenRect.height + 24

        Text {
            id: title
            font.family: "Segoe UI"
            wrapMode: Text.WordWrap
            text: viewModel.title
            color: Colors.move_window.title
            font.pixelSize: 28
            font.weight: Font.Light
            horizontalAlignment: Text.AlignHCenter

            Accessible.role: Accessible.StaticText
            Accessible.name: viewModel.title
            Accessible.readOnly: true
            Accessible.ignored: isConfirmDialogUp
            Accessible.focusable: true
            focus: true

            anchors {
                top: parent.top
                topMargin: 24
                left: parent.left
                leftMargin: 24
                right: parent.right
                rightMargin: 24
            }
        }

        TextWithLink {
            id: instructionText
            embeddedLinkModel: viewModel.informativeText

            font.family: "Segoe UI"
            font.pixelSize: 14
            wrapMode: Text.WordWrap

            color: Colors.common.text_secondary

            Accessible.ignored: isConfirmDialogUp
            Accessible.readOnly: true

            onLinkActivated: Qt.openUrlExternally(link)

            callback: function(text, index) {
                viewModel.onEmbeddedLinkActivated(text, index);
            }

            anchors {
                top: title.bottom
                topMargin: 24

                left: parent.left
                leftMargin: 24

                right: parent.right
                rightMargin: 24
            }
        }
    }

    Rectangle {
        id: folderSelectionArea
        height: folderSelectionRow.height
        color: Colors.common.background

        anchors {
            left: parent.left
            leftMargin: 24

            right: parent.right
            rightMargin: 24

            top: headerSection.bottom
            topMargin: 16
        }

        Image {
            id: finishedImage
            source: fullImageLocation + "done_graphic.svg"
            visible: false
            // we don't need to set the width because the fill mode will scale the width after we set the height
            height: showDonePageInfoText ? 214 : 248
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
        }

        Row {
            id: folderSelectionRow
            Accessible.ignored: true
            spacing: 4
            
            FolderItem {
                id: desktopFolder
                isAccessibleIgnored: !parent.visible || isConfirmDialogUp
                folderType: ViewModel.Desktop
                folderState: viewModel.desktopFolderItemState
                imageSource: fullImageLocation + "folder_image_desktop.svg"
                primaryText: viewModel.desktopFolderName
                secondaryText: viewModel.desktopSecondaryText
                actionLinkText: viewModel.stopAutoSaveLinkText
                actionLinkEnabled: !viewModel.disableDesktopOptOut
                enableUserInput: viewModel.dialogState === "userInput"
                progressPercentage: viewModel.desktopProgressValue
                isDeterminate: viewModel.hasDesktopProgressValue
                showSizeWhileInProgress: root.atLeastOneFolderHasProgressValue()
                Accessible.ignored: isAccessibleIgnored
            }

            FolderItem {
                id: picturesFolder
                isAccessibleIgnored: !parent.visible || isConfirmDialogUp
                folderType: ViewModel.Pictures
                folderState: viewModel.picturesFolderItemState
                imageSource: fullImageLocation + "folder_image_pictures.svg"
                primaryText: viewModel.picturesFolderName
                secondaryText: viewModel.picturesSecondaryText
                actionLinkText: viewModel.stopAutoSaveLinkText
                actionLinkEnabled: !viewModel.disablePicturesOptOut
                enableUserInput: viewModel.dialogState === "userInput"
                progressPercentage: viewModel.picturesProgressValue
                isDeterminate: viewModel.hasPicturesProgressValue
                showSizeWhileInProgress: root.atLeastOneFolderHasProgressValue()
                Accessible.ignored: isAccessibleIgnored
            }

            FolderItem {
                id: documentsFolder
                isAccessibleIgnored: !parent.visible || isConfirmDialogUp
                folderType: ViewModel.Documents
                folderState: viewModel.documentsFolderItemState
                imageSource: fullImageLocation + "folder_image_documents.svg"
                primaryText: viewModel.documentsFolderName
                secondaryText: viewModel.documentsSecondaryText
                actionLinkText: viewModel.stopAutoSaveLinkText
                actionLinkEnabled: !viewModel.disableDocumentsOptOut
                enableUserInput: viewModel.dialogState === "userInput"
                progressPercentage: viewModel.documentsProgressValue
                isDeterminate: viewModel.hasDocumentsProgressValue
                showSizeWhileInProgress: root.atLeastOneFolderHasProgressValue()
                Accessible.ignored: isAccessibleIgnored
            }
        }
    }

    Rectangle {
        id: infoArea
        color: Colors.common.background
        border.color: scrollView.focus && (scrollView.isScrollable || viewModel.infoAreaTabIndex === 0) ? Colors.move_window.scrollViewBorderColor : Colors.common.background
        height: Math.max(infoAreaGraphic.sourceSize.height, Math.min(availableSpaceForInfoArea, infoAreaText.height))

        anchors {
            top: folderSelectionArea.bottom
            topMargin: 16

            right: parent.right
            rightMargin: 24

            left: parent.left
            leftMargin: 24
        }

        // Set the visibility to false if no text to show.
        // Otherwise, if there is no text but visible is "true" this item
        // is included in TAB navigation, which we don't want when there's no text
        visible: (infoAreaText.text.length > 0)

        ScrollViewWithAcc {
            id: scrollView
            property bool isScrollable: (infoAreaText.height > scrollView.height)
            Accessible.ignored: (!visible || isConfirmDialogUp)

            anchors {
                left: (infoAreaGraphic.visible || infoAreaErrorIcon.visible) ? infoAreaGraphic.right : infoArea.left
                leftMargin: (infoAreaGraphic.visible || infoAreaErrorIcon.visible) ? 8 : 0
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
            clip: true

            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            Keys.onLeftPressed: nil
            Keys.onRightPressed: nil

            activeFocusOnTab: (infoAreaText.height > scrollView.height)
            
            TextWithLink {
                id: infoAreaText
                embeddedLinkModel: viewModel.infoAreaText

                font.family: "Segoe UI"
                font.pixelSize: 14
                width: scrollView.width - 6 // scroll view width - width of scroll bar
                wrapMode: Text.WordWrap

                minTabIndex: scrollView.isScrollable ? 0 : 1

                color: Colors.move_window.title

                Accessible.ignored: scrollView.Accessible.ignored
                Accessible.readOnly: true
                Accessible.focusable: true

                onLinkActivated: {
                    if (link.search("http") === 0) { // we found the http prefix at the begining of the string
                        Qt.openUrlExternally(link);
                   } else { // otherwise we assume this is a sc:// link that requests the client to do something
                       viewModel.handleClientAction(link);
                   }
                }
                callback: function(text, index)
                {
                    viewModel.onEmbeddedLinkActivated(text, index);
                }
            }
        }

        Image {
            id: infoAreaErrorIcon
            visible: false
            source: (viewModel.errorSeverity === ViewModel.GreyWarning) ?
                        fullImageLocation + "infoIcon.svg" :
                        fullImageLocation + "errorIcon.svg"
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

    FabricButton {
        id: viewActivityCenterButton
        visible: false
        onClicked:viewModel.handleClientAction("sc://OpenActivityCenter")
        buttonText: viewModel.finishedButtonText

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: (showDonePageInfoText) ?
                     infoArea.bottom :
                     folderSelectionArea.bottom;
            topMargin: (showDonePageInfoText) ? 16 : 32
        }

        Accessible.onPressAction: onClicked()
        Keys.onEnterPressed: onClicked()
        Keys.onReturnPressed: onClicked()
        Keys.onSpacePressed: onClicked()
    }

    Button {
        id: getAppTextLink
        visible: false
        width: contentItem.paintedWidth
        height: contentItem.paintedHeight
        text: viewModel.getAppText

        Accessible.ignored: !visible
        Accessible.onPressAction: openMobileUpsellPage()
        Accessible.name: viewModel.getAppText

        Keys.onEnterPressed: openMobileUpsellPage()
        Keys.onReturnPressed: openMobileUpsellPage()
        Keys.onSpacePressed: openMobileUpsellPage()

        background: Rectangle {
            implicitWidth: getAppTextLinkText.width
            implicitHeight: getAppTextLinkText.height
            color: "transparent"
            border.color: "transparent"
        }

        contentItem: Text {
            id: getAppTextLinkText
            text: viewModel.getAppText
            font.family: "Segoe UI"
            font.pixelSize: 12
            color: chooseLinkTextColor(getAppTextLinkMouseArea)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: getAppTextLinkMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: openMobileUpsellPage()
        }

        anchors {
            top: viewActivityCenterButton.bottom
            topMargin: 20
            horizontalCenter: viewActivityCenterButton.horizontalCenter
        }
    }

    Rectangle {
        id: footerSection
        color: Colors.common.background
        height: Math.max(remainingSpace.height, nextButton.height)

        anchors {
            bottom: parent.bottom
            bottomMargin: 32

            left: parent.left
            leftMargin: 24

            right: parent.right
            rightMargin: 24
        }

        Text {
            id: remainingSpace
            visible: (remainingSpace.text === "")

            font.family: "Segoe UI"
            font.pixelSize: 14
            wrapMode: Text.WordWrap
            // if the remaining space is negative (i.e. by moving a selected folder the user will
            // go over quota) then we want to display the text in red.
            color: nextDisabledByQuota ? Colors.move_window.cancelledSecondaryText : Colors.common.text_secondary
            text: viewModel.remainingSpaceText

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: tryAgainButton.visible ? tryAgainButton.left : nextButton.left
                rightMargin: 8
            }

            Accessible.role: Accessible.StaticText
            Accessible.name: viewModel.remainingSpaceText
            Accessible.readOnly: true
            // Ignore when not visible or if text is empty
            Accessible.ignored: (!visible || isConfirmDialogUp)
        }

        FabricButton {
            id: tryAgainButton
            onClicked: viewModel.reScan()
            visible: atLeastOneFolderInError && ((viewModel.dialogState === "userInput") || (viewModel.dialogState === "userInputDialog"))
            enabled: visible
            buttonStyle: "secondary"
            buttonText: viewModel.tryAgainButtonText

            Accessible.role: Accessible.Button
            Accessible.name: viewModel.nextButtonText
            Accessible.ignored: !visible || isConfirmDialogUp
            Accessible.onPressAction: viewModel.reScan()
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
            onClicked: viewModel.onNextButtonClicked()
            buttonText: viewModel.nextButtonText
            visible: !viewModel.allFoldersMigrated && (viewModel.dialogState !== "finished")
            enabled: ((viewModel.dialogState === "userInput") && !nextDisabledByQuota &&
                      ((viewModel.desktopFolderItemState === "selected") ||
                       (viewModel.picturesFolderItemState === "selected") ||
                       (viewModel.documentsFolderItemState === "selected")))

            Accessible.role: Accessible.Button
            Accessible.name: viewModel.nextButtonText
            Accessible.ignored: !visible || isConfirmDialogUp
            Accessible.onPressAction: viewModel.onNextButtonClicked()
            
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
