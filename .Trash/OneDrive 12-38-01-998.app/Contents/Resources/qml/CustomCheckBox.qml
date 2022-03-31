/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0
import "fabricMdl2.js" as FabricMDL

// CustomCheckBox is a formatted CheckBox
//
// How to use CustomCheckBox:
//
// Developer must change the following for each CustomCheckBox:
//  - Text (string): Text displayed after the Checkbox
//  - onClicked: Action that occurs if a checkbox has been clicked
//
// Optional
//  - spacingBetweenCheckBoxAndText: Modify the spacing between the Checkbox and Text
//  - checked: Checkbox will be checked if true, unchecked if false. Default is unchecked

CheckBox {
    id: theCheck

    property string checkBoxText: ""
    property int spacingBetweenCheckBoxAndText: 0
    
    Accessible.ignored: !theCheck.visible
    text: theText.text      // this gets picked up Accessible.name
    
    Accessible.role: Accessible.CheckBox
    Accessible.name: theCheck.text
    Accessible.checked: ((checkState === Qt.Checked) || (checkState === Qt.PartiallyChecked))
    Accessible.checkStateMixed: (checkState === Qt.PartiallyChecked)

    spacing: 3
    hoverEnabled: true
    activeFocusOnTab: true
    
    topPadding: 1
    bottomPadding: 1
    leftPadding: 5

    FontLoader {
        id: fabricMDL2;
        source: (Qt.platform.os === "osx") ? "FabExMDL2.ttf" : "file:///" + qmlEngineBasePath + "FabExMDL2.ttf"
    }

    background: Rectangle {
        id: theBkgnd
        color: "transparent"
        // Width of both the Checkbox and Checkbox text
        implicitWidth: theCheck.indicator.width + theCheck.spacing + theCheck.leftPadding + theCheck.rightPadding + theFocusRect.width + theCheck.spacing
    }

    indicator: Rectangle {
        id: theInd
        implicitHeight: 20
        implicitWidth: 20
        color: "transparent"

        anchors.left: theCheck.left
        anchors.verticalCenter: theContent.verticalCenter

        border.width: theCheck.visualFocus ? 1 : 0
        border.color: theCheck.visualFocus ? Colors.common.text : "transparent"

        Rectangle {
            anchors.centerIn: parent
            width: 16
            height: 16

            border.width: 1
            border.color: theCheck.hovered ?
                              Colors.treeview_checkbox.border_unchecked_hovered :
                              Colors.treeview_checkbox.border_unchecked

            color: (checkState === Qt.Checked) ? 
                        (theCheck.pressed ? 
                            Colors.treeview_checkbox.fill_color_checked_pressed :
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

                text: FabricMDL.Icons.CheckMark
            }
        }
    }

    contentItem: Rectangle {
        id: theContent
        color: "transparent"

        anchors.left: indicator.right

        Rectangle {
            id : theFocusRect
            width: childrenRect.width + theCheck.spacing + theText.anchors.leftMargin
            color: "transparent"
            
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: spacingBetweenCheckBoxAndText
            height: 20

            Text {
                id: theText
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                text: theCheck.checkBoxText
                font.family: "Segoe UI"
                font.pixelSize: 14
                color: (theCheck.hovered ?
                      Colors.common.text_hover : Colors.common.text)
                font.weight: Font.Normal
            }
        }
    }
}