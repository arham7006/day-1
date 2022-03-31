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

// Error list item component, data is configured by an ActivityCenterErrorData struct
// stored in a list in the ErrorModel 
Component {
    id: errorItemDelegate

    FocusScope {
        anchors.left: parent.left
        anchors.right: parent.right
        height: rootMessageRect.height
        id: errorItem

        property variant parentErrorsList: ListView.view

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
            color: HelperFunctions.chooseListItemBackgroundColor(
                isSelfOrChildActive(), true, containsHoverFocus)

            border.color: isSelfOrChildActive() ? Colors.activity_center.list.border_focus : "transparent"
            border.width: 1
            focus: true
 
            function makeItemCurrent() {
                parentErrorsList.currentIndex = index;
                parentErrorsList.positionViewAtIndex(index, ListView.Visible);
                parentErrorsList.forceActiveFocus();
            }

            function mainAction() {
                makeItemCurrent();
                if (parentErrorsList.mainAction !== null)
                {
                    parentErrorsList.mainAction(index, errorCheckBox.checked);
                }
            }

            MouseArea {
                id: itemMouseArea
                anchors.fill: parent
                hoverEnabled: true

                onDoubleClicked: hoverRectangle.mainAction(index, errorCheckBox.checked)
                onClicked: hoverRectangle.makeItemCurrent()
            }

            Accessible.role: Accessible.LayeredPane
            Accessible.name: itemIndexAccessibleText + " " + primaryText + secondaryText;
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

                height: visible ? messageInner.height : 0

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
                        width: 32
                        height: 32
                        sourceSize.width: 48
                        sourceSize.height: 48
                        anchors.left: parent.left
                        anchors.top: parent.top
                        fillMode: Image.PreserveAspectFit

                         // If an imageUrl isn't specified, then we know we should use the file icon image
                        source: imageUrl ? ("file:///" + imageLocation + imageUrl) : fileImage
                    }

                    Column {
                        id: messageTextGroup
                        anchors.left: messageIcon.right
                        anchors.leftMargin: rootMessageRect.horizontalPadding
                        anchors.right : parent.right
                        anchors.top: parent.top

                        Text {
                            id: messagePrimary
                            color: containsHoverFocus ? Colors.common.text_hover : Colors.common.text
                            text: primaryText
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
                            color:  containsHoverFocus ? Colors.common.text_secondary_hovering : Colors.common.text_secondary
                            text: secondaryText
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
                            height: contentItem.paintedHeight
                            leftPadding: 0
                            rightPadding: 0
                            bottomPadding: 0
                            topPadding: 0
                            activeFocusOnTab: true
                            visible: hasLearnMoreLink

                            text: learnMoreText
                            contentItem: Text {
                                id: learnMoreTextItem
                                text: learnMoreLinkId.text
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
                                parentErrorsList.learnMoreClicked(index, errorCheckBox.checked);
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
                        height: hasCustomControl ? childrenRect.height : 0
                        anchors.top: (errorCheckBox.visible ? errorCheckBox.bottom : messageTextGroup.bottom)
                        anchors.left: messageTextGroup.left
                        anchors.topMargin: rootMessageRect.verticalPadding
                        visible: (customControlsFile.length === 0)

                        Loader {
                            source: customControlsFile
                            asynchronous: true
                            active: hasCustomControl
                            visible: (status === Loader.Ready)
                        }
                    }

                    CheckBox {
                        id: errorCheckBox
                        visible: hasCheckbox
                        spacing: 2
                        topPadding: -1
                        bottomPadding: 0
                        // Anchor to left and shift over checkbox by width of error icon image,
                        // so the user can click in the empty area under the icon
                        leftPadding: messageIcon.width + rootMessageRect.horizontalPadding
                        rightPadding: messageIcon.width + rootMessageRect.horizontalPadding
                        anchors.top: messageTextGroup.bottom
                        anchors.left: parent.left
                        anchors.topMargin: hasCheckbox ? rootMessageRect.verticalPadding : 0
                        height: hasCheckbox ? undefined : 0

                        contentItem: Text {
                            id: checkboxTextLabel
                            width: errorCheckBox.width
                            anchors.left: indicatorBox.right
                            leftPadding: errorCheckBox.spacing
                            rightPadding: errorCheckBox.spacing
                            text: checkboxText
                            color: Colors.common.text_secondary

                            font.pixelSize: 12
                            font.family: "Segoe UI"
                            font.weight: Font.Light
                        }

                        indicator: Rectangle {
                            id: indicatorBox
                            implicitWidth: 14
                            implicitHeight: 14
                            
                            border.width: parent.visualFocus ? 2 : 1
                            border.color: Colors.fabric_button.primary.background

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
                        text: checkboxText
                        Accessible.ignored: !visible
                        Accessible.role: Accessible.CheckBox
                        Accessible.focusable: true
                    }

                    Flow {
                        id: actionButtons
                        objectName: "actionButtons"
                        spacing: 8
                        visible: buttonOneVisible || buttonTwoVisible
                        anchors.top: errorCheckBox.bottom
                        anchors.left: messageTextGroup.left
                        anchors.topMargin: visible ? rootMessageRect.verticalPadding : 0
                        bottomPadding: visible ? rootMessageRect.verticalPadding : 0
                        anchors.right: parent.right

                        SimpleButton {
                            id: buttonOne
                            visible: buttonOneVisible
                            width: visible ? ((textcontrol.width > 80) ? textcontrol.width : 80) : 0
                            height: visible ? 28 : 0
                            primarycolor: Colors.fabric_button.primary.background
                            hovercolor:   Colors.activity_center.message.button_hovering
                            pressedcolor: Colors.fabric_button.primary.down
                            border.color: (mousearea.containsPress ?
                               Colors.fabric_button.primary.focused_border :
                                (mousearea.containsMouse ?
                                    Colors.fabric_button.primary.focused_border :
                                    Colors.fabric_button.primary.background))
                            focusunderline: true
                            activeFocusOnTab: true

                            textcontrol.font.pixelSize: 12
                            textcontrol.color: (mousearea.containsPress ?
                                Colors.fabric_button.primary.text:
                                (mousearea.containsMouse ?
                                    Colors.fabric_button.primary.hovered :
                                   Colors.fabric_button.primary.text))
                            textcontrol.text: primaryButtonText
                            textcontrol.font.family: "Segoe UI Semibold"
                            textcontrol.topPadding: 4
                            textcontrol.bottomPadding: 4
                            textcontrol.leftPadding: 12
                            textcontrol.rightPadding: 12
                            callback: function() {
                                parentErrorsList.primaryAction(index, errorCheckBox.checked);
                            }
                            Accessible.name: textcontrol.text
                            Accessible.ignored: !visible
                        }

                        SimpleButton {
                            id: buttonTwo
                            visible: buttonTwoVisible
                            width: visible ? ((textcontrol.width > 80) ? textcontrol.width : 80) : 0
                            height: visible ? 28 : 0
                            primarycolor: Colors.fabric_button.primary.background
                            hovercolor:   Colors.activity_center.message.button_hovering
                            pressedcolor: Colors.fabric_button.primary.down
                            border.color: (mousearea.containsPress ?
                               Colors.fabric_button.primary.focused_border :
                                (mousearea.containsMouse ?
                                    Colors.fabric_button.primary.focused_border :
                                   Colors.fabric_button.primary.background))
                            focusunderline: true
                            activeFocusOnTab: true

                            textcontrol.font.pixelSize: 12
                            textcontrol.color: (mousearea.containsPress ?
                                Colors.fabric_button.primary.text:
                                (mousearea.containsMouse ?
                                    Colors.fabric_button.primary.hovered :
                                   Colors.fabric_button.primary.text))
                            textcontrol.text: secondaryButtonText
                            textcontrol.font.family: "Segoe UI Semibold"
                            textcontrol.topPadding: 4
                            textcontrol.bottomPadding: 4
                            textcontrol.leftPadding: 12
                            textcontrol.rightPadding: 12
                            textcontrol.font.bold: true
                            callback: function() {
                                parentErrorsList.secondaryAction(index, errorCheckBox.checked);
                            }
                            Accessible.name: textcontrol.text
                            Accessible.ignored: !visible
                        }
                    }
                }
            }
        }
    }
}
