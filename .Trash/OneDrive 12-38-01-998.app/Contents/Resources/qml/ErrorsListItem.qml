/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4
import QtQml 2.2

import "HelperFunctions.js" as HelperFunctions

// Error list item, data is configured by an ActivityCenterErrorData struct
// stored in a list in the ErrorModel 
FocusScope {
    anchors.left: parent.left
    anchors.right: parent.right
    height: rootMessageRect.height
    id: errorItem

    // Attaches to parent so we can access data
    property variant parentErrorsList: ListView.view

    property var messageColors: (errorsModel.isWarningsOnly) ? Colors.errors_list.warning : Colors.errors_list.error

    // SinglePageEntry follows custom theme. Otherwise follow default error list theme
    property variant buttonOneTheme:
        (errorsModel.hasSingleFrontPageEntry && !errorsModel.isWarningOnly) ?
            Colors.acm_buttons.error :
            Colors.acm_buttons.primary

    property variant buttonTwoTheme:
        (errorsModel.hasSingleFrontPageEntry && !errorsModel.isWarningOnly) ?
            Colors.acm_buttons.error_transparent :
            Colors.acm_buttons.primary_transparent

    function isSelfOrChildActive() {
        return (activeFocus ||
                learnMoreLinkId.activeFocus ||
                buttonOne.activeFocus ||
                buttonTwo.activeFocus ||
                errorCheckBox.activeFocus);
    }

    property bool containsHoverFocus: (itemMouseArea.containsMouse ||
                                        learnMoreLinkId.hovered ||
                                        buttonOne.containsMouse ||
                                        buttonTwo.containsMouse ||
                                        errorCheckBox.hovered)

    Rectangle {
        id: hoverRectangle
        anchors.fill: parent
        color:

            (errorsModel.hasSingleFrontPageEntry) ?
                messageColors.background
                :
                HelperFunctions.chooseListItemBackgroundColor(
                    isSelfOrChildActive(),
                    true,
                    containsHoverFocus)

        border.color: isSelfOrChildActive() ? Colors.activity_center.list.border_focus : "transparent"
        border.width: 1
        focus: true
 
        function makeItemCurrent() {
            if (parentErrorsList)
            {
                parentErrorsList.currentIndex = index;
                parentErrorsList.positionViewAtIndex(index, ListView.Visible);
                parentErrorsList.forceActiveFocus();
            }
        }

        function mainAction() {
            makeItemCurrent();
            errorsModel.MainAction(index, errorCheckBox.checked);
        }

        MouseArea {
            id: itemMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onClicked: hoverRectangle.mainAction(index, errorCheckBox.checked)
        }

        Accessible.role: Accessible.LayeredPane
        Accessible.name: (errorsModel.hasSingleFrontPageEntry) ?
               (errorsModel.GetPrimaryErrorData("primaryText") + "," + errorsModel.GetPrimaryErrorData("secondaryText")) :
               (itemIndexAccessibleText + ";" + primaryText + ";" + secondaryText)
               
        Accessible.focusable: true
        Accessible.selectable: true
        Accessible.selected: errorItem.ListView.isCurrentItem
        Accessible.ignored: !visible
        Accessible.onPressAction: activateAndDoAction();

        function activateAndDoAction() {
            hoverRectangle.makeItemCurrent()
            hoverRectangle.mainAction(index, errorCheckBox.checked);
        }

        Keys.onEnterPressed: activateAndDoAction()
        Keys.onReturnPressed: activateAndDoAction()
        Keys.onSpacePressed: activateAndDoAction()

        Rectangle {
            id: rootMessageRect

            readonly property int verticalPadding: 8
            readonly property int horizontalPadding: 12

            height: visible ? 
                        (errorsModel.hasSingleFrontPageEntry) ? 
                            Math.max(messageInner.height, 60) :
                            messageInner.height :
                        0

            activeFocusOnTab: false // Focus should go to content instead

            anchors.left: parent.left
            anchors.right: parent.right
            color: "transparent" // So the hoverRectangle shows through

            Rectangle {
                id: messageInner
                anchors.top: parent.top
                anchors.topMargin: rootMessageRect.verticalPadding
                anchors.left: parent.left
                anchors.leftMargin: rootMessageRect.horizontalPadding
                anchors.right: parent.right
                anchors.rightMargin: rootMessageRect.horizontalPadding
                height: (messageTextGroup.height + loaderRect.height + 
                        actionButtons.height + rootMessageRect.verticalPadding +
                        (errorCheckBox.visible ?
                            (errorCheckBox.height + rootMessageRect.verticalPadding) : 0 ) +
                        rootMessageRect.verticalPadding)
                color: "transparent"

                Image {
                    id: messageIcon
                    width: (errorsModel.hasSingleFrontPageEntry) ? 48 : 32
                    height: (errorsModel.hasSingleFrontPageEntry) ? 48 : 32
                    sourceSize.width: 48
                    sourceSize.height: 48
                    anchors.left: parent.left
                    anchors.top: parent.top
                    fillMode: Image.PreserveAspectFit

                    // If an imageUrl isn't specified, then we know we should use the file icon image
                    source: errorsModel.hasSingleFrontPageEntry ? 
                        (errorsModel.GetPrimaryErrorData("imageUrl") ? ("file:///" + imageLocation + errorsModel.GetPrimaryErrorData("imageUrl") ) : errorsModel.GetPrimaryErrorData("fileImage")) :
                        (imageUrl ? ("file:///" + imageLocation + imageUrl) : fileImage)
                }

                Column {
                    id: messageTextGroup
                    anchors.left: messageIcon.right
                    anchors.leftMargin: rootMessageRect.horizontalPadding
                    anchors.right : parent.right
                    anchors.top: parent.top

                    Text {
                        id: messagePrimary
                        color: (errorsModel.hasSingleFrontPageEntry) ?
                                    messageColors.text:
                                    containsHoverFocus ?
                                        Colors.common.text_hover : Colors.common.text
                        text: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("primaryText") : primaryText
                        height: visible ? undefined : 0
                        font.family: "Segoe UI Semibold"
                        font.pixelSize: 14
                        anchors.left: messageTextGroup.left
                        anchors.right: messageTextGroup.right
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignTop
                    }

                    Text {
                        id: messageSecondary
                        color:  (errorsModel.hasSingleFrontPageEntry) ?
                                    messageColors.text :
                                    containsHoverFocus ?
                                        Colors.common.text_secondary_hovering : Colors.common.text_secondary

                        text: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("secondaryText") : secondaryText
                        height: visible ? undefined : 0
                        font.pixelSize: 12
                        font.family: "Segoe UI Semilight"
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignLeft
                        anchors.left: parent.left
                        anchors.right: parent.right
                    }

                    Button {
                        id: learnMoreLinkId
                        width: 75
                        anchors.left: parent.left
                        height: visible ? contentItem.paintedHeight : 0
                        leftPadding: 0
                        rightPadding: 0
                        bottomPadding: 0
                        topPadding: 0
                        activeFocusOnTab: true
                        visible: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("hasLearnMoreLink") : hasLearnMoreLink

                        contentItem: Text {
                            id: learnMoreTextItem
                            text: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("learnMoreText") : learnMoreText
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            font.underline: learnMoreLinkId.visualFocus
                            color: parent.pressed ?
                                Colors.common.hyperlink_pressed :
                                parent.hovered ?
                                    Colors.common.hyperlink_hovering :
                                    Colors.common.hyperlink
                            horizontalAlignment: Text.AlignLeft
                        }

                        background: Rectangle {
                            implicitWidth: learnMoreLinkId.width
                            implicitHeight: learnMoreLinkId.height
                            color: "transparent"
                        }

                        function launchLearnMoreAction() {
                            errorsModel.LearnMoreClicked(index, errorCheckBox.checked);
                        }

                        Accessible.ignored: !visible
                        Accessible.onPressAction: launchLearnMoreAction()
                        Keys.onEnterPressed: launchLearnMoreAction()
                        Keys.onReturnPressed: launchLearnMoreAction()
                        Keys.onSpacePressed: launchLearnMoreAction()

                        MouseArea {
                            id: folderLinkMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: parent.launchLearnMoreAction()
                        }
                    }
                }

                // This area contains custom controls configured for each error.
                // If the ActivityCenterErrorData struct specifies the customControlFile
                // This qml file will be loaded below
                Rectangle {
                    id: loaderRect
                    height:  errorsModel.hasSingleFrontPageEntry ?
                        (errorsModel.GetPrimaryErrorData("hasCustomControl") ? childrenRect.height : 0 ) : 
                        ( hasCustomControl ? childrenRect.height : 0)
                    anchors.top: (errorCheckBox.visible ? errorCheckBox.bottom : messageTextGroup.bottom)
                    anchors.left: messageTextGroup.left
                    anchors.topMargin: rootMessageRect.verticalPadding
                    visible: errorsModel.hasSingleFrontPageEntry ? (errorsModel.GetPrimaryErrorData("customControlsFile").length  === 0) : (customControlsFile.length === 0)

                    Loader {
                        source: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("customControlsFile") : customControlsFile
                        asynchronous: true
                        active: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("hasCustomControl") : hasCustomControl
                        visible: (status === Loader.Ready)
                    }
                }

                CheckBox {
                    id: errorCheckBox
                    visible: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("hasCheckbox") : hasCheckbox
                    spacing: 2
                    topPadding: -1
                    bottomPadding: 0
                    // Anchor to left and shift over checkbox by width of error icon image,
                    // so the user can click in the empty area under the icon
                    leftPadding: messageIcon.width + rootMessageRect.horizontalPadding
                    rightPadding: messageIcon.width + rootMessageRect.horizontalPadding
                    anchors.top: messageTextGroup.bottom
                    anchors.left: parent.left
                    anchors.topMargin: visible ? rootMessageRect.verticalPadding : 0
                    height: visible ? contentItem.paintedHeight : 0

                    contentItem: Text {
                        id: checkboxTextLabel
                        width: errorCheckBox.width
                        anchors.left: indicatorBox.right
                        leftPadding: errorCheckBox.spacing
                        rightPadding: errorCheckBox.spacing
                        text: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("checkboxText") : checkboxText
                        color: messageColors.text

                        font.pixelSize: 12
                        font.family: "Segoe UI"
                        font.weight: Font.Light
                    }

                    indicator: Rectangle {
                        id: indicatorBox
                        implicitWidth: 14
                        implicitHeight: 14
                            
                        border.width: parent.visualFocus ? 2 : 1
                        border.color: buttonOneTheme.button

                        x: headerModel.isRTL ? (parent.width - parent.leftPadding  - implicitWidth ) : parent.leftPadding
                        Image {
                            sourceSize.width:  14
                            sourceSize.height: 14
                            anchors.fill: parent
                            source: "file:///" + imageLocation + "checkboxComposite.svg"
                            visible: errorCheckBox.checked
                        }
                    }

                    // Workaround for accessibility, Controls2.0 read accessible text from text,
                    // instead of setting Accessible.name. Displayed text is based off contentItem (checkboxTextLabel)
                    text: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("checkboxText") : checkboxText
                    Accessible.ignored: !visible
                    Accessible.role: Accessible.CheckBox
                    Accessible.focusable: true
                }

                Flow {
                    id: actionButtons
                    objectName: "actionButtons"
                    spacing: 8
                    visible:  (errorsModel.hasSingleFrontPageEntry ?
                                    errorsModel.GetPrimaryErrorData("buttonOneVisible") ||  errorsModel.GetPrimaryErrorData("buttonTwoVisible") : 
                                    buttonOneVisible || buttonTwo.visible)
                    anchors.top: errorCheckBox.bottom
                    anchors.left: messageTextGroup.left
                    anchors.topMargin: visible ? rootMessageRect.verticalPadding : 0
                    bottomPadding: visible ? rootMessageRect.verticalPadding : 0
                    anchors.right: parent.right

                    SimpleButton {
                        id: buttonOne
                        visible: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("buttonOneVisible") : buttonOneVisible
                        width: visible ? ((textcontrol.width > 80) ? textcontrol.width : 80) : 0
                        height: visible ? 28 : 0

                        colorScheme: buttonOneTheme

                        focusunderline: true
                        activeFocusOnTab: true

                        textcontrol.font.pixelSize: 12
                        textcontrol.text: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("primaryButtonText") : primaryButtonText
                        textcontrol.font.family: "Segoe UI Semibold"
                        textcontrol.topPadding: 4
                        textcontrol.bottomPadding: 4
                        textcontrol.leftPadding: 12
                        textcontrol.rightPadding: 12
                        callback: function() {
                            errorsModel.PrimaryAction(index, errorCheckBox.checked);
                        }
                        Accessible.name: textcontrol.text
                        Accessible.ignored: !visible
                    }

                    SimpleButton {
                        id: buttonTwo
                        visible: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("buttonTwoVisible") : buttonTwoVisible
                        width: visible ? ((textcontrol.width > 80) ? textcontrol.width : 80) : 0
                        height: visible ? 28 : 0

                        colorScheme: buttonTwoTheme

                        focusunderline: true
                        activeFocusOnTab: true

                        textcontrol.font.pixelSize: 12
                        textcontrol.text: errorsModel.hasSingleFrontPageEntry ? errorsModel.GetPrimaryErrorData("secondaryButtonText") : secondaryButtonText
                        textcontrol.font.family: "Segoe UI Semibold"
                        textcontrol.topPadding: 4
                        textcontrol.bottomPadding: 4
                        textcontrol.leftPadding: 12
                        textcontrol.rightPadding: 12
                        textcontrol.font.bold: true
                        callback: function() {
                            errorsModel.SecondaryAction(index, errorCheckBox.checked);
                        }
                        Accessible.name: textcontrol.text
                        Accessible.ignored: !visible
                    }
                }
            }
        }
    }
}
