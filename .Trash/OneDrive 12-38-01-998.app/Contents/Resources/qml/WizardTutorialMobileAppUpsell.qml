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

    header.title.text: _("FirstRunTutorialGetMobileTitle")
    header.subtitle.text: _("FirstRunTutorialGetMobileSubtitle")
    header.image.source: fullImageLocation + "FRE_Tutorial_Mobile.svg"
    header.image.anchors.topMargin: 38
    nextButton.buttonText: _("FirstRunLaterButton")
    nextButton.onClicked: pageModel.NextClicked();
    nextButton.buttonStyle: "standard"

    FabricButton {
        id: getAppButton
        width: getAppButton.contentItem.paintedWidth + 50
        height: contentItem.paintedHeight + 12

        anchors {
            bottom: parent.bottom
            right: nextButton.left

            bottomMargin: 30
            rightMargin: 18
        }

        Accessible.role: Accessible.Button
        Accessible.name: getAppButton.buttonText
        Accessible.onPressAction: getAppButton.clicked()
        Keys.onReturnPressed: getAppButton.clicked()
        Keys.onEnterPressed: getAppButton.clicked()

        onClicked: pageModel.GetAppClicked()
        buttonText: _("FirstRunTutorialGetMobileButton")
    }
}
