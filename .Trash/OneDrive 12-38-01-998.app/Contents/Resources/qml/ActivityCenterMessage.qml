/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/
import Colors 1.0
import "palettes.js" as Palettes;
import QtQuick 2.7

// ActivityCenterMessage
Rectangle
{
    id: rootMessageRect

    readonly property int verticalPadding: 16
    readonly property int horizontalPadding: 12

    property alias dismissButton: dismissButton

    property var primaryActionCallback: defaultCallback
    property var secondaryActionCallback: defaultCallback

    function defaultCallback() {
        console.log("ActivityCenterMessage: no click handler set");
    }

    function calcHeight(childrenHeight) {
        if (childrenHeight < 68) {
            return 68;
        } else {
            return childrenHeight;
        }
    }

    property variant messageColors: ({})
    property QtObject colorScheme: null

    height: visible ? calcHeight(messageInner.height + verticalPadding) : 0
    activeFocusOnTab: false
    color: messageColors['message'].background
    border.color: activeFocus ? Colors.activity_center.error.border_alert_focus : "transparent"
    border.width: 1

    Accessible.role: Accessible.LayeredPane;
    Accessible.name: messageModel.primaryAccessibleText + " " + messageModel.secondaryAccessibleText
    Accessible.focusable: true
    Accessible.ignored: !(rootMessageRect.visible || headerModel.showHiddenNodesInAccTree)

    Rectangle {
        id: messageInner
        anchors.top: parent.top
        anchors.topMargin: rootMessageRect.verticalPadding
        anchors.left: parent.left
        anchors.leftMargin: rootMessageRect.horizontalPadding
        anchors.right: parent.right
        anchors.rightMargin: rootMessageRect.horizontalPadding
        height: messageTextGroup.height + actionButtons.height + rootMessageRect.verticalPadding
        color: "transparent"

        Image {
            id: messageIcon
            width: 48
            height: 48
            sourceSize.width: 48
            sourceSize.height: 48
            anchors.left: parent.left
            anchors.top: parent.top
            fillMode: Image.PreserveAspectFit
            source: messageModel.imageSource
        }

        Column {
            id: messageTextGroup
            anchors.left: messageIcon.right
            anchors.leftMargin: rootMessageRect.horizontalPadding
            anchors.right : parent.right
            anchors.top: parent.top
            bottomPadding: (actionButtons.visible ? 12 : 0)
            spacing: 2
            
            Text {
                id: messagePrimary
                color: messageColors['message'].primary_text
                text: messageModel.primaryText
                visible: (text !== "")
                height: visible ? undefined : 0
                font.family: "Segoe UI Semibold"
                font.pixelSize: 15
                anchors.left: messageTextGroup.left
                anchors.right: messageTextGroup.right
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
            }

            Text {
                id: messageSecondary
                color: messageColors['message'].secondary_text
                text: messageModel.secondaryText
                visible: (text !== "")
                height: visible ? undefined : 0
                font.pixelSize: 12
                anchors.left: messageTextGroup.left
                anchors.right: messageTextGroup.right
                font.family: "Segoe UI Semilight"
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
            }
        }

        Flow {
            id: actionButtons
            objectName: "actionButtons"
            spacing: 8
            anchors.top: messageTextGroup.bottom
            anchors.left: messageTextGroup.left
            anchors.right: messageTextGroup.right

            visible: messageModel.buttonOne.isVisible || messageModel.buttonTwo.isVisible
            height: visible ? undefined : 0

            SimpleButton {
                id: buttonOne
                visible: messageModel.buttonOne.isVisible
                width: visible ? ((textcontrol.width > 80) ? textcontrol.width : 80) : 0
                height: visible ? 32 : 0

                colorScheme: messageColors['button_one']

                focusunderline: true
                activeFocusOnTab: true

                textcontrol.font.pixelSize: 12
                textcontrol.text: messageModel.buttonOne.text
                textcontrol.font.family: "Segoe UI Semibold"
                textcontrol.topPadding: 5
                textcontrol.bottomPadding: 5
                textcontrol.leftPadding: 12
                textcontrol.rightPadding: 12
                callback: rootMessageRect.primaryActionCallback

                Accessible.name: textcontrol.text
                Accessible.ignored: !visible
            }

            SimpleButton {
                id: buttonTwo
                visible: messageModel.buttonTwo.isVisible
                width: visible ? ((textcontrol.width > 80) ? textcontrol.width : 80) : 0
                height: visible ? 32 : 0

                colorScheme: messageColors['button_two']
                property bool isTransparent: (colorScheme.button === "transparent" ||
                                              colorScheme.button === Palettes.Basic.transparentHex)

                focusunderline: true
                activeFocusOnTab: true

                textcontrol.font.pixelSize: 12
                textcontrol.text: messageModel.buttonTwo.text
                textcontrol.font.family: isTransparent ? "Segoe UI Regular" : "Segoe UI Semibold"
                textcontrol.topPadding: 4
                textcontrol.bottomPadding: 6
                textcontrol.leftPadding: 12
                textcontrol.rightPadding: 12
                textcontrol.font.bold: !isTransparent
                callback: rootMessageRect.secondaryActionCallback

                Accessible.name: textcontrol.text
                Accessible.ignored: !visible

                // If the button has a transparent background, it will look more like a link than a button.
                // Adjust its accessibility role accordingly to reflect the semantics of its appearance.
                Accessible.role: isTransparent ? Accessible.Link : Accessible.Button
            }
        }
    }

    SimpleButton {
        id: dismissButton
        objectName: "dismissButton"

        visible: !messageModel.shouldHideDismiss
        enabled: visible
        width: 16
        height: 16
        primarycolor:        Colors.activity_center.message_dismiss.primary
        hovercolor:          Colors.activity_center.message_dismiss.hovered
        pressedcolor:        Colors.activity_center.message_dismiss.pressed
        focuscolor:          Colors.activity_center.message_dismiss.focus_border
        activeFocusOnTab: true
        anchors.top: rootMessageRect.top
        anchors.right: rootMessageRect.right
        anchors.topMargin: 2
        anchors.rightMargin: anchors.topMargin

        useImage: true
        imagecontrol.source: "file:///" + imageLocation + "acmDismissIcon.svg"
        imagecontrol.width: 8
        imagecontrol.height: 8
        imagecontrol.sourceSize.width:  8
        imagecontrol.sourceSize.height: 8

        Accessible.name: messageModel.dismissHint
        Accessible.ignored: !(visible || headerModel.showHiddenNodesInAccTree)
    }
}
