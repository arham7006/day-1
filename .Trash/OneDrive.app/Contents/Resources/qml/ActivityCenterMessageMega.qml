/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/
import Colors 1.0
import QtQuick 2.7
import QtQuick.Window 2.2

import com.microsoft.OneDrive 1.0

// ActivityCenterMessageMega

Rectangle
{
    id: rootMessageRect

    readonly property int verticalPadding: 20
    readonly property int verticalPaddingLarge: 12
    readonly property int horizontalPadding: 12

    property alias dismissButton: dismissButton

    property var primaryActionCallback: defaultCallback
    property var secondaryActionCallback: defaultCallback

    function defaultCallback() {
        console.log("ActivityCenterMessageMega: no click handler set");
    }

    function calcHeight(childrenHeight) {
        if (childrenHeight < 68) {
            return 68;
        } else {
            return childrenHeight;
        }
    }

    height:               visible ? calcHeight(messageInner.height + verticalPadding) : 0
    activeFocusOnTab:     false
    color:                colorThemeManager.highContrastEnabled ? Colors.activity_center.message.background_upsell
                                                           : messageModel.backgroundColor
    border.color:         activeFocus ? Colors.activity_center.error.border_alert_focus
                                      : "transparent"
    border.width:         1
    Accessible.role:      Accessible.LayeredPane;
    Accessible.name:      messageModel.primaryText +
                          messageModel.secondaryText
    Accessible.focusable: true
    Accessible.ignored:   !(visible || headerModel.showHiddenNodesInAccTree)

    Rectangle {
        id:                  messageInner
        anchors.top:         parent.top
        anchors.topMargin:   verticalPadding
        anchors.left:        parent.left
        anchors.leftMargin:  horizontalPadding
        anchors.right:       parent.right
        anchors.rightMargin: horizontalPadding
        color:               "transparent"
        height:              childrenRect.height

        Rectangle {
            id:            messageTextGroup
            anchors.left:  parent.left
            anchors.right: parent.right
            anchors.top:   parent.top
            height:        childrenRect.height
            color:         colorThemeManager.highContrastEnabled ? Colors.activity_center.message.background_upsell
                                                            : messageModel.backgroundColor
            Text {
                id:                  messagePrimary
                text:                messageModel.primaryText
                font.family:         "Segoe UI Semibold"
                font.pixelSize:      15
                anchors.top:         parent.top
                anchors.left:        parent.left
                anchors.right:       parent.right
                anchors.leftMargin:  horizontalPadding
                anchors.rightMargin: horizontalPadding
                wrapMode:            Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment:   Text.AlignTop       
                color:               colorThemeManager.highContrastEnabled ?
                                         Colors.common.text :
                                         messageModel.primaryTextColor
            }
            
            // OneRM uses an animated GIF for one of their message sources. To handle animations, use AnimatedImage. 
            // AnimatedImage extends the Image qml element such that it can handle both static and animated image formats
            // NOTE on battery drain and Animations: we need to explicitly disable the animation
            // the the window is hidden (the Window.visibility attached property is Window.Hidden)
            AnimatedImage {
                id:                  megaModeImage
                fillMode:            Image.PreserveAspectFit
                source:              messageModel.imageSource
                anchors.top:         messagePrimary.bottom
                anchors.left:        parent.left
                anchors.right:       parent.right
                anchors.topMargin:   verticalPaddingLarge
            }

            Text {
                id:                  messageSecondary
                text:                messageModel.secondaryText
                font.pixelSize:      12
                anchors.top:         megaModeImage.bottom
                anchors.left:        parent.left
                anchors.right:       parent.right
                anchors.topMargin:   verticalPaddingLarge
                anchors.leftMargin:  horizontalPadding
                anchors.rightMargin: horizontalPadding
                font.family:         "Segoe UI Semilight"
                wrapMode:            Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                color:               colorThemeManager.highContrastEnabled ?
                                         Colors.common.text_secondary :
                                         messageModel.secondaryTextColor
            }

            Window.onVisibilityChanged : {
                if (Window.visibility === Window.Hidden) {
                    megaModeImage.playing = false;
                } else {
                    megaModeImage.playing = true;
                }
            }
        }

        Rectangle {
            id:                 actionButtons
            color:              "transparent"
            objectName:         "actionButtons"
            anchors.top :       messageTextGroup.bottom
            anchors.left:       messageTextGroup.left
            anchors.right:      messageTextGroup.right
            // We DO NOT need top margin if only button two is visible because the padding within the button is more than enough space
            anchors.topMargin:  (!buttonOne.visible && buttonTwo.visible) ? 0 : 16
            // We need to increase the height if only button one is visible so that the button does not sit on the edge of the rectangle
            height:             childrenRect.height + (buttonOne.visible && !buttonTwo.visible ? verticalPadding : 0)

            SimpleButton {
                id:                 buttonOne
                visible:            messageModel.buttonOne.isVisible
                Accessible.name:    textcontrol.text
                Accessible.ignored: !visible
                callback:           rootMessageRect.primaryActionCallback
                height:             visible ? 32 : 0
                focusunderline:     true
                activeFocusOnTab:   true
                width:              visible ? ((textcontrol.width > 80) ? textcontrol.width : 80) : 0

                primarycolor: colorThemeManager.highContrastEnabled ? Colors.common.background        : messageModel.buttonOne.backgroundColor
                hovercolor:   colorThemeManager.highContrastEnabled ? Colors.activity_center.message.button_hovering   : messageModel.buttonOne.hoverColor
                pressedcolor: colorThemeManager.highContrastEnabled ? Colors.activity_center.message.button_pressed    : messageModel.buttonOne.pressedColor
                border.color: colorThemeManager.highContrastEnabled ?
                                  (mousearea.containsPress ? Colors.activity_center.message.button_border_pressed : (mousearea.containsMouse ? Colors.activity_center.message.button_border_hovering : Colors.activity_center.message.button_border)) :
                                  (mousearea.containsPress ? messageModel.buttonOne.borderPressedColor : (mousearea.containsMouse ? messageModel.buttonOne.borderHoverColor : messageModel.buttonOne.borderColor))

                anchors.top:                parent.top
                anchors.horizontalCenter:   parent.horizontalCenter
                textcontrol.text:           messageModel.buttonOne.text
                textcontrol.font.pixelSize: 12
                textcontrol.font.family:    "Segoe UI Semibold"
                textcontrol.topPadding:     4
                textcontrol.bottomPadding:  6
                textcontrol.leftPadding:    16
                textcontrol.rightPadding:   16
                textcontrol.color:          colorThemeManager.highContrastEnabled ?
                                                (mousearea.containsPress ? Colors.activity_center.message.button_text_pressed : (mousearea.containsMouse ? Colors.activity_center.message.button_text_hovering : Colors.activity_center.message.button_text)) :
                                                (mousearea.containsPress ? messageModel.buttonOne.textPressedColor : (mousearea.containsMouse ? messageModel.buttonOne.textHoverColor : messageModel.buttonOne.textColor))
            }

            SimpleButton {
                id:                 buttonTwo
                visible:            messageModel.buttonTwo.isVisible
                Accessible.name:    textcontrol.text
                Accessible.ignored: !visible
                callback:           rootMessageRect.secondaryActionCallback
                height:             visible ? 32 : 0
                focusunderline:     true
                activeFocusOnTab:   true
                width:              visible ? ((textcontrol.width > 80) ? textcontrol.width : 80) : 0

                primarycolor: colorThemeManager.highContrastEnabled ? Colors.common.background        : messageModel.buttonTwo.backgroundColor
                hovercolor:   colorThemeManager.highContrastEnabled ? Colors.activity_center.message.button_hovering   : messageModel.buttonTwo.hoverColor
                pressedcolor: colorThemeManager.highContrastEnabled ? Colors.activity_center.message.button_pressed    : messageModel.buttonTwo.pressedColor
                border.color: colorThemeManager.highContrastEnabled ?
                                  (mousearea.containsPress ? Colors.activity_center.message.button_border_pressed : (mousearea.containsMouse ? Colors.activity_center.message.button_border_hovering : Colors.activity_center.message.button_border)) :
                                  (mousearea.containsPress ? messageModel.buttonTwo.borderPressedColor : (mousearea.containsMouse ? messageModel.buttonTwo.borderHoverColor : messageModel.buttonTwo.borderColor))

                function isTransparent(color) {
                    if (color === "transparent")
                        return true;
                    if (color === "#00000000")
                         return true;
                    return false;
                }

                anchors.top :               buttonOne.bottom
                anchors.horizontalCenter:   parent.horizontalCenter
                textcontrol.font.pixelSize: 12
                textcontrol.text:           messageModel.buttonTwo.text
                textcontrol.font.family:    isTransparent(messageModel.buttonTwo.backgroundColor) ? "Segoe UI Regular" : "Segoe UI Semibold"
                textcontrol.font.bold:      !isTransparent(messageModel.buttonTwo.backgroundColor)
                textcontrol.topPadding:     isTransparent(messageModel.buttonTwo.backgroundColor) ? 0 : 4
                textcontrol.bottomPadding:  isTransparent(messageModel.buttonTwo.backgroundColor) ? 0 : 4
                textcontrol.leftPadding:    isTransparent(messageModel.buttonTwo.backgroundColor) ? 0 : 8
                textcontrol.rightPadding:   isTransparent(messageModel.buttonTwo.backgroundColor) ? 0 : 8
                textcontrol.color:          colorThemeManager.highContrastEnabled ?
                                                (mousearea.containsPress ? Colors.activity_center.message.button_text_pressed : (mousearea.containsMouse ? Colors.activity_center.message.button_text_hovering : Colors.activity_center.message.button_text)) :
                                                (mousearea.containsPress ? messageModel.buttonTwo.textPressedColor : (mousearea.containsMouse ? messageModel.buttonTwo.textHoverColor : messageModel.buttonTwo.textColor))
            }
        }
    }

    SimpleButton {
        id:                  dismissButton
        objectName:          "dismissButton"

        visible:             parent.visible && !headerModel.isError && !messageModel.shouldHideDismiss
        enabled:             visible
        width:               16
        height:              16
        primarycolor:        Colors.activity_center.message.dismiss_button_primary
        hovercolor:          Colors.activity_center.message.dismiss_button_hovered
        pressedcolor:        Colors.activity_center.message.dismiss_button_pressed
        focuscolor:          Colors.activity_center.message.dismiss_button_focus_border
        activeFocusOnTab:    true
        anchors.top:         rootMessageRect.top
        anchors.right:       rootMessageRect.right
        anchors.topMargin:   2
        anchors.rightMargin: anchors.topMargin + 2

        useImage:            true
        imagecontrol.source: "file:///" + imageLocation + "acmDismissIcon.svg"
        imagecontrol.width:  8
        imagecontrol.height: 8
        imagecontrol.sourceSize.width:  8
        imagecontrol.sourceSize.height: 8

        Accessible.name:    messageModel.dismissHint
        Accessible.ignored: !(visible || headerModel.showHiddenNodesInAccTree)
    }
}
