/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/
import Colors 1.0
import QtQuick 2.7

// ActivityCenterMessage

Rectangle
{
    id: rootMessageRect

    readonly property int verticalPadding: 8
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

    height: visible ? calcHeight(messageInner.height + verticalPadding) : 0
    activeFocusOnTab: false
    color: colorThemeManager.highContrastEnabled ? Colors.activity_center.message.background_upsell : messageModel.backgroundColor
    border.color: activeFocus ? Colors.activity_center.error.border_alert_focus : "transparent"
    border.width: 1

    Accessible.role: Accessible.LayeredPane;
    Accessible.name: messageModel.primaryText + messageModel.secondaryText
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
            bottomPadding: (actionButtons.visible ? rootMessageRect.verticalPadding : 0)

            Text {
                id: messagePrimary
                color: colorThemeManager.highContrastEnabled ? Colors.common.text : messageModel.primaryTextColor
                text: messageModel.primaryText
                visible: (text !== "")
                height: visible ? undefined : 0
                font.family: "Segoe UI Semibold"
                font.pixelSize: 14
                anchors.left: messageTextGroup.left
                anchors.right: messageTextGroup.right
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
            }

            Text {
                id: messageSecondary
                color: colorThemeManager.highContrastEnabled ? Colors.common.text_secondary : messageModel.secondaryTextColor
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
                primarycolor: colorThemeManager.highContrastEnabled ? Colors.common.background        : messageModel.buttonOne.backgroundColor
                hovercolor:   colorThemeManager.highContrastEnabled ? Colors.activity_center.message.button_hovering   : messageModel.buttonOne.hoverColor
                pressedcolor: colorThemeManager.highContrastEnabled ? Colors.activity_center.message.button_pressed    : messageModel.buttonOne.pressedColor
                border.color: colorThemeManager.highContrastEnabled ?
                                  (mousearea.containsPress ? Colors.activity_center.message.button_border_pressed : (mousearea.containsMouse ? Colors.activity_center.message.button_border_hovering : Colors.activity_center.message.button_border)) :
                                  (mousearea.containsPress ? messageModel.buttonOne.borderPressedColor : (mousearea.containsMouse ? messageModel.buttonOne.borderHoverColor : messageModel.buttonOne.borderColor))
                focusunderline: true
                activeFocusOnTab: true

                textcontrol.font.pixelSize: 12
                textcontrol.color: colorThemeManager.highContrastEnabled ?
                                       (mousearea.containsPress ? Colors.activity_center.message.button_text_pressed : (mousearea.containsMouse ? Colors.activity_center.message.button_text_hovering : Colors.activity_center.message.button_text)) :
                                       (mousearea.containsPress ? messageModel.buttonOne.textPressedColor : (mousearea.containsMouse ? messageModel.buttonOne.textHoverColor : messageModel.buttonOne.textColor))
                textcontrol.text: messageModel.buttonOne.text
                textcontrol.font.family: "Segoe UI Semibold"
                textcontrol.topPadding: 4
                textcontrol.bottomPadding: 6
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
                primarycolor: colorThemeManager.highContrastEnabled ? Colors.common.background        : messageModel.buttonTwo.backgroundColor
                hovercolor:   colorThemeManager.highContrastEnabled ? Colors.activity_center.message.button_hovering   : messageModel.buttonTwo.hoverColor
                pressedcolor: colorThemeManager.highContrastEnabled ? Colors.activity_center.message.button_pressed    : messageModel.buttonTwo.pressedColor
                border.color: colorThemeManager.highContrastEnabled ?
                                  (mousearea.containsPress ? Colors.activity_center.message.button_border_pressed : (mousearea.containsMouse ? Colors.activity_center.message.button_border_hovering : Colors.activity_center.message.button_border)) :
                                  (mousearea.containsPress ? messageModel.buttonTwo.borderPressedColor : (mousearea.containsMouse ? messageModel.buttonTwo.borderHoverColor : messageModel.buttonTwo.borderColor))
                focusunderline: true
                activeFocusOnTab: true

                function isTransparent(color) {
                    if (color === "transparent")
                        return true;
                    if (color === "#00000000")
                         return true;
                    return false;
                }

                textcontrol.font.pixelSize: 12
                textcontrol.color: colorThemeManager.highContrastEnabled ?
                                       (mousearea.containsPress ? Colors.activity_center.message.button_text_pressed : (mousearea.containsMouse ? Colors.activity_center.message.button_text_hovering : Colors.activity_center.message.button_text)) :
                                       (mousearea.containsPress ? messageModel.buttonTwo.textPressedColor : (mousearea.containsMouse ? messageModel.buttonTwo.textHoverColor : messageModel.buttonTwo.textColor))
                textcontrol.text: messageModel.buttonTwo.text
                textcontrol.font.family: isTransparent(messageModel.buttonTwo.backgroundColor) ? "Segoe UI Regular" : "Segoe UI Semibold"
                textcontrol.topPadding: 4
                textcontrol.bottomPadding: 6
                textcontrol.leftPadding: 12
                textcontrol.rightPadding: 12
                textcontrol.font.bold: !isTransparent(messageModel.buttonTwo.backgroundColor)
                callback: rootMessageRect.secondaryActionCallback

                Accessible.name: textcontrol.text
                Accessible.ignored: !visible
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
        primarycolor:        Colors.activity_center.message.dismiss_button_primary
        hovercolor:          Colors.activity_center.message.dismiss_button_hovered
        pressedcolor:        Colors.activity_center.message.dismiss_button_pressed
        focuscolor:          Colors.activity_center.message.dismiss_button_focus_border
        activeFocusOnTab: true
        anchors.top: rootMessageRect.top
        anchors.right: rootMessageRect.right
        anchors.topMargin: 2
        anchors.rightMargin: anchors.topMargin + 2

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
