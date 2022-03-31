/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import FloodgateSurveyViewModel 1.0

Rectangle {
    id: root
    color: Colors.common.background
    
    LayoutMirroring.enabled: model.isRTL
    LayoutMirroring.childrenInherit: true
    
    function getLocalizedMessage(key) {
        return model.getLocalizedMessage(key);
    }

    function getNumResponses() {
        return model.numResponses;
    }

    function getResponseString(index) {
        return model.getResponseString(index);
    }

    function updateSelection(index) {
        model.onCurrentIndexChanged(index);
    }
    
    width: 350
    height: childrenRect.height
    
    Item {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: childrenRect.height
        
        Text {
            id: title

            width: parent.width
            leftPadding: 20
            rightPadding: 20
            topPadding: 16
            anchors {
                top: parent.top
                left: parent.left
            }

            text: getLocalizedMessage(FloodgateSurveyViewModel.Primary)
            color: Colors.floodgate_survey.title_text
            font.family: "Segoe UI"
            font.pixelSize: 20
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft

            Accessible.role: Accessible.StaticText
            Accessible.name: text
            Accessible.readOnly: true
        }

        Text {
            id: surveyQuestion

            width: parent.width
            leftPadding: 20
            rightPadding: 20
            topPadding: 10
            anchors {
                top: title.bottom
                left: parent.left
            }

            text: getLocalizedMessage(FloodgateSurveyViewModel.Question)
            color: Colors.common.text
            font.family: "Segoe UI"
            font.pixelSize: 16
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft

            Accessible.role: Accessible.StaticText
            Accessible.name: text
            Accessible.readOnly: true
        }
    }
    
    Column {
        id: responsesColumn
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            leftMargin: 20
            rightMargin: 20
        }

        Repeater {
            id: responseRepeater
            model: getNumResponses()
            delegate: RadioButton {
                width: parent.width
                height: contentItem.contentHeight + 10
                padding: 0

                text: getResponseString(index)

                activeFocusOnTab: true
                Accessible.role: Accessible.RadioButton
                Accessible.name: text
                Accessible.focusable: true

                onClicked: updateSelection(index);
                contentItem: Text {
                    leftPadding: 10
                    rightPadding: 10
                    anchors {
                        top: parent.top
                        left: indicator.right
                    }
                    horizontalAlignment: Text.AlignLeft
                    font.family: "Segoe UI"
                    font.pixelSize: 16
                    text: parent.text
                    color: Colors.common.text
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.Wrap
                }
                indicator: Rectangle {
                    property int radioButtonSize: 20
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    width: radioButtonSize
                    height: radioButtonSize
                    radius: radioButtonSize / 2
                    border.color: checked ? Colors.floodgate_survey.title_text : Colors.common.text

                    Rectangle {
                        anchors {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                        }
                        width: parent.radioButtonSize - 6
                        height: parent.radioButtonSize - 6
                        radius: (parent.radioButtonSize - 6) / 2

                        color: Colors.floodgate_survey.title_text
                        visible: checked
                    }
                }
            }
        }
    }

    Rectangle {
        id: feedbackBox
        anchors {
            top: responsesColumn.bottom
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
            topMargin: 10
        }
        height: 150
        border.color: userInputField.activeFocus ? Colors.floodgate_survey.input_border_focused : Colors.floodgate_survey.input_border
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
                color: Colors.common.text
                width: parent.width
                height: feedbackBox.height
                padding: 8
                wrapMode: TextEdit.Wrap
                horizontalAlignment: Text.AlignLeft
                textFormat: Qt.PlainText
                font.family: "Segoe UI"
                font.pixelSize: 16
                onCursorRectangleChanged: flick.followCursor(cursorRectangle)
                onTextChanged: { model.userInput = text; }
                activeFocusOnTab: true

                Accessible.role: Accessible.EditableText
                Accessible.name: getLocalizedMessage(FloodgateSurveyViewModel.FeedbackBox)
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
                    text: getLocalizedMessage(FloodgateSurveyViewModel.FeedbackBox)
                    color: Colors.floodgate_survey.input_placeholder
                    horizontalAlignment: Text.AlignLeft
                    visible: !userInputField.text && !userInputField.activeFocus
                    font: userInputField.font
                    anchors.left: parent.left
                    width: parent.width
                    wrapMode: TextEdit.Wrap
                }
            }
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
        }
    }
    
    Item
    {
        id: footer
        anchors {
            top: feedbackBox.bottom
            left: parent.left
            right: parent.right
            topMargin: 10
            bottomMargin: 16
        }
        height: childrenRect.height + anchors.bottomMargin
        
        SimpleButtonLink {
            id: privacyLink

            anchors {
                left: parent.left
                leftMargin: 20
            }

            textcontrol.text: getLocalizedMessage(FloodgateSurveyViewModel.Privacy)
            textcontrol.font.pixelSize: 12
            textcontrol.font.family: "Segoe UI"

            Accessible.name: textcontrol.text

            callback: function() {
                Qt.openUrlExternally(model.privacyUrl);
                model.onPrivacyLinkClicked();
            }
        }

        FabricButton {
            id: submitButton
            anchors {
                right: parent.right
                rightMargin: 20
                top: privacyLink.bottom
            }

            buttonStyle: "primary"
            buttonText: getLocalizedMessage(FloodgateSurveyViewModel.Submit)
            onClicked: model.onSubmitButtonClicked()
            enabled: true
        }
    }
}
