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

    Text {
        id: primaryText
        text: _("VaultIntroPagePrimaryText")
        font.family: "Segoe UI Semibold"
        font.pixelSize: 24
        color: Colors.activity_center.header.normal

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right

            topMargin: 28
            leftMargin: 40
            rightMargin: 40
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: primaryText.text
        Accessible.readOnly: true
    }

    Text {
        id: secondaryText
        text: _("VaultIntroPageSecondaryText")
        font.family: "Segoe UI"
        font.pixelSize: 15
        color: Colors.common.text_secondaryAlt

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        anchors {
            top: primaryText.bottom
            left: parent.left
            right: parent.right

            topMargin: 8
            leftMargin: 80
            rightMargin: 80
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: secondaryText.text
        Accessible.readOnly: true
    }

    Column {
        id: bullets
        height: childrenRect.height
        anchors {
            top: secondaryText.bottom
            left: parent.left
            right: parent.right

            topMargin: 41
            leftMargin: 46
            rightMargin: 44
        }

        spacing: 24

        Row {
            id: firstBullet
            height: Math.max(firstBulletIcon.paintedHeight, firstBulletText.paintedHeight)
            width: parent.width
            spacing: 16

            Image {
                id: firstBulletIcon
                source: fullImageLocation + "lock_icon.svg"
                sourceSize.height: 52
                sourceSize.width: 52

                verticalAlignment: Image.AlignVCenter

                Accessible.ignored: true
            }

            Text {
                id: firstBulletText
                width: (firstBullet.width - firstBulletIcon.paintedWidth - firstBullet.spacing)
                text: _("VaultIntroPageFirstBullet")
                font.family: "Segoe UI"
                font.pixelSize: 16
                color: Colors.common.text

                wrapMode: Text.WordWrap
                anchors.verticalCenter: firstBulletIcon.verticalCenter

                Accessible.role: Accessible.StaticText
                Accessible.name: firstBulletText.text
                Accessible.readOnly: true
            }
        }

        Row {
            id: secondBullet
            height: Math.max(secondBulletIcon.paintedHeight, secondBulletText.paintedHeight)
            width: parent.width
            spacing: 16

            Image {
                id: secondBulletIcon
                source: fullImageLocation + "clock_icon.svg"
                sourceSize.height: 52
                sourceSize.width: 52

                verticalAlignment: Image.AlignVCenter

                Accessible.ignored: true
            }

            Text {
                id: secondBulletText
                width: (secondBullet.width - secondBulletIcon.paintedWidth - secondBullet.spacing)
                text: _("VaultIntroPageSecondBullet")
                font.family: "Segoe UI"
                font.pixelSize: 16
                color: Colors.common.text

                wrapMode: Text.WordWrap
                anchors.verticalCenter: secondBulletIcon.verticalCenter

                Accessible.role: Accessible.StaticText
                Accessible.name: secondBulletText.text
                Accessible.readOnly: true
            }
        }

        Row {
            id: thirdBullet
            height: Math.max(thirdBulletIcon.paintedHeight, thirdBulletText.paintedHeight)
            width: parent.width
            spacing: 16

            Image {
                id: thirdBulletIcon
                source: fullImageLocation + "fileLockIcon.svg"
                sourceSize.height: 52
                sourceSize.width: 52

                verticalAlignment: Image.AlignVCenter

                Accessible.ignored: true
            }

            Text {
                id: thirdBulletText
                width: (thirdBullet.width - thirdBulletIcon.paintedWidth - thirdBullet.spacing)
                text: _("VaultIntroPageThirdBullet")
                font.family: "Segoe UI"
                font.pixelSize: 16
                color: Colors.common.text

                wrapMode: Text.WordWrap
                anchors.verticalCenter: thirdBulletIcon.verticalCenter

                Accessible.role: Accessible.StaticText
                Accessible.name: thirdBulletText.text
                Accessible.readOnly: true
            }
        }
    }

    FabricButton {
        id: nextBtn
        width: nextBtn.contentItem.paintedWidth + 50
        height: contentItem.paintedHeight + 12

        buttonText: _("VaultIntroPageNextButton")
        focus: true

        anchors {
            bottom: parent.bottom
            right: parent.right

            bottomMargin: 20
            rightMargin: 24
        }

        Accessible.role: Accessible.Button
        Accessible.name: nextBtn.buttonText
        Accessible.onPressAction: nextBtn.clicked()
        Keys.onReturnPressed: nextBtn.clicked()
        Keys.onEnterPressed:  nextBtn.clicked()

        onClicked: pageModel.onNextButtonClicked()
    }
}
