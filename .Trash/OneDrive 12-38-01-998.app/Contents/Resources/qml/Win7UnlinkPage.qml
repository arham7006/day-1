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

    onVisibleChanged: { if (visible) viewActivityCenterButton.forceActiveFocus(); }

    WizardPageHeader {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        title.text: _("Win7UnlinkTitle")
        subtitle.text: _("Win7UnlinkSecondaryText")
        subtitle.anchors.leftMargin: 24
        subtitle.anchors.rightMargin: 24

        image.visible: false
    }

    Rectangle {
        id: imageRect
        height: finishSyncingRect.height
        width: parent.width
        color: "transparent"

        Accessible.ignored: true

        anchors {
            top: header.bottom
            topMargin: 40

            right: parent.right
            rightMargin: 45

            left: parent.left
            leftMargin: 45
        }

        Rectangle {
            id: finishSyncingRect
            width: finishSyncingImage.paintedWidth
            height: childrenRect.height
            color: "transparent"

            anchors {
                top: parent.top
                left: parent.left
            }

            Image {
                id: finishSyncingImage
                source: fullImageLocation + "win7_unlink-1.svg"

                sourceSize.height: 110
                sourceSize.width: 257

                anchors {
                    top: parent.top
                }
            }

            Text {
                text: _("Win7UnlinkStep1Text")
                font.family: "Segoe UI"
                font.pixelSize: 14
                font.italic: true
                color: Colors.common.text_secondary

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: finishSyncingImage.bottom
                anchors.topMargin: 12
            }
        }

        Rectangle {
            id: unlinkRect
            width: unlinkImage.paintedWidth
            height: childrenRect.height
            color: "transparent"

            anchors {
                top: parent.top
                right: parent.right
            }

            Image {
                id: unlinkImage
                source: fullImageLocation + "win7_unlink-2.svg"

                sourceSize.height: 110
                sourceSize.width: 180

                anchors {
                    top: parent.top
                }
            }

            Text {
                text: _("Win7UnlinkStep2Text")
                font.family: "Segoe UI"
                font.pixelSize: 14
                font.italic: true
                color: Colors.common.text_secondary

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: unlinkImage.bottom
                anchors.topMargin: 12
            }
        }
    }

    Text {
        id: infoAreaText
        anchors {
            top: imageRect.bottom
            topMargin: 40

            left: parent.left
            leftMargin: 24

            right: parent.right
            rightMargin: 24
        }

        text: _("Win7UnlinkInfoAreaText")

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
        height: viewActivityCenterButton.height

        anchors {
            bottom: parent.bottom
            bottomMargin: 32

            left: parent.left
            leftMargin: 24

            right: parent.right
            rightMargin: 24
        }

        FabricButton {
            id: openSettingsButton
            onClicked: pageModel.onOpenSettings()
            buttonText: _("OpenSettingsButtonText")
            buttonStyle: "secondary"

            anchors {
                verticalCenter: parent.verticalCenter
                right: viewActivityCenterButton.left
                rightMargin: 16
            }

            Accessible.onPressAction: onClicked()
            Keys.onEnterPressed: onClicked()
            Keys.onReturnPressed: onClicked()
            Keys.onSpacePressed: onClicked()
        }

        FabricButton {
            id: viewActivityCenterButton
            onClicked: pageModel.onViewSyncProgress()
            buttonText: _("MoveWindowFinishedButtonText")

            Accessible.role: Accessible.Button
            Accessible.name: _("MoveWindowFinishedButtonText")
            Accessible.onPressAction: pageModel.onViewSyncProgress()

            Keys.onReturnPressed: viewActivityCenterButton.clicked()
            Keys.onEnterPressed:  viewActivityCenterButton.clicked()

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 8
            }
        }
    }
}
