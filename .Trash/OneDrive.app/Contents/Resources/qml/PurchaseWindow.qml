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
    width: plansPage.width
    height: plansPage.height
    color: Colors.in_app_purchase.main_background

    property string fullImageLocation: "file:///" + imageLocation
    
    LayoutMirroring.enabled: viewModel.isRTL
    LayoutMirroring.childrenInherit: true

    Accessible.role: Accessible.Pane
    Accessible.focusable: true
    Accessible.focused: false
    Accessible.name: "Microsoft OneDrive"
    
    // This function is invoked in PurchaseView.cpp whenever the purchaseViewState has changed.
    // This is used to notify narrator to read the new focused item. See ActivityCenterLoader.qml note on Accessibility
    function updateFocusScope(){
        plansFocusScope.forceActiveFocus();
    }

    function _(resourceId) {
        return viewModel.getLocalizedMessage(resourceId);
    }

    Rectangle {
        id: loadingMask
        color: "black"
        opacity: 0.30
        width: root.width
        height: root.height
        visible: (viewModel.state === PurchaseViewModel.Purchasing)
        z: 1
    }

    Image {
        id: spinner
        visible: (viewModel.state === PurchaseViewModel.Initial ||
                 (viewModel.state === PurchaseViewModel.Purchasing))

        source: fullImageLocation + "loading_spinner.svg"
        sourceSize.height: 35
        sourceSize.width: 35
        anchors.centerIn: parent
        fillMode: Image.Pad
        Accessible.ignored: true
        z: 2

        NumberAnimation on rotation {
            id: rotationAnimation;
            easing.type: Easing.InOutQuad
            from: -45;
            to: 315;
            duration: 1500;
            loops: Animation.Infinite
        }
    }

    Rectangle {
        id: plansPage
        color: "transparent"

        property int sideMargins: 25
        property int estimatedWidth: cardRow.implicitWidth + (sideMargins * 2)
        property int minWidth: 604 // Default width of the PurchaseWindow
        width: (estimatedWidth > minWidth) ? estimatedWidth : minWidth
        height: 550
        
        FocusScope {
            id: plansFocusScope
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.right: parent.right
            height: childrenRect.height

            Text {
                id: mainTitle
                text: viewModel.mainTitleText
                color: (viewModel.state === PurchaseViewModel.Failure) ? Colors.in_app_purchase.error_title : Colors.in_app_purchase.title
                focus: true
                Accessible.focusable: true
                
                font.family: ".SF NS Text"
                font.pixelSize: 28

                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                Accessible.name: mainTitle.text

                onTextChanged: function(){

                    // Once the state changes, we update the text. After the text has been updated
                    // call the QML function to change the active focus.
                    // This will trigger an accessibility call to the FocusScoped element such that
                    // narrator will read the corresponding element that defined as focus: true
                    // In this case, it will be the title elements
                    // Please read Accessibility note in ActivityCenterLoader.qml for more information
                    updateFocusScope();
                }
            }
        }

        Text {
            id: mainBody
            text: viewModel.mainBodyText
            visible: ((viewModel.state === PurchaseViewModel.Success) || 
                      (viewModel.state === PurchaseViewModel.Failure))

            horizontalAlignment: Text.AlignHCenter
            color: Colors.common.text
            wrapMode: Text.WordWrap

            font.family: ".SF NS Text"
            font.pixelSize: 14

            anchors.top: plansFocusScope.bottom
            anchors.topMargin: 12
            anchors.left: parent.left
            anchors.leftMargin: plansPage.sideMargins
            anchors.right: parent.right
            anchors.rightMargin: plansPage.sideMargins
            
            Accessible.name: mainBody.text
        }

        Image {
            id: successPurchaseBackgroundImage
            visible: (viewModel.state === PurchaseViewModel.Success)
            source: fullImageLocation + "purchase_success_bg.svg"
            width: plansPage.width - (plansPage.sideMargins * 2)
            height: 378
            sourceSize.width: width
            sourceSize.height: height
            anchors.top: mainBody.bottom
            anchors.topMargin: 3
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.Pad
        }

        // Keep the same size for both cards
        property int maxCardWidth: ((cardOne.maxWidth > cardTwo.maxWidth) ? cardOne.maxWidth : cardTwo.maxWidth)

        Row {
            id: cardRow
            spacing: 20
            visible: ((viewModel.state === PurchaseViewModel.ReadyForPurchase) || 
                      (viewModel.state === PurchaseViewModel.Success) || 
                      (viewModel.state === PurchaseViewModel.Purchasing))

            anchors.top: plansFocusScope.bottom
            anchors.topMargin: (viewModel.state === PurchaseViewModel.Success) ? 89 : 25
            anchors.horizontalCenter: parent.horizontalCenter
            
            PurchaseCard
            {
                width: plansPage.maxCardWidth
                cardModel: cardOne
                viewState: viewModel.state
            }

            PurchaseCard
            {
                width: plansPage.maxCardWidth
                cardModel: cardTwo
                viewState: viewModel.state
            }

            PurchaseCard
            {
                width: plansPage.maxCardWidth
                cardModel: successCard
                viewState: viewModel.state
            }
        }

        ScrollView {
            id: termsOfUseScrollBox
            visible: ((viewModel.state === PurchaseViewModel.ReadyForPurchase) ||
                      (viewModel.state === PurchaseViewModel.Purchasing))
            
            height: 50
            clip: true
            
            anchors.top: cardRow.bottom
            anchors.topMargin: 35
            anchors.left: parent.left
            anchors.leftMargin: plansPage.sideMargins
            anchors.right: parent.right
            anchors.rightMargin: plansPage.sideMargins

            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            activeFocusOnTab: true

            Column {
                id: termsOfUseContainer
                height: children.height
                spacing: 3

                Text {
                    id: termsOfUseTitle

                    text: _("PurchaseSubscriptionTermsTitle")
                    color: Colors.in_app_purchase.tou_title
                    font.family: ".SF NS Text"
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                    
                    anchors.horizontalCenter: parent.horizontalCenter
                    Accessible.name: text
                }
                
                Text {
                    id: termsOfUseText

                    text: _("PurchaseSubscriptionTermsBody")
                    color: Colors.common.text
                    wrapMode: Text.WordWrap
                    font.family: ".SF NS Text"
                    font.pixelSize: 10
                    width: plansPage.width - (plansPage.sideMargins * 2)
                    
                    horizontalAlignment: Text.AlignHCenter
                    Accessible.name: text
                }

                Row {
                    id: linkRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 4

                    SimpleButtonLink {
                        id: termsOfUseLink
                        anchors.verticalCenter: parent.verticalCenter

                        textcontrol.text: _("PurchaseSubscriptionTermsOfUseLink")
                        textcontrol.font.pixelSize: 10
                        textcontrol.font.family: ".SF NS Text"
                        
                        Accessible.name: textcontrol.text
                        callback: function() {
                            Qt.openUrlExternally("http://go.microsoft.com/fwlink/?LinkId=215128");
                        }
                    }

                    Text {
                        id: spacer
                        color: Colors.common.text
                        font.family: ".SF NS Text"
                        font.pixelSize: 10
                        font.weight: Font.Black
                        text: "\u2022"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    SimpleButtonLink {
                        id: privacyLink
                        anchors.verticalCenter: parent.verticalCenter

                        textcontrol.text: _("PurchaseSubscriptionPrivacyLink")
                        textcontrol.font.pixelSize: 10
                        textcontrol.font.family: ".SF NS Text"
                        
                        Accessible.name: textcontrol.text
                        callback: function() {
                            Qt.openUrlExternally("https://go.microsoft.com/fwlink/?LinkId=521839");
                        }
                    }
                }
            }
        }
    }

    SimpleButton {
        id: closeButton
        height: 20
        width: textcontrol.width
        radius: 5
        visible: ((viewModel.state === PurchaseViewModel.Success) || (viewModel.state === PurchaseViewModel.Failure))
        primarycolor: Colors.in_app_purchase.close_button
        pressedcolor: Colors.in_app_purchase.close_button
        hovercolor: Colors.in_app_purchase.close_button_hover

        textcontrol.text: _("PurchaseCloseButtonText")
        textcontrol.color: Colors.fabric_button.primary.text
        textcontrol.font.pixelSize: 13
        textcontrol.font.family: ".SF NS Text"
        textcontrol.topPadding: 3
        textcontrol.bottomPadding: 3
        textcontrol.leftPadding: 13
        textcontrol.rightPadding: 13
        textcontrol.horizontalAlignment: Text.AlignHCenter
       
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        anchors.right: parent.right
        anchors.rightMargin: plansPage.sideMargins

        callback: viewModel.onCloseClicked

        activeFocusOnTab: true
        focusunderline: true
        Accessible.name: textcontrol.text
    }
}