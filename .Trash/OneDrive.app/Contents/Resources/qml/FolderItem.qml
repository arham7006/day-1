/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import ViewModel 1.0

Rectangle {
    id: root

    // these properties need to be set when a FolderItem is used
    property int    folderType
    property string folderState
    property bool   enableUserInput
    property bool   isAccessibleIgnored
    property bool   isSelectable: (state === "unselected") || (state === "selected") || (state === "cancelled")

    // Property forces showing the secondary text
    // with the folder size while in progress, even when isDeterminate is false.
    // This is used when this folder is migrating side-by-side
    // with a cross-volume folder that does have determinate progress
    property bool   showSizeWhileInProgress: false

    property alias  progressPercentage : progressBar.progressPercentage
    property alias  isDeterminate: progressBar.isDeterminate

    property alias  imageSource: primaryImage.source
    property alias  primaryText: primaryTextControl.text
    property alias  secondaryText: secondaryTextControl.text
    property alias  actionLinkText: actionLink.text
    property alias  actionLinkEnabled: actionLink.enabled

    height: 172
    width: 176

    state: folderState
    states: [
        State {
            name: "scanning"
            PropertyChanges { target: secondaryTextControl; visible: false; }
            PropertyChanges { target: checkMark; visible: false; }
            PropertyChanges { target: root; Accessible.checkable: false; }
        },
        State {
            name: "unselected"
            PropertyChanges { target: root; color: Colors.common.background; }
            PropertyChanges { target: root; Accessible.checkable: true; }
            PropertyChanges { target: root; Accessible.checked: false; }
            PropertyChanges { target: primaryTextControl; color: Colors.move_window.folderItemPrimaryText; }
            PropertyChanges { target: secondaryTextControl; color: Colors.move_window.folderItemPrimaryText; }
        },
        State {
            name: "selected"
            PropertyChanges { target: root; color: Colors.move_window.folderItemBackgroundSelected; }
            PropertyChanges { target: root; Accessible.checkable: true; }
            PropertyChanges { target: root; Accessible.checked: true; }
            PropertyChanges { target: primaryTextControl; color: Colors.move_window.folderItemPrimaryTextSelected; }
            PropertyChanges { target: secondaryTextControl; color: Colors.move_window.folderItemPrimaryTextSelected; }
        },
        State {
            name: "inProgress"
            PropertyChanges { target: progressBar; visible: true; }
            PropertyChanges { target: root; Accessible.checkable: false; }
            PropertyChanges { target: primaryTextControl; color: Colors.move_window.folderItemPrimaryTextSelected; }
            PropertyChanges { target: secondaryTextControl; visible: (showSizeWhileInProgress | isDeterminate); }
            PropertyChanges {
                target: root
                color: viewModel.isFolderInProgress(folderType) ?
                           Colors.move_window.folderItemBackgroundSelected :
                           Colors.common.background
            }
        },
        State {
            name: "done"
            PropertyChanges { target: root; color: Colors.move_window.folderItemBackgroundDone; }
            PropertyChanges { target: checkMark; visible: false; }
            PropertyChanges { target: primaryTextControl; color: Colors.move_window.folderItemBackgroundDoneText; }
            PropertyChanges { target: secondaryTextControl; color: Colors.move_window.folderItemBackgroundDoneText; }
            PropertyChanges { target: root; Accessible.checkable: false; }
        },
        State {
            name: "error"
            PropertyChanges { target: primaryTextControl; color: Colors.move_window.cancelledSecondaryText; }
            PropertyChanges { target: secondaryTextControl; visible: false; }
            PropertyChanges { target: root; Accessible.checkable: false; }
        },
        State {
            name: "doneWithStop"
            PropertyChanges { target: root; color: Colors.move_window.folderItemBackgroundDone; }
            PropertyChanges { target: actionLink; visible: true; }
            PropertyChanges { target: checkMark; visible: false; }
            PropertyChanges { target: primaryTextControl; color: Colors.move_window.folderItemBackgroundDoneText; }
            PropertyChanges { target: secondaryTextControl; color: Colors.move_window.folderItemBackgroundDoneText; }
            PropertyChanges { target: root; Accessible.checkable: false; }
        },
        State {
            name: "restored"
            PropertyChanges { target: root; color: Colors.move_window.folderItemBackgroundDone; }
            PropertyChanges { target: actionLink; visible: false; }
            PropertyChanges { target: primaryTextControl; color: Colors.move_window.folderItemBackgroundDoneText; }
            PropertyChanges { target: secondaryTextControl; color: Colors.move_window.folderItemBackgroundDoneText; }
            PropertyChanges { target: root; Accessible.checkable: false; }
        }
    ]

    transitions: [
        Transition {
            from: "scanning"
            to: "doneWithStop"
            ColorAnimation {
                target:root
                property: "color"
                from: Colors.common.background
                to: Colors.move_window.folderItemBackgroundDone
                duration: 250
            }
        },
        Transition {
            from: "scanning"
            to: "selected"
            ColorAnimation {
                target:root
                property: "color"
                from: Colors.common.background
                to: Colors.move_window.folderItemBackgroundSelected
                duration: 250
            }
        },
        Transition {
            from: "unselected"
            to: "selected"
            ColorAnimation {
                target:root
                property: "color"
                from: Colors.common.background
                to: Colors.move_window.folderItemBackgroundSelected
                duration: 250
            }
        },
        Transition {
            from: "selected"
            to: "unselected"
            ColorAnimation {
                target:root
                property: "color"
                from: Colors.move_window.folderItemBackgroundSelected
                to: Colors.common.background
                duration: 250
            }
        },
        Transition {
            from: "inProgress"
            to: "done"
            ColorAnimation {
                target:root
                property: "color"
                from: Colors.move_window.folderItemBackgroundSelected
                to: Colors.move_window.folderItemBackgroundDone
                duration: 250
            }
        },
        Transition {
            from: "inProgress"
            to: "error"
            ColorAnimation {
                target:root
                property: "color"
                from: Colors.move_window.folderItemBackgroundSelected
                to: Colors.common.background
                duration: 250
            }
        },
        Transition {
            from: "inProgress"
            to: "cancelled"
            ColorAnimation {
                target:root
                property: "color"
                from: Colors.move_window.folderItemBackgroundSelected
                to: Colors.common.background
                duration: 250
            }
        },
        Transition {
            from: "selected"
            to: "scanning"
            ColorAnimation {
                target:root
                property: "color"
                from: Colors.move_window.folderItemBackgroundSelected
                to: Colors.common.background
                duration: 250
            }
        }
    ]

    function chooseCheckMarkImageSource(folderItemState, containsMouse) {
        var src = "";

        if (enableUserInput) {
            if (folderItemState === "selected") {
                src = fullImageLocation + "checkmark_selected.svg";
            }
            else if (((folderItemState === "unselected") || (folderItemState === "cancelled")) &&
                     containsMouse) {
                src = fullImageLocation + "checkmark_hovered.svg";
            }
            else if (folderItemState === "inProgress") {
                src = fullImageLocation + "checkmark_in_progress.svg";
            }
            else if ((folderItemState === "done") || (folderItemState === "doneWithStop")) {
                src = fullImageLocation + "checkmark_finished.svg";
            }
        }

        return src;
    }

    function chooseLinkTextColor(linkItem, linkItemMouseArea) {
        var color = Colors.common.hyperlink;

        if (!linkItem.enabled) {
            color = Colors.fabric_button.standard.text_disabled
        }

        if (linkItemMouseArea.containsPress) {
            color = Colors.common.hyperlink_pressed;
        }
        else if (linkItemMouseArea.containsMouse || linkItem.activeFocus) {
          color = Colors.common.hyperlink_hovering;
        }

        return color;
    }

    function onActionLinkActivated() {
        confirmRestoreDialog.folderType = root.folderType;
        confirmRestoreDialog.open();
    }

    Accessible.onPressAction: viewModel.toggleFolderSelected(folderType);
    Accessible.onToggleAction: viewModel.toggleFolderSelected(folderType);
    Keys.onEnterPressed: viewModel.toggleFolderSelected(folderType);
    Keys.onReturnPressed: viewModel.toggleFolderSelected(folderType);
    Keys.onSpacePressed: viewModel.toggleFolderSelected(folderType);

    activeFocusOnTab: isSelectable
    Accessible.role: Accessible.CheckBox
    Accessible.name: secondaryTextControl.visible ? primaryText + "; " + secondaryText : primaryText
    color: Colors.common.background
    border.color: ((folderSelectionMouseArea.containsMouse || root.activeFocus) && isSelectable && enableUserInput && !confirmRestoreDialog.visible) ?
                      Colors.move_window.folderItemBorderColor :
                      Colors.common.background

    Image {
        id: checkMark
        source: chooseCheckMarkImageSource(folderState, folderSelectionMouseArea.containsMouse)
        sourceSize.height: 32
        sourceSize.width: 32
        anchors {
            right: parent.right
            top: parent.top
        }
    }

    MouseArea {
        id: folderSelectionMouseArea
        anchors.fill: parent
        onClicked: viewModel.toggleFolderSelected(folderType);
        hoverEnabled: true
    }

    Column {
        id: theColumn
        anchors {
            top: parent.top
            topMargin: 12
            bottom: parent.bottom

            left: parent.left
            right: parent.right
        }

        spacing: 4
        Image {
            id: primaryImage
            width: 104
            height: 84
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
        }

        Text {
            id: primaryTextControl
            font.family: "Segoe UI"
            font.pixelSize: 14
            wrapMode: Text.WordWrap
            color: (root.showSizeWhileInProgress) ? "yellow" : Colors.move_window.folderItemPrimaryText
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: secondaryTextControl
            font.family: "Segoe UI"
            wrapMode: Text.WordWrap
            font.pixelSize: 12
            color: Colors.move_window.folderItemPrimaryText
            anchors.horizontalCenter: parent.horizontalCenter
        }

        FabricProgressBar {
            id: progressBar
            anchors {
                left: parent.left
                leftMargin: 8

                right: parent.right
                rightMargin: 8
            }
            visible: false
            height: (visible? 2 : 0)
            width: 150
            animatorObjectWidth: width
            isRTL: viewModel.isRTL
        }

        Button {
            id: actionLink
            visible: false
            width: contentItem.paintedWidth
            height: contentItem.paintedHeight
            text: viewModel.stopAutoSaveLinkText
            anchors.horizontalCenter: parent.horizontalCenter

            Accessible.ignored: !visible || root.isAccessibleIgnored
            Accessible.onPressAction: onActionLinkActivated()

            Keys.onEnterPressed: onActionLinkActivated()
            Keys.onReturnPressed: onActionLinkActivated()
            Keys.onSpacePressed: onActionLinkActivated()

            background: Rectangle {
                implicitWidth: actionLinkText.width
                implicitHeight: actionLinkText.height
                color: "transparent"
            }

            contentItem: Text {
                id: actionLinkText
                text: viewModel.stopAutoSaveLinkText
                font.family: "Segoe UI"
                font.pixelSize: 12
                color: chooseLinkTextColor(actionLink, actionLinkMouseArea)
                anchors.fill: parent
                font.underline: actionLink.activeFocus

                MouseArea {
                    id: actionLinkMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: onActionLinkActivated()
                }
            }
        }
    }
}
