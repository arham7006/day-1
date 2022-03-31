/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7

Rectangle {
    id: root
    color: Colors.common.background

    property alias title: titleText

    height: titleText.height + titleText.anchors.topMargin + titleText.anchors.bottomMargin

    Text {
        id: titleText
        wrapMode: Text.WordWrap
        color: Colors.send_feedback.title_text
        font.family: "Segoe UI"
        font.pixelSize: 20
        font.weight: Font.Light
        leftPadding: 22
        rightPadding: 22

        Accessible.role: Accessible.StaticText
        Accessible.name: text
        Accessible.readOnly: true
        Accessible.focusable: true
        Accessible.headingLevel: Accessible.HeadingLevel1

        anchors {
            top: parent.top
            topMargin: 16
            left: parent.left
            bottomMargin: 10
        }
    }
}
