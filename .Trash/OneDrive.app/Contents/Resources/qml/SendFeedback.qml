/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4
import SendFeedbackViewModel 1.0

import "fabricMdl2.js" as FabricMDL

Rectangle {
    id: root
    color: Colors.common.background
    opacity: 1.0

    property string fullImageLocation: "file:///" + imageLocation

    LayoutMirroring.enabled: model.isRTL
    LayoutMirroring.childrenInherit: true

    function _(key) {
        return model.getLocalizedMessage(key);
    }

    function getPlaceholderText() {
        if (model.state === SendFeedbackViewModel.GetHelp)
        {
            return _("GetHelpFieldTip");
        }
        return (model.isSmile ? _("FeedbackSmileFieldTip") : _("FeedbackFrownFieldTip"));
    }

    function getWindowHeader() {
        // Window header depends on state
        if (model.state === SendFeedbackViewModel.Initial)
        {
            return _("FeedbackWindowTitle");
        }
        if (model.state === SendFeedbackViewModel.Confirm)
        {
            return (model.isGetHelp ? _("GetHelpSendSuccessTitle") : _("FeedbackSendSuccessTitle"));
        }
        if (model.isGetHelp)
        {
            return ((model.state === SendFeedbackViewModel.SendFailure) ? _("GetHelpSendFailureTitle") : _("GetHelpWindowTitle"));
        }
        if (model.isSmile)
        {
            return _("FeedbackSmileChoiceTitle");
        }
        else
        {
            return _("FeedbackFrownChoiceTitle");
        }
    }

    width: 380
    height: 380

    Rectangle {
        id: header
        color: Colors.common.background
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: title.height + title.anchors.topMargin + title.anchors.bottomMargin

        Text {
            id: title
            wrapMode: Text.WordWrap
            text: getWindowHeader()
            color: Colors.send_feedback.title_text
            font.family: "Segoe UI"
            font.pixelSize: 20
            font.weight: Font.Light
            leftPadding: 22
            rightPadding: 22

            Accessible.role: Accessible.StaticText
            Accessible.name: text
            Accessible.readOnly: true

            anchors {
                top: parent.top
                topMargin: 16
                left: parent.left
                bottomMargin: 10
            }
        }
    }

    Rectangle {
        id: modePane
        color: Colors.common.background
        anchors {
            top: header.bottom
            topMargin: 4
            bottom: footer.top
            left: parent.left
            leftMargin: 12
            right: parent.right
            rightMargin: 12
        }
        visible: model.state === SendFeedbackViewModel.Initial
        onVisibleChanged: { if (visible) modePane.forceActiveFocus(); }

        Column {
            anchors.fill: parent
            spacing: 16

            SendFeedbackModeItem {
                id: modeSmile
                anchors {
                    left: parent.left
                    right: parent.right
                }
                primaryText: _("FeedbackSmileChoiceTitle")
                secondaryText: _("FeedbackSmileChoiceText")
                iconSymbol: FabricMDL.Icons.Emoji2
                iconColor: Colors.common.text
                activeFocusOnTab: true
                callback: model.onSendSmile
            }
            SendFeedbackModeItem {
                id: modeFrown
                anchors {
                    left: parent.left
                    right: parent.right
                }
                primaryText: _("FeedbackFrownChoiceTitle")
                secondaryText: _("FeedbackFrownChoiceText")
                iconSymbol: FabricMDL.Icons.Sad
                iconColor: Colors.common.text
                activeFocusOnTab: true
                callback: model.onSendFrown
            }
            SendFeedbackModeItem {
                id: modeSuggest
                anchors {
                    left: parent.left
                    right: parent.right
                }
                primaryText: _("FeedbackSuggestionChoiceTitle")
                secondaryText: _("FeedbackSuggestionChoiceText")
                iconSymbol: FabricMDL.Icons.Feedback
                iconColor: Colors.common.text
                activeFocusOnTab: true
                callback: function() {
                    model.onSendSuggestion();
                    Qt.openUrlExternally(model.suggestionUrl);
                }
            }
        }
    }

    Rectangle {
        id: sendingPane
        anchors {
            top: header.bottom
            bottom: footer.top
            left: parent.left
            right: parent.right
        }
        visible: model.state === SendFeedbackViewModel.Sending
        onVisibleChanged: { if (visible) sendingPane.forceActiveFocus(); }

        Rectangle {
            color: Colors.common.background
            anchors.fill: parent
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
                leftPadding: 20
                rightPadding: 20
                topPadding: 10
                bottomPadding: 5
                wrapMode: Text.WordWrap
                font.family: "Segoe UI"
                font.pixelSize: 14
                color: Colors.common.text_secondary
                Accessible.role: Accessible.StaticText
                Accessible.name: text
                Accessible.readOnly: true
            }
        }
    }

    Rectangle {
        id: failurePane
        color: Colors.common.background
        anchors {
            top: header.bottom
            bottom: footer.top
            left: parent.left
            right: parent.right
        }
        visible: model.state === SendFeedbackViewModel.SendFailure
        onVisibleChanged: { if (visible) failurePane.forceActiveFocus(); }

        Column {
            anchors.fill: parent
            TextWithLink {
                id: failureMessage
                visible: !model.isGetHelp
                embeddedLinkModel: model.sendFailureText
                anchors {
                    left: parent.left
                }
                width: parent.width
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft
                font.family: "Segoe UI"
                font.pixelSize: 14
                leftPadding: 20
                rightPadding: 20
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
            }
            Text {
                id: getHelpFailureMessage
                visible: model.isGetHelp
                text: _("GetHelpSendFailureText")
                anchors {
                    left: parent.left
                }
                width: parent.width
                leftPadding: 20
                rightPadding: 20
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
            }
        }
    }

    Rectangle {
        id: confirmPane
        color: Colors.common.background
        anchors {
            top: header.bottom
            bottom: footer.top
            left: parent.left
            right: parent.right
        }
        visible: model.state === SendFeedbackViewModel.Confirm
        onVisibleChanged: { if (visible) confirmPane.forceActiveFocus(); }

        Column {
            anchors.fill: parent
            Text {
                id: confirmText
                text: (model.isGetHelp) ? model.sendGetHelpSuccessText : _("FeedbackSendSuccessText")
                anchors {
                    left: parent.left
                }
                width: parent.width
                leftPadding: 20
                rightPadding: 20
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
            }
        }
    }

    Rectangle {
        id: inputPane
        color: Colors.common.background
        anchors {
            top: header.bottom
            bottom: footer.top
            left: parent.left
            right: parent.right
        }
        visible: ((model.state === SendFeedbackViewModel.UserInput) || (model.state === SendFeedbackViewModel.GetHelp))
        onVisibleChanged: { if (visible) submitBtn.forceActiveFocus(); }

        Rectangle {
            anchors.fill: parent
            color: Colors.common.background

            Rectangle
            {
                anchors {
                    bottom: privacyStatement.top
                    bottomMargin: 10
                    top: parent.top
                    topMargin: 2
                    left: parent.left
                    leftMargin: 20
                    right: parent.right
                    rightMargin: 20
                }
                border.color: userInputField.activeFocus ? Colors.send_feedback.input_border_focused : Colors.send_feedback.input_border
                id: inputRect
                color: Colors.common.background

                Flickable {
                    id: flick
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick
                    contentWidth: parent.width
                    contentHeight: userInputField.implicitHeight
                    clip: true

                    function followCursor(r) {
                        if (contentY >= r.y)
                            contentY = r.y;
                        else if (contentY + height <= r.y + r.height)
                            contentY = r.y + r.height - height;
                    }

                    TextEdit {
                        id: userInputField
                        color: Colors.send_feedback.input_placeholder
                        width: parent.width
                        height: inputRect.height
                        padding: 8
                        wrapMode: TextEdit.WordWrap
                        horizontalAlignment: Text.AlignLeft
                        readOnly: false
                        textFormat: Qt.PlainText
                        font.family: "Segoe UI"
                        font.pixelSize: 14
                        onCursorRectangleChanged: flick.followCursor(cursorRectangle)
                        onTextChanged: { model.userInput = text; }
                        activeFocusOnTab: true

                        Accessible.role: Accessible.EditableText
                        Accessible.name: text
                        Accessible.focusable: true

                        Keys.onTabPressed: {
                            // KeyNavigation priority does not work for TextInput by some reason,
                            // Handling it manually
                            userInputField.nextItemInFocusChain(true).forceActiveFocus();
                        }
                        Keys.onBacktabPressed: {
                            // KeyNavigation priority does not work for TextInput by some reason,
                            // Handling it manually
                            userInputField.nextItemInFocusChain(false).forceActiveFocus();
                        }
                        KeyNavigation.priority: KeyNavigation.BeforeItem

                        Text {
                            padding: 8
                            text: getPlaceholderText()
                            color: Colors.send_feedback.input_placeholder
                            visible: !userInputField.text && !userInputField.activeFocus
                            font: userInputField.font
                            anchors.left: parent.left
                            width: parent.width
                            wrapMode: TextEdit.WordWrap
                        }
                    }
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }
                }
            }
            TextWithLink {
                id: privacyStatement
                embeddedLinkModel: model.privacyText
                anchors {
                    left: parent.left
                    bottom: tosItem.top
                    leftMargin: 20
                    rightMargin: 20
                }
                width: parent.width - anchors.leftMargin - anchors.rightMargin
                font.family: "Segoe UI"
                font.pixelSize: 14
                bottomPadding: 10
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                color: Colors.common.text_secondary
                onLinkActivated: {
                    Qt.openUrlExternally(model.privacyUrl);
                    model.onPrivacyLinkClicked();
                }
                callback: function(text, index) {
                    Qt.openUrlExternally(model.privacyUrl);
                    model.onPrivacyLinkClicked();
                }
            }
            TextWithLink {
                id: tosItem
                embeddedLinkModel: model.termsOfServiceText
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                    leftMargin: 20
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
        visible: model.state !== SendFeedbackViewModel.Initial
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
                id: backBtn
                buttonStyle: "standard"
                buttonText: _("FeedbackBackButtonLabel")
                onClicked: model.onBackButtonClicked()
                visible: model.state === SendFeedbackViewModel.UserInput
            }

            FabricButton {
                id: submitBtn
                buttonStyle: "primary"
                buttonText: _("FeedbackSendButtonLabel")
                enabled: (model.state !== SendFeedbackViewModel.GetHelp) || userInputField.text
                onClicked: {
                    model.onSendButtonClicked();
                    model.onSubmitFeedback();
                }
                visible: ((model.state === SendFeedbackViewModel.UserInput) || (model.state === SendFeedbackViewModel.GetHelp))
            }

            FabricButton {
                id: retryBtn
                buttonStyle: "primary"
                buttonText: _("FeedbackRetryButtonLabel")
                onClicked: {
                    model.onRetryButtonClicked();
                    model.onSubmitFeedback();
                }
                visible: model.state === SendFeedbackViewModel.SendFailure
            }

            FabricButton {
                id: closeBtn
                buttonStyle: "primary"
                buttonText: _("FeedbackCloseButtonLabel")
                onClicked: model.onCloseButtonClicked()
                visible: model.state === SendFeedbackViewModel.Confirm
            }

            FabricButton {
                id: cancelBtn
                buttonStyle: "primary"
                buttonText: _("FeedbackCancelButtonLabel")
                onClicked: model.onCancelButtonClicked()
                visible: model.state === SendFeedbackViewModel.Sending
            }
        }
    }
}
