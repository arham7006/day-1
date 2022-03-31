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
    color: "transparent"
    onVisibleChanged: {
        if (visible) {
            nextBtn.forceActiveFocus();

            wizardWindow.announceTextChange(hdr, hdr.title.text + " " + hdr.subtitle.text, Accessible.AnnouncementProcessing_ImportantAll);
        }
    }

    property alias header: hdr
    property alias nextButton: nextBtn
    property alias backButton: backBtn
    property alias additionalContent: extraContentArea

    WizardPageHeader {
        id: hdr
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        image.visible: !isFREAnimationEnabled
    }

    Item {
        id: extraContentArea
        anchors {
            
            right: parent.right
            rightMargin: 30

            left: parent.left
            leftMargin: 30

            top: hdr.bottom
            topMargin: 24
        }
    }

    FabricButton {
        id: backBtn
        width: backBtn.contentItem.paintedWidth + 50
        height: contentItem.paintedHeight + 12

        buttonStyle: "standard"
        anchors {
            bottom: parent.bottom
            left: parent.left

            bottomMargin: 30
            leftMargin: 35
        }

        Accessible.role: Accessible.Button
        Accessible.name: backBtn.buttonText
        Accessible.onPressAction: backBtn.clicked()
        Keys.onReturnPressed: backBtn.clicked()
        Keys.onEnterPressed: backBtn.clicked()
        
        onClicked: pageModel.BackClicked()
        buttonText: _("FirstRunBackButton")
        visible: pageModel.canNavigateBack
    }

    FabricButton {
        id: nextBtn
        width: nextBtn.contentItem.paintedWidth + 50
        height: contentItem.paintedHeight + 12

        anchors {
            bottom: parent.bottom
            right: parent.right

            bottomMargin: 30
            rightMargin: 35
        }

        Accessible.role: Accessible.Button
        Accessible.name: nextBtn.buttonText
        Accessible.onPressAction: nextBtn.clicked()
        Keys.onReturnPressed: nextBtn.clicked()
        Keys.onEnterPressed: nextBtn.clicked()

        buttonText: _("FirstRunNextButton")
    }
}
