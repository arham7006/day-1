
import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2

// TextWithCheck
//
// Represents a text element with a green check beside it. can have embedded links within in.
// Consumers need to define the following when adding it:
//   text.text as the string to display

// Optionally, the following can be configured:
//   checkBoxWidth
//   checkBoxHeight
//   marginBetweenCheckBoxAndText

Rectangle {
    id: container
    color: "transparent"

    property int checkBoxWidth: 12
    property int checkBoxHeight: 12
    property int marginBetweenCheckBoxAndText: 5
    property alias text: itemText

    height: checkBoxHeight
    width: childrenRect.width

    Image {
        id: checkMark
        source:fullImageLocation + "list_checkbox.svg"
        sourceSize.height: checkBoxHeight
        sourceSize.width: checkBoxWidth
        height: checkBoxHeight
        width: checkBoxWidth
        fillMode: Image.PreserveAspectFit
        
        anchors.left: parent.left
        anchors.verticalCenter: itemText.verticalCenter
    }
    
    Text {
        id: itemText
        text: ""
        color: Colors.common.text
        font.pixelSize: 14
        font.family: "Segoe UI"

        anchors.left: checkMark.right
        anchors.leftMargin: marginBetweenCheckBoxAndText
        
        Accessible.role: Accessible.StaticText
        Accessible.name: itemText.text
        Accessible.readOnly: true
    }
}
