/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: root
    anchors.fill: parent

    color: "transparent"

    onVisibleChanged: {
        if (visible) {
            if (emailAddressBar.enabled) {
                emailAddressBar.forceActiveFocus();
            }
            else if (emailAddressDropdown.visible)
            {
                emailAddressDropdown.forceActiveFocus();
            }
            else {
                signInBtn.forceActiveFocus();
            }

            wizardWindow.announceTextChange(header, header.title.text, Accessible.AnnouncementProcessing_ImportantAll);
        }
    }

    state: pageModel.dialogState
    states: [
        State {
            name: "emailInput"
            PropertyChanges { target: infoText; horizontalAlignment: Text.AlignLeft; }
            PropertyChanges { target: infoText; font.family: "Segoe UI Semibold" }
            PropertyChanges { target: emailAddressBar; visible: true; }
            PropertyChanges { target: emailAddressDropdown; visible: false }
            PropertyChanges { target: createAccountBtn; visible: true }
            PropertyChanges { target: signInBtn; visible: true }
            PropertyChanges { target: personalBtn; visible: false }
            PropertyChanges { target: businessBtn; visible: false }
        },
        State {
            name: "emailDropdown"
            PropertyChanges { target: infoText; horizontalAlignment: Text.AlignLeft; }
            PropertyChanges { target: infoText; font.family: "Segoe UI Semibold" }
            PropertyChanges { target: emailAddressBar; visible: false; }
            PropertyChanges { target: emailAddressBar; enabled: false; }
            PropertyChanges { target: emailAddressDropdown; visible: true }
            PropertyChanges { target: createAccountBtn; visible: true }
            PropertyChanges { target: signInBtn; visible: true }
            PropertyChanges { target: personalBtn; visible: false }
            PropertyChanges { target: businessBtn; visible: false }
        },

        State {
            name: "isBoth"
            PropertyChanges { target: infoText; horizontalAlignment: Text.Center; }
            PropertyChanges { target: infoText; font.family: "Segoe UI" }
            PropertyChanges { target: emailAddressBar; visible: false; }
            PropertyChanges { target: emailAddressDropdown; visible: false }
            PropertyChanges { target: createAccountBtn; visible: false }
            PropertyChanges { target: signInBtn; visible: false }
            PropertyChanges { target: personalBtn; visible: true }
            PropertyChanges { target: businessBtn; visible: true }
            StateChangeScript {
                name: "onSwitchToIsBothState"
                script: {
                    // Force focus on button to change Narrator selection to this element and
                    // read out the infoText
                    infoText.forceActiveFocus();
                }
            }
        }
    ]

    WizardPageHeader {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        title.text: pageModel.isWin7EolFlow ? _("FirstRunWin7Text") : _("FirstRunText")
        subtitle.text: pageModel.isWin7EolFlow ? _("FirstRunWin7DescriptiveText") : _("FirstRunDescriptiveText")
        image.source: pageModel.isWin7EolFlow ? fullImageLocation + "fre_email_hrd_win7.svg" : fullImageLocation + "fre_email_hrd.svg"
        image.height: pageModel.isWin7EolFlow ? 170 : 220
        image.width: pageModel.isWin7EolFlow ? 376 :470
        image.anchors.topMargin: 37
        image.visible: !isFREAnimationEnabled
    }

    Column {
        spacing: 5

        width: 402

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: buttonGroup.top
        anchors.bottomMargin: 24

        Text {
            id: infoText
            width: parent.width
            wrapMode: Text.WordWrap
            text: pageModel.infoText
            font.pixelSize: 14
            color: Colors.common.text
            visible: (infoText.text.length > 0)

            Accessible.role: Accessible.StaticText
            Accessible.name: infoText.text
            Accessible.ignored: !infoText.visible
            Accessible.readOnly: true
            Accessible.focusable: true
        }

        TextField {
            id: emailAddressBar
            placeholderText: _("FirstRunEmailInputPlaceholderText")
            placeholderTextColor: Colors.fabric_textfield.text_placeholder
            text: pageModel.emailAddress
            color: enabled ? Colors.fabric_textfield.text : Colors.fabric_textfield.text_disabled

            // for RTL, cursor should appear on right
            horizontalAlignment: effectiveHorizontalAlignment

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
            Accessible.ignored: !emailAddressBar.visible
            Accessible.disabled: !enabled
            Accessible.role: Accessible.EditableText

            Keys.onEnterPressed: pageModel.onSignInButtonClicked(emailAddressBar.text)
            Keys.onReturnPressed: pageModel.onSignInButtonClicked(emailAddressBar.text)

            focus: true
        }

        FabricDropdown {
            id: emailAddressDropdown

            width: parent.width
            height: 32

            defaultInput: pageModel.emailAddress
            inError: errorText.visible

            callback: function(text) {
                selectionMenu.close();
                pageModel.onSignInButtonClicked(text);
            }

            button.callback: function() {
                selectionMenu.showMenu(emailAddressDropdown);
            }

            buttonAccName: _("MenuButtonAccessibleName")
        }

        Text {
            id: errorText
            width: parent.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft;
            text: pageModel.errorText
            font.family: "Segoe UI"
            font.pixelSize: 12
            color: Colors.fabric_textfield.border_error
            visible: (errorText.text.length > 0)

            Accessible.role: Accessible.StaticText
            Accessible.name: errorText.text
            Accessible.ignored: !errorText.visible
            Accessible.readOnly: true
            Accessible.focusable: true
        }
    }

    CustomMenu {
        id: selectionMenu

        menuWidth: parent.width
        property int itemCount: 0

        Instantiator {
            id: menuInstatiator
            delegate: newMenuItem
            model: pageModel

            // When an item is added/removed, resize the menu and ensure it's position is correct
            // Note: an item is added/removed when a sub-menu is expanded/collapsed, not just on initialization
            onObjectAdded: {
                selectionMenu.insertItem(index, object);
                selectionMenu.itemCount++;
                selectionMenu.resize();
                selectionMenu.reposition();
            }
            onObjectRemoved: {
                selectionMenu.removeItem(index, object);
                selectionMenu.itemCount--;
                selectionMenu.resize();
                selectionMenu.reposition();
            }
        }

        // Displays or "Shows" the menu and resizes it according to contained items
        function showMenu(anchoredItem) {
            selectionMenu.parent = anchoredItem;

            selectionMenu.visible = !selectionMenu.visible;

            selectionMenu.resize();
            selectionMenu.reposition();

            selectionMenu.itemAt(0).forceActiveFocus();
        }

        // Helper function to resize the menu after it has been populated with items
        function resize() {
            var height = 0;
            for (var index = 0; index < itemCount; index++) {
                height += selectionMenu.itemAt(index).menuItemHeight;
            }
            selectionMenu.menuHeight = height;
        }

        // Helper function to calculate and set position of the menu
        // Calculates the upper left of the menu (x,y) such that the bottom of this menu
        // is at the top of the parent item set in showMenu().
        function reposition() {
            selectionMenu.x = 0 ;
            selectionMenu.y = -selectionMenu.menuHeight;
        }

        // Component for creating new items in the menu
        Component {
            id: newMenuItem
            CustomMenuItem {
                id: theItem

                textcontrol.text: model.itemName
                textcontrol.font.family: "Segoe UI"
                textcontrol.font.pixelSize: 14

                text: model.itemName

                callback: function()
                {
                    emailAddressDropdown.textFieldText = model.itemName;
                    emailAddressDropdown.inputField.forceActiveFocus();
                    selectionMenu.close();
                }
            }
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
            width: Math.max(signInBtn.contentItem.paintedWidth, createAccountBtn.contentItem.paintedWidth) + 45
            height: contentItem.paintedHeight + 12

            buttonText: _("FirstRunEmailCreateAccountButton")
            buttonStyle: "secondary"

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
            enabled: !pageModel.shouldShowSpinner &&
                     ((pageModel.dialogState === "emailInput" && (emailAddressBar.text.length > 0)) ||
                      (pageModel.dialogState === "emailDropdown" && (emailAddressDropdown.textFieldText.length > 0)))
            width: Math.max(signInBtn.contentItem.paintedWidth, createAccountBtn.contentItem.paintedWidth) + 45
            height: contentItem.paintedHeight + 12

            buttonText: _("FirstRunEmailSignInButton")

            anchors.left: parent.horizontalCenter
            anchors.leftMargin: 8

            Accessible.role: Accessible.Button
            Accessible.name: signInBtn.buttonText
            Accessible.ignored: !signInBtn.visible
            Accessible.onPressAction: signInBtn.clicked()
            Accessible.disabled: !enabled
            Keys.onReturnPressed: signInBtn.clicked()
            Keys.onEnterPressed:  signInBtn.clicked()

            onClicked: function() {
                pageModel.onSignInButtonClicked(
                           (pageModel.dialogState === "emailInput") ? emailAddressBar.text : emailAddressDropdown.textFieldText);
                wizardWindow.announceTextChange(signInBtn, _("SignInPageLoadingText"), Accessible.AnnouncementProcessing_ImportantAll);
            }
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
                source: fullImageLocation + "loading_spinner.svg"
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
            enabled: !pageModel.shouldDisablePersonalButton
            width: Math.max(personalBtn.contentItem.paintedWidth, businessBtn.contentItem.paintedWidth) + 45
            height: contentItem.paintedHeight + 12

            buttonText: _("FirstRunWelcomePersonalButton")

            anchors.right: parent.horizontalCenter
            anchors.rightMargin: 8

            Accessible.role: Accessible.Button
            Accessible.name: personalBtn.buttonText
            Accessible.ignored: !personalBtn.visible
            Accessible.disabled: !personalBtn.enabled
            Accessible.onPressAction: personalBtn.clicked()
            Keys.onReturnPressed: personalBtn.clicked()
            Keys.onEnterPressed:  personalBtn.clicked()

            onClicked: pageModel.onPersonalButtonClicked()
        }

        FabricButton {
            id: businessBtn
            width: Math.max(personalBtn.contentItem.paintedWidth, businessBtn.contentItem.paintedWidth) + 45
            height: contentItem.paintedHeight + 12

            buttonText: _("FirstRunWelcomeBusinessButton")

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
