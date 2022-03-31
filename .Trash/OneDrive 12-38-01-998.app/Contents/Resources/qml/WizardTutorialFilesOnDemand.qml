/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

WizardTutorialPageBase {
    id: root
    anchors.fill: parent

    header.title.text: _("FirstRunTutorialCloudFilesTitle")
    header.subtitle.text: _("FirstRunTutorialCloudFilesSubtitle")
    header.image.visible: false
    nextButton.onClicked: pageModel.NextClicked();

    additionalContent.anchors.bottom: nextButton.top
    additionalContent.anchors.bottomMargin: 10
    additionalContent.data: Rectangle {
        anchors.fill: additionalContent
        width: 531
        color: "transparent"

        Row {
            id: contentList
            width: 531
            spacing: 45
            anchors.verticalCenter: parent.verticalCenter

            IconWithTextAndDescription
            {
                image.source: Qt.platform.os === "osx" ?
                                  fullImageLocation + "FRE_Tutorial_FilesOnDemand_OnlineOnly_mac.svg" :
                                  fullImageLocation + "FRE_Tutorial_FilesOnDemand_OnlineOnly.svg"
                accessibleIconDescription: _("FirstRunTutorialCloudFilesOnlineImageAccessible")
                titleText.text: _("FirstRunTutorialCloudFilesOnlineTitle")
                subtitleText.text: _("FirstRunTutorialCloudFilesOnlineDescription")
            }

            IconWithTextAndDescription
            {
                image.source: Qt.platform.os === "osx" ?
                                  fullImageLocation + "FRE_Tutorial_FilesOnDemand_Placeholder_mac.svg" :
                                  fullImageLocation + "FRE_Tutorial_FilesOnDemand_Placeholder.svg"
                accessibleIconDescription: _("FirstRunTutorialCloudFilesAvailableImageAccessible")
                titleText.text: _("FirstRunTutorialCloudFilesAvailableTitle")
                subtitleText.text: _("FirstRunTutorialCloudFilesAvailableDescription")
            }

            IconWithTextAndDescription
            {
                image.source: Qt.platform.os === "osx" ?
                                  fullImageLocation + "FRE_Tutorial_FilesOnDemand_Important_mac.svg" :
                                  fullImageLocation + "FRE_Tutorial_FilesOnDemand_Important.svg"
                accessibleIconDescription: _("FirstRunTutorialCloudFilesImportantImageAccessible")
                titleText.text: _("FirstRunTutorialCloudFilesImportantTitle")
                subtitleText.text: _("FirstRunTutorialCloudFilesImportantDescription")
                accessibleSubtitleText: _("FirstRunTutorialCloudFilesImportantDescriptionAccessible")
            }
        }
    }

}
