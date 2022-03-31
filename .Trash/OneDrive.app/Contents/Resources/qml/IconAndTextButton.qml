import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0

// IconAndTextButton
//
// Button which contains a horizontally centered and text.
// Consumers need to do the following when adding it:
//    Define the file asset of the icon using imageControl
//    Define the text value of the label via textControl
//    Left and right anchors
//    Declare onClicked behavior
Button {
    id: root

    // Exposed properties for setting image and text values
    property alias textControl: txt
    property alias imageControl: img

    // Fixed width, but anchors to top/bottom of parent
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 105

    // Setting text value of the base button object will take care of accessible name
    text: txt.text
    Accessible.onPressAction: root.clicked()
    
    background: Rectangle {
        border.width: (root.activeFocus || colorThemeManager.highContrastEnabled) ? 1 : 0
        border.color: Colors.activity_center.footer.button_focused_border
        color : root.pressed ? Colors.activity_center.footer.button_pressed : (root.hovered ? Colors.activity_center.footer.button_hovered : Colors.activity_center.footer.button)
    }

    // A vertical column which holds the icon and label of the button.
    contentItem: Column {
        // padding from top of button to the Icon
        padding: 16
        // Spacing between Icon and Text
        spacing: 12

        opacity: enabled ? 1 : 0.3

        // Icon on the button
        Image {
            id: img
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.height: 20
            sourceSize.width: 20
            height: 20
            width: 20
        }

        // Text label on the button
        Text {
            id: txt
            width: root.width
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
            font.underline: root.activeFocus
            font.family: "Segoe UI"
            color: Colors.activity_center.footer.button_text
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
    }
}