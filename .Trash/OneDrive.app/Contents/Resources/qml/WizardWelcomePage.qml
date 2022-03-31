/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: root
    anchors.fill: parent

    color: "transparent"

    property string fullImageLocation: "file:///" + imageLocation

    function _(key)
    {
        return wizardWindow.getLocalizedMessage(key);
    }

    Text {
        id: heading
        text: _("FirstRunText")
        font.family: "Segoe UI Semibold"
        font.pixelSize: 28
        color: Colors.common.text

        horizontalAlignment: Text.Center
        anchors {
            top: parent.top
            topMargin: 30

            left: parent.left
            leftMargin: 61

            right: parent.right
            rightMargin: 61
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: heading.text
        Accessible.readOnly: true
    }

    Text {
        id: secondaryText
        text: _("FirstRunDescriptiveText")
        font.family: "Segoe UI"
        font.pixelSize: 14
        color: Colors.common.text_secondary

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        anchors {
            top: heading.bottom
            topMargin: 9

            left: parent.left
            leftMargin: 61

            right: parent.right
            rightMargin: 61
        }

        Accessible.role: Accessible.StaticText
        Accessible.name: secondaryText.text
        Accessible.readOnly: true
    }

    Image {
        id: welcomeImage
        // TODO TFS 684329 (brchua) use actual image
        source: fullImageLocation + "done_graphic.svg"
        sourceSize.height: 220
        sourceSize.width: 469

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: secondaryText.bottom
        anchors.topMargin: 20

        Accessible.ignored: true
    }

    Column {
        spacing: 5

        width: 402

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: buttonGroup.top
        anchors.bottomMargin: 24

        Text {
            id: errorText
            width: parent.width
            wrapMode: Text.WordWrap
            text: pageModel.errorText
            font.family: "Segoe UI"
            font.pixelSize: 14
            color: Colors.common.text
            visible: (errorText.text.length > 0)

            horizontalAlignment: pageModel.shouldHideEmailInput ? Text.Center : Text.AlignLeft

            Accessible.role: Accessible.StaticText
            Accessible.name: errorText.text
            Accessible.ignored: !errorText.visible
            Accessible.readOnly: true
        }

        TextField {
            id: emailAddressBar
            visible: !pageModel.shouldHideEmailInput
            placeholderText: _("FirstRunEmailInputPlaceholderText")
            text: pageModel.emailAddress
            color: enabled ? Colors.fabric_textfield.text : Colors.fabric_textfield.text_disabled

            font.family: "Segoe UI"
            font.pixelSize: 14

            height: 32
            width: parent.width
            selectByMouse: true
            enabled: !pageModel.shouldDisableEmailInput

            background: Rectangle {
                color: emailAddressBar.enabled ? Colors.fabric_textfield.background : Colors.fabric_textfield.background_disabled
                border.color:
                    emailAddressBar.enabled ?
                        (errorText.visible ? Colors.fabric_textfield.border_error :
                            (emailAddressBar.focus ? Colors.fabric_textfield.border_selected :
                                (emailAddressBar.hovered ? Colors.fabric_textfield.border_hover :
                                    Colors.fabric_textfield.border))) : Colors.fabric_textfield.border_disabled
            }

            Accessible.name: emailAddressBar.placeholderText
            Accessible.ignored: !emailAddressBar.visible || !emailAddressBar.enabled

            Keys.onEnterPressed: pageModel.onSignInButtonClicked(emailAddressBar.text)
            Keys.onReturnPressed: pageModel.onSignInButtonClicked(emailAddressBar.text)
        }
    }

    Rectangle {
        id: buttonGroup
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        width: parent.width
        height: createAccountBtn.height

        color: "transparent"

        FabricButton {
            id: createAccountBtn
            visible: !pageModel.shouldHideEmailInput
            width: Math.max(signInBtn.contentItem.paintedWidth, createAccountBtn.contentItem.paintedWidth) + 40
            height: contentItem.paintedHeight + 12

            buttonText: _("FirstRunEmailCreateAccountButton")
            buttonStyle: "secondary"
            buttonRadius: 2

            anchors.right: parent.horizontalCenter
            anchors.rightMargin: 8

            Accessible.role: Accessible.Button
            Accessible.name: createAccountBtn.buttonText
            Accessible.ignored: !createAccountBtn.visible
            Accessible.onPressAction: createAccountBtn.clicked()
            Keys.onReturnPressed: createAccountBtn.clicked()
            Keys.onEnterPressed:  createAccountBtn.clicked()

            onClicked: function() {
                Qt.openUrlExternally("http://go.microsoft.com/fwlink/?LinkId=746888");
                pageModel.onCreateAccountClicked();
            }
        }

        FabricButton {
            id: signInBtn
            visible: !pageModel.shouldHideEmailInput
            enabled: (emailAddressBar.text.length > 0) && !pageModel.shouldShowSpinner
            width: Math.max(signInBtn.contentItem.paintedWidth, createAccountBtn.contentItem.paintedWidth) + 40
            height: contentItem.paintedHeight + 12

            buttonText: _("FirstRunEmailSignInButton")
            buttonRadius: 2

            anchors.left: parent.horizontalCenter
            anchors.leftMargin: 8

            Accessible.role: Accessible.Button
            Accessible.name: signInBtn.buttonText
            Accessible.ignored: !signInBtn.visible || !signInBtn.enabled
            Accessible.onPressAction: signInBtn.clicked()
            Keys.onReturnPressed: signInBtn.clicked()
            Keys.onEnterPressed:  signInBtn.clicked()

            onClicked: pageModel.onSignInButtonClicked(emailAddressBar.text)
        }

        Rectangle {
            id: spinnerRect
            width: signInBtn.width
            height: signInBtn.height
            visible: pageModel.shouldShowSpinner
            anchors.left: signInBtn.left
            anchors.top: signInBtn.top

            color: Colors.fabric_button.primary.disabled

            Accessible.role: Accessible.StaticText
            Accessible.name: _("SignInPageLoadingText")
            Accessible.ignored: !visible
            Accessible.readOnly: true

            Image {
                id: spinningGraphic
                source: "file:///" + imageLocation + "loading_spinner.svg"
                sourceSize.height: 20
                sourceSize.width: 20
                anchors.centerIn: parent

                Accessible.ignored: true

                NumberAnimation on rotation {
                    id: rotationAnimation
                    easing.type: Easing.InOutQuad
                    from: -45
                    to: 315
                    duration: 1500
                    loops: Animation.Infinite
                    running: spinningGraphic.visible
                }
            }
        }

        FabricButton {
            id: personalBtn
            visible: pageModel.shouldHideEmailInput
            enabled: !pageModel.shouldDisablePersonalButton
            width: Math.max(personalBtn.contentItem.paintedWidth, businessBtn.contentItem.paintedWidth) + 40
            height: contentItem.paintedHeight + 12

            buttonText: _("FirstRunWelcomePersonalButton")
            buttonRadius: 2

            anchors.right: parent.horizontalCenter
            anchors.rightMargin: 8

            Accessible.role: Accessible.Button
            Accessible.name: personalBtn.buttonText
            Accessible.ignored: !personalBtn.visible || !personalBtn.enabled
            Accessible.onPressAction: personalBtn.clicked()
            Keys.onReturnPressed: personalBtn.clicked()
            Keys.onEnterPressed:  personalBtn.clicked()

            onClicked: pageModel.onPersonalButtonClicked()
        }

        FabricButton {
            id: businessBtn
            visible: pageModel.shouldHideEmailInput
            width: Math.max(personalBtn.contentItem.paintedWidth, businessBtn.contentItem.paintedWidth) + 40
            height: contentItem.paintedHeight + 12

            buttonText: _("FirstRunWelcomeBusinessButton")
            buttonRadius: 2

            anchors.left: parent.horizontalCenter
            anchors.leftMargin: 8

            Accessible.role: Accessible.Button
            Accessible.name: businessBtn.buttonText
            Accessible.ignored: !businessBtn.visible
            Accessible.onPressAction: businessBtn.clicked()
            Keys.onReturnPressed: businessBtn.clicked()
            Keys.onEnterPressed:  businessBtn.clicked()

            onClicked: pageModel.onBusinessButtonClicked()
        }
    }
}
