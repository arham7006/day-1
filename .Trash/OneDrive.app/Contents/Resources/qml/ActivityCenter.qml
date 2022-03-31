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

// Z order:
// 100 - Mac border, Always on top of everything
// 3 - Header, Footer - Always on top of other content
// 2 - Error view controls - Toggled errors list window shows on top of history list
// 1 - History list, ACMs, old error message, error view entry point, sync status, pause, signing in

// Note on Accessibility and focus:
// We want to set the focus: property to true
// on the element that we want the Narrator/Voiceover tool to read 
// out first. 
// This is because of implicit accessibility behavior in Qt: when
// all the nodes in the QML tree have been created,
// the one with focus: true receives the initial keyboard
// focus. Along with keyboard focus, Qt raises a FocusChanged accessibility
// event which makes the Narrator/Voiceover tool read out load the Accessible.name
// of the node in focus.
// CONCLUSION: we want to give focus to the ActivityCenterHeader node.
Rectangle
{
    id: root
    width: 360
    height: 640

    color: Colors.common.background

    property bool isOnlineMode: (headerModel.visualState >= ActivityCenterHeaderModel.Online)
    property bool isRTL: headerModel.isRTL
    property bool isPaused: (headerModel.visualState === ActivityCenterHeaderModel.Paused)
    property bool needsAttention: (headerModel.isError || headerModel.isWarning)
    property bool showErrorBackground: (headerModel.isError || headerModel.isActionableWarning)
    property bool isSyncingBlocked: headerModel.isSyncingBlocked

    // New vs old error view properties
    property bool hasOldErrorBanner: (needsAttention && headerModel.shouldShowErrorBanner && !errorsModel.hasErrors)
    property bool hasNewErrorBanner: (errorsModel.hasErrors && errorsModel.isErrorsV2)
    property bool hasAnyErrorBanner: (hasOldErrorBanner || hasNewErrorBanner)
    property bool isErrorViewCurrentlyVisible: (errorsModel.isErrorViewOpened && errorsModel.hasErrors && !isPaused)

    LayoutMirroring.enabled: isRTL
    LayoutMirroring.childrenInherit: true

    Accessible.ignored: true
    Accessible.role: Accessible.Pane
    Accessible.focused: false

    Connections {
        target: headerModel
        // Refocus to header so Narrator/Voiceover can announce the sync state in the header.
        // As narrator tend to only announce the first state when the control gets focus,
        // we only refocus for below two steady states for pause/resume.
        onVisualStateChanged: {
            if ((headerModel.visualState === ActivityCenterHeaderModel.Paused) ||
                (headerModel.visualState === ActivityCenterHeaderModel.Online))
            {
                theHeader.forceActiveFocus();
            }
        }
    }

    // draw a border around the window for Mac
    Rectangle
    {
        id: macBorder
        color: "transparent"
        border.width: 1
        border.color: Colors.activity_center.common.mac_border
        anchors.fill: parent
        z: 100 // Mac Border should always be on top of everything
        visible: Qt.platform.os === "osx"
    }

    Component {
        id: listItemDelegate

        FocusScope {
            width: parent.width
            height: 68
            id: item

            function chooseBGColor(afocus, isHistoryItem, isHovering) {
                var color = isHistoryItem ? Colors.common.background : Colors.activity_center.list.background_secondary;
                if (isHovering) {
                    color = Colors.activity_center.list.background_hovering;
                }
                if (afocus) {
                    color = Colors.activity_center.list.background_focus;
                }
                return color;
            }

            function setOpacity(isDeleted) {
                if(isDeleted) {
                    return 0.3;
                } else {
                    return 1;
                }
            }

            function isSelfOrChildActive() {
                return activeFocus || folderLink.activeFocus || itemMenuButton.activeFocus || itemCancelButton.activeFocus ||
                        (itemMenu.activeFocus && (itemMenu.parentIndex == index));
            }

            function containsHoverFocus() {
                return itemMouseArea.containsMouse || itemMenuButton.hovered || folderLink.hovered || itemCancelButton.hovered;
            }

            function isRegularHistoryListItem()
            {
                return !isDeletedItem && !isAutoRenameItem;
            }

            Rectangle {
                id: hoverRectangle
                width: parent.width
                height: parent.height
                color: chooseBGColor(isSelfOrChildActive(), isHistoryItem, containsHoverFocus())
                border.color: isSelfOrChildActive() ? Colors.activity_center.list.border_focus : "transparent"
                border.width: 1
                focus: true

                function makeItemCurrent() {
                    theList.currentIndex = index;
                    theList.positionViewAtIndex(index, ListView.Visible);

                    theList.forceActiveFocus();
                }

                function activateItem() {
                    makeItemCurrent();
                    if (isRegularHistoryListItem()) {
                        theList.itemActivated(index);
                    }
                }

                function openItemFolder() {
                    makeItemCurrent();
                    if (isRegularHistoryListItem()) {
                        theList.itemFolderClicked(index);
                    }
                }

                function cancelProgressItem() {
                    makeItemCurrent();
                    if (canBeCanceled) {
                        theList.itemCancelProgressClicked(index);
                    }
                }

                MouseArea {
                    id: itemMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onDoubleClicked: hoverRectangle.activateItem();
                    onClicked: hoverRectangle.makeItemCurrent();
                }

                Accessible.role: Accessible.LayeredPane
                Accessible.name: {
                    var name = itemNameText.text
                    if (isHistoryItem)
                    {
                        name += ";" + itemDescriptionPrefixText.text
                        if (isRegularHistoryListItem())
                            name += folderLink.text + itemDescriptionSuffixText.text
                    }
                    name += ";" + elapsedTime.text
                    if (!isHistoryItem)
                        name += inProgressStatus.text
                    return name
                }
                Accessible.focusable: true
                Accessible.focused: item.ListView.isCurrentItem
                Accessible.ignored: !visible
                Accessible.selectable: true
                Accessible.selected: item.ListView.isCurrentItem
                Accessible.onPressAction: {
                    hoverRectangle.onAccessiblePressAction();
                }

                Keys.onEnterPressed: hoverRectangle.activateItem()
                Keys.onReturnPressed: hoverRectangle.activateItem()
                Keys.onSpacePressed: hoverRectangle.activateItem()

                KeyNavigation.left: itemMenuButton.visible ? itemMenuButton : (itemCancelButton.visible ? itemCancelButton : folderLink)
                KeyNavigation.right: folderLink

                Rectangle {
                    color: "transparent"
                    width: parent.width
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8

                    Image {
                        visible: !isAutoRenameItem
                        id: thumbnail
                        anchors.left: parent.left
                        width: 48; height: 48
                        anchors.verticalCenter: parent.verticalCenter
                        source: "image://fileIcons/" + itemName
                        opacity: setOpacity(isDeletedItem)
                    }

                    Text {
                        visible: isAutoRenameItem
                        id: autoRenameIcon
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        width: 36; height: 36
                        anchors.verticalCenter: parent.verticalCenter
                        text: FabricMDL.Icons.Completed
                        font.pixelSize: 36
                        color: Colors.common.checkmark
                    }

                    Rectangle {
                        id: itemRect
                        visible: true
                        anchors.left: thumbnail.right
                        anchors.leftMargin: 12
                        anchors.right: parent.right
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        color: "transparent"

                        Rectangle {
                            id: itemNameRect
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: itemMenuButton.left
                            anchors.rightMargin: 12
                            color: "transparent"
                            height: itemNameText.height

                            Text {
                                id: itemNameText
                                text: itemName
                                font.pixelSize: 14
                                font.family: "Segoe UI Semibold"
                                color: itemMouseArea.containsMouse ? Colors.common.text_hover : Colors.common.text
                                width: parent.width
                                elide: Text.ElideRight
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                horizontalAlignment: Text.AlignLeft
                            }
                        }

                        Rectangle {
                            id: itemStatusRect
                            anchors.left: parent.left
                            anchors.right: itemMenuButton.left
                            anchors.rightMargin: 12
                            color: "transparent"
                            height: 20
                            anchors.verticalCenter: parent.verticalCenter

                            Row {
                                id: itemDescription
                                anchors.fill: parent
                                visible: isHistoryItem
                                anchors.topMargin: 4
                                anchors.bottomMargin: 4

                                Text {
                                    id: itemDescriptionPrefixText
                                    text: itemActionPrefix
                                    font.pixelSize: 12
                                    font.family: "Segoe UI"
                                    color: itemMouseArea.containsMouse ? Colors.common.text_secondary_hovering : Colors.common.text_secondary
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignLeft
                                }

                                Button {
                                    id: folderLink
                                    width: {
                                        // width should be the minimum of space available or the actual width of button text
                                        var spaceAvailable = itemStatusRect.width - itemDescriptionPrefixText.width - itemDescriptionSuffixText.width;

                                        // add 1 to the calculated width because of truncation on Mac
                                        var buttonWidth = headerModel.getPixelWidthOfString("Segoe UI", 12, itemParentFolder) + 1;

                                        return Math.min(buttonWidth, spaceAvailable);
                                    }
                                    height: contentItem.paintedHeight
                                    leftPadding: 0
                                    rightPadding: 0
                                    bottomPadding: 0
                                    topPadding: 0
                                    activeFocusOnTab: false
                                    visible: (isRegularHistoryListItem())

                                    text: itemParentFolder
                                    contentItem: Text {
                                        id: folderLinkText
                                        text: folderLink.text
                                        font.family: "Segoe UI"
                                        font.pixelSize: 12
                                        font.underline: folderLink.visualFocus
                                        color: folderLinkMouseArea.containsPress ? Colors.common.hyperlink_pressed :
                                                                                   (folderLinkMouseArea.containsMouse ? Colors.common.hyperlink_hovering : Colors.common.hyperlink)
                                        horizontalAlignment: Text.AlignLeft
                                        elide: Text.ElideRight

                                        // Work around for a Qt bug where a second underline appears at (2x,2y) co-ordinates
                                        clip: true
                                    }

                                    background: Rectangle {
                                        implicitWidth: folderLinkText.width
                                        implicitHeight: folderLinkText.height
                                        color: "transparent"
                                        border.color: "transparent"
                                    }

                                    Accessible.ignored: !visible
                                    Accessible.onPressAction: {
                                        hoverRectangle.openItemFolder();
                                    }

                                    KeyNavigation.left: hoverRectangle
                                    KeyNavigation.right: itemMenuButton.visible ? itemMenuButton : folderLink

                                    MouseArea {
                                        id: folderLinkMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: {
                                            hoverRectangle.openItemFolder();
                                        }
                                    }
                                }

                                Text {
                                    id: itemDescriptionSuffixText
                                    text: itemActionSuffix
                                    visible: (isRegularHistoryListItem())
                                    font.pixelSize: 12
                                    font.family: "Segoe UI"
                                    color: itemMouseArea.containsMouse ? Colors.common.text_secondary_hovering : Colors.common.text_secondary
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignLeft
                                }
                            }
                            
                            Rectangle {
                                id: progressGauge
                                anchors.right: parent.right
                                anchors.left: parent.left
                                color: Colors.activity_center.list.progress_background
                                visible: !isHistoryItem && !isPartnerFile
                                height: 2
                                anchors.verticalCenter: parent.verticalCenter

                                Rectangle {
                                    visible: !isIndeterminateBarOn // show indeterminate progress instead
                                    width: itemProgressPercentage * parent.width / 100; 
                                    height: parent.height
                                    color: Colors.activity_center.list.progress
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                }

                                // Indeterminate progress bar used for reviewing diff sync items
                                FabricProgressBar {
                                    anchors.fill: parent
                                    animatorObjectWidth: progressGauge.width
                                    visible: isIndeterminateBarOn
                                    isRTL: headerModel.isRTL
                                }
                            }
                        }

                        Rectangle {
                            id: secondaryTextRect
                            anchors.top: itemStatusRect.bottom
                            anchors.left: parent.left
                            anchors.right: itemMenuButton.left
                            anchors.rightMargin: 12
                            color: "transparent"
                            height: childrenRect.height

                            Row {
                                id: secondaryText
                                anchors.fill: parent

                                Text {
                                    id: elapsedTime
                                    text: isHistoryItem ? timestamp : itemProgressString
                                    font.pixelSize: 10
                                    font.family: "Segoe UI"
                                    color: itemMouseArea.containsMouse ? Colors.common.text_secondary_hovering_alt : Colors.common.text_secondaryAlt
                                    horizontalAlignment: Text.AlignLeft
                                    elide: Text.ElideRight
                                    width: {
                                        // width should be the minimum of space available or the actual width of elapsedTime text
                                        var spaceAvailable = parent.width - inProgressStatus.width;

                                        // add 1 to the calculated width because of truncation on Mac
                                        var desiredWidth = headerModel.getPixelWidthOfString("Segoe UI", 10, elapsedTime.text) + 1;

                                        return Math.min(desiredWidth, spaceAvailable);
                                    }
                                }

                                Text {
                                    id: inProgressStatus
                                    text: (isHistoryItem || isPartnerFile || isWaitingForDiffSync) ? "" : itemProgress
                                    font.pixelSize: 10
                                    font.family: "Segoe UI"
                                    color: itemMouseArea.containsMouse ? Colors.common.text_secondary_hovering_alt : Colors.common.text_secondaryAlt
                                    horizontalAlignment: Text.AlignLeft
                                    visible: (text.length > 0)
                                }
                            }
                        }

                        Button {
                            id: itemCancelButton
                            visible: canBeCanceled && (itemCancelButton.activeFocus ||
                                                       hoverRectangle.activeFocus ||
                                                       itemCancelButton.hovered ||
                                                       itemMouseArea.containsMouse)

                            contentItem: Image {
                                source: "file:///" + imageLocation + "cancelIcon.svg"
                                width: 36
                                height: 36
                                sourceSize.width:  36
                                sourceSize.height: 36
                                anchors.fill: parent
                            }

                            activeFocusOnTab: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            width: 36
                            height: 36

                            // This text is only used for accessibility. QT Button pulls the accessibility string from the button text.
                            // We are overwritting the contentItem so the text isnt shown on the screen.
                            text: listModel.cancelButtonAccessibleName

                            background: Rectangle {
                                anchors.fill: parent
                                color : itemCancelButton.pressed ? Colors.activity_center.context_menu.button_pressed :
                                                                 (itemCancelButton.hovered ? Colors.activity_center.context_menu.button_hover : "transparent")
                                border.color: itemCancelButton.activeFocus ? Colors.activity_center.context_menu.button_hover : "transparent"
                                border.width: 1
                            }

                            onClicked: hoverRectangle.cancelProgressItem();

                            KeyNavigation.right: hoverRectangle
                            KeyNavigation.left: folderLink
                            Keys.onReturnPressed: hoverRectangle.cancelProgressItem();
                            Keys.onEnterPressed: hoverRectangle.cancelProgressItem();
                            Keys.onSpacePressed: hoverRectangle.cancelProgressItem();

                            Accessible.name: listModel.cancelButtonAccessibleName
                            Accessible.ignored: !visible
                            Accessible.onPressAction: hoverRectangle.cancelProgressItem();
                        }

                        Button {
                            id: itemMenuButton
                            visible: itemMenuButton.shouldShowMenuButton()
                            activeFocusOnTab: true
                            hoverEnabled: true

                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            width: 36
                            height: 36

                            KeyNavigation.right: hoverRectangle
                            KeyNavigation.left: folderLink
                            Keys.onReturnPressed: itemMenuButton.handleAction();
                            Keys.onEnterPressed: itemMenuButton.handleAction();

                            onClicked: itemMenuButton.handleAction();

                            Accessible.name: listModel.menuButtonAccessibleName
                            Accessible.ignored: !visible
                            Accessible.onPressAction: itemMenuButton.handleAction();

                            background: Rectangle {
                                anchors.fill: parent
                                color : itemMenuButton.pressed ? Colors.activity_center.context_menu.button_pressed :
                                                                 (itemMenuButton.hovered ? Colors.activity_center.context_menu.button_hover : "transparent")
                                border.color: itemMenuButton.activeFocus ? Colors.activity_center.context_menu.button_hover : "transparent"
                                border.width: 1
                            }

                            // This text is only used for accessibility. QT Button pulls the accessibility string from the button text.
                            // We are overwritting the content Item below so the text isnt shown on the screen.
                            text: listModel.menuButtonAccessibleName

                            contentItem: Image {
                                    anchors.fill: parent
                                    source: "file:///" + imageLocation + "overflowIcon.svg"
                                    width: 40
                                    height: 40
                                    sourceSize.width:  40
                                    sourceSize.height: 40
                            }

                            function handleAction() {
                                hoverRectangle.makeItemCurrent();
                                itemMenu.parent = itemMenuButton;
                                itemMenu.parentIndex = index;
                                itemMenu.parentItemWidth = itemMenuButton.width;

                                var offset = item.y - theList.contentY;
                                var totalHeight = item.height + itemMenu.height;
                                var extraVerticalSpacing = 2;
                                var listItemVerticalMargins = 8;

                                if (totalHeight + offset < theList.height)
                                {
                                    var bottomOfMenuButton = itemMenuButton.y + itemMenuButton.height - listItemVerticalMargins;
                                    itemMenu.y = bottomOfMenuButton + extraVerticalSpacing;
                                }
                                else
                                {
                                    var topOfMenuButton = itemMenuButton.y - itemMenu.height - listItemVerticalMargins;
                                    itemMenu.y = topOfMenuButton - extraVerticalSpacing;
                                }

                                itemMenu.visible = !itemMenu.visible;
                            }

                            // This function should return true whenever the menu button should be shown. The button should only be
                            // shown on non-delete, non-AutoRename history items when the the item either has active focus on any of its children
                            // or hover focus on any of its children.
                            function shouldShowMenuButton() {
                                if (isHistoryItem &&
                                     isRegularHistoryListItem() &&
                                     (itemMenuButton.activeFocus ||
                                      hoverRectangle.activeFocus ||
                                      folderLink.activeFocus ||
                                      (itemMenu.activeFocus && (itemMenu.parentIndex == index)) ||
                                      itemMenuButton.hovered ||
                                      itemMouseArea.containsMouse ||
                                      folderLinkMouseArea.containsMouse)) {
                                    return true;
                                }
                                return false;
                            }
                        }

                        Connections {
                            target: theList
                            onContentYChanged: {
                                // This event is fired when the list view scrolls
                                itemMenu.close();
                            }
                        }

                        // This will close the menu when user action causes AC to hide
                        Window.onVisibilityChanged: {
                            if (Window.visibility == Window.Hidden) {
                                itemMenu.close();
                            }
                        }
                    }
                }
            }
        }
    }

    CustomMenu {
        id: itemMenu
        property int parentItemWidth: 0
        property int parentIndex: 0

        // menu width is sum widths of longest string, left margin, and right margin
        menuWidth: Math.min(Math.max(viewOnlineMenu.menuItemWidth, shareMenu.menuItemWidth, openMenu.menuItemWidth) + (2 * openMenu.menuItemMargin), theList.width)
        menuHeight: openMenu.menuItemHeight * 3

        // Explanation: the Menu control inherits from Popup, whose behavior is to automatically adjust
        // position in a "popup" way: it makes sure it never overflows outside the window. The x value
        // we specify gets applied on top of the default positioning that Popup takes for itself.
        // E.g. if Popup decides its x value relative to the itemMenuButton is x:-152 (152 pixels to the left),
        // and we want it even 10 pixels to the left, we can adjust that position by explicitly setting x: -10 here.
        // The resulting final x will be -152 + (-10), -162, which is 162 pixels left of the left edge of the menu's parent.
        // For RTL, align menu to left of button. For LTR, align to right of button.
        x: headerModel.isRTL ? 0 : parentItemWidth - itemMenu.width

        onClosed: {
            theList.currentItem.forceActiveFocus();
            listModel.isMenuOpen = false;
        }
        onOpened: {
            if (parentItemWidth == 0)
            {
                console.warn("Item Menu parentItemWidth set to 0, needs to be the size of the item that the menu belongs to");
            }

            listModel.isMenuOpen = true;
            itemMenu.forceActiveFocus();
            itemMenu.itemAt(0).forceActiveFocus();
        }

        CustomMenuItem {
            id: openMenu
            textcontrol.text: listModel.menuItemOpen
            callback: function() {
                theList.itemActivated(itemMenu.parentIndex);
                itemMenu.close();
            }
        }

        CustomMenuItem {
            id: shareMenu
            enabled: !isPaused && !listModel.isVaultItem(itemMenu.parentIndex)
            textcontrol.text: listModel.menuItemShare
            callback: function() {
                theList.itemShareClicked(itemMenu.parentIndex);
                itemMenu.close();
            }
        }

        CustomMenuItem {
            id: viewOnlineMenu
            enabled: !isPaused && !listModel.isVaultItem(itemMenu.parentIndex)
            textcontrol.text: listModel.menuItemViewOnline
            callback: function() {
                theList.itemViewOnlineClicked(itemMenu.parentIndex);
                itemMenu.close();
            }
        }
    }

    ActivityCenterHeader {
        id: theHeader
        objectName: "theHeader"
        
        // Per the Accessibility note at the top
        // this item receives the initial default focus.
        focus: true

        width: parent.width
        height: 68
        anchors.top: parent.top
        isPaused: parent.isPaused
        needsAttention: parent.needsAttention
        isOnlineMode: parent.isOnlineMode
        isSyncingBlocked: parent.isSyncingBlocked
        showErrorBackground: parent.showErrorBackground
        z: 3 // Header and footer should be at top of z-order

        FontLoader {
            id: fabricMDL2;
            source: Qt.platform.os === "osx" ? "FabExMDL2.ttf" : "file:///" + qmlEngineBasePath + "FabExMDL2.ttf"
        }
    }

    ActivityCenterMessage {
        id: acmRect
        objectName: "acmRect"
        visible: (messageModel.isVisible &&
                  !messageModel.isMegaMode &&
                  !hasAnyErrorBanner &&
                  !isPaused)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: theHeader.bottom
        z: 1

        signal primaryMessageAction()
        signal secondaryMessageAction()
        signal dismissMessage()
        primaryActionCallback: primaryMessageAction
        secondaryActionCallback: secondaryMessageAction
        dismissButton.callback: dismissMessage
    }

    ActivityCenterMessageMega {
        id:            acMegaRect
        objectName:    "acMegaRect"
        visible:       (messageModel.isVisible &&
                        messageModel.isMegaMode &&
                        !hasAnyErrorBanner &&
                        !isPaused)
        anchors.left:  parent.left
        anchors.right: parent.right
        anchors.top:   theHeader.bottom

        z: 1
        signal primaryMessageAction()
        signal secondaryMessageAction()
        signal dismissMessage()
        primaryActionCallback:   primaryMessageAction
        secondaryActionCallback: secondaryMessageAction
        dismissButton.callback:  dismissMessage
    }

    function calcBannerHeight(childrenHeight) {

        if (childrenHeight < 68) {
            return 68;
        } else {
            return childrenHeight;
        }
    }

    Rectangle {
        readonly property int verticalPadding: 8
        readonly property int horizontalPadding: 12
        readonly property int bottomPadding: 14

        id: errorStatusRect
        objectName: "errorStatusRect"
        visible: (hasOldErrorBanner && !isPaused)
        height: visible ? calcBannerHeight(errorStatusInner.height + bottomPadding) : 0
        anchors.left: parent.left
        anchors.right: parent.right
        color: errorMouseArea.containsMouse ? Colors.activity_center.error.background_hovering : Colors.activity_center.error.background
        anchors.top: messageModel.isMegaMode ? acMegaRect.bottom : acmRect.bottom
        z: 1

        Accessible.role: Accessible.Button
        Accessible.name: errorPrimary.text + ";" + headerModel.errorTextSecondary
        Accessible.focusable: true
        Accessible.ignored: !(errorStatusRect.visible || headerModel.showHiddenNodesInAccTree)

        Accessible.onPressAction: {
            errorMouseArea.errorClicked();
        }

        Keys.onEnterPressed: errorMouseArea.errorClicked()
        Keys.onReturnPressed: errorMouseArea.errorClicked()
        Keys.onSpacePressed: errorMouseArea.errorClicked()

        function getOverQuotaIcon() {
            switch (headerModel.overQuotaIconState) {
            case "QUOTA_REACHED":
                return "file:///" + imageLocation + "waterGlass.svg";
            case "OVER_QUOTA_BUSINESS":
                return "file:///" + imageLocation + "waterGlass.svg";
            case "OVER_QUOTA_NO_LOCKDOWN":
                return "file:///" + imageLocation + "iceBucket.svg";
            case "OVER_QUOTA_LOCK_DOWN":
                return "file:///" + imageLocation + "partiallyFreezing.svg";
            default:
                return "file:///" + imageLocation + "errorIcon.svg"; // default to error icon which is red X
            }
        }

        states: [
            State {
                name: "GenericError"
                PropertyChanges { target: errorStatusRect; color: errorMouseArea.containsMouse ? Colors.activity_center.error.background_hovering : Colors.activity_center.error.background }
                PropertyChanges { target: errorStatusRect; activeFocusOnTab: true }
                PropertyChanges { target: errorButtons; height: 0 }
                PropertyChanges { target: errorButtons; visible: false }
                PropertyChanges { target: errorMouseArea; enabled: true }
                PropertyChanges { target: errorMouseArea; hoverEnabled: true }
                PropertyChanges { target: errorMouseArea; cursorShape: Qt.PointingHandCursor }
                PropertyChanges { target: errorIcon; source: "file:///" + imageLocation + "errorIcon.svg" }
            },

            State {
                name: "GenericWarning"
                PropertyChanges { target: errorStatusRect; color: errorMouseArea.containsMouse ? Colors.activity_center.error.background_warning_hovering : Colors.activity_center.error.background_warning }
                PropertyChanges { target: errorStatusRect; activeFocusOnTab: true }
                PropertyChanges { target: errorButtons; height: 0 }
                PropertyChanges { target: errorButtons; visible: false }
                PropertyChanges { target: errorMouseArea; enabled: true }
                PropertyChanges { target: errorMouseArea; hoverEnabled: true }
                PropertyChanges { target: errorMouseArea; cursorShape: Qt.PointingHandCursor }
                PropertyChanges { target: errorIcon; source: "file:///" + imageLocation + "infoIcon.svg" }
            },

            State {
                name: "QuotaCriticalError"
                PropertyChanges { target: errorStatusRect; color: Colors.activity_center.error.background_alert }
                PropertyChanges { target: errorStatusRect; activeFocusOnTab: false }
                PropertyChanges { target: errorTextGroup; bottomPadding: errorStatusRect.verticalPadding }
                PropertyChanges { target: errorButtons; height: childrenRect.height }
                PropertyChanges { target: errorButtons; visible: true }
                // Forcing errorButtons update. Could get empty or stale text/Accessible.name without this step
                PropertyChanges { target: errorPrimaryButton; textcontrol.text: headerModel.errorPrimaryButtonText }
                PropertyChanges { target: errorPrimaryButton; Accessible.name: headerModel.errorPrimaryButtonText }
                PropertyChanges { target: errorSecondaryLink; textcontrol.text: headerModel.errorSecondaryLinkText }
                PropertyChanges { target: errorSecondaryLink; Accessible.name: headerModel.errorSecondaryLinkText }
                PropertyChanges { target: errorMouseArea; enabled: false }
                PropertyChanges { target: errorMouseArea; hoverEnabled: false }
                PropertyChanges { target: errorMouseArea; cursorShape: Qt.ArrowCursor }
                PropertyChanges { target: errorIcon; source: "file:///" + imageLocation + "stackedIceCubes.svg" }
            },

            State {
                name: "QuotaOverLimitError"
                PropertyChanges { target: errorStatusRect; color: Colors.activity_center.error.background }
                PropertyChanges { target: errorStatusRect; activeFocusOnTab: false }
                PropertyChanges { target: errorTextGroup; bottomPadding: errorStatusRect.verticalPadding }
                PropertyChanges { target: errorButtons; height: childrenRect.height }
                PropertyChanges { target: errorButtons; visible: true }
                // Forcing errorButtons update. Could get empty or stale text/Accessible.name without this step
                PropertyChanges { target: errorPrimaryButton; textcontrol.text: headerModel.errorPrimaryButtonText }
                PropertyChanges { target: errorPrimaryButton; Accessible.name: headerModel.errorPrimaryButtonText }
                PropertyChanges { target: errorSecondaryLink; textcontrol.text: headerModel.errorSecondaryLinkText }
                PropertyChanges { target: errorSecondaryLink; Accessible.name: headerModel.errorSecondaryLinkText }
                PropertyChanges { target: errorMouseArea; enabled: false }
                PropertyChanges { target: errorMouseArea; hoverEnabled: false }
                PropertyChanges { target: errorMouseArea; cursorShape: Qt.ArrowCursor }
                PropertyChanges { target: errorIcon; source: errorStatusRect.getOverQuotaIcon() }
            },

            State {
                name: "LocalMassDeleteError"
                PropertyChanges { target: errorStatusRect; color: Colors.activity_center.error.background }
                PropertyChanges { target: errorStatusRect; activeFocusOnTab: false }
                PropertyChanges { target: errorTextGroup; bottomPadding: errorStatusRect.verticalPadding }
                PropertyChanges { target: errorButtons; height: childrenRect.height }
                PropertyChanges { target: errorButtons; visible: true }
                // Forcing errorButtons update. Could get empty or stale text/Accessible.name without this step
                PropertyChanges { target: errorPrimaryButton; textcontrol.text: headerModel.errorPrimaryButtonText }
                PropertyChanges { target: errorPrimaryButton; Accessible.name: headerModel.errorPrimaryButtonText }
                PropertyChanges { target: errorSecondaryLink; textcontrol.text: headerModel.errorSecondaryLinkText }
                PropertyChanges { target: errorSecondaryLink; Accessible.name: headerModel.errorSecondaryLinkText }
                PropertyChanges { target: errorMouseArea; enabled: false }
                PropertyChanges { target: errorMouseArea; hoverEnabled: false }
                PropertyChanges { target: errorMouseArea; cursorShape: Qt.ArrowCursor }
                PropertyChanges { target: errorIcon; source: "file:///" + imageLocation + "recycleBin.svg" }
            }
        ]

        state: headerModel.errorUIState
        border.color: activeFocus ? Colors.activity_center.error.border_alert_focus : "transparent"
        border.width: 1

        Rectangle {
            id: errorStatusInner
            anchors.top: parent.top
            anchors.topMargin: errorStatusRect.verticalPadding
            anchors.left: parent.left
            anchors.leftMargin: errorStatusRect.horizontalPadding
            anchors.right: parent.right
            anchors.rightMargin: errorStatusRect.horizontalPadding
            height: childrenRect.height + errorStatusRect.verticalPadding
            color: "transparent"

            Image {
                id: errorIcon
                width: 42
                height: 42
                anchors.left: parent.left
                fillMode: Image.PreserveAspectFit
            }

            Column {
                id: errorTextGroup
                anchors.left: errorIcon.right
                anchors.leftMargin: errorStatusRect.horizontalPadding
                anchors.right : parent.right
                height : errorPrimary.paintedHeight + errorSecondary.paintedHeight + errorStatusRect.verticalPadding 

                Text {
                    id: errorPrimary
                    color: Colors.activity_center.error.error_rect_text
                    text: headerModel.errorTextPrimary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 14
                    anchors.left: errorTextGroup.left
                    anchors.right: errorTextGroup.right
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop

                    Accessible.role: Accessible.Link
                    Accessible.name: text
                    Accessible.focusable: true
                    Accessible.ignored: !(errorPrimary.visible || headerModel.showHiddenNodesInAccTree)
                }

                Text {
                    id: errorSecondary
                    color: Colors.activity_center.error.error_rect_text
                    text: headerModel.errorTextSecondary
                    font.pixelSize: 12
                    anchors.left: errorTextGroup.left
                    anchors.right: errorTextGroup.right
                    font.family: "Segoe UI"
                    font.weight: Font.Light
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                    visible: contentWidth > 0
                }
            }

            Rectangle
            {
                id: localMassDeleteSpecificControls
                readonly property int checkboxSize: 14
                anchors.top: errorTextGroup.bottom
                anchors.left: errorTextGroup.left
                anchors.right: errorTextGroup.right
                visible: ((headerModel.errorUIState === "LocalMassDeleteError") && !headerModel.forcedLocalMassDeleteDetection)
                height: visible ? checkboxSize : 0
                color: "transparent"
        
                CheckBox {
                    id: localMassDeleteCheckBox
                    spacing: 2
                    topPadding: -1
                    bottomPadding: 0
                    text: headerModel.localMassDeleteOptOutCheckboxText
                    font.pixelSize: 12
                    font.family: "Segoe UI"
                    font.weight: Font.Light
                    // For local mass delete, we always want to start with checked: false and
                    // there is no need to persist the state.
                    checked: false
                    onClicked: { headerModel.isOptOutLocalMassDelete = checked; }
                    indicator: Rectangle {
                        implicitWidth: localMassDeleteSpecificControls.checkboxSize
                        implicitHeight: localMassDeleteSpecificControls.checkboxSize
                        border.width: parent.visualFocus ? 2 : 1
                        border.color: parent.visualFocus ? Colors.activity_center.common.focused_border : Colors.activity_center.message.button_border

                        Image {
                            anchors.fill: parent
                            source: "file:///" + imageLocation + "checkboxComposite.svg"
                            visible: localMassDeleteCheckBox.checked
                        }
                    }

                    Accessible.ignored: !(parent.visible || headerModel.showHiddenNodesInAccTree)
                    Accessible.role: Accessible.CheckBox
                    Accessible.name: text
                    Accessible.focusable: true
                }
            }

            Flow {
                id: errorButtons
                objectName: "errorButtons"
                spacing: 30
                anchors.topMargin: localMassDeleteSpecificControls.visible ? 8 : 0
                anchors.top: localMassDeleteSpecificControls.bottom
                anchors.left: errorTextGroup.left
                anchors.right: errorTextGroup.right
                height: childrenRect.height

                signal errorPrimaryButtonClicked()
                signal errorSecondaryLinkClicked()

                SimpleButton {
                    id: errorPrimaryButton
                    width: (textcontrol.width > 80) ? textcontrol.width : 80
                    height: 32
                    primarycolor: "transparent"
                    hovercolor:  Colors.activity_center.message.button_hovering
                    pressedcolor: Colors.activity_center.message.button_pressed
                    border.color: mousearea.containsPress ? Colors.activity_center.message.button_border_pressed : (mousearea.containsMouse ? Colors.activity_center.message.button_border_hovering : Colors.activity_center.message.button_border)
                    focusunderline: true
                    activeFocusOnTab: true

                    textcontrol.font.pixelSize: 12
                    textcontrol.color: mousearea.containsPress ? Colors.activity_center.message.button_text_pressed : (mousearea.containsMouse ? Colors.activity_center.message.button_text_hovering : Colors.activity_center.message.button_text)
                    textcontrol.text: headerModel.errorPrimaryButtonText
                    textcontrol.font.family: "Segoe UI Semibold"
                    textcontrol.topPadding: 4
                    textcontrol.bottomPadding: 6
                    textcontrol.leftPadding: 36
                    textcontrol.rightPadding: 36

                    callback: parent.errorPrimaryButtonClicked

                    Accessible.ignored: !(visible || headerModel.showHiddenNodesInAccTree)
                }

                SimpleButton {
                    id: errorSecondaryLink
                    property bool isSideBySide: (errorPrimaryButton.x < x)   // determine if the button and link appear side by side to set the height of the text control accordingly because it affects section height
                    width: textcontrol.paintedWidth
                    height:  isSideBySide ? 32 : 12
                    primarycolor: "transparent"
                    hovercolor:  "transparent"
                    pressedcolor: "transparent"
                    border.color: "transparent"
                    activeFocusOnTab: true
                    focusunderline: true
                    visible: headerModel.isSecondaryLinkVisible

                    textcontrol.font.pixelSize: 12
                    textcontrol.color: getTextColor()
                    textcontrol.text: headerModel.errorSecondaryLinkText
                    textcontrol.font.family: "Segoe UI Semibold"

                    Accessible.ignored: !(visible || headerModel.showHiddenNodesInAccTree)

                    callback: parent.errorSecondaryLinkClicked
                    enabled: !(localMassDeleteCheckBox.visible && localMassDeleteCheckBox.checked)

                    function getTextColor()
                    {
                        if (!enabled) {
                            return Colors.common.text_disabled;
                        }
                        else if (mousearea.containsPress) {
                            return Colors.common.hyperlink_pressed;
                        }
                        else if (mousearea.containsMouse) {
                            return Colors.common.hyperlink_hovering;
                        }
                        else {
                            return Colors.common.hyperlink;
                        }
                    }
                }
            }
        }

        MouseArea {
            id: errorMouseArea
            objectName: "errorMouseArea"
            anchors.fill: parent

            signal errorClicked()

            onClicked: {
                errorClicked();
            }
        }
    }

    // Errors V2 entry point into Errors List
    ErrorsViewEntryPoint {
        id: viewErrorsEntryPoint
        visible: (!isErrorViewCurrentlyVisible && (hasNewErrorBanner && !isPaused))
        z: 1

        anchors.top: errorStatusRect.visible ? 
                        errorStatusRect.bottom :
                        messageModel.isMegaMode ? 
                            acMegaRect.bottom : 
                            acmRect.bottom

        function switchToErrorsView(isKeyboard) {
            errorsModel.SetErrorViewOpened(true);

            // Record whether the user is using keyboard or mouse
            // so we can show the proper focus indicators
            // Keyboard is more visible but not pretty for regular mouse use
            errorsPage.usingKeyboard = isKeyboard;

            if (isKeyboard)
            {
                errorsViewRect.setFocusOnViewChanged();
            }
            else
            {
                theHeader.forceActiveFocus();
            }
        }
    }

    Rectangle {
        id: upToDateStatusRect
        objectName: "upToDateStatusRect"
        visible: headerModel.isUpToDateItemVisible
        height: visible ? calcBannerHeight(upToDateTextGroup.height + 2 * upToDateStatusInner.margin) : 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: hasNewErrorBanner ? viewErrorsEntryPoint.bottom : errorStatusRect.bottom
        activeFocusOnTab: false
        z: 1

        color: "transparent"
        border.color: "transparent"
        border.width: 1

        // Note: make sure element is *not* focusable if using StaticText as an accessible role.
        // Otherwise, won't be recognized by JAWS.
        Accessible.role: Accessible.StaticText
        Accessible.name: syncStatusPrimary.text + " . " + syncStatusSecondary.text
        Accessible.ignored: !(upToDateStatusRect.visible || headerModel.showHiddenNodesInAccTree)

        Rectangle {
            id: upToDateStatusInner
            anchors.fill: parent
            property int margin: 12
            anchors.topMargin: margin
            anchors.bottomMargin: margin
            color: parent.color
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: upToDateIcon
                width: 42
                height: 42
                anchors.leftMargin : 14
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left

                color: Colors.common.checkmark
                text: FabricMDL.Icons.CheckMark
                font.family: fabricMDL2.name
                font.pixelSize: 42
            }

            Column {
                id: upToDateTextGroup
                anchors.left: upToDateIcon.right
                anchors.leftMargin: 12
                anchors.right : parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    height: syncStatusPrimary.height
                    width: parent.width
                    color: "transparent"
                    Text {
                        id: syncStatusPrimary
                        color: Colors.common.text
                        text: headerModel.upToDateTextPrimary
                        font.family: "Segoe UI Semibold"
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        anchors.left: parent.left
                        anchors.right: parent.right
                    }
                }

                Rectangle {
                    height: syncStatusSecondary.height
                    width: parent.width
                    color: "transparent"
                    Text {
                        id: syncStatusSecondary
                        color: Colors.common.text_secondary
                        text: headerModel.upToDateTextSecondary
                        font.pixelSize: 12
                        font.family: "Segoe UI"
                        wrapMode: Text.WordWrap
                        anchors.left: parent.left
                        anchors.right: parent.right
                    }
                }
            }
        }
    }

    Rectangle {
        id: pauseStatusRect
        objectName: "pauseStatusRect"
        visible: isPaused
        height: visible ? calcBannerHeight(pausedTextGroup.height + 2 * pausedStatusInner.margin) : 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: upToDateStatusRect.bottom
        activeFocusOnTab: true
        z: 1

        color: (theList.count == 0) ? "transparent" : Colors.activity_center.error.background_warning
        border.color: activeFocus ? Colors.activity_center.common.focused_border : "transparent"
        border.width: 1

        Accessible.role: Accessible.Button
        Accessible.name: pausedStatusPrimary.text + " . " + pausedStatusSecondary.text
        Accessible.ignored: !(pauseStatusRect.visible || headerModel.showHiddenNodesInAccTree)
        Accessible.focusable: true
        Accessible.onPressAction: {
            pauseStatusRect.pauseStatusRectClicked()
        }
        Keys.onEnterPressed:  pauseStatusRect.pauseStatusRectClicked()
        Keys.onReturnPressed: pauseStatusRect.pauseStatusRectClicked()
        Keys.onSpacePressed:  pauseStatusRect.pauseStatusRectClicked()

        signal pauseStatusRectClicked()

        Rectangle {
            id: pausedStatusInner
            anchors.fill: parent
            property int margin: 12
            anchors.topMargin: margin
            anchors.bottomMargin: margin
            color: parent.color
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: pausedIcon
                width: 42
                height: 42
                anchors.leftMargin : 14
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left

                source: "file:///" + imageLocation + "paused.svg"
                sourceSize.width:  42
                sourceSize.height: 42
            }

            Column {
                id: pausedTextGroup
                anchors.left: pausedIcon.right
                anchors.leftMargin: 12
                anchors.right : parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    height: pausedStatusPrimary.height
                    width: parent.width
                    color: "transparent"
                    Text {
                        id: pausedStatusPrimary
                        color: (theList.count == 0) ? Colors.common.text : Colors.activity_center.error.error_rect_text
                        text: headerModel.pausedTextPrimary
                        font.family: "Segoe UI Semibold"
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        anchors.left: parent.left
                        anchors.right: parent.right
                    }
                }

                Rectangle {
                    height: pausedStatusSecondary.height
                    width: parent.width
                    color: "transparent"
                    Text {
                        id: pausedStatusSecondary
                        color: (theList.count == 0) ? Colors.common.text : Colors.activity_center.error.error_rect_text
                        text: headerModel.pausedTextSecondary
                        font.pixelSize: 12
                        font.family: "Segoe UI"
                        wrapMode: Text.WordWrap
                        anchors.left: parent.left
                        anchors.right: parent.right
                    }
                }
            }

            MouseArea {
                id: pauseStatusMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: pauseStatusRect.pauseStatusRectClicked()
            }
        }
    }

    Rectangle {
        id: syncStatusRect
        objectName: "syncStatusRect"
        anchors.top: pauseStatusRect.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: (headerModel.isSyncing) ? 34 : 0
        color: Colors.activity_center.list.background_secondary
        property bool expanded: true
        property string statusText: headerModel.syncStatusText
        property bool isSyncing: headerModel.isSyncing
        visible: isSyncing
        z: 1

        Accessible.role: Accessible.StaticText
        Accessible.name: "OneDrive is " + syncStatusTextItem.text
        Accessible.ignored: (!(syncStatusRect.visible || headerModel.showHiddenNodesInAccTree) || isErrorViewCurrentlyVisible)

        Rectangle {
            id: chevronIconRect
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            opacity:100
            width: 0
            height: 25
            color: parent.color
            border.color: activeFocus ? Colors.activity_center.common.focused_border : "transparent"
            border.width: 1

            Text
            {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: Colors.common.text_tertiary
                text: syncStatusRect.expanded ? FabricMDL.Icons.ChevronDownMed : FabricMDL.Icons.ChevronRightMed
                font.family: fabricMDL2.name
                font.pixelSize: 20
                height: 20
                visible: false
                width: 0
            }
        }

        Text {
            id: syncStatusTextItem
            anchors.left:chevronIconRect.right
            anchors.right:parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            font.weight: Font.Normal
            font.pixelSize: 12
            font.family: "Segoe UI"
            wrapMode: Text.WordWrap
            text: headerModel.syncStatusText
            color: Colors.common.text_secondary
            horizontalAlignment: Text.AlignLeft
        }
    }

    Rectangle {
        id: signingInRect
        color: Colors.common.background
        z: 1
        visible: !needsAttention &&
                 ((headerModel.visualState === ActivityCenterHeaderModel.SigningIn) ||
                  (headerModel.visualState === ActivityCenterHeaderModel.SigningOut)||
                  (headerModel.visualState === ActivityCenterHeaderModel.Updating))
        anchors {
            left: parent.left
            right: parent.right
            top: theHeader.bottom
            bottom: parent.bottom
        }

        Accessible.ignored: !visible
        Accessible.role: Accessible.StaticText
        Accessible.name: signingInTxt.text

        Text {
            id: signingInTxt
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: headerModel.signingInText

            font.family: "Segoe UI Light"
            font.pixelSize: 17
            color: Colors.common.text
        }

        Image {
            id: spinningGraphic
            source: "file:///" + imageLocation + "loading_spinner.svg"
            sourceSize.height: 44
            sourceSize.width: 44
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: signingInTxt.top
                bottomMargin: 12
            }

            // NOTE on battery drain and Animations: we need to explicitly disable the animation
            // the the window is hidden (the Window.visibility attached property is Window.Hidden)
            NumberAnimation on rotation {
                id: rotationAnimation
                easing.type: Easing.InOutQuad
                from: -45
                to: 315
                duration: 1500
                loops: Animation.Infinite
                property bool enabled : false
                running: enabled && signingInRect.visible
            }
        }

        Window.onVisibilityChanged : {
            if (Window.visibility === Window.Hidden) {
                rotationAnimation.enabled = false;
            } else {
                rotationAnimation.enabled = true;
            }
        }
    }

    ListView {
        id: theList
        objectName: "theList"
        anchors.top: syncStatusRect.bottom
        width: parent.width;
        anchors.bottom: footerBar.top
        model: listModel
        delegate: listItemDelegate
        clip: true
        activeFocusOnTab: (theList.count != 0)
        visible: !errorsPage.visible

        ScrollBar.vertical: ScrollBar {
            active: true
            onActiveChanged: { active = true; /* Keeps scrollbar visible always */}

            Accessible.ignored: parent.Accessible.ignored
        }

        Accessible.role: Accessible.List
        Accessible.focusable: true
        Accessible.ignored: ((theList.count == 0) || !visible)
        Accessible.name: listModel.historyListAccessibleText

        highlightFollowsCurrentItem: true

        signal itemActivated(int index);
        signal itemFolderClicked(int index);
        signal itemShareClicked(int index);
        signal itemViewOnlineClicked(int index);
        signal itemCancelProgressClicked(int index);

        function updateIndexAndScrollToItem(theIndex) {
            var newIndex = theIndex;
            if (newIndex < 0) {
                newIndex = 0;
            }
            else if (newIndex >= theList.count) {
                newIndex = theList.count - 1;
            }

            theList.currentIndex = newIndex;
            theList.positionViewAtIndex(newIndex, ListView.Visible);
        }

        Keys.onPressed: {
            if (theList.count > 0)
            {
                var newIndex = -1;
                var itemHeight = 68;
                var pageIncrement = theList.height / itemHeight; // How many items to scroll

                if (event.key === Qt.Key_End) {
                    newIndex = theList.count - 1;
                    updateIndexAndScrollToItem(newIndex);
                }
                else if (event.key === Qt.Key_Home) {
                    newIndex = 0;
                    updateIndexAndScrollToItem(newIndex);
                }
                else if (event.key === Qt.Key_PageUp) {
                    newIndex = theList.currentIndex - pageIncrement;
                    updateIndexAndScrollToItem(newIndex);
                }
                else if (event.key === Qt.Key_PageDown) {
                    newIndex = theList.currentIndex + pageIncrement;
                    updateIndexAndScrollToItem(newIndex);
                }
            }
        }
    }

    // The errors page in the Activity Center
    Rectangle {
        id: errorsPage
        anchors.top: theHeader.bottom
        anchors.bottom: footerBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        visible:  isErrorViewCurrentlyVisible
        color: "transparent" // Allow base color to show through
        z: 2 // The errors view goes on top of the history view when toggled on

        // changes when a keypress vs mouse click is detected to enter the page
        // used to determine whether to start with a black border or not,
        // for accessibility on page change
        property bool usingKeyboard: false

        Loader {
            id: errorsViewRect
            objectName: "errorsViewRect"
            anchors.fill: parent

            source: "ErrorsView.qml"
            asynchronous: true
            active: errorsModel.hasOpenedErrorsView

            // Proxy for keyPresses to be read in child qml
            // Set when ErrorsView.qml is loaded and when errors view is loaded
            property var keyHandler: undefined

            // Proxy for setting item in focus, set when errors view is loaded
            signal setFocusOnViewChanged()

            onLoaded: function() { 
                // Sets key handler and setFocusOnViewChanged handler
                item.setHandlers(errorsViewRect);

                item.onErrorsViewClosed.connect( function() {
                    // Sets focus on the root so Narrator reads out a value when changing views
                    // And so that other list views don't hold on to arrow presses
                    theHeader.forceActiveFocus();
                })

                // onLoaded is called the first time we switch to the errors view.
                // Since we already clicked the entry button before the handler was attached,
                // directly call it now to set the focus, since the view is changed and
                // the handler is now attached thanks to the setHandlers call above
                if (errorsPage.usingKeyboard)
                {
                    // If using keyboard, this reads out the accessibility text of the errors list
                    // and sets a black border around the object
                    setFocusOnViewChanged();
                }
                else
                {
                    // We don't want the black border around the object if we're using mouse nav,
                    // so just set focus to the header bar instead (no special focus properties on that)
                    theHeader.forceActiveFocus();
                }
            }

            onStatusChanged: function() {
                if (status === Loader.Error)
                {
                    activityCenterView.onErrorsViewLoaderError();
                }
            }
        }
    }

    // Three-button footer on the bottom of the ActivityCenter
    ActivityCenterFooter {
        id: footerBar
        objectName: "footerBar"
        anchors.bottom: parent.bottom
        width: parent.width
        isOnlineMode: parent.isOnlineMode
        isPaused: parent.isPaused
        isRTL: parent.isRTL
        z: 3 // Header and footer should be at top of z-order
    }

    signal onEscapePressed();

    Keys.onPressed: {
        if (!theList.activeFocus && !isErrorViewCurrentlyVisible)
        {
            if (HelperFunctions.isHandledKeyPress(event))
            {
                theList.forceActiveFocus(Qt.MouseFocusReason);
                theList.Keys.onPressed(event);
            }
        }
        else if (isErrorViewCurrentlyVisible && !errorsViewRect.listHasFocus)
        {
            if (HelperFunctions.isHandledKeyPress(event))
            {
                errorsViewRect.keyHandler.forceActiveFocus();
                errorsViewRect.keyHandler.Keys.onPressed(event);
            }
        }

        if (event.key === Qt.Key_Escape)
        {
            onEscapePressed();
        }
    }

    // This Popup Animation logic is duplicated here
    // and in ActivityCenterLoader.qml.
    // This enables us to turn off async loading via ActivityCenterLoader.qml
    // and still preserve functionality.
    NumberAnimation {
        id: anim
        target: theHeader.Window.window
        property: "y"
        duration: 550
        easing.type: Easing.OutQuint
    }

    function startPopupAnimation(startY, endY) {
        anim.from = startY;
        anim.to = endY;
        anim.start();
    }
}
