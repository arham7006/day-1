/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import ResetWindowViewModel 1.0

Rectangle {
    id: root
    color: Colors.common.background
    opacity: 1.0
    
    LayoutMirroring.enabled: model.isRTL
    LayoutMirroring.childrenInherit: true
    
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
        height: headerText.implicitHeight + 30
        
        Text {
            id: headerText
            wrapMode: Text.WordWrap
            text: model.getLocalizedMessage("ResetHeaderText")
            font.family: "Segoe UI"
            font.pixelSize: 20
            color: Colors.reset_window.title_text

            Accessible.role: Accessible.Heading
            Accessible.focusable: true
            
            anchors {
                top: parent.top
                topMargin: 16
                left: parent.left
                leftMargin: 20
                right: parent.right
                rightMargin: 20
            }
        }
    }
    
    Rectangle {
        id: resetPane
        color: Colors.common.background
        anchors {
            top: header.bottom
            bottom: footer.top
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }
        
        TextWithLink {
            id: resetDescription
            embeddedLinkModel: model.descriptionLinkModel
            font.pixelSize: 12
            font.family: "Segoe UI"
            color: Colors.common.text
            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                right: parent.right
            }
            wrapMode: Text.WordWrap
            onLinkActivated: {
                Qt.openUrlExternally(model.learnMoreUrl);
                model.onLearnMoreLinkClicked();
            }
            callback: function(text, index) {
                Qt.openUrlExternally(model.learnMoreUrl);
                model.onLearnMoreLinkClicked();
            }
        }
        CheckBox {
            id: settingsCheckbox
            anchors {
                bottom: parent.bottom
                bottomMargin: 10
                left: parent.left
                right: parent.right
            }

            contentItem: Text {
                id: settingsCheckboxText
                leftPadding: settingsCheckbox.indicator.width + 4
                text: model.getLocalizedMessage("ResetSettingsCheckboxText")
                color: Colors.common.text_secondary
                font.pixelSize: 12
                font.family: "Segoe UI"
                wrapMode: Text.WordWrap
            }

            Accessible.description: settingsCheckboxText.text
            checked: true

            indicator: Rectangle {
                implicitWidth: 14
                implicitHeight: 14
                border.width: parent.visualFocus ? 2 : 1
                border.color: parent.visualFocus ? Colors.reset_window.focused_border : Colors.reset_window.button_border
                anchors {
                    verticalCenter: parent.verticalCenter
                }
                
                Image {
                    anchors.fill: parent
                    source: "file:///" + imageLocation + "checkboxComposite.svg"
                    visible: settingsCheckbox.checked
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
                buttonStyle: "standard"
                buttonText: model.getLocalizedMessage("ResetCancelButtonLabel")
                onClicked: model.onCancelButtonClicked()
                enabled: model.state === ResetWindowViewModel.UserInput
            }
            
            FabricButton {
                id: resetButton
                buttonStyle: "primary"
                buttonText: model.getLocalizedMessage("ResetConfirmButtonLabel")
                onClicked: model.onResetButtonClicked(settingsCheckbox.checked)
                enabled: model.state === ResetWindowViewModel.UserInput
            }
        }
    }
}
