/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4

import "fabricMdl2.js" as FabricMDL

WizardTutorialPageBase {
    id: root
    anchors.fill: parent

    header.title.text: _("FirstRunFinishFirstRunTitle")
    header.subtitle.visible: false
    header.subtitle.height: 56
    header.image.source: fullImageLocation + "fre_done.svg"

    nextButton.buttonText: _("StatusMenuItemOpenLocalFolder")
    nextButton.onClicked: pageModel.OpenOneDriveFolderClicked();

    additionalContent.anchors.bottom: nextButton.top
    additionalContent.anchors.bottomMargin: 25

    additionalContent.data: Rectangle {
        anchors.fill: additionalContent
        color: "transparent"

        CustomCheckBox {
            id: checkBox
            visible: pageModel.shouldShowOpenAtLoginCheckbox
            checkBoxText: _("FirstRunFinishFirstRunOpenAtLoginCheckboxText")
            
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 3 //  Additional spacing to align with fabric buttons in WizardTutorialPageBase
            anchors.right: parent.right

            spacingBetweenCheckBoxAndText: 5
            onClicked: { pageModel.openAtLogin = checked; }
        }
    }
}
