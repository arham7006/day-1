/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/
import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQml 2.2

/*
Component representing button of the feedback type selection.
Caller is expected to set following properties:
   - primaryText - one line text explaining selection
   - secondaryText - text providing more details on selection
   - iconSymbol - single character string used as an button icon (e.g. like)
   - iconColor - color for the iconSymbol
   - callback - function called once user clicks button
*/

Button {
    id: root
    property string primaryText
    property string secondaryText
    property string iconSymbol
    property string iconColor
    property var callback: genericCallback

    Keys.onReturnPressed: doCallback(true);
    Keys.onEnterPressed: doCallback(true);
    Keys.onSpacePressed: doCallback(true);

    function genericCallback()
    {
    }

    function doCallback(isKeyboard)
    {
        if (typeof(callback) === "function")
        {
            callback(isKeyboard);
        }
    }

    Accessible.onPressAction: doCallback(true);

    background: Rectangle {
        border.width: (root.activeFocus || root.hovered) ? 1 : 0
        border.color: Colors.move_window.folderItemBorderColor
        color : root.hovered ? Colors.fabric_button.standard.hovered : Colors.common.background
    }

    onClicked: doCallback(false)
    text: primaryText

    // Purely to change cursor shape
    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        onPressed:  mouse.accepted = false
        cursorShape:  Qt.PointingHandCursor
    }

    FontLoader {
        id: assets
        source: Qt.platform.os === "osx" ? "FabExMDL2.ttf" : "file:///" + qmlEngineBasePath + "FabExMDL2.ttf"
    }

    contentItem: Column {
        id: contentColumn
        anchors.left: parent.left
        anchors.right: parent.right
        height: actionRow.height + icon.bottomPadding + explanationText.height

        Item {
            id: actionRow
            height: Math.max(labelText.height, icon.height)
            width: parent.width
            anchors.left: parent.left

            Text {
                id: icon
                anchors {
                    top: parent.top
                    left: parent.left
                }
                padding: 10
                bottomPadding: 4

                text: iconSymbol
                color: iconColor
                font.pixelSize: 22
                font.family: assets.name
            }

            Text {
                id: labelText
                anchors {
                    top: parent.top
                    left: icon.right
                    right: actionRow.right
                }
                topPadding: 8
                text: primaryText
                font.family: "Segoe UI"
                font.pixelSize: 18
                color: Colors.common.text
                wrapMode: Text.WordWrap

                Accessible.role: Accessible.StaticText
                Accessible.name: text
                Accessible.readOnly: true
            }
        }

        Text {
            id: explanationText
            text: secondaryText
            leftPadding: 10
            rightPadding: 10
            bottomPadding: 10
            topPadding: 4
            width: parent.width
            height: contentHeight + topPadding + bottomPadding
            font.family: "Segoe UI"
            font.pixelSize: 12
            color: Colors.common.text
            wrapMode: Text.WordWrap
            anchors.left: parent.left

            Accessible.role: Accessible.StaticText
            Accessible.name: text
            Accessible.readOnly: true
        }
    }
}
