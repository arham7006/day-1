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
    height: childrenRect.height

    property int borderPadding: 20
    property int itemPadding: 20
    property int columnWidth: 334

    Column {
        id: resetColumn
        spacing: itemPadding
        topPadding: borderPadding
        bottomPadding: borderPadding

        width: columnWidth
        anchors.horizontalCenter: root.horizontalCenter

        Text {
            id: headerText
            wrapMode: Text.WordWrap
            text: model.getLocalizedMessage("ResetHeaderText")
            font.family: "Segoe UI"
            font.pixelSize: 20
            color: Colors.reset_window.title_text

            Accessible.role: Accessible.Heading
            Accessible.name: model.getLocalizedMessage("ResetHeaderText")
            Accessible.focusable: true
        }

        TextWithLink {
            id: resetDescription
            width: resetColumn.width
            embeddedLinkModel: model.descriptionLinkModel
            font.pixelSize: 14
            font.family: "Segoe UI"
            color: Colors.common.text
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

        TreeItemCheckBox {
            id: settingsCheckbox
            width: resetColumn.width

            contentItem: Text {
                id: settingsCheckboxText
                leftPadding: settingsCheckbox.indicator.width + 4
                text: model.getLocalizedMessage("ResetSettingsCheckboxText")
                color: Colors.common.text_secondary
                font.pixelSize: 14
                font.family: "Segoe UI"
                wrapMode: Text.WordWrap
            }

            Accessible.role: Accessible.CheckBox
            Accessible.name: settingsCheckboxText.text

            checkState: Qt.Checked
            tristate: false
        }

        Row {
            id: buttons
            spacing: 8
            anchors {
                right: resetColumn.right
            }

            FabricButton {
                id: cancelBtn
                buttonStyle: "standard"
                buttonText: model.getLocalizedMessage("ResetCancelButtonLabel")
                onClicked: {
                    cancelBtn.enabled = false;
                    resetButton.enabled = false;
                    model.onCancelButtonClicked();
                }

                Accessible.role: Accessible.Button
                Accessible.name: buttonText
                Accessible.focusable: true
                Accessible.disabled: !enabled
                Accessible.onPressAction: {
                    clicked();
                }
            }

            FabricButton {
                id: resetButton
                buttonStyle: "primary"
                buttonText: model.getLocalizedMessage("ResetConfirmButtonLabel")
                onClicked: {
                    cancelBtn.enabled = false;
                    resetButton.enabled = false;
                    model.onResetButtonClicked(settingsCheckbox.checked);
                }

                Accessible.role: Accessible.Button
                Accessible.name: buttonText
                Accessible.focusable: true
                Accessible.disabled: !enabled
                Accessible.onPressAction: {
                    clicked();
                }
            }
        }
    }
}
