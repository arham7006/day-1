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

    header.title.text: _("FirstRunTutorialSharingTitle")
    header.subtitle.text: _("FirstRunTutorialSharingSubtitle")
    header.image.source: Qt.platform.os === "osx" ? fullImageLocation + "FRE_Tutorial_Share_mac.svg" : fullImageLocation + "FRE_Tutorial_Share.svg"
    header.image.anchors.topMargin: 38
    header.accessibleImageDescription: _("FirstRunTutorialSharingImageAccessible")

    nextButton.onClicked: pageModel.NextClicked();
}
