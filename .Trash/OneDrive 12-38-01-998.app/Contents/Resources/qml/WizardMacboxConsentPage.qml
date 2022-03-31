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

    LayoutMirroring.enabled: pageModel.isRTL
    LayoutMirroring.childrenInherit: true

    property int verticalPageMargin: 30
    property int horizontalPageMargin: 35
    property int primaryFontSize: 14

    onVisibleChanged: {
        if (visible) {
            acceptButton.forceActiveFocus();

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

        title.text: pageModel.isFirstRun ? _("WizardMacboxConsentPageTitleFirstRun") : _("WizardMacboxConsentPageTitleUpgrade")
        subtitle.text: pageModel.isFirstRun ? _("WizardMacboxConsentPageSecondaryTextFirstRun") : _("WizardMacboxConsentPageSecondaryTextUpgrade")

        image.source: "file:///" + imageLocation + "MB_ConsentDialog_Denied.svg"
        image.sourceSize.width: 342
        image.sourceSize.height: 278
        image.anchors.topMargin: 57
    }

    FabricButton {
        id: acceptButton

        anchors {
            bottom: parent.bottom
            right: parent.right

            bottomMargin: verticalPageMargin
            rightMargin: horizontalPageMargin
        }

        Accessible.role: Accessible.Button
        Accessible.disabled: !enabled
        Accessible.name: acceptButton.buttonText
        Accessible.onPressAction: acceptButton.clicked()
        Keys.onReturnPressed: acceptButton.clicked()
        Keys.onEnterPressed: acceptButton.clicked()

        onClicked: {
            if (enabled) {
                pageModel.onEnableDomainButtonClicked();
            }
        }
        buttonText: pageModel.isFirstRun ? _("WizardMacboxConsentPageEnableButtonTextFirstRun") : _("WizardMacboxConsentPageEnableButtonTextUpgrade")
    }
}

