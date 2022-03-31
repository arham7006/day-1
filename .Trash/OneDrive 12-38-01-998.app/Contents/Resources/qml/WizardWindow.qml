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

import "fabricMdl2.js" as FabricMDL

Rectangle {
    id: root
    objectName: "wizardWindowRoot"

    property bool isConfirmDialogUp: ((state === "confirmDialogUp") || (state === "imageConfirmDialogUp"))
    opacity: isConfirmDialogUp ? 0.6 : 1.0

    // Hide all other elements when dialog is up on Mac.
    // For Windows, the dialog uses the WindowProvider pattern, where we declared the Dialog
    // as implementing IWindowProvider and Narrator ignores everything else
    property bool shouldIgnoreAccessible: (Qt.platform.os === "osx") && isConfirmDialogUp

    property string fullImageLocation: "file:///" + imageLocation

    property bool isFREAnimationEnabled: wizardWindow.isFREAnimationEnabled

    width: wizardWindow.defaultWidth
    height: wizardWindow.defaultHeight

    color: Colors.common.background

    LayoutMirroring.enabled: wizardWindow.isRTL
    LayoutMirroring.childrenInherit: true
        
    // Needed for Narrator cursor to respect
    // the Focus event occuring on root.
    Accessible.focusable: true
    Accessible.role: Accessible.Pane

    // Workaround for Qt Bug 78050 - when changing active window
    // from a window with the Qt.Popup flag (Activity Center) to
    // a regular standalone window, initial focus doesn't
    // get assigned to any control in the window
    Window.onActiveChanged: {
        if (Window.active && !Window.activeFocusItem) {
            root.forceActiveFocus();
        }
    }

    Keys.onPressed: {
        if ((Qt.platform.os !== "osx") && (event.key === Qt.Key_Escape))
        {
            wizardWindow.closeWizardWindow();
        }
    }

    state: wizardWindow.dialogState
    states: [
        State {
            name: "dialogHidden"
        },
        State {
            name: "confirmDialogUp"
            StateChangeScript {
                name: "onSwitchToConfirmDialogUpState"
                script: {
                    confirmDialog.open();
                    confirmDialog.forceActiveFocus();

                    wizardWindow.announceTextChange(confirmDialog, confirmDialog.accessibleDialogTitleText, Accessible.AnnouncementProcessing_ImportantAll);
                }
            }
        },
        State {
            name: "imageConfirmDialogUp"
            StateChangeScript {
                name: "onSwitchToImageDialogUpState"
                script: {
                    imageConfirmDialog.open();
                    imageConfirmDialog.forceActiveFocus();

                    wizardWindow.announceTextChange(confirmDialog, confirmDialog.accessibleDialogTitleText, Accessible.AnnouncementProcessing_ImportantAll);
                }
            }
        }
    ]

    Loader {
        id: myLoader
        objectName: "wizardWindowLoader"

        source: wizardWindow.loaderSource
        anchors.fill: parent
        asynchronous: true
        visible: (status === Loader.Ready)
        focus: true

        onStatusChanged: {
            console.log("Loader src: " + source + " status: " + status);

            if (status === Loader.Null)
            {
                spinningText.forceActiveFocus();
            }

            if (status === Loader.Ready)
            {
                wizardWindow.onLoaderReady();

                // Always show "pause" button when we enter a new page
                // because animation starts automatically
                animationButton.playButtonClicked = true;
            }
        }
    }

    // Add button to control animation play/pause for Accessibility purposes
    // It's next to the animation.
    SimpleButton {
        id:                  animationButton

        // Animation will start automatically
        // Treat it as play button clicked
        // so we can show correct button image when animation starts
        property bool playButtonClicked: true

        // Show button when page has animation and loader is ready
        visible:             (myLoader.status === Loader.Ready) && isFREAnimationEnabled
        enabled:             visible
        width:               20
        height:              20
        radius:              10 // button is round
        primarycolor:        Colors.fabric_button.standard.background
        hovercolor:          Colors.fabric_button.standard.hovered
        pressedcolor:        Colors.fabric_button.standard.down
        focuscolor:          Colors.fabric_button.standard.focused_border
        activeFocusOnTab:    true
        anchors.bottom:      parent.bottom
        anchors.right:       parent.right
        anchors.bottomMargin: 160
        anchors.rightMargin: 50

        useImage:            true
        imagecontrol.source: "file:///" + imageLocation + (playButtonClicked ? "animation_Pause.svg" : "animation_Play.svg")
        imagecontrol.width:  20
        imagecontrol.height: 20
        imagecontrol.sourceSize.width:  20
        imagecontrol.sourceSize.height: 20

        callback: function () {
            animationButton.playButtonClicked = !animationButton.playButtonClicked
            wizardWindow.onAnimationButtonClicked(playButtonClicked);
        }

        // After clicking "Play" button, it will become "Pause" button
        Accessible.name: playButtonClicked ? _("FirstRunAnimationPauseButtonAccessibleText") : _("FirstRunAnimationPlayButtonAccessibleText")
        Accessible.ignored: !visible
    }

    Rectangle {
        anchors.centerIn: parent
        height: childrenRect.height

        width: parent.width
        visible: ((myLoader.status !== Loader.Ready) && !wizardWindow.isBrowserLoaded)
        color: "transparent"

        Image {
            id: spinningGraphic
            source: "file:///" + imageLocation + "loading_spinner.svg"
            sourceSize.height: 28
            sourceSize.width: 28

            Accessible.ignored: true

            anchors.horizontalCenter: parent.horizontalCenter

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

        Text {
            id: spinningText
            text: wizardWindow.spinningText

            width: root.width - 40
            wrapMode: Text.WordWrap

            font.family: "Segoe UI"
            font.pixelSize: 14
            color: Colors.common.hyperlink

            horizontalAlignment: Text.Center
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: spinningGraphic.bottom
                topMargin: 4
            }

            Accessible.ignored: !spinningText.visible
            Accessible.role: Accessible.StaticText
            Accessible.name: spinningText.text
            Accessible.readOnly: true
            Accessible.focusable: true
        }

        Text {
            id: spinningSubText
            text: wizardWindow.spinningSubText

            visible: parent.visible
            width: root.width - 40
            wrapMode: Text.WordWrap

            font.family: "Segoe UI"
            font.pixelSize: 12
            color: Colors.common.hyperlink

            horizontalAlignment: Text.Center
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: spinningText.bottom
                topMargin: 2
            }

            Accessible.ignored: !spinningSubText.visible
            Accessible.role: Accessible.StaticText
            Accessible.name: spinningSubText.text
            Accessible.readOnly: true
            Accessible.focusable: true
        }
    }

    ConfirmDialog {
        id: confirmDialog
        isRTL: wizardWindow.isRTL

        // we break Windows paradigm here since we want the default button to be on the right for Wizards
        defaultButtonOnLeft: false

        dialogTitleText: wizardWindow.confirmDialogPrimaryText
        dialogBodyText: wizardWindow.confirmDialogSecondaryText

        accessibleDialogTitleText: wizardWindow.confirmDialogAccessiblePrimaryText

        button1Text: wizardWindow.confirmDialogButtonOneText
        button2Text: wizardWindow.confirmDialogButtonTwoText
        xButtonAltText: _("SignInCloseButtonText")

        headerBottomPadding: 10

        modal: true

        onButton1Clicked: {
            wizardWindow.onDialogClosed(1);
        }

        onButton2Clicked: {
            wizardWindow.onDialogClosed(2);
        }

        onDismissed: reject()
        onRejected: {
            wizardWindow.onDialogClosed(0);
        }
    }

    ImageConfirmDialog {
        id: imageConfirmDialog
        isRTL: wizardWindow.isRTL

        property int folderType: 0

        // we break Windows paradigm here since we want the default 'Cancel' button to be on the right
        defaultButtonOnLeft: false

        dialogTitleText: wizardWindow.confirmDialogPrimaryText
        dialogBodyText: wizardWindow.confirmDialogSecondaryText

        accessibleDialogTitleText: wizardWindow.confirmDialogAccessiblePrimaryText

        linkButtonText: wizardWindow.confirmDialogLinkButtonText
        button1Text: wizardWindow.confirmDialogButtonOneText
        button2Text: wizardWindow.confirmDialogButtonTwoText
        xButtonAltText: _("SignInCloseButtonText")

        imageSource: fullImageLocation + wizardWindow.confirmDialogImageSource
        imageLabel: wizardWindow.confirmDialogImageLabel
        imageWidth: 97
        imageHeight: 74

        modal: true

        onButton1Clicked: {
            wizardWindow.onDialogClosed(1);
        }

        onButton2Clicked: {
            wizardWindow.onDialogClosed(2);
        }

        onLinkButtonClicked: {
            wizardWindow.onDialogClosed(3);
        }

        onDismissed: reject()
        onRejected: {
            wizardWindow.onDialogClosed(0);
        }
    }
}
