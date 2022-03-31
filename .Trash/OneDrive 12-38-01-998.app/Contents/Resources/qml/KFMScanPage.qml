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

    property string fullImageLocation: "file:///" + imageLocation

    WizardPageHeader {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        title.text: _("MoveWindowTitleScan")
        subtitle.visible: false
        image.visible: false
    }

    Rectangle {
        id: spinningRect
        anchors.centerIn: parent
        height: childrenRect.height

        width: parent.width
        visible: true
        color: "transparent"

        Image {
            id: spinningGraphic
            source: "file:///" + imageLocation + "loading_spinner.svg"
            sourceSize.height: 28
            sourceSize.width: 28

            Accessible.ignored: true

            anchors.horizontalCenter: parent.horizontalCenter

            NumberAnimation on rotation {
                id: rotationAnimation
                easing.type: Easing.InOutQuad
                from: -45
                to: 315
                duration: 1500
                loops: Animation.Infinite
                running: spinningGraphic.visible
            }
        }

        Text {
            id: spinningText
            text: _("SignInPageLoadingText")

            width: root.width - 40
            wrapMode: Text.WordWrap

            font.family: "Segoe UI"
            font.pixelSize: 14
            color: Colors.common.hyperlink

            horizontalAlignment: Text.Center
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: spinningGraphic.bottom
                topMargin: 4
            }

            Accessible.ignored: !spinningText.visible
            Accessible.role: Accessible.StaticText
            Accessible.name: spinningText.text
            Accessible.readOnly: true
            Accessible.focusable: true
        }
    }

    Text {
        id: longScanText
        text: _("MoveWindowLongScanText")
        visible: pageModel.isLongScan

        width: root.width - 40
        wrapMode: Text.WordWrap

        font.family: "Segoe UI"
        font.pixelSize: 14
         color: Colors.common.text_secondary

        horizontalAlignment: Text.Center
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: spinningRect.bottom
            topMargin: 40
        }

        Accessible.ignored: !visible
        Accessible.role: Accessible.StaticText
        Accessible.name: text
        Accessible.readOnly: true
        Accessible.focusable: true
    }
}
