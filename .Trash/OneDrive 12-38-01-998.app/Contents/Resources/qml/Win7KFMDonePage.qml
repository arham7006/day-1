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
    anchors.fill: parent
    color: "transparent"

    onVisibleChanged: { if (visible) nextButton.forceActiveFocus(); }

    WizardPageHeader {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        title.text: _("Win7MoveWindowTitleDone")
        subtitle.text: _("Win7MoveWindowSecondaryTextDone")
        image.source: fullImageLocation + "win7_kfm_done.svg"
        image.height: 188
        image.width: 410

        image.sourceSize.height: 188
        image.sourceSize.width: 410

        image.anchors.topMargin: 40
    }

    Text {
        id: infoAreaText
        anchors {
            top: header.bottom
            topMargin: 20

            left: parent.left
            leftMargin: 24

            right: parent.right
            rightMargin: 24
        }

        text: _("Win7MoveWindowInfoAreaDone")

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap

        font.family: "Segoe UI"
        font.pixelSize: 14
        color: Colors.common.text_secondary

        Accessible.role: Accessible.StaticText
        Accessible.name: infoAreaText.text
        Accessible.readOnly: true
    }

    Rectangle {
        id: footerSection
        color: Colors.common.background
        height: nextButton.height

        anchors {
            bottom: parent.bottom
            bottomMargin: 32

            left: parent.left
            leftMargin: 24

            right: parent.right
            rightMargin: 24
        }

        FabricButton {
            id: viewActivityCenterButton
            onClicked: pageModel.onViewSyncProgress()
            buttonText: _("MoveWindowFinishedButtonText")
            buttonStyle: "secondary"

            anchors {
                verticalCenter: parent.verticalCenter
                right: nextButton.left
                rightMargin: 16
            }

            Accessible.onPressAction: onClicked()
            Keys.onEnterPressed: onClicked()
            Keys.onReturnPressed: onClicked()
            Keys.onSpacePressed: onClicked()
        }

        FabricButton {
            id: nextButton
            onClicked: pageModel.onNextButtonClicked()
            buttonText: _("FirstRunNextButton")

            Accessible.role: Accessible.Button
            Accessible.name: _("FirstRunNextButton")
            Accessible.onPressAction: pageModel.onNextButtonClicked()

            Keys.onReturnPressed: nextButton.clicked()
            Keys.onEnterPressed:  nextButton.clicked()

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 8
            }
        }
    }
}
