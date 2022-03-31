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
            enableBtn.forceActiveFocus();

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

        title.text: _("FirstRunEnableFinderSyncTitle")
        subtitle.text: _("FirstRunEnableFinderSyncDescription")
        image.source: fullImageLocation + "fre_enable_finder.svg"
        image.height: 220
        image.width: 470
        image.anchors.topMargin: 18
    }

    Rectangle {
        id: buttonGroup
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        width: parent.width
        height: enableBtn.height

        color: "transparent"

        FabricButton {
            id: skipBtn
            width: Math.max(skipBtn.contentItem.paintedWidth, enableBtn.contentItem.paintedWidth) + 45
            height: contentItem.paintedHeight + 12

            buttonText: _("FirstRunEnableFinderSyncSkipButtonText")
            buttonStyle: "secondary"

            anchors.right: parent.horizontalCenter
            anchors.rightMargin: 8

            Accessible.role: Accessible.Button
            Accessible.name: skipBtn.buttonText
            Accessible.onPressAction: skipBtn.clicked()
            Keys.onReturnPressed: skipBtn.clicked()
            Keys.onEnterPressed:  skipBtn.clicked()

            onClicked: pageModel.onSkipButtonClicked()
        }

        FabricButton {
            id: enableBtn
            width: Math.max(skipBtn.contentItem.paintedWidth, enableBtn.contentItem.paintedWidth) + 45
            height: contentItem.paintedHeight + 12

            buttonText: _("FirstRunEnableFinderSyncEnableButtonText")

            anchors.left: parent.horizontalCenter
            anchors.leftMargin: 8

            Accessible.role: Accessible.Button
            Accessible.name: enableBtn.buttonText
            Accessible.onPressAction: enableBtn.clicked()
            Keys.onReturnPressed: enableBtn.clicked()
            Keys.onEnterPressed:  enableBtn.clicked()

            onClicked: pageModel.onEnableButtonClicked()
        }
    }
}
