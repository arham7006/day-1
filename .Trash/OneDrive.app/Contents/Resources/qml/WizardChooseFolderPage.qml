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

    property string fullImageLocation: "file:///" + imageLocation

    function _(key)
    {
        return wizardWindow.getLocalizedMessage(key);
    }

    Text {
        id: heading
        text: _("FirstRunIntroduceText")
        font.family: "Segoe UI Semibold"
        font.pixelSize: 28
        color: Colors.common.text

        horizontalAlignment: Text.Center
        anchors {
            top: parent.top
            topMargin: 30

            left: parent.left
            leftMargin: 61

            right: parent.right
            rightMargin: 61
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: heading.text
        Accessible.readOnly: true
        Accessible.ignored: isErrorDialogUp
    }

    Text {
        id: secondaryText
        text: _("FirstRunIntroduceDescriptiveText")
        font.family: "Segoe UI"
        font.pixelSize: 14
        color: Colors.common.text_secondary

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        anchors {
            top: heading.bottom
            topMargin: 9

            left: parent.left
            leftMargin: 61

            right: parent.right
            rightMargin: 61
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: secondaryText.text
        Accessible.readOnly: true
        Accessible.ignored: isErrorDialogUp
    }

    Image {
        id: chooseFolderImage
        // TODO TFS 684329 (brchua) use actual image
        source: fullImageLocation + "done_graphic.svg"
        sourceSize.height: 220
        sourceSize.width: 469

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: secondaryText.bottom
        anchors.topMargin: 20

        Accessible.ignored: true
    }

    Rectangle {
        id: pathLocationRect
        height: childrenRect.height

        color: "transparent"

        anchors {
            top: chooseFolderImage.bottom
            topMargin: 48

            left: parent.left
            leftMargin: 35

            right: changeFolderLink.left
            rightMargin: 20
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: locationDescription.text + " " + fullPath.text
        Accessible.readOnly: true
        Accessible.ignored: isErrorDialogUp

        Text {
            id: locationDescription
            text: pageModel.locationDescription
            font.family: "Segoe UI Semibold"
            font.pixelSize: 16
            color: Colors.common.text

            horizontalAlignment: Text.AlignLeft
            width: parent.width
            elide: Text.ElideRight
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
        }

        Text {
            id: adminLockedWarning
            text: _("FirstRunChangeFolderAdminWarning")
            visible: pageModel.didAdminLockLocation
            font.family: "Segoe UI"
            font.pixelSize: 12
            color: Colors.common.text_secondary

            horizontalAlignment: Text.AlignLeft
            width: parent.width
            wrapMode: Text.WordWrap

            anchors {
                top: fullPath.bottom
                topMargin: 8
            }

            Accessible.role: Accessible.StaticText
            Accessible.name: adminLockedWarning.text
            Accessible.readOnly: true
            Accessible.ignored: !visible || isErrorDialogUp
        }
    }

    Button {
        id: changeFolderLink
        enabled: (!pageModel.didAdminLockLocation && !pageModel.shouldShowSpinner)
        width: contentItem.paintedWidth
        height: contentItem.paintedHeight
        leftPadding: 0
        rightPadding: 0
        bottomPadding: 0
        topPadding: 0
        activeFocusOnTab: true

        anchors {
            bottom: nextBtn.top
            bottomMargin: 18

            right: parent.right
            rightMargin: 35
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
        Accessible.ignored: !enabled || isErrorDialogUp
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

        buttonText: _("FirstRunDoneIntroductionButtonText")
        buttonRadius: 2

        anchors {
            bottom: parent.bottom
            bottomMargin: 30

            right: parent.right
            rightMargin: 35
        }

        Accessible.role: Accessible.Button
        Accessible.name: nextBtn.buttonText
        Accessible.ignored: !nextBtn.enabled || isErrorDialogUp
        Accessible.onPressAction: nextBtn.clicked()
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
        Accessible.ignored: !visible || isErrorDialogUp
        Accessible.readOnly: true

        Image {
            id: spinningGraphic
            source: "file:///" + imageLocation + "loading_spinner.svg"
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
