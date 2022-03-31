import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2

Dialog {
    id: confirmDialogRoot

    // Exported properties
    property string dialogTitleText: ""
    property string accessibleDialogTitleText: dialogTitleText

    property string dialogBodyText: ""
    property string button1Text: ""
    property string button2Text: ""
    property string linkButtonText: ""
    property string xButtonAltText: ""

    property bool isRTL: false
    property bool defaultButtonOnLeft: true

    property int headerTextHorizontalAlignment: Text.AlignLeft
    property int headerTextFontPixelSize: 21
    property int headerBottomPadding: 20

    property int footerBottomPadding: 20
    property int footerTopPadding: 5

    property int xButtonSize: 8

    property int preferredWidth: 310
    property int preferredHeight: 172

    // Make sure there is no default padding
    // around contentItem (so that the text aligns with the heading text)
    leftPadding: 0
    rightPadding: 0

    signal button1Clicked()
    signal button2Clicked()
    signal linkButtonClicked()
    signal dismissed()

    onAboutToHide: {
        // Reset keyboard focus within the scope of this dialog
        // to the default (header).
        // If the user opens the dialog, presses TAB to go to a button
        // then closes the dialog, and later reopens it again, the expectation
        // is that TAB focus starts anew on the default tab item.
        header.forceActiveFocus();
    }

    width: Math.max(preferredWidth, buttons.implicitWidth)
    height: Math.max(preferredHeight, confirmDialogRoot.implicitHeight)

    // Need to set focus to true so that when Dialog becomes visible
    // keyboard focus moves from the parent Item into the Dialog
    focus: true

    x: (parent.width / 2 ) - (width / 2)
    y: (parent.height / 2) - (height / 2)

    enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; } }
    exit: Transition { NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; } }

    Keys.onEscapePressed: {
        dismissed();
    }

    title: accessibleDialogTitleText

    background: Rectangle {
        // give the effect of a drop shadow. We can't use the QML DropShadow type because
        // Dialog does not inherit from Item
        color: Colors.common.background
        anchors.fill: parent
        BorderImage {
            id: borderimg
            source: fullImageLocation + "blurrect.png" //rectangle with Gaussian blur
            anchors { left: parent.left; top: parent.top; topMargin: -7; leftMargin: -7; }
            width: confirmDialogRoot.width + 14
            height: confirmDialogRoot.height + 14
            border { left: 7; top: 7; right: 7; bottom: 7 }
            opacity: (confirmDialogRoot.opacity > 0.9) ? 0.5 : 0.0
            z: 1
        }

        // White rectangle lying on top of BorderImage with transparent border
        Rectangle {
            color: Colors.common.background
            border.color: "transparent"
            width: confirmDialogRoot.width
            height: confirmDialogRoot.height
            z:2
        }
    }

    // Elements are in reverse-order of how they will show up in accessibility tree
    // since they are created from top to bottom of file.
    // Thus, we have footer, contentItem, then header.

    footer: Rectangle {
        id: buttons
        implicitHeight: theRow.implicitHeight
        implicitWidth:  theRow.implicitWidth
        LayoutMirroring.enabled: isRTL
        LayoutMirroring.childrenInherit: true
        color: "transparent"

        Row {
            anchors.right: parent.right
            id: theRow
            spacing: 8

            layoutDirection: defaultButtonOnLeft ? Qt.LeftToRight : Qt.RightToLeft

            topPadding: footerTopPadding
            bottomPadding: footerBottomPadding
            leftPadding: isRTL ? 28 : (linkButton.visible ? linkButton.implicitWidth : 28)
            rightPadding: isRTL ? (linkButton.visible ? linkButton.implicitWidth : 28) : 28

            FabricButton {
                id: primaryButton
                buttonStyle: "primary"
                buttonText: button1Text
                focus: true

                onClicked: {
                    confirmDialogRoot.close();
                    confirmDialogRoot.button1Clicked();
                }

                Accessible.onPressAction: onClicked();
                Keys.onReturnPressed: onClicked();
                Keys.onEnterPressed: onClicked();

                KeyNavigation.backtab: (button2Text.length > 0) ? secondaryButton : ((linkButton.visible > 0) ? linkButton : dismissButton)
                KeyNavigation.tab: dismissButton
            }

            FabricButton {
                id: secondaryButton
                buttonStyle: "secondary"
                buttonText: button2Text
                visible: (button2Text.length > 0)

                onClicked: {
                    confirmDialogRoot.close();
                    confirmDialogRoot.button2Clicked();
                }

                Accessible.onPressAction: onClicked();
                Keys.onReturnPressed: onClicked();
                Keys.onEnterPressed: onClicked();

                KeyNavigation.backtab: (linkButton.visible > 0) ? linkButton : dismissButton
                KeyNavigation.tab: primaryButton
            }
        }

        SimpleButtonLink {
            id: linkButton
            objectName: "linkButton"
            visible: (textcontrol.text.length > 0)
            height: theRow.implicitHeight
            textcontrol.text: linkButtonText
            textcontrol.font.family: "Segoe UI Semibold"
            textcontrol.font.pixelSize: 14
            textcontrol.color: getTextColor()
            textcontrol.linkColor: getTextColor()
            anchors.left: parent.left
            anchors.leftMargin: 28
            anchors.top: parent.top
            anchors.topMargin: footerTopPadding
            anchors.verticalCenter: theRow.verticalCenter

            callback: function() {
                confirmDialogRoot.close();
                confirmDialogRoot.linkButtonClicked();
            }

            KeyNavigation.backtab: dismissButton
            KeyNavigation.tab: (button2Text.length > 0) ? secondaryButton : primaryButton
        }
    }

    contentItem: Text {
        LayoutMirroring.enabled: isRTL

        id: bodyTextElement

        text: dialogBodyText
        horizontalAlignment: Text.AlignLeft

        leftPadding: 28
        rightPadding: 28

        font.family: "Segoe UI"
        font.weight: Font.Light
        wrapMode: Text.WordWrap
        color: Colors.move_window.folderItemPrimaryText
        font.pixelSize: 14

        Accessible.role: Accessible.StaticText
        Accessible.readOnly: true
        Accessible.name: text
    }

    header: Rectangle {
        implicitHeight: headerText.implicitHeight
        id: confirmDialogHeader
        color: "transparent"

        LayoutMirroring.enabled: isRTL
        LayoutMirroring.childrenInherit: true

        Text {
            id: headerText
            // Important: we must directly bind to confirmDialogRoot.width
            // instead of the parent.width because the latter causes
            // a binding loop for reasons unknown
            width: confirmDialogRoot.width
            font.family: "Segoe UI"
            font.weight: Font.Light
            text: dialogTitleText
            horizontalAlignment: headerTextHorizontalAlignment
            wrapMode: Text.WordWrap
            color: Colors.move_window.folderItemPrimaryText
            font.pixelSize: headerTextFontPixelSize
            topPadding: (dialogTitleText.length > 0) ? 28 : dismissButton.anchors.topMargin
            bottomPadding: headerBottomPadding
            leftPadding: 28
            rightPadding: 28

            Accessible.role: Accessible.StaticText
            Accessible.readOnly: true
            Accessible.name: confirmDialogRoot.accessibleDialogTitleText
            Accessible.focusable: true
            Accessible.focused: activeFocus
        }

        SimpleButton {
            id: dismissButton

            visible: true
            enabled: true
            width: 16
            height: 16
            primarycolor:        Colors.common.background
            hovercolor:          Colors.confirm_dialog.confirmButtonHover
            pressedcolor:        Colors.confirm_dialog.confirmButtonPressed
            focuscolor:          Colors.common.background

            border.color:        dismissButton.activeFocus ?
                                    Colors.activity_center.error.border_alert_focus :
                                    "transparent"
            activeFocusOnTab: true
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 12
            anchors.rightMargin: anchors.topMargin

            useImage: true
            imagecontrol.source: "file:///" + imageLocation + "dialog_dismiss.svg"
            imagecontrol.width: xButtonSize
            imagecontrol.height: xButtonSize
            imagecontrol.sourceSize.width:  xButtonSize
            imagecontrol.sourceSize.height: xButtonSize

            mousearea.cursorShape: Qt.ArrowCursor

            Accessible.name: confirmDialogRoot.xButtonAltText
            callback: function() {
                dismissed();
                confirmDialogRoot.close();
            }

            KeyNavigation.backtab: primaryButton
            KeyNavigation.tab: (linkButton.visible > 0) ? linkButton : ((button2Text.length > 0) ? secondaryButton : primaryButton)
        }
    }
}
