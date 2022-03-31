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

    Image {
        id: adminRequestImage
        source: fullImageLocation + "lock_graphic.svg"
        sourceSize.height: 120
        sourceSize.width: 120

        anchors {
            top: parent.top
            topMargin: 68
            horizontalCenter: parent.horizontalCenter
        }

        Accessible.ignored: true
    }

    Text {
        id: primaryText
        text: _("VaultAdminPagePrimaryText")
        font.family: "Segoe UI Semibold"
        font.pixelSize: 24
        color: Colors.common.text

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        anchors {
            top: adminRequestImage.bottom
            topMargin: 44

            left: parent.left
            leftMargin: 40

            right: parent.right
            rightMargin: 40
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: primaryText.text
        Accessible.readOnly: true
    }

    Text {
        id: secondaryText
        text: _("VaultAdminPageSecondaryText")
        font.family: "Segoe UI"
        font.pixelSize: 15
        color: Colors.common.text_secondaryAlt

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        anchors {
            top: primaryText.bottom
            topMargin: 8

            left: parent.left
            leftMargin: 40

            right: parent.right
            rightMargin: 40
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: secondaryText.text
        Accessible.readOnly: true
    }

    FabricButton {
        id: allowBtn
        width: allowBtn.contentItem.paintedWidth + 50
        height: contentItem.paintedHeight + 12
        enabled: !pageModel.shouldDisableButton

        buttonText: _("VaultAdminPageButtonText")
        focus: true

        anchors {
            bottom: parent.bottom
            right: parent.right

            bottomMargin: 20
            rightMargin: 24
        }

        Accessible.role: Accessible.Button
        Accessible.name: allowBtn.buttonText
        Accessible.onPressAction: allowBtn.clicked()
        Keys.onReturnPressed: allowBtn.clicked()
        Keys.onEnterPressed:  allowBtn.clicked()

        onClicked: pageModel.onAllowButtonClicked()
    }
}
