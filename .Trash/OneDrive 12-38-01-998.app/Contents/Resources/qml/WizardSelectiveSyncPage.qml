/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/
import Colors 1.0
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4 as Controls2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import TreeModel 1.0

import "fabricMdl2.js" as FabricMDL

Rectangle {
    id: root
    visible: true
    objectName: "selectiveSyncPageRoot"

    color: "transparent"

    onVisibleChanged: {
        if (visible) {
            nextButton.forceActiveFocus();

            wizardWindow.announceTextChange(header, header.title.text, Accessible.AnnouncementProcessing_ImportantAll);
        }
    }

    WizardPageHeader {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        title.text: pageModel.titleText
        subtitle.text: pageModel.secondaryText
        image.visible: false
    }

    Controls2.CheckBox {
        id: allFoldersCheckbox

        spacing: 6

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 34
        anchors.rightMargin: 20
        anchors.top: header.bottom
        anchors.topMargin: 10

        topPadding: -1
        bottomPadding: 0

        visible: (pageModel.errorText === "") &&
                 !pageModel.isLoading &&
                 pageModel.treeModel.rootFolderCheckStateLoaded

        checkState: pageModel.treeModel.allFoldersCheckState

        activeFocusOnTab: true

        FontLoader {
            id: fabricMDL2;
            source: Qt.platform.os === "osx" ? "FabExMDL2.ttf" : "file:///" + qmlEngineBasePath + "FabExMDL2.ttf"
        }

        text: pageModel.allFoldersCheckBoxText
        contentItem: Text {
            font.family: "Segoe UI"
            font.pixelSize: 14
            wrapMode: Text.WordWrap

            text: allFoldersCheckbox.text

            anchors.left: indicator.right
            anchors.leftMargin: allFoldersCheckbox.spacing
            color: Colors.common.text
        }

        onClicked: {
            pageModel.toggleNodes(allFoldersCheckbox.checkState)
        }

        indicator: Rectangle {
            id: indicator
            implicitHeight: 20
            implicitWidth: 20
            color: "transparent"

            anchors.left: parent.left

            border.width: parent.visualFocus ? 1 : 0
            border.color: parent.visualFocus ? Colors.treeview_checkbox.focused_border : Colors.common.text

            Rectangle {
                anchors.centerIn: parent
                border.color: (allFoldersCheckbox.checkState === Qt.Checked) ?
                                  "transparent" :
                                  (allFoldersCheckbox.checkState === Qt.PartiallyChecked) ?
                                        allFoldersCheckbox.hovered ?
                                            Colors.treeview_checkbox.checked_partial_hovered :
                                            Colors.treeview_checkbox.border_partial :
                                        allFoldersCheckbox.hovered ?
                                            Colors.treeview_checkbox.border_unchecked_hovered :
                                            Colors.treeview_checkbox.border_unchecked

                border.width: 1
                color: (allFoldersCheckbox.checkState === Qt.Checked) ?
                           (allFoldersCheckbox.pressed ?
                                Colors.treeview_checkbox.fill_color_checked_pressed :
                                allFoldersCheckbox.hovered ?
                                    Colors.treeview_checkbox.checked_partial_hovered :
                                    Colors.treeview_checkbox.fill_color_checked) :
                           (allFoldersCheckbox.pressed ?
                                Colors.treeview_checkbox.fill_color_unchecked_pressed :
                                Colors.treeview_checkbox.fill_color_unchecked)
                width: 16
                height: 16

                Text {
                    visible: (allFoldersCheckbox.checkState === Qt.Checked)
                    anchors.centerIn: parent
                    font.family: fabricMDL2.name
                    font.pixelSize: 12
                    text: (allFoldersCheckbox.checkState === Qt.Checked) ?
                              FabricMDL.Icons.CheckMark :
                              (allFoldersCheckbox.checkState === Qt.Unchecked) ? "" : FabricMDL.Icons.CheckboxIndeterminate
                    color: Colors.treeview_checkbox.checkmark
                }

                Rectangle {
                    visible: (allFoldersCheckbox.checkState === Qt.PartiallyChecked)
                    anchors.centerIn: parent
                    width: 8
                    height: 8
                    color: allFoldersCheckbox.hovered ?
                               Colors.treeview_checkbox.checked_partial_hovered :
                               Colors.treeview_checkbox.partial
                }
            }
        }
    }

    Text {
        id: selectFoldersText
        anchors.top: allFoldersCheckbox.bottom
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 34

        font.family: "Segoe UI"
        font.pixelSize: 14
        wrapMode: Text.WordWrap

        text: pageModel.onlyTheseFoldersText
        color: Colors.common.text

        visible: (pageModel.errorText === "") &&
                 pageModel.treeModel.rootFolderCheckStateLoaded

        Accessible.name: text
        Accessible.role: Accessible.StaticText
        Accessible.readOnly: true
    }

    // the treeViewContainer gets all remaining space
    Rectangle {
        id: treeViewContainer
        objectName: "treeViewContainer"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 34
        anchors.rightMargin: 34
        anchors.top: selectFoldersText.bottom
        anchors.topMargin: 10
        anchors.bottom: infoBar.top
        anchors.bottomMargin: 8

        color: "transparent"

        border.color: theTree.activeFocus ? Colors.treeview_container.border_focus : Colors.treeview_container.border

        border.width: 1
        radius: 3

        Rectangle {
            id: loadingPane
            objectName: "loadingPane"
            color: Colors.selective_sync_page.loading_pane_background
            opacity: 0.6
            anchors.fill: parent
            z: 1000
            visible: pageModel.isLoading

            Accessible.ignored: !loadingPane.visible
            Accessible.name: _("SignInPageLoadingText")
            Accessible.role: Accessible.StaticText

            Image {
                id: treeViewSpinningGraphic
                source: "file:///" + imageLocation + "loading_spinner.svg"
                sourceSize.height: 28
                sourceSize.width: 28

                Accessible.ignored: true

                anchors.centerIn: parent

                NumberAnimation on rotation {
                    id: rotationAnimation
                    easing.type: Easing.InOutQuad
                    from: -45
                    to: 315
                    duration: 1500
                    loops: Animation.Infinite
                    running: treeViewSpinningGraphic.visible
                }
            }

            MouseArea {
                id: stealMouseArea
                anchors.fill: parent
                preventStealing: true
            }
        }

        Rectangle {
            id: errorPane
            objectName: "errorPane"

            color: "transparent"

            width: treeViewContainer.width - 160
            height: treeViewErrorGraphic.height + 5 + treeViewErrorText.paintedHeight
            anchors.centerIn: parent

            z: 1000
            visible: (pageModel.errorText !== "")

            Image {
                id: treeViewErrorGraphic
                source: "file:///" + imageLocation + "errorIcon.svg"
                Accessible.ignored: true

                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: treeViewErrorText
                objectName: "errorText"
                width: errorPane.width

                text: pageModel.errorText

                anchors.horizontalCenter: treeViewErrorGraphic.horizontalCenter
                anchors.top: treeViewErrorGraphic.bottom
                anchors.topMargin: 3

                color: Colors.common.text_secondary
                wrapMode: Text.WordWrap

                font.family: "Segoe UI"
                font.pixelSize: 14

                horizontalAlignment: Text.AlignHCenter

                Accessible.name: text
                Accessible.ignored: (pageModel.errorText === "")
                Accessible.role: Accessible.StaticText
                Accessible.readOnly: true
            }
        }

        SelectiveSyncTreeView {
            id: theTree
            objectName: "theTree"
            isRTL: wizardWindow.isRTL

            visible: (pageModel.errorText === "") && !pageModel.isLoading

            width: treeViewContainer.width-2
            model: pageModel.treeModel

            activeFocusOnTab: true

            anchors {
                top: parent.top
                topMargin: 5
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 5
            }
        }
    }

    Rectangle {
        id: infoBar
        visible: (pageModel.infoBarText !== "")
        height: infoBarRow.implicitHeight + 10

        color: Colors.selective_sync_page.infobar_background

        anchors {
            right: parent.right
            rightMargin: 35

            left: parent.left
            leftMargin: 35

            bottom: footer.top
            bottomMargin: 16
        }

        Row {
            id: infoBarRow
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            
            anchors.verticalCenter: parent.verticalCenter

            spacing: 5

            Image {
                id: infoIcon
                source: "file:///" + imageLocation + "infoIcon.svg"
                width: 11
                height: 11
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
            }

            Text {
                id: infoText
                text: pageModel.infoBarText
                font.family: "Segoe UI"
                font.pixelSize: 11
                color: Colors.common.text
                width: parent.width - 16
                wrapMode: Text.WordWrap

                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter

                Accessible.name: text
                Accessible.role: Accessible.StaticText
                Accessible.readOnly: true
                Accessible.ignored: !infoBar.visible
            }
        }
    }

    Rectangle {
        id: footer

        width: parent.width
        height: childrenRect.height
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        color: "transparent"

        Column {
            id: infoTextColumn
            anchors.left: parent.left
            anchors.leftMargin: 34

            anchors.right: cancelButton.visible ? cancelButton.left : nextButton.left
            anchors.rightMargin: 18

            spacing: 3

            Row {
                width: infoTextColumn.width
                spacing: 2

                Text {
                    id: locationText
                    text: pageModel.locationOnDiskText
                    width: folderLink.visible ? paintedWidth : parent.width
                    elide: Text.ElideRight

                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    color: Colors.common.text

                    Accessible.name: text
                    Accessible.role: Accessible.StaticText
                    Accessible.readOnly: true
                }

                Controls2.Button {
                    id: folderLink
                    width: parent.width - locationText.paintedWidth - 2
                    leftPadding: 0
                    rightPadding: 0
                    bottomPadding: 0
                    topPadding: 0

                    text: pageModel.locationOnDiskPathLink
                    visible: (pageModel.locationOnDiskPathLink !== "")

                    activeFocusOnTab: true

                    contentItem: Text {
                        id: folderLinkText
                        text: folderLink.text
                        font.family: "Segoe UI"
                        font.pixelSize: 12
                        font.underline: folderLink.visualFocus
                        color: folderLinkMouseArea.containsPress ? Colors.common.hyperlink_pressed :
                                                                   (folderLinkMouseArea.containsMouse ? Colors.common.hyperlink_hovering : Colors.common.hyperlink)
                        horizontalAlignment: Text.AlignLeft
                        width: folderLink.width
                        elide: Text.ElideRight

                        // Work around for a Qt bug where a second underline appears at (2x,2y) co-ordinates
                        clip: true
                    }

                    background: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "transparent"
                    }

                    Accessible.ignored: !visible
                    Accessible.onPressAction: {
                        pageModel.onLinkClicked();
                    }

                    MouseArea {
                        id: folderLinkMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            pageModel.onLinkClicked();
                        }
                    }
                }
            }

            Flow {
                spacing: 3
                width: parent.width

                Text {
                    id: selectedItemSizeText
                    text: pageModel.selectedSpaceText
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    color: Colors.common.text

                    Accessible.name: text
                    Accessible.role: Accessible.StaticText
                    Accessible.readOnly: true
                }

                Text {
                    id: spaceRemainingText
                    text: pageModel.spaceRemainingText
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    color: pageModel.notEnoughDiskSpace ? Colors.selective_sync_page.error_disk_space : Colors.common.text

                    Accessible.name: text
                    Accessible.role: Accessible.StaticText
                    Accessible.readOnly: true
                }
            }
        }

        FabricButton {
            id: cancelButton
            onClicked: pageModel.onCancelButtonPress()
            visible: pageModel.shouldShowCancelButton
            enabled: !pageModel.shouldShowSpinner

            buttonStyle: "secondary"
            buttonText: _("AdvancedSelectiveSyncCancelButtonText")

            Accessible.role: Accessible.Button
            Accessible.name: _("AdvancedSelectiveSyncCancelButtonText")
            Accessible.ignored: !visible
            Accessible.disabled: !enabled
            Accessible.onPressAction: pageModel.onCancelButtonPress()
            Keys.onReturnPressed: cancelButton.clicked()
            Keys.onEnterPressed:  cancelButton.clicked()

            anchors {
                right: nextButton.left
                rightMargin: 8
                bottom: infoTextColumn.bottom
            }
        }

        FabricButton {
            id: nextButton
            buttonText: pageModel.nextButtonText
            enabled: !pageModel.notEnoughDiskSpace && !pageModel.shouldShowSpinner

            anchors.right: parent.right
            anchors.rightMargin: 35
            anchors.bottom: infoTextColumn.bottom

            onClicked: pageModel.onNextButtonPress()
            Keys.onEnterPressed: pageModel.onNextButtonPress()
            Keys.onReturnPressed: pageModel.onNextButtonPress()
            Keys.onSpacePressed: pageModel.onNextButtonPress()

            Accessible.onPressAction: pageModel.onNextButtonPress()
            Accessible.disabled: !enabled
        }

        Rectangle {
            id: spinnerRect
            width: nextButton.width
            height: nextButton.height
            visible: pageModel.shouldShowSpinner
            anchors.left: nextButton.left
            anchors.top: nextButton.top

            color: Colors.fabric_button.primary.disabled

            Accessible.role: Accessible.StaticText
            Accessible.name: _("SignInPageLoadingText")
            Accessible.ignored: !visible
            Accessible.readOnly: true

            Image {
                id: spinningGraphic
                source: fullImageLocation + "loading_spinner.svg"
                sourceSize.height: 20
                sourceSize.width: 20
                anchors.centerIn: parent

                Accessible.ignored: true

                NumberAnimation on rotation {
                    id: rotationAnimationOnButton
                    easing.type: Easing.InOutQuad
                    from: -45
                    to: 315
                    duration: 1500
                    loops: Animation.Infinite
                    running: spinningGraphic.visible
                }
            }
        }
    }
}

