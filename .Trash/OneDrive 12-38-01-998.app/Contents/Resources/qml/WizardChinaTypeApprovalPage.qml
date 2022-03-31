/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0
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

        title.text: _("CTAUpdateConsentHeaderPrimary")
        subtitle.text: _("CTAUpdateConsentHeaderSecondary")
        subtitle.horizontalAlignment: Text.AlignJustify
        subtitle.anchors.topMargin: 20
        subtitle.anchors.leftMargin: 52
        subtitle.anchors.rightMargin: 52
        image.source: "file:///" + imageLocation + "optionalDiagnosticData.svg"
        image.sourceSize.height: 190
        image.sourceSize.width: 405
        image.anchors.topMargin: 50
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
        Accessible.name: acceptButton.buttonText
        Accessible.onPressAction: acceptButton.clicked()
        Keys.onReturnPressed: acceptButton.clicked()
        Keys.onEnterPressed: acceptButton.clicked()

        onClicked: {
            pageModel.onAcceptButtonClicked();
        }
        buttonText: _("CTAUpdateConsentAcceptButton")
    }
}
