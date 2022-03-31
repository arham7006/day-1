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
import PurchaseViewModel 1.0

import "fabricMdl2.js" as FabricMDL

Rectangle {
    id: root
    property string fullImageLocation: "file:///" + imageLocation
    property var cardModel
    property var viewState
    visible: cardModel.isVisible

    // If the purchase card is shown on a successful purchase, hide the price and purchase button
    // This also shrinks the height
    height: (viewState !== PurchaseViewModel.Success) ? 385 : 312
    radius: 5
    color: Colors.common.background
    
    Accessible.role: Accessible.LayeredPane
    Accessible.name: cardSKUTitle.text
    
    function _(resourceId) {
        return cardModel.getLocalizedMessage(resourceId);
    }

    // Custom dropshadow effect by using an image with gaussian blur. See CustomMenu.qml for more info
    BorderImage {
        id: borderimg
        property int shadowMargin: 4
        source: fullImageLocation + "blurrect.png" //rectangle with Gaussian blur
        
        anchors.left: root.left
        anchors.top: root.top 
        anchors.leftMargin: -shadowMargin
        anchors.topMargin: -shadowMargin

        width: root.width + (2 * shadowMargin)
        height: root.height + (2 * shadowMargin)
        border.left: 7
        border.top: 7
        border.right: 7
        border.bottom: 7
        opacity: 0.5
        z: -1
    }

    Text {
        id: cardSKUTitle
        text: cardModel.cardTitle
        color: Colors.common.text
        horizontalAlignment: Text.AlignHCenter

        font.family: ".SF NS Text"
        font.weight: Font.Bold
        font.pixelSize: cardModel.getPixelSizeOfString("CardTitleText")
        
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        
        Accessible.name: text
    }    
    
    Image {
        id: premiumGem
        source:fullImageLocation + "premium_gem.svg"
        sourceSize.height: 24
        sourceSize.width: 24
        height: 20
        width: 20
        fillMode: Image.PreserveAspectFit

        anchors.top: cardSKUTitle.bottom
        anchors.topMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: cardMainBody
        text: _("PurchaseCardMainBody")
        color: Colors.common.text
        horizontalAlignment: Text.AlignHCenter

        font.family: ".SF NS Text"
        font.weight: Font.Black
        font.pixelSize: cardModel.getPixelSizeOfString("CardSubBodyText")

        anchors.top: premiumGem.bottom
        anchors.topMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter

        Accessible.name: text
    }

    property int checkBoxWidth: 12
    property int checkBoxHeight: 12
    property int marginBetweenCheckBoxAndText: 5
    property int numListItems: cardModel.numListElements

    Column {
        id: listBody
        spacing: 8
        
        anchors.top: cardMainBody.bottom
        anchors.topMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        
        Accessible.role: Accessible.LayeredPane
        Accessible.name: _("PurchaseListBodyAccessibleName")
        
        Repeater {
            model: numListItems
            Rectangle {
                id: listItem
                color: "transparent"

                // Longest Side currently has the pixel width of the longest string 
                // To get the total item pixel width, add the checkbox width, margins and additional padding
                width: cardModel.listElementMaxPixelWidth + checkBoxWidth + marginBetweenCheckBoxAndText + 5
                height: cardModel.getPixelSizeOfString("CardNormalText")

                Image {
                    id: checkBox
                    source:fullImageLocation + "list_checkbox.svg"
                    sourceSize.height: checkBoxHeight
                    sourceSize.width: checkBoxWidth
                    height: checkBoxHeight
                    width: checkBoxWidth
                    fillMode: Image.PreserveAspectFit
                    
                    anchors.left: parent.left
                    anchors.verticalCenter: listText.verticalCenter
                }
                
                Text {
                    id: listText
                    text: cardModel.GetListBodyText(index)     
                    color: Colors.common.text
                    font.pixelSize: cardModel.getPixelSizeOfString("CardNormalText")
                    font.family: ".SF NS Text"

                    anchors.left: checkBox.right
                    anchors.leftMargin: marginBetweenCheckBoxAndText
                    Accessible.name: text
                }
            }            
        }
    }
    
    Text {
        id: cardSubBody
        text: _("PurchaseCardSubBody")
        color: Colors.common.text
        horizontalAlignment: Text.AlignHCenter

        font.family: ".SF NS Text"
        font.pixelSize: cardModel.getPixelSizeOfString("CardSubBodyText")
        font.weight: Font.DemiBold

        anchors.top: listBody.bottom
        anchors.topMargin: 22
        anchors.horizontalCenter: parent.horizontalCenter
        
        Accessible.name: text
    }

    property int squareIconLength: 25
    property int iconSpacing: 10

    Row {
        id: iconRow
        width: childrenRect.width
        spacing: iconSpacing
        
        anchors.top: cardSubBody.bottom
        anchors.topMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter

        Accessible.role: Accessible.LayeredPane
        Accessible.name: _("PurchaseIconAccessibleName")

        Image {
            source: fullImageLocation + "word.svg"
            width: squareIconLength
            height: squareIconLength
            sourceSize.height: squareIconLength
            sourceSize.width: squareIconLength
            Accessible.role: Accessible.Graphic
            Accessible.name: "Microsoft Word"
        }        
        
        Image {
            source: fullImageLocation + "excel.svg"
            width: squareIconLength
            height: squareIconLength
            sourceSize.height: squareIconLength
            sourceSize.width: squareIconLength
            Accessible.role: Accessible.Graphic
            Accessible.name: "Microsoft Excel"
        }

        Image {
            source: fullImageLocation + "powerpoint.svg"
            width: squareIconLength
            height: squareIconLength
            sourceSize.height: squareIconLength
            sourceSize.width: squareIconLength
            Accessible.role: Accessible.Graphic
            Accessible.name: "Microsoft PowerPoint"
        }

        Image {
            source: fullImageLocation + "onenote.svg"
            width: squareIconLength
            height: squareIconLength
            sourceSize.height: squareIconLength
            sourceSize.width: squareIconLength
            Accessible.role: Accessible.Graphic
            Accessible.name: "Microsoft OneNote"
        }

        Image {
            source: fullImageLocation + "outlook.svg"
            width: squareIconLength
            height: squareIconLength
            sourceSize.height: squareIconLength
            sourceSize.width: squareIconLength
            Accessible.role: Accessible.Graphic
            Accessible.name: "Microsoft Outlook"
        }
    }
    
    property bool ableToPurchase: ((viewState === PurchaseViewModel.ReadyForPurchase) || (viewState === PurchaseViewModel.Purchasing))
    
    Text {
        id: pricingText
        text: cardModel.cardPriceText
        font.family: ".SF NS Text"
        font.pixelSize: cardModel.getPixelSizeOfString("CardNormalText")
        color: Colors.common.text
        horizontalAlignment: Text.AlignHCenter
        visible: ableToPurchase

        anchors.top: iconRow.bottom
        anchors.topMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        
        Accessible.name: text
    }

    SimpleButton {
        id: getPremiumButton
        height: 28
        width: textcontrol.width
        radius: 3
        visible: ableToPurchase
        primarycolor: Colors.in_app_purchase.purchase_button
        pressedcolor: Colors.in_app_purchase.purchase_button
        hovercolor: Colors.in_app_purchase.purchase_button_hover

        textcontrol.text: _("PurchaseCardButtonText")
        textcontrol.color: Colors.fabric_button.primary.text
        textcontrol.font.pixelSize: cardModel.getPixelSizeOfString("CardNormalText")
        textcontrol.font.family: ".SF NS Text"
        textcontrol.topPadding: 8
        textcontrol.bottomPadding: 8
        textcontrol.leftPadding: 18
        textcontrol.rightPadding: 18
        textcontrol.horizontalAlignment: Text.AlignHCenter
        mousearea.hoverEnabled: (viewState === PurchaseViewModel.ReadyForPurchase)
        mousearea.cursorShape: (viewState === PurchaseViewModel.ReadyForPurchase) ? Qt.PointingHandCursor : Qt.ArrowCursor

        anchors.top: pricingText.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter        

        callback: cardModel.onPremiumButtonClicked

        activeFocusOnTab: true
        focusunderline: true
        Accessible.name: textcontrol.text
        Accessible.ignored: (viewState === PurchaseViewModel.Purchasing)
    }
}