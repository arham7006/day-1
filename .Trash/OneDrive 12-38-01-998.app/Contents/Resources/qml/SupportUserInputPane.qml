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

    Component.onCompleted: { 
        if (visible) {
            if (submitBtn.enabled) {
                submitBtn.forceActiveFocus();
            }
            else {
                header.forceActiveFocus();
            }
        }
    }

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

    //Default placeholder text is SendFeedback
    function getPlaceholderText() {
        var text = (model.isSmile ? _("FeedbackSmileFieldTip") : _("FeedbackFrownFieldTip"));
        switch (model.type) {
            case "GetHelp":
                text = _("GetHelpFieldTip");
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

    UserInputField
    {
        id: userInput
        anchors {
            top: header.bottom
            topMargin: 12
            bottom: privacyStatement.top
            bottomMargin: 10
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }
        placeholderText: getPlaceholderText()
        onTextChanged: function(text) {model.userInput = text;}
    }

    SimpleButtonLink {
        id: privacyStatement
        anchors {
            left: parent.left
            bottom: tosItem.top
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }
        textcontrol.text: model.privacyText.hyperlinkedText
        textcontrol.font.pixelSize: 14
        textcontrol.font.family: "Segoe UI"
        Accessible.name: model.getLinkAccessibleText(model.privacyText.hyperlinkedText)
        Accessible.focusable: true

        callback: function() {
            Qt.openUrlExternally(model.privacyUrl);
            model.onPrivacyLinkClicked();
        }
    }

    TextWithLink {
        id: tosItem
        embeddedLinkModel: model.termsOfServiceText
        anchors {
            bottom: buttons.top
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }
        width: parent.width - anchors.leftMargin - anchors.rightMargin
        font.family: "Segoe UI"
        font.pixelSize: 14
        bottomPadding: 5
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
        color: Colors.common.text_secondary
        onLinkActivated: {
            Qt.openUrlExternally(model.termsOfServiceUrl)
            model.onTermsOfServiceClicked();
        }
        callback: function(text, index) {
            Qt.openUrlExternally(model.termsOfServiceUrl)
            model.onTermsOfServiceClicked();
        }

        Accessible.focusable: true
    }

    Row {
        id: buttons
        spacing: 8
        topPadding: 20
        leftPadding: 28
        rightPadding: 28
        bottomPadding: 20
        anchors {
            bottom: root.bottom
            right: parent.right
        }

        FabricButton {
            id: backBtn
            buttonStyle: "standard"
            buttonText: _("FeedbackBackButtonLabel")
            onClicked: model.onBackButtonClicked()
            visible: model.type === "SendFeedback"
            Accessible.focusable: true
            Accessible.ignored: !visible
            Accessible.onPressAction: backBtn.clicked()
            Keys.onReturnPressed: backBtn.clicked()
            Keys.onEnterPressed: backBtn.clicked()
            Keys.onSpacePressed: backBtn.clicked()
        }

        FabricButton {
            id: submitBtn
            buttonStyle: "primary"
            buttonText: _("FeedbackSendButtonLabel")
            enabled: (model.type !== "GetHelp") || userInput.hasText
            onClicked: {
                model.onSendButtonClicked();
                model.onSubmitFeedback();
            }
            Accessible.focusable: true
            Accessible.disabled: !enabled
            Accessible.ignored: !visible
            Accessible.onPressAction: submitBtn.clicked()
            Keys.onReturnPressed: submitBtn.clicked()
            Keys.onEnterPressed: submitBtn.clicked()
            Keys.onSpacePressed: submitBtn.clicked()
        }
    }
}