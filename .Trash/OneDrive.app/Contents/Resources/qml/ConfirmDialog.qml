import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2

Dialog {
    id: confirmDialogRoot

    // Exported properties
    property int folderType : 0

    property string dialogTitleText: ""
    property string dialogBodyText: ""
    property string button1Text: ""
    property string button2Text: ""
    property string xButtonAltText: ""

    property bool isRTL: false
    property bool defaultButtonOnLeft: true

    signal button1Clicked()
    signal button2Clicked()
    signal dismissed()

    onAboutToHide: {
        // Reset keyboard focus within the scope of this dialog
        // to the default (header).
        // If the user opens the dialog, presses TAB to go to a button
        // then closes the dialog, and later reopens it again, the expectation
        // is that TAB focus starts anew on the default tab item.
        header.forceActiveFocus();
    }

    height: Math.max(172, confirmDialogRoot.implicitHeight)
    width: Math.max(310, buttons.implicitWidth)

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

    title: dialogTitleText

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

            topPadding: 5
            bottomPadding: 20
            leftPadding: 28
            rightPadding: 28

            FabricButton {
                id: primaryButton
                buttonStyle: "primary"
                buttonText: button1Text

                onClicked: {
                    confirmDialogRoot.close();
                    confirmDialogRoot.button1Clicked();
                }

                Accessible.onPressAction: onClicked();
                Keys.onReturnPressed: onClicked();
                Keys.onEnterPressed: onClicked();

                KeyNavigation.backtab: (button2Text.length > 0) ? secondaryButton : xButton
                KeyNavigation.tab: xButton
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

                KeyNavigation.backtab: xButton
                KeyNavigation.tab: primaryButton
            }
        }
    }

    header: Rectangle {
        implicitHeight: headerText.implicitHeight
        id: confirmDialogHeader
        color: "transparent"
        focus: true
        Accessible.role: Accessible.StaticText
        Accessible.readOnly: true
        Accessible.name: headerText.text
        Accessible.focusable: true
        Accessible.focused: activeFocus

        LayoutMirroring.enabled: isRTL
        LayoutMirroring.childrenInherit: true

        Text {
            id: headerText
            font.family: "Segoe UI"
            font.weight: Font.Light
            text: dialogTitleText
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            color: Colors.move_window.folderItemPrimaryText
            font.pixelSize: 21
            topPadding: 28
            bottomPadding: 20
            leftPadding: 28
            rightPadding: 28
            anchors.left: confirmDialogHeader.left
            anchors.right: xButton.right
            anchors.rightMargin: 12
        }

        Button {
            id: xButton

            onClicked: {
                dismissed();
                confirmDialogRoot.close();
            }

            Accessible.onPressAction: onClicked()
            Keys.onReturnPressed: onClicked()
            Keys.onEnterPressed: onClicked()

            hoverEnabled: true
            contentItem: Image {
                source: fullImageLocation + "acmDismissIcon.svg"
                sourceSize.width: 8
                sourceSize.height: 8
            }
            background: Rectangle {
                color: (xButton.down) ?
                           Colors.move_window.confirmButtonPressed :
                           (xButton.hovered) ?
                               Colors.move_window.confirmButtonHover :
                               Colors.common.background   // Add new color set for confirm dialog
                border.color: xButton.activeFocus ?
                                  Colors.activity_center.error.border_alert_focus : // Add new color set for confirm dialog
                                  "transparent"
            }
            anchors {
                top: parent.top
                topMargin: 12
                right: parent.right
                rightMargin: 12
            }

            text: confirmDialogRoot.xButtonAltText

            KeyNavigation.backtab: primaryButton
            KeyNavigation.tab: (button2Text.length > 0) ? secondaryButton : primaryButton
        }
    }

    contentItem: Rectangle {
        id: confirmDialogContent

        LayoutMirroring.enabled: isRTL
        LayoutMirroring.childrenInherit: true
        color: "transparent"

        anchors {
            left: parent.left
            right: parent.right
            top: confirmDialogHeader.bottom
        }

        Text {
            id: bodyTextElement

            anchors.left: parent.left
            anchors.right: parent.right

            text: dialogBodyText
            horizontalAlignment: Text.AlignLeft

            leftPadding: 28
            rightPadding: 28

            font.family: "Segoe UI"
            font.weight: Font.Light
            wrapMode: Text.WordWrap
            color: Colors.move_window.folderItemPrimaryText
            font.pixelSize: 12

            Accessible.role: Accessible.StaticText
            Accessible.readOnly: true
            Accessible.name: text
        }
    }
}
