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

    property bool isErrorDialogUp: errorDialog.visible
    opacity: isErrorDialogUp ? 0.6 : 1.0

    property string fullImageLocation: "file:///" + imageLocation

    width: wizardWindow.defaultWidth
    height: wizardWindow.defaultHeight

    color: Colors.common.background

    LayoutMirroring.enabled: wizardWindow.isRTL
    LayoutMirroring.childrenInherit: true

    state: wizardWindow.dialogState
    states: [
        State {
            name: "errorDialogHidden"
        },
        State {
            name: "errorDialogUp"
            StateChangeScript {
                name: "onSwitchToErrorDialogUpState"
                script: {
                    errorDialog.open();
                }
            }
        }
    ]

    Loader {
        id: myLoader
        source: wizardWindow.loaderSource
        width: parent.width
        anchors.fill: parent
        asynchronous: true
        visible: (status === Loader.Ready)
    }

    Image {
        id: spinningGraphic
        source: "file:///" + imageLocation + "loading_spinner.svg"
        sourceSize.height: 28
        sourceSize.width: 28
        anchors.centerIn: parent
        visible: (myLoader.status !== Loader.Ready)

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

    Text {
        id: spinningText
        visible: spinningGraphic.visible
        text: wizardWindow.spinningText

        font.family: "Segoe UI"
        font.pixelSize: 12
        color: Colors.common.text

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: spinningGraphic.bottom
        anchors.topMargin: 4

        Accessible.ignored: !spinningText.visible
        Accessible.role: Accessible.StaticText
        Accessible.name: spinningText.text
    }

    ConfirmDialog {
        id: errorDialog
        isRTL: wizardWindow.isRTL

        // we break Windows paradigm here since we want the default button to be on the right for Wizards
        defaultButtonOnLeft: false

        dialogTitleText: wizardWindow.errorDialogPrimaryText
        dialogBodyText: wizardWindow.errorDialogSecondaryText

        button1Text: wizardWindow.errorDialogButtonOneText
        button2Text: wizardWindow.errorDialogButtonTwoText
        xButtonAltText: _("SignInCloseButtonText")

        modal: true

        onButton1Clicked: {
            wizardWindow.onErrorDialogClosed(1);
        }

        onButton2Clicked: {
            wizardWindow.onErrorDialogClosed(2);
        }

        onDismissed: reject()
        onRejected: {
            wizardWindow.onErrorDialogClosed(0);
        }
    }
}
