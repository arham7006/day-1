
import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2

// IconWithTextAndDescription
//
// Represents a horizontal layout of image, title and subtext.
// Consumers need to define the following when adding it:
//   icon.source
//   subtitleText.text
//   titleText.text

Rectangle {
    id: container
    color: "transparent"
    width: 144
    height: childrenRect.height

    property alias image: icon
    property string accessibleIconDescription: ""
    property alias titleText: title
    property alias subtitleText: subtitle
    property string accessibleSubtitleText: ""
    
    Accessible.role: Accessible.Grouping
    Accessible.name: title.text

    Image {
        id: icon
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        sourceSize.height: 80
        sourceSize.width: 61
        height: 65
        width: 48
        fillMode: Image.PreserveAspectFit
        Accessible.role: Accessible.Graphic
        Accessible.name: accessibleIconDescription
    }

    Text {
        id: title
        anchors {
            top: icon.bottom
            topMargin: 22
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width - 16

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap

        color: Colors.common.text
        font.pixelSize: 14
        font.family: "Segoe UI Semibold"
        font.weight: Font.Bold

        Accessible.ignored: true
    }

    Text {
        id: subtitle
        anchors {
            top: title.bottom
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width

        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap

        color: Colors.common.text_secondary
        font.pixelSize: 12
        font.family: "Segoe UI"

        Accessible.role: Accessible.StaticText
        Accessible.name: (accessibleSubtitleText !== "") ? accessibleSubtitleText : subtitle.text
        Accessible.readOnly: true
    }
}
