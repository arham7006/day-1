/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/
import Colors 1.0
import QtQml 2.2
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2
import TaskDialogViewModel 1.0

import "fabricMdl2.js" as FabricMDL

Rectangle {
    id: root

    property string fullImageLocation: "file:///" + imageLocation
    property int bottomMargin: 24
    
    // Additional space between the header and the Title for Mac since Dialog Header is gray. 
    // On Windows, the header is white and matches the background color
    property int topMargin: (Qt.platform.os === "osx") ? 35 : 15 
    
    // Task Dialog will have a fixed width but dynamic height
    width: 576
    height: childrenRect.height + topMargin + bottomMargin
    color: Colors.common.background

    LayoutMirroring.enabled: viewModel.isRTL
    LayoutMirroring.childrenInherit: true

    Row {
        id: header
        
        width: parent.width
        height: headerText.height
        spacing: 8
        
        anchors.top: parent.top
        anchors.topMargin: topMargin
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        
        Image {
            id: headerIcon
            source: fullImageLocation + viewModel.iconImage
            width: viewModel.iconSize
            height: viewModel.iconSize
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.Pad
            anchors.verticalCenter: headerText.verticalCenter
            
            Accessible.ignored: true
        }

        Text {
            id: headerText
            
            width: parent.width - headerIcon.width - header.spacing
            text: viewModel.header
            color: Colors.common.text
            font.family: "Segoe UI Semibold"
            font.pixelSize: 23
            wrapMode: Text.WordWrap
            
            Accessible.role: Accessible.StaticText
            Accessible.name: text
            Accessible.readOnly: true
        }
    }
    
    Column {
        id: body
        spacing: 18

        width: parent.width
        height: childrenRect.height
                
        anchors.top: header.bottom
        anchors.topMargin: 11
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 24
        anchors.rightMargin: 24

        // TextWithLink does not require a link (link is optional)
        // This is treated as a regular text body if there are no links
        TextWithLink {
            id: bodyText

            embeddedLinkModel: viewModel.body
            font.family: "Segoe UI"
            font.pixelSize: 14
            color: Colors.common.text

            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.right: parent.right

            onLinkActivated: {
                // Called on Mouse Click
                Qt.openUrlExternally(viewModel.bodyLink);
            }
            callback: function() {
                // Called on Keyboard Enter Key
                Qt.openUrlExternally(viewModel.bodyLink);
            }
        }

        // Additional Text is optional. Callers must set the text to enable this component
        Text {
            id: additionalBodyText

            text: viewModel.additionalBody
            visible:(additionalBodyText.text !== "")
            
            anchors.left: parent.left
            anchors.right: parent.right
            
            color: Colors.common.text
            font.family: "Segoe UI Semibold"
            font.pixelSize: 14
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignLeft
            
            Accessible.role: Accessible.StaticText
            Accessible.name: text
            Accessible.ignored: !visible
            Accessible.readOnly: true
        }

       // Checkbox is optional. Callers must set the text to enable this component
       CustomCheckBox {
            id: checkBox
            visible: (viewModel.checkBoxText !== "")
            checkBoxText: viewModel.checkBoxText
            onClicked: { viewModel.checkBoxValue = checked; }
            checked: viewModel.checkBoxValue
            anchors.left: parent.left
       }
    }

    Row {
        id: buttonPane
        spacing: 8
        width: parent.width
        height: childrenRect.height

        anchors.top: body.bottom
        anchors.topMargin: 34
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        
        // Mac shows the primary button on the Right
        // Windows shows the primary button on the Left
        // If there's only one button, it will align to the right
        layoutDirection: ((Qt.platform.os === "osx") || !secondaryButton.visible) ? Qt.RightToLeft : Qt.LeftToRight
        
        FabricButton {
            id: primaryButton
            
            width: 260
            height: contentItem.paintedHeight + 12
            focus: true

            buttonText: viewModel.getButtonText(TaskDialogViewModel.PrimaryButton)

            Accessible.role: Accessible.Button
            Accessible.name: primaryButton.buttonText
            Accessible.ignored: !primaryButton.visible
            Accessible.onPressAction: primaryButton.clicked()
            Keys.onReturnPressed: primaryButton.clicked()
            Keys.onEnterPressed:  primaryButton.clicked()

            onClicked: function() {
                viewModel.onButtonClicked(TaskDialogViewModel.PrimaryButton)
            }
        }

        // Secondary Button is optional. Caller must set text to enable this component
        FabricButton {
            id: secondaryButton
            width: 260
            height: contentItem.paintedHeight + 12

            buttonText: viewModel.getButtonText(TaskDialogViewModel.SecondaryButton)
            visible: (secondaryButton.text !== "")
            buttonStyle: "secondary"

            Accessible.role: Accessible.Button
            Accessible.name: secondaryButton.buttonText
            Accessible.ignored: !secondaryButton.visible
            Accessible.onPressAction: secondaryButton.clicked()
            Keys.onReturnPressed: secondaryButton.clicked()
            Keys.onEnterPressed:  secondaryButton.clicked()

            onClicked: function() {
                viewModel.onButtonClicked(TaskDialogViewModel.SecondaryButton)
            }
        }        
    }
}