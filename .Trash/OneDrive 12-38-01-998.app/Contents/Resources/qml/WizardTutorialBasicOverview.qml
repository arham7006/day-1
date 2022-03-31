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

    header.title.text: _("FirstRunTutorialGetToKnowTitle")
    header.subtitle.text: _("FirstRunTutorialGetToKnowSubtitle")
    header.image.source: Qt.platform.os === "osx" ? fullImageLocation + "FRE_Tutorial_Intro_mac.svg" : fullImageLocation + "FRE_Tutorial_Intro.svg"
    header.image.anchors.topMargin: 57

    nextButton.onClicked: pageModel.NextClicked();
}
