/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4
import QtQml 2.2

import com.microsoft.OneDrive 1.0

import "fabricMdl2.js" as FabricMDL

import "HelperFunctions.js" as HelperFunctions

Rectangle
{
    readonly property int verticalPadding: 8
    readonly property int horizontalPadding: 12
    readonly property int bottomPadding: 14
    height: visible ?  (errorTextGroupV2.height + (2 * verticalPadding)) : 0
    width: parent.width

    color: HelperFunctions.chooseErrorOrWarningBGColor(errorsModel.isWarningsOnly, (errorListHeaderMouseArea.containsMouse || errorListHeaderMouseArea.activeFocus))

    border.color: errorListHeaderMouseArea.activeFocus ? Colors.activity_center.error.border_alert_focus : "transparent"
    border.width: 1

    Image {
        id: errorIconV2
        width: 48
        height: 48
        sourceSize.width:  48
        sourceSize.height: 48
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: errorStatusRect.horizontalPadding
        source: errorsModel.isWarningsOnly ?
                    "file:///" + imageLocation + "infoIcon.svg" :
                    "file:///" + imageLocation + "errorIcon.svg";
        fillMode: Image.PreserveAspectFit
    }

    Column {
        id: errorTextGroupV2
        anchors.left: errorIconV2.right
        anchors.leftMargin: errorStatusRect.horizontalPadding
        anchors.right : rightArrowButton.left
        anchors.topMargin: parent.verticalPadding
        anchors.top: parent.top

        Text {
            id: errorPrimaryV2
            color: errorListHeaderMouseArea.containsMouse ?
                Colors.activity_center.error.error_rect_text_hovering :
                Colors.activity_center.error.error_rect_text
            text: errorsModel.errorEntryHeaderText

            font.family: "Segoe UI Semibold"
            font.pixelSize: 14
            anchors.left: errorTextGroupV2.left
            anchors.right: errorTextGroupV2.right
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
        }

        Text {
            id: errorSecondaryV2
            color: errorListHeaderMouseArea.containsMouse ?
                Colors.activity_center.error.error_rect_text_hovering :
                Colors.activity_center.error.error_rect_text
            text: errorsModel.errorEntrySecondaryText
            font.pixelSize: 12
            anchors.left: errorTextGroupV2.left
            anchors.right: errorTextGroupV2.right
            font.family: "Segoe UI"
            font.weight: Font.Light
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            visible: (contentWidth > 0)
        }
    }

    Image {
        id: rightArrowButton
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        height: 32
        width: 32
        sourceSize.width:  32
        sourceSize.height: 32
        source: headerModel.isRTL ?
            "file:///" + imageLocation + "backArrow.svg" : // RTL should use the back arrow
            "file:///" + imageLocation + "forwardArrow.svg"  // LTR should use forward arrow
    }

    MouseArea
    {
        id: errorListHeaderMouseArea
        anchors.fill: parent
        hoverEnabled: true

        activeFocusOnTab: true
        Accessible.focusable: true
        Accessible.onPressAction: {
            errorsModel.SetErrorViewOpened(true);
        }
        Accessible.name: errorsModel.errorEntryBannerAccessibleText
        Accessible.ignored: !visible
        Accessible.role: Accessible.Button

        Keys.onReturnPressed: switchToErrorsView(true);
        Keys.onSpacePressed: switchToErrorsView(true);
        onClicked: switchToErrorsView(false);
    }
}