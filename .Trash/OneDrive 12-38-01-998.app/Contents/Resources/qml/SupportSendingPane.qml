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

    Component.onCompleted: { if (visible) body.forceActiveFocus(); }

    //Default header text is SendFeedback
    function getHeaderText() {
        var text = model.isSmile ? _("FeedbackSmileChoiceTitle") : _("FeedbackFrownChoiceTitle");
        switch (model.type) {
            case "GetHelp":
                text = _("GetHelpWindowTitle");
                break;
        }
        return text;
    }

    SupportPaneHeader {
        id: header
        title.text: getHeaderText()
        anchors {
            top: parent.top
            left: parent.left
        }
    }

    Rectangle {
        id: body
        color: Colors.common.background
        anchors {
            top: header.bottom
            bottom: footer.top
            left: parent.left
            right: parent.right
        }
        Image {
            id: sendingImage
            source: fullImageLocation + "loading_spinner.svg"
            sourceSize.height: 44
            sourceSize.width: 44
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.Pad
            NumberAnimation on rotation {
                id: rotationAnimation;
                easing.type: Easing.InOutQuad
                from: -45;
                to: 315;
                duration: 1500;
                loops: Animation.Infinite
            }
        }
        Text {
            id: sendingText
            text: _("FeedbackSendingText")
            anchors {
                left: parent.left
                top: parent.top
            }
            leftPadding: 22
            rightPadding: 22
            topPadding: 10
            bottomPadding: 5
            wrapMode: Text.WordWrap
            font.family: "Segoe UI"
            font.pixelSize: 14
            color: Colors.common.text_secondary
            Accessible.role: Accessible.StaticText
            Accessible.name: text
            Accessible.readOnly: true
            Accessible.focusable: true
        }
    }

    Rectangle
    {
        id: footer
        color: Colors.common.background
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: buttons.height

        Row {
            id: buttons
            spacing: 8
            topPadding: 20
            leftPadding: 28
            rightPadding: 28
            bottomPadding: 20

            anchors {
                right: parent.right
            }

            FabricButton {
                id: cancelBtn
                buttonStyle: "primary"
                buttonText: _("FeedbackCancelButtonLabel")
                onClicked: model.onCancelButtonClicked()
                Accessible.focusable: true
                Accessible.onPressAction: cancelBtn.clicked()
                Keys.onReturnPressed: cancelBtn.clicked()
                Keys.onEnterPressed: cancelBtn.clicked()
                Keys.onSpacePressed: cancelBtn.clicked()
            }
        }
    }
}