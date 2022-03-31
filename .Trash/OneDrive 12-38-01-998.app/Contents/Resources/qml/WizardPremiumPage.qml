/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"

    onVisibleChanged: {
        if (visible) {
            nextBtn.forceActiveFocus();
            wizardWindow.announceTextChange(header, header.title.text, Accessible.AnnouncementProcessing_ImportantAll);
        }
    }

    WizardPageHeader {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        title.text: _("FirstRunPremiumPageTitle")
        subtitle.text: _("FirstRunPremiumPageSubtitle")
        image.visible: false
    }
    
    Rectangle {
        id: contentArea
        anchors {
            top: header.bottom
            topMargin: -8
            bottom: nextBtn.top

            horizontalCenter: parent.horizontalCenter
        }

        Rectangle
        {
            id: purchaseCard
            height: 308
            width: Math.max(360, iconsHeader.paintedWidth + 40)
            radius: 5
            color: Colors.in_app_purchase.card_background

            border.color: Colors.in_app_purchase.card_border
            border.width: 1

            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            BorderImage {
                id: borderimg
                property int shadowMargin: 3
                source: fullImageLocation + "blurrect.png" //rectangle with Gaussian blur

                anchors {
                    left: purchaseCard.left
                    top: purchaseCard.top
                    leftMargin: -shadowMargin
                    topMargin: shadowMargin
                }

                width: purchaseCard.width + (2 * shadowMargin)
                height: purchaseCard.height + (2 * shadowMargin)
                border.left: 7
                border.top: 7
                border.right: 7
                border.bottom: 7
                opacity: 0.25
                z: -1
            }

            Column {
                id: cardContent
                spacing: 13

                anchors {
                    fill: parent
                    topMargin: 10
                }

                Text {
                    id: cardSKUTitle
                    text: _("FirstRunPremiumPageCardHeaderAlta")     // in M365, we no longer differentiate Solo plan
                    color: Colors.common.text
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    font.family: "Segoe UI Semibold"
                    font.weight: Font.Bold
                    font.pixelSize: 20

                    Accessible.name: text
                    Accessible.readOnly: true
                }

                Image {
                    id: premiumGem
                    source:fullImageLocation + "premium_gem.svg"
                    sourceSize.height: 24
                    sourceSize.width: 24
                    height: 20
                    width: 20
                    fillMode: Image.PreserveAspectFit

                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    id: featureHeader
                    text: _("FirstRunPremiumPageFeatureHeader")
                    color: Colors.common.text
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 14
                    Accessible.ignored: true
                }

                Rectangle {
                    height: childrenRect.height
                    width: childrenRect.width
                    color: "transparent"

                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    Accessible.role: Accessible.Grouping
                    Accessible.name: featureHeader.text

                    Column {
                        spacing: cardContent.spacing

                        TextWithCheck
                        {
                            id: feature1
                            text.text: _("FirstRunPremiumPageFeatureUpsell1")
                        }

                        TextWithCheck
                        {
                            id: feature2
                            text.text: _("FirstRunPremiumPageFeatureUpsell2")
                        }

                        TextWithCheck
                        {
                            id: feature3
                            text.text: _("FirstRunPremiumPageFeatureUpsell3")
                        }
                    }
                }

                Rectangle {
                    color: "transparent" // spacer for column
                    height: 1
                    width: 1
                }

                Text {
                    id: iconsHeader
                    text: _("FirstRunPremiumPageOfficeIconsHeader")
                    color: Colors.common.text
                    horizontalAlignment: Text.AlignHCenter

                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 14

                    anchors.horizontalCenter: parent.horizontalCenter
                    Accessible.ignored: true
                }

                OfficeIcons {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Accessible.ignored: (os !== Qt.osx)
                    Accessible.name: iconsHeader.text
                }

                Text {
                    id: pricingText
                    text: pageModel.planPriceText
                    font.family: "Segoe UI"
                    font.pixelSize: 14
                    color: Colors.common.text
                    horizontalAlignment: Text.AlignHCenter
                    visible: ableToPurchase

                    anchors.horizontalCenter: parent.horizontalCenter

                    Accessible.name: text
                    Accessible.readOnly: true
                }
            }
        }
    }

    FabricButton {
        id: laterBtn
        width: laterBtn.contentItem.paintedWidth + 50
        height: contentItem.paintedHeight + 12
        buttonStyle: "standard"
        
        buttonText: _("FirstRunPremiumPageLaterButton")

        anchors {
            bottom: parent.bottom
            right: nextBtn.left

            bottomMargin: 30
            rightMargin: 16
        }

        Accessible.role: Accessible.Button
        Accessible.name: laterBtn.buttonText
        Accessible.onPressAction: laterBtn.clicked()
        Keys.onReturnPressed: laterBtn.clicked()
        Keys.onEnterPressed:  laterBtn.clicked()

        onClicked: pageModel.NotNowClicked()
    }

    FabricButton {
        id: nextBtn
        focus: true
        width: nextBtn.contentItem.paintedWidth + 50
        height: contentItem.paintedHeight + 12
        buttonStyle: "upsell"

        buttonText: _("FirstRunPremiumPageGoPremiumButton")

        anchors {
            bottom: parent.bottom
            right: parent.right

            bottomMargin: 30
            rightMargin: 18
        }

        Accessible.role: Accessible.Button
        Accessible.name: nextBtn.buttonText
        Accessible.onPressAction: nextBtn.clicked()
        Keys.onReturnPressed: nextBtn.clicked()
        Keys.onEnterPressed:  nextBtn.clicked()

        onClicked: pageModel.GoPremiumClicked()
    }
}
