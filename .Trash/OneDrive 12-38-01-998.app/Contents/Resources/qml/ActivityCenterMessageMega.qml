/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/
import Colors 1.0
import QtQuick 2.7
import QtQuick.Window 2.2

import com.microsoft.OneDrive 1.0
import "palettes.js" as Palettes;

// ActivityCenterMessageMega

Rectangle
{
    id: rootMessageRect

    readonly property int verticalPadding: 20
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

    property variant messageColors: ({})

    height:               visible ? childrenRect.height : 0
    activeFocusOnTab:     false
    color:                messageColors['message'].background
    border.color:         activeFocus ? Colors.activity_center.error.border_alert_focus : "transparent"
    border.width:         1
    Accessible.role:      Accessible.LayeredPane;
    Accessible.name:      messageModel.primaryAccessibleText + " " + messageModel.secondaryAccessibleText
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
            color:         messageColors['message'].background

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
                color:               messageColors['message'].primary_text
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
                anchors.topMargin:   12
            }

            Text {
                id:                  messageSecondary
                text:                messageModel.secondaryText
                font.pixelSize:      12
                anchors.top:         megaModeImage.bottom
                anchors.left:        parent.left
                anchors.right:       parent.right
                anchors.topMargin:   12
                anchors.leftMargin:  horizontalPadding
                anchors.rightMargin: horizontalPadding
                font.family:         "Segoe UI Semilight"
                wrapMode:            Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                color:               messageColors['message'].secondary_text
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
            anchors.bottomMargin: (buttonOne.visible && !buttonTwo.visible) ? verticalPadding : 0

            height:             childrenRect.height + 8

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

                colorScheme: messageColors['button_one']

                anchors.top:                parent.top
                anchors.horizontalCenter:   parent.horizontalCenter
                textcontrol.text:           messageModel.buttonOne.text
                textcontrol.font.pixelSize: 12
                textcontrol.font.family:    "Segoe UI Semibold"
                textcontrol.topPadding:     5
                textcontrol.bottomPadding:  5
                textcontrol.leftPadding:    16
                textcontrol.rightPadding:   16
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

                colorScheme: messageColors['button_two']
                property bool isTransparent: (colorScheme.button === "transparent" ||
                                              colorScheme.button === Palettes.Basic.transparentHex)

                anchors.top:                buttonOne.bottom
                anchors.topMargin:          6
                anchors.horizontalCenter:   parent.horizontalCenter
                textcontrol.font.pixelSize: 12
                textcontrol.text:           messageModel.buttonTwo.text
                textcontrol.font.family:    "Segoe UI Regular"
                textcontrol.font.bold:      isTransparent
                textcontrol.topPadding:     4
                textcontrol.bottomPadding:  6
                textcontrol.leftPadding:    16
                textcontrol.rightPadding:   16
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
        primarycolor:        Colors.activity_center.message_dismiss.primary
        hovercolor:          Colors.activity_center.message_dismiss.hovered
        pressedcolor:        Colors.activity_center.message_dismiss.pressed
        focuscolor:          Colors.activity_center.message_dismiss.focus_border
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
