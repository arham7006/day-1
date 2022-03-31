import Colors 1.0
import QtQuick 2.0
import QtQuick.Controls 2.4

import "fabricMdl2.js" as FabricMDL

/*
  Checkbox customized to be used in a TreeView (e.g. Selective Sync), shows a
  checkbox, text and a file/folder icon.

  Need to set:
    text - the text to be shown
    checkState - the Checked/Unchecked state
 */
CheckBox {
    id: theCheck
    text: "Sample checkbox"
    tristate: true

    spacing: 3
    hoverEnabled: true

    topPadding: 1
    bottomPadding: 1
    leftPadding: 0

    property bool hasActiveFocus : false
    property alias imageSrc : fileFolderIcon.source

    Accessible.role: Accessible.CheckBox
    Accessible.name: theCheck.text
    Accessible.checked: ((checkState === Qt.Checked) || (checkState === Qt.PartiallyChecked))
    Accessible.checkStateMixed: (checkState === Qt.PartiallyChecked)

    FontLoader {
        id: fabricMDL2;
        source: Qt.platform.os === "osx" ? "FabExMDL2.ttf" : "file:///" + qmlEngineBasePath + "FabExMDL2.ttf"
    }

    background: Rectangle {
        id: theBkgnd
        color: "transparent"
        implicitWidth: theCheck.indicator.width + theCheck.spacing + theCheck.leftPadding + theCheck.rightPadding + theFocusRect.width + theCheck.spacing
    }

    nextCheckState: function() {
        if ((checkState === Qt.Checked) || (checkState === Qt.PartiallyChecked))
            return Qt.Unchecked
        else if (checkState === Qt.Unchecked)
            return Qt.Checked
    }

    indicator: Rectangle {
        id: theInd
        implicitHeight: 20
        implicitWidth: 20
        color: "transparent"

        anchors.left: theCheck.left
        anchors.verticalCenter: theCont.verticalCenter

        Rectangle {
            anchors.centerIn: parent
            width: 16
            height: 16

            border.width: 1
            border.color: (theCheck.checkState === Qt.Checked) ?
                              "transparent" :
                              (theCheck.checkState === Qt.PartiallyChecked) ?
                                    theCheck.hovered ?
                                        Colors.treeview_checkbox.checked_partial_hovered :
                                        Colors.treeview_checkbox.border_partial:
                                    theCheck.hovered ?
                                        Colors.treeview_checkbox.border_unchecked_hovered :
                                        Colors.treeview_checkbox.border_unchecked

            color: (theCheck.checkState == Qt.Checked) ?
                       (theCheck.pressed ?
                            Colors.treeview_checkbox.fill_color_checked_pressed :
                                theCheck.hovered ?
                                    Colors.treeview_checkbox.checked_partial_hovered :
                                    Colors.treeview_checkbox.fill_color_checked) :
                       (theCheck.pressed ?
                            Colors.treeview_checkbox.fill_color_unchecked_pressed :
                            Colors.treeview_checkbox.fill_color_unchecked)

            Text {
                visible: (theCheck.checkState === Qt.Checked)
                anchors.centerIn: parent
                font.family: fabricMDL2.name
                font.pixelSize: 13
                color: Colors.treeview_checkbox.checkmark

                text: (theCheck.checkState === Qt.Checked) ?
                          FabricMDL.Icons.CheckMark :
                          ((theCheck.checkState === Qt.Unchecked) ? "" : FabricMDL.Icons.CheckboxIndeterminate)
            }

            Rectangle {
                visible: (theCheck.checkState === Qt.PartiallyChecked)
                anchors.centerIn: parent
                width: 8
                height: 8
                color: theCheck.hovered ?
                           Colors.treeview_checkbox.checked_partial_hovered :
                           Colors.treeview_checkbox.partial
            }
        }
    }

    contentItem: Rectangle {
        id: theCont
        color: "transparent"

        anchors.left: indicator.right
        anchors.leftMargin: 2

        Rectangle {
            id : theFocusRect
            width: childrenRect.width + (fileFolderIcon.anchors.leftMargin * 2)
            color: theCheck.hasActiveFocus ?
                                   Colors.activity_center.list.background_focus :
                                   (theCheck.hovered ? Colors.treeview_checkbox.text_hover : "transparent")

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            height: 20

            Image {
                id: fileFolderIcon
                sourceSize.height: 16
                sourceSize.width: 16

                anchors.left: parent.left
                anchors.leftMargin: 5

                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: theText
                anchors.left: fileFolderIcon.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                text: theCheck.text
                font.family: "Segoe UI"
                font.pixelSize: 14
                color: (theCheck.hasActiveFocus || theCheck.hovered) ? Colors.common.text_hover : Colors.common.text
                font.weight: Font.Normal
            }
        }
    }
}
