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

    function _(key)
    {
        return wizardWindow.getLocalizedMessage(key);
    }

    Text {
        id: heading
        text: pageModel.primaryText
        font.family: "Segoe UI Semibold"
        font.pixelSize: 28
        color: Colors.common.text

        horizontalAlignment: Text.Center
        anchors {
            top: parent.top
            topMargin: 30

            left: parent.left
            leftMargin: 61

            right: parent.right
            rightMargin: 61
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: heading.text
        Accessible.readOnly: true
    }

    TextWithLink {
        id: secondaryText
        embeddedLinkModel: pageModel.secondaryText
        font.family: "Segoe UI"
        font.pixelSize: 14
        color: Colors.common.text_secondary

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        anchors {
            top: heading.bottom
            topMargin: 9

            left: parent.left
            leftMargin: 61

            right: parent.right
            rightMargin: 61
        }

        onLinkActivated: pageModel.onLinkClicked()
        callback: pageModel.onLinkClicked()
    }

    Text {
        id: tertiaryText
        text: pageModel.tertiaryText
        font.family: "Segoe UI"
        font.pixelSize: 14
        color: Colors.common.text_secondary
        visible: (tertiaryText.text.length > 0)

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        anchors {
            top: secondaryText.bottom
            topMargin: 9

            left: parent.left
            leftMargin: 61

            right: parent.right
            rightMargin: 61
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: tertiaryText.text
        Accessible.readOnly: true
        Accessible.ignored: !tertiaryText.visible
    }

    FabricButton {
        id: primaryBtn
        visible: !pageModel.shouldHideEmailInput
        width: contentItem.paintedWidth + 40
        height: contentItem.paintedHeight + 12

        buttonText: pageModel.buttonText
        buttonRadius: 2

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30

        Accessible.role: Accessible.Button
        Accessible.name: primaryBtn.buttonText
        Accessible.ignored: !primaryBtn.visible
        Accessible.onPressAction: primaryBtn.clicked()
        Keys.onReturnPressed: primaryBtn.clicked()
        Keys.onEnterPressed:  primaryBtn.clicked()

        onClicked: pageModel.onPrimaryButtonClicked()
    }
}
