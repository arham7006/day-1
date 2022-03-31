/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/
import Colors 1.0
import QtQml 2.2
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

// InfoBarWithDismissButton
//
// Represents a layout of icon, text including title and subtext and dismiss button.
// Consumers need to define the following when adding it:
//   icon.source
//   infoPrimary.text
//   infoSecondary.text
//   dismissButtonCallback
//   dismissButtonAccessibleName

Rectangle {
    id: bar

    property alias image: icon
    property alias primaryText: infoPrimary
    property alias secondaryText: infoSecondary
    property alias dismissButton: button
    property var dismissButtonCallback: dismissButtonCallback
    property string dismissButtonAccessibleName: ""

    readonly property int rootLevelHorizontalPadding: 16

    height: visible ? 64 : 0
    anchors.left: parent.left
    anchors.right: parent.right

    Accessible.role: Accessible.StaticText;
    Accessible.name: infoPrimary.text + ";" + infoSecondary.text
    Accessible.focusable: true
    Accessible.ignored: !visible
    Accessible.readOnly: true

    Image {
        id: icon
        width: 32
        height: 32
        sourceSize.width:  48
        sourceSize.height: 48
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: rootLevelHorizontalPadding
        fillMode: Image.PreserveAspectFit
    }

    Column {
        id: textGroup
        anchors.left: icon.right
        anchors.leftMargin: rootLevelHorizontalPadding
        anchors.right : parent.right
        anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2

        Text {
            id: infoPrimary
            width: parent.width
            color: Colors.common.text
            visible: (text.length > 0)
            font.family: "Segoe UI Semibold"
            font.pixelSize: 15
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
        }

        Text {
            id: infoSecondary
            width: parent.width
            color: Colors.common.text
            visible: (text.length > 0)
            font.pixelSize: 12
            font.family: "Segoe UI"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
        }
    }

    SimpleButton {
        id:                  button
        objectName:          "dismissButton"
        z: 1

        visible:             parent.visible
        enabled:             visible
        width:               9
        height:              9
        primarycolor:        Colors.version_window.message_dismiss.primary
        hovercolor:          Colors.version_window.message_dismiss.hovered
        pressedcolor:        Colors.version_window.message_dismiss.pressed
        focuscolor:          Colors.version_window.message_dismiss.focus_border
        activeFocusOnTab:    true
        anchors.top:         parent.top
        anchors.right:       parent.right
        anchors.topMargin:   9
        anchors.rightMargin: 12

        useImage:            true
        imagecontrol.source: "file:///" + imageLocation + "acmDismissIcon.svg"
        imagecontrol.width:  8
        imagecontrol.height: 8
        imagecontrol.sourceSize.width:  8
        imagecontrol.sourceSize.height: 8

        callback: dismissButtonCallback

        Accessible.name: dismissButtonAccessibleName
        Accessible.ignored: !visible
    }
}
