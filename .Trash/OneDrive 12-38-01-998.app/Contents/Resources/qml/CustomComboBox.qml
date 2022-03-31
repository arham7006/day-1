/************************************************************ */
/*                                                            */
/* Copyright (C) Microsoft Corporation. All rights reserved.  */
/*                                                            */
/**************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0

// CustomComboBox is a formatted ComboBox object.
//
// How to use CustomComboBox:
//  - Populate the combobox with a model.
//
// Developer must change the following for each CustomComboBox:
//  - model (model): model used to populate values of ComboBox. See QT documentation for more.
//  - placeholderText (string): default string of the combobox
//  - width (int): width of the ComboBox OR anchors.(left + right): specifies the width of the ComboBox
//
// Optional
//  - height (int): height of the CustomComboBox. Default value 40
//  - itemMargin (int): margin for placeholder text and items in the combobox
//  - fontSize (int): text font size for placeholder text and dropdown text options

ComboBox {
    id: comboBox
    activeFocusOnTab: true
    height: placeholder.implicitHeight
            
    property bool isCategoryPicked: false
    property int itemMargin: 12
    property int fontSize: 14
    property string placeholderText: "Replace me with your text"

    onActivated: {comboBox.isCategoryPicked = true}

    Accessible.role: Accessible.ComboBox
    Accessible.name: "combobox"
    Accessible.focusable: true

    function chooseBackgroundColor(isHovering, activeFocus, isPressed, index) {
        var color = Colors.common.background;
        if (isHovering) {
            color = Colors.combo_box.item_hover;
        }
        if (activeFocus) {
            color = Colors.combo_box.item_focus;
        }
        if (isPressed || (comboBox.currentIndex === index && isCategoryPicked)) {
            color = Colors.combo_box.item_pressed;
        }
        return color;
    }

    function chooseTextColor(isHovering, activeFocus) {
        var color = Colors.common.text_secondary;
        if (isHovering || activeFocus || comboBox.isCategoryPicked) {
            color = Colors.common.text;
        }
        return color;
    }

    function chooseBorderColor(isHovering, activeFocus) {
        var color = color =  Colors.combo_box.input_border;
        if (activeFocus || isHovering) {
            color = Colors.combo_box.input_border_focused;
        }
        return color;
    }

    indicator: Image {
        id: chevronButton
        height: 32
        width: 24
        source: "file:///" + imageLocation + "chevron.svg"
        anchors.right: parent.right
        anchors.rightMargin: comboBox.itemMargin
        anchors.verticalCenter: parent.verticalCenter
    }

    background: Rectangle {
        color: Colors.common.background
        border.color: chooseBorderColor(comboBox.hovered, comboBox.activeFocus)
    }

    contentItem: Text {
        id: placeholder
        text: comboBox.isCategoryPicked ? comboBox.currentText : placeholderText
        color: chooseTextColor(comboBox.hovered, comboBox.activeFocus)
        
        width: comboBox.width
        padding: parent.itemMargin
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.Wrap
        anchors.left: parent.left
        
        font.family: "Segoe UI"
        font.pixelSize: fontSize
    }

    delegate: ItemDelegate {
        id: itemDlgt
        LayoutMirroring.enabled: comboBox.mirrored
        LayoutMirroring.childrenInherit: true

        width: parent.width
        height: textItem.implicitHeight
        padding: 0

        contentItem: Text {
            id: textItem
            text: modelData
            color: Colors.combo_box.input_placeholder
            
            wrapMode: Text.Wrap
            padding: comboBox.itemMargin
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            width: parent.width
            anchors {
                top: parent.top
                left: parent.left
            }

            font.family: "Segoe UI"
            font.pixelSize: fontSize
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            onClicked: itemDlgt.clicked()
        }

        background: Rectangle {
            anchors.fill: parent
            color: chooseBackgroundColor(itemDlgt.hovered, itemDlgt.activeFocus, ma.containsPress, index)
        }
    }
}
