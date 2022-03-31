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
    
    Keys.onPressed: {
        if (event.key === Qt.Key_Escape)
        {
            model.closeWindow();
        }
    }

    function getLinkAccessibleText(linkText) {
        return model.getLinkAccessibleText(linkText);
    }

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
        selectionMade = true;
    }

    property bool selectionMade: false
    property int borderPadding: 20
    property int linePadding: 10
    
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
            leftPadding: borderPadding
            rightPadding: borderPadding
            topPadding: borderPadding
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

            Accessible.role: Accessible.Heading
            Accessible.name: text
            Accessible.readOnly: true
        }

        Text {
            id: surveyQuestion

            width: parent.width
            leftPadding: borderPadding
            rightPadding: borderPadding
            topPadding: linePadding
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

            // This is needed so the narrator will read the survey question immediately
            // when the window opens.
            focus: true
        }
    }
    
    // For accessibility, the expected behavior for a group of radio buttons is for tab
    // to enter the group of buttons, and then arrow keys should be used to navigate within
    // the group. This is so keyboard users do not need to navigate through the full list of
    // items just to navigate to the bottom of the menu. Additionally, while not in scan-mode,
    // navigating to the next radio button should automatically select that radio button.
    ListView {
        id: responsesList
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            topMargin: linePadding
            leftMargin: borderPadding
            rightMargin: borderPadding
        }
        height: contentHeight

        activeFocusOnTab: true
        keyNavigationEnabled: true
        keyNavigationWraps: true
        interactive: false

        model: getNumResponses()
        delegate: FabricRadioButton {
            activeFocusOnTab: false
            text: getResponseString(index)
            onToggled: {
                updateSelection(index);
            }
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }

    Rectangle {
        id: feedbackBox
        anchors {
            top: responsesList.bottom
            left: parent.left
            leftMargin: borderPadding
            right: parent.right
            rightMargin: borderPadding
            topMargin: linePadding
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
                Accessible.ignored: true
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
            topMargin: linePadding
            bottomMargin: borderPadding
        }
        height: childrenRect.height + anchors.bottomMargin
        
        SimpleButtonLink {
            id: privacyLink

            anchors {
                left: parent.left
                leftMargin: borderPadding
            }

            textcontrol.text: getLocalizedMessage(FloodgateSurveyViewModel.Privacy)
            textcontrol.font.pixelSize: 12
            textcontrol.font.family: "Segoe UI"
            textcontrol.color: getTextColor() 
            textcontrol.linkColor: getTextColor() 

            Accessible.name: getLinkAccessibleText(textcontrol.text)

            callback: function() {
                Qt.openUrlExternally(model.privacyUrl);
                model.onPrivacyLinkClicked();
            }
        }

        FabricButton {
            id: submitButton
            anchors {
                right: parent.right
                rightMargin: borderPadding
                top: privacyLink.bottom
            }

            buttonStyle: "primary"
            buttonText: getLocalizedMessage(FloodgateSurveyViewModel.Submit)
            onClicked: model.onSubmitButtonClicked()
            enabled: selectionMade

            Accessible.role: Accessible.Button
            Accessible.name: buttonText
            Accessible.focusable: true
            Accessible.disabled: !enabled
            Accessible.ignored: !visible
            Accessible.onPressAction: {
                clicked();
            }
        }
    }
}
