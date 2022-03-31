import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2

ConfirmDialog {
    id: confirmDialogRoot

    // Exported properties
    property string imageSource: ""
    property string imageLabel: ""
    property int imageWidth: 0
    property int imageHeight: 0

    preferredWidth: 426
    preferredHeight: 409

    padding: 0

    headerTextHorizontalAlignment: Text.AlignHCenter
    headerTextFontPixelSize: 24
    headerBottomPadding: 25

    footerBottomPadding: 25
    footerTopPadding: 25

    xButtonSize: 10

    // Overwrite the dialog's content element here in order to support the requisite image area.
    contentItem: Rectangle {
        id: confirmDialogContent

        LayoutMirroring.enabled: isRTL
        LayoutMirroring.childrenInherit: true
        color: "transparent"

        implicitHeight: confirmDialogImageArea.implicitHeight + confirmDialogBodyText.implicitHeight

        Column {
            id: confirmDialogImageArea

            property int margin : 28

            spacing: 5

            anchors {
                left: parent.left
                leftMargin: margin
                right: parent.right
                rightMargin: margin
            }

            Image {
                id: confirmDialogImage
                anchors.horizontalCenter: parent.horizontalCenter
                source: imageSource
                width: imageWidth
                height: imageHeight
            }

            Text {
                id: confirmDialogImageLabel

                anchors.horizontalCenter: parent.horizontalCenter

                text: imageLabel
                fontSizeMode: Text.VerticalFit
                font.family: "Segoe UI"
                font.pixelSize: 14
                font.weight: Font.Light
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: Colors.move_window.folderItemPrimaryText

                Accessible.ignored: true
                Accessible.role: Accessible.StaticText
                Accessible.readOnly: true
                Accessible.name: text
            }
        }

        Text {
            id: confirmDialogBodyText

            anchors.top: confirmDialogImageArea.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            text: dialogBodyText
            horizontalAlignment: Text.AlignLeft

            topPadding: 25
            leftPadding: 28
            rightPadding: 28

            fontSizeMode: Text.VerticalFit
            font.pixelSize: 14
            font.family: "Segoe UI"
            font.weight: Font.Light
            wrapMode: Text.WordWrap
            color: Colors.move_window.folderItemPrimaryText

            Accessible.role: Accessible.StaticText
            Accessible.readOnly: true
            Accessible.name: text
        }
    }
}
