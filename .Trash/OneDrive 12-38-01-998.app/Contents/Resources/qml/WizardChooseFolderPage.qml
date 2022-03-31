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
    objectName: "chooseFolderPageRoot"

    color: "transparent"

    onVisibleChanged: {
        if (visible) {
            nextBtn.forceActiveFocus();

            wizardWindow.announceTextChange(header, header.title.text, Accessible.AnnouncementProcessing_ImportantAll);
        }
    }

    function onDialogClosed() {
        nextBtn.forceActiveFocus();
    }

    WizardPageHeader {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        title.text:  pageModel.titleText
        subtitle.text: pageModel.secondaryText
        image.source: Qt.platform.os === "osx" ? fullImageLocation + "fre_choose_folder_mac.svg" : fullImageLocation + "fre_choose_folder.svg"
        image.height: 220
        image.width: 470
        image.anchors.topMargin: 18
        image.visible: !isFREAnimationEnabled
    }

    Rectangle {
        id: pathLocationRect
        height: childrenRect.height
        visible: (pageModel.fullPath !== "")

        color: "transparent"

        anchors {
            bottom: changeFolderLink.top
            bottomMargin: 10

            left: parent.left
            leftMargin: 35

            right: parent.right
            rightMargin: 35
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: locationDescription.text + " " + fullPath.text
        Accessible.ignored: !visible || isConfirmDialogUp
        Accessible.readOnly: true
        Accessible.focusable: true

        Text {
            id: locationDescription
            text: pageModel.locationDescription
            font.family: "Segoe UI Semibold"
            font.pixelSize: 16
            color: Colors.common.text

            horizontalAlignment: Text.AlignLeft
            width: parent.width
            elide: Text.ElideRight

            Accessible.ignored: true
        }

        Text {
            id: fullPath
            text: pageModel.fullPath
            font.family: "Segoe UI"
            font.pixelSize: 14
            color: Colors.common.text_secondary

            horizontalAlignment: Text.AlignLeft
            width: parent.width
            elide: Text.ElideMiddle

            anchors {
                top: locationDescription.bottom
                topMargin: 6
            }

            Accessible.ignored: true

            onTextChanged: pathLocationRect.forceActiveFocus();
        }
    }

    Button {
        id: changeFolderLink
        enabled: !pageModel.shouldShowSpinner
        visible: pageModel.shouldShowChangeFolderLink
        width: changeFolderLinkText.paintedWidth
        height: changeFolderLinkText.paintedHeight
        leftPadding: 0
        rightPadding: 0
        bottomPadding: 0
        topPadding: 0
        activeFocusOnTab: enabled

        anchors {
            bottom: parent.bottom
            bottomMargin: 56

            left: parent.left
            leftMargin: 35
        }

        text: _("FirstRunBrowseButtonText")
        contentItem: Text {
            id: changeFolderLinkText
            text: changeFolderLink.text
            font.family: "Segoe UI"
            font.pixelSize: 12
            font.underline: changeFolderLink.visualFocus
            color: changeFolderLinkMouseArea.containsPress ? Colors.common.hyperlink_pressed :
                    (changeFolderLinkMouseArea.containsMouse ? Colors.common.hyperlink_hovering :
                       (changeFolderLink.enabled ? Colors.common.hyperlink : Colors.common.text_disabled))
            horizontalAlignment: Text.AlignLeft

            // Work around for a Qt bug where a second underline appears at (2x,2y) co-ordinates
            clip: true
        }

        Keys.onSpacePressed: pageModel.onChangeLocationButtonClicked();
        Keys.onReturnPressed: pageModel.onChangeLocationButtonClicked();
        Keys.onEnterPressed: pageModel.onChangeLocationButtonClicked();

        background: Rectangle {
            implicitWidth: changeFolderLinkText.width
            implicitHeight: changeFolderLinkText.height
            color: "transparent"
            border.color: "transparent"
        }

        Accessible.name: changeFolderLink.text
        Accessible.ignored: !visible || isConfirmDialogUp
        Accessible.disabled: !enabled
        Accessible.onPressAction: {
            pageModel.onChangeLocationButtonClicked();
        }

        MouseArea {
            id: changeFolderLinkMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                pageModel.onChangeLocationButtonClicked();
            }
        }
    }

    FabricButton {
        id: nextBtn
        enabled: !pageModel.shouldShowSpinner
        width: contentItem.paintedWidth + 40
        height: contentItem.paintedHeight + 12

        buttonText: pageModel.buttonText

        anchors {
            bottom: parent.bottom
            bottomMargin: 30

            right: parent.right
            rightMargin: 35
        }

        Accessible.role: Accessible.Button
        Accessible.name: nextBtn.buttonText
        Accessible.onPressAction: nextBtn.clicked()
        Accessible.disabled: !enabled
        Accessible.ignored: isConfirmDialogUp
        Keys.onReturnPressed: nextBtn.clicked()
        Keys.onEnterPressed:  nextBtn.clicked()

        onClicked: pageModel.onNextButtonClicked()
    }

    Rectangle {
        id: spinnerRect
        width: nextBtn.width
        height: nextBtn.height
        visible: pageModel.shouldShowSpinner
        anchors.left: nextBtn.left
        anchors.top: nextBtn.top

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
                id: rotationAnimation
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
