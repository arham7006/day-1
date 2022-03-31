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

    // Needed for Narrator cursor to respect
    // the Focus event occuring on root.
    Accessible.focusable: true
    Accessible.role: Accessible.Pane

    // Workaround for Qt Bug 78050 - when changing active window
    // from a window with the Qt.Popup flag (Activity Center) to
    // a regular standalone window, initial focus doesn't
    // get assigned to any control in the window
    Window.onActiveChanged: {
        if (Window.active && !Window.activeFocusItem) {
            root.forceActiveFocus();
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape)
        {
            model.closeWindow();
        }
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
            font.family: "Segoe UI Semibold"
            font.pixelSize: 20
            leftPadding: 22
            rightPadding: 22

            Accessible.role: Accessible.StaticText
            Accessible.name: text
            Accessible.readOnly: true
            Accessible.focusable: true
            Accessible.headingLevel: Accessible.HeadingLevel1

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
        onVisibleChanged: { if (visible) modeSmile.forceActiveFocus(); }

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
        onVisibleChanged: { 
            if (visible) {
                sendingPane.forceActiveFocus(); 
            }
            else if (model.state === SendFeedbackViewModel.Confirm) {
                title.forceActiveFocus();
            }
        }

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
                color: Colors.send_feedback.text_secondary
                Accessible.role: Accessible.StaticText
                Accessible.name: text
                Accessible.readOnly: true
                Accessible.focusable: true
                Accessible.ignored: !sendingPane.visible
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
        onVisibleChanged: { if (visible) failureMessage.forceActiveFocus(); }

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
                color: Colors.send_feedback.text_secondary
                onLinkActivated: {
                    Qt.openUrlExternally(model.contactSupportUrl);
                    model.onContactSupportLinkClicked();
                }
                callback: function(text, index) {
                    Qt.openUrlExternally(model.contactSupportUrl);
                    model.onContactSupportLinkClicked();
                }

                Accessible.focusable: true
                Accessible.ignored: !failureMessage.visible || !failurePane.visible
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
                color: Colors.send_feedback.text_secondary

                Accessible.role: Accessible.StaticText
                Accessible.name: text
                Accessible.readOnly: true
                Accessible.focusable: true
                Accessible.ignored: !failurePane.visible || !failureMessage.visible
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
        onVisibleChanged: {
            if (visible) {
                confirmPane.forceActiveFocus();
                model.announceTextChange(closeBtn, confirmText.text, Accessible.AnnouncementProcessing_ImportantAll);
            }
        }
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
                color: Colors.send_feedback.text_secondary

                Accessible.role: Accessible.StaticText
                Accessible.name: text
                Accessible.readOnly: true
                Accessible.focusable: true
                Accessible.ignored: !confirmPane.visible
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
                        Accessible.name: getPlaceholderText()

                        Accessible.focusable: true
                        Accessible.ignored: !parent.visible

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
                            Accessible.focusable: false
                            Accessible.ignored: true
                        }
                    }
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        Accessible.focusable : false
                        Accessible.ignored: true
                    }
                }
            }
            SimpleButtonLink {
                id: privacyStatement

                anchors {
                    left: parent.left
                    bottom: tosItem.top
                    leftMargin: 20
                    rightMargin: 20
                }

                textcontrol.text: _("FeedbackPrivacyLinkText")
                textcontrol.font.pixelSize: 14
                textcontrol.font.family: "Segoe UI"
                textcontrol.wrapMode: Text.WordWrap

                Accessible.name: _("FeedbackPrivacyLinkText")
                Accessible.focusable: true
                Accessible.ignored: !parent.visible

                callback: function() {
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
                color: Colors.send_feedback.text_secondary
                onLinkActivated: {
                    Qt.openUrlExternally(model.termsOfServiceUrl)
                    model.onTermsOfServiceClicked();
                }
                callback: function(text, index) {
                    Qt.openUrlExternally(model.termsOfServiceUrl)
                    model.onTermsOfServiceClicked();
                }

                Accessible.focusable: true
                Accessible.ignored: !parent.visible
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
                enabled: model.state === SendFeedbackViewModel.UserInput
                onClicked: {
                    title.forceActiveFocus();
                    model.onBackButtonClicked();
                }
                visible: model.state === SendFeedbackViewModel.UserInput
                Accessible.focusable: true
                Accessible.ignored: !visible
                Accessible.onPressAction: backBtn.clicked()
                Keys.onReturnPressed: backBtn.clicked()
                Keys.onEnterPressed:  backBtn.clicked()
            }

            FabricButton {
                id: submitBtn
                buttonStyle: "primary"
                buttonText: _("FeedbackSendButtonLabel")
                enabled: (model.state !== SendFeedbackViewModel.GetHelp) || userInputField.text
                onClicked: {
                    sendingText.forceActiveFocus();
                    model.onSendButtonClicked();
                    model.onSubmitFeedback();
                    closeBtn.forceActiveFocus();
                }
                visible: ((model.state === SendFeedbackViewModel.UserInput) || (model.state === SendFeedbackViewModel.GetHelp))
                Accessible.focusable: true
                Accessible.disabled: !enabled
                Accessible.ignored: !visible
                Accessible.onPressAction: submitBtn.clicked()
                Keys.onReturnPressed: submitBtn.clicked()
                Keys.onEnterPressed:  submitBtn.clicked()
            }

            FabricButton {
                id: retryBtn
                buttonStyle: "primary"
                buttonText: _("FeedbackRetryButtonLabel")
                onClicked: {
                    sendingText.forceActiveFocus();
                    model.onRetryButtonClicked();
                    model.onSubmitFeedback();
                }
                visible: model.state === SendFeedbackViewModel.SendFailure
                Accessible.focusable: true
                Accessible.ignored: !visible
                Accessible.onPressAction: retryBtn.clicked()
                Keys.onReturnPressed: retryBtn.clicked()
                Keys.onEnterPressed:  retryBtn.clicked()
            }

            FabricButton {
                id: closeBtn
                buttonStyle: "primary"
                buttonText: _("FeedbackCloseButtonLabel")
                onClicked: model.onCloseButtonClicked()
                visible: model.state === SendFeedbackViewModel.Confirm
                Accessible.focusable: true
                Accessible.ignored: !visible
                Accessible.onPressAction: closeBtn.clicked()
                Keys.onReturnPressed: closeBtn.clicked()
                Keys.onEnterPressed:  closeBtn.clicked()
            }

            FabricButton {
                id: cancelBtn
                buttonStyle: "primary"
                buttonText: _("FeedbackCancelButtonLabel")
                onClicked: model.onCancelButtonClicked()
                visible: model.state === SendFeedbackViewModel.Sending
                Accessible.focusable: true
                Accessible.ignored: !visible
                Accessible.onPressAction: cancelBtn.clicked()
                Keys.onReturnPressed: cancelBtn.clicked()
                Keys.onEnterPressed:  cancelBtn.clicked()
            }
        }
    }
}
