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

    Component.onCompleted: { if (visible) header.forceActiveFocus(); }

    //Default header text is SendFeedback
    function getHeaderText() {
        var text = _("FeedbackSendSuccessTitle");
        switch (model.type) {
            case "GetHelp":
                text = _("GetHelpSendSuccessTitle");
                break;
        }
        return text;
    }

    //Default body text is SendFeedback
    function getBodyText() {
        var text = _("FeedbackSendSuccessText");
        switch (model.type) {
            case "GetHelp":
                text = model.sendGetHelpSuccessText;
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
            right: parent.right
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
        Text {
            id: confirmText
            text: getBodyText()
            anchors {
                left: parent.left
            }
            width: parent.width
            leftPadding: 22
            rightPadding: 22
            topPadding: 10
            bottomPadding: 5
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignLeft
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
                id: closeBtn
                buttonStyle: "primary"
                buttonText: _("FeedbackCloseButtonLabel")
                onClicked: model.onCloseButtonClicked()
                Accessible.focusable: true
                Accessible.onPressAction: closeBtn.clicked()
                Keys.onReturnPressed: closeBtn.clicked()
                Keys.onEnterPressed: closeBtn.clicked()
                Keys.onSpacePressed: closeBtn.clicked()
            }
        }
    }
}