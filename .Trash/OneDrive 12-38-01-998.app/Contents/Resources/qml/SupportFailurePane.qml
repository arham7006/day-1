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

    SupportPaneHeader {
        id: header
        title.text: _("GetHelpSendFailureTitle")
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

        Column {
            anchors.fill: parent
            TextWithLink {
                id: failureMessage
                visible: model.type === "SendFeedback"
                embeddedLinkModel: model.sendFailureText
                anchors {
                    left: parent.left
                }
                width: parent.width
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft
                font.family: "Segoe UI"
                font.pixelSize: 14
                leftPadding: 22
                rightPadding: 22
                bottomPadding: 5
                wrapMode: Text.WordWrap
                color: Colors.common.text_secondary
                onLinkActivated: {
                    Qt.openUrlExternally(model.contactSupportUrl);
                    model.onContactSupportLinkClicked();
                }
                callback: function(text, index) {
                    Qt.openUrlExternally(model.contactSupportUrl);
                    model.onContactSupportLinkClicked();
                }

                Accessible.focusable: true
                Accessible.ignored: !visible
            }
            Text {
                id: getHelpFailureMessage
                visible: model.type === "GetHelp"
                text: _("GetHelpSendFailureText")
                anchors {
                    left: parent.left
                }
                width: parent.width
                leftPadding: 22
                rightPadding: 22
                topPadding: 10
                bottomPadding: 5
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                font.family: "Segoe UI"
                font.pixelSize: 14
                color: Colors.common.text_secondary

                Accessible.role: Accessible.StaticText
                Accessible.name: text
                Accessible.readOnly: true
                Accessible.focusable: true
                Accessible.ignored: !visible
            }
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
                id: retryBtn
                buttonStyle: "primary"
                buttonText: _("FeedbackRetryButtonLabel")
                onClicked: {
                    model.onRetryButtonClicked();
                    model.onSubmitFeedback();
                }
                Accessible.focusable: true
                Accessible.onPressAction: retryBtn.clicked()
                Keys.onReturnPressed: retryBtn.clicked()
                Keys.onEnterPressed: retryBtn.clicked()
                Keys.onSpacePressed: retryBtn.clicked()
            }
        }
    }
}