/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/
import Colors 1.0
import QtQml 2.2
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2
import VersionWindowViewModel 1.0

// Z order:
// 3 - Header - Always on top of other content
// 2 - Error Status Rect - Toggled error status shows on top of version history list
// 1 - Processing spinner
// 0 - Version History list, Error Bar
Rectangle {
    id: root
    width: 320
    height: 407

    color: Colors.common.background
    opacity: confirmDialog.visible ? 0.6 : 1.0

    property bool isRTL: viewModel.isRTL
    LayoutMirroring.enabled: isRTL
    LayoutMirroring.childrenInherit: true
    readonly property int rootLevelHorizontalPadding: 16
    property color focusBorderColor: (Qt.platform.os === "osx") ? Colors.common.mac_border_focus : Colors.common.border_focus

    Accessible.ignored: true

    function _(resourceId) {
        return viewModel.getLocalizedMessage(resourceId);
    }

    Keys.onPressed: {
        if ((Qt.platform.os !== "osx") && (event.key === Qt.Key_Escape))
        {
            viewModel.closeWindow();
        }
    }

    Component {
        id: versionListItemDelegate

        FocusScope {
            id: versionListItem
            width: parent.width
            height: 71

            function isSelfOrMenuActive() {
                return (hoverRectangle.activeFocus ||
                       (versionHistoryItemMenu.activeFocus && (versionHistoryItemMenu.parentIndex == index)));
            }

            function containsHoverFocus() {
                return (itemMouseArea.containsMouse || versionHistoryItemMenuButton.hovered);
            }

            function containsPressFocus() {
                return (itemMouseArea.containsPress || versionHistoryItemMenuButton.pressed);
            }

            // Gets the background color of a list item
            function chooseListItemBackgroundColor(isPressed, isHovering, isConfirmDialogUp) {
                var color = isConfirmDialogUp ? "transparent" : Colors.common.background;

                if (isHovering) {
                    color = Colors.version_window.list.background_hovering;
                }
                if (isPressed) {
                    color = Colors.version_window.list.background_press;
                }
                return color;
            }

            // Add borderRectangle below to create separator between items in the ListView
            // hoverRectangle which contains the ListItem will shift down by 1 to show a line between items
            Rectangle {
                id: borderRectangle
                width: parent.width
                height: parent.height

                // Set background to "transparent" when ConfirmDialog is up to avoid double opacity
                color: confirmDialog.visible ? "transparent" : Colors.version_window.list.background_press

                // This will set the focus to the cell on every navigation. If we dont then the list item
                // will default to the last focus location which is jarring.
                onFocusChanged: if (focus) hoverRectangle.forceActiveFocus();

                Rectangle {
                    id: hoverRectangle
                    width: parent.width
                    anchors.top: parent.top
                    anchors.topMargin: 1
                    anchors.bottom: parent.bottom
                    color: chooseListItemBackgroundColor(containsPressFocus(), containsHoverFocus(), confirmDialog.visible)
                    border.color: versionListView.isUsingKeyboard && isSelfOrMenuActive() ? root.focusBorderColor : "transparent"
                    border.width: (Qt.platform.os === "osx") ? 1 : 2
                    focus: true

                    function makeItemCurrent() {
                        versionListView.currentIndex = index;
                        versionListView.positionViewAtIndex(index, ListView.Visible);

                        versionListView.forceActiveFocus();
                    }

                    function chooseImageSource() {
                        var imageSource = "file:///" + imageLocation + "timelineLong.svg";

                        if ((index == 0) || (index == versionListView.count - 1)) {
                            imageSource = "file:///" + imageLocation + "timelineShort.svg";
                        }

                        return imageSource;
                    }

                    MouseArea {
                        id: itemMouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: hoverRectangle.makeItemCurrent();
                    }

                    Accessible.role: Accessible.ListItem
                    Accessible.name: {
                        var name = itemNameText.text
                        name += ";" + itemSizeText.text
                        name += ";" + elapsedTime.text
                        return name
                    }
                    Accessible.focusable: true
                    Accessible.focused: versionListItem.ListView.isCurrentItem
                    Accessible.ignored: !visible
                    Accessible.selectable: true
                    Accessible.selected: versionListItem.ListView.isCurrentItem
                    Accessible.onPressAction: {
                        hoverRectangle.onAccessiblePressAction();
                    }
                    KeyNavigation.left: versionHistoryItemMenuButton.visible ? versionHistoryItemMenuButton : hoverRectangle
                    KeyNavigation.right: KeyNavigation.left

                    Item {
                        id: imageRect
                        anchors.left: parent.left
                        anchors.top: parent.top
                        height: parent.height
                        width: 56

                        Image {
                            visible: index == 0
                            id: thumbnail
                            anchors.top: parent.top
                            anchors.topMargin: 21
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 28
                            source: "image://fileIcons/" + viewModel.fileName
                            fillMode: Image.PreserveAspectFit
                            z: 2 // For index 0, thumbnail icon needs to be on top of timeline to cover the dot
                        }

                        Image {
                            visible: versionListView.count > 1
                            id: timeline
                            height: parent.height
                            width: 9
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: hoverRectangle.chooseImageSource()
                            fillMode: Image.PreserveAspectFit
                            z: 1
                            transformOrigin: Item.Center
                            rotation: (index == 0) ? 180 : 0
                        }
                    }

                    Item {
                        id: itemRect
                        width: parent.width
                        anchors.left: imageRect.right
                        anchors.right: parent.right
                        anchors.rightMargin: rootLevelHorizontalPadding
                        anchors.top: parent.top
                        anchors.topMargin: 8
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 8

                        Image {
                            id: eyelash
                            visible: (index == 0) && showEyelash
                            height: 8
                            width: 8
                            sourceSize.height: 32
                            sourceSize.width: 32
                            anchors.top: itemNameRect.top
                            anchors.right: itemNameRect.left
                            source: "file:///" + imageLocation + "eyelash.svg"
                            fillMode: Image.PreserveAspectFit
                            mirror: isRTL
                        }

                        Item {
                            id: itemNameRect
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: versionHistoryItemMenuButton.left
                            anchors.rightMargin: 12
                            height: elapsedTime.height

                            Text {
                                id: elapsedTime
                                text: timestamp
                                font.pixelSize: 14
                                font.family: "Segoe UI Semibold"
                                color: versionHistoryItemMenuButton.shouldShowMenuButton() ? Colors.common.text_hover : Colors.common.text
                                elide: Text.ElideRight
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                width: parent.width
                                horizontalAlignment: Text.AlignLeft
                            }
                        }

                        Item {
                            id: secondaryTextRect
                            anchors.top: itemNameRect.bottom
                            anchors.topMargin: 4
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: versionHistoryItemMenuButton.left
                            anchors.rightMargin: 12
                            height: secondaryText.height

                            Column {
                                id: secondaryText
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right

                                Text {
                                    id: itemSizeText
                                    text: itemSize
                                    font.pixelSize: 12
                                    font.family: "Segoe UI"
                                    color: versionHistoryItemMenuButton.shouldShowMenuButton() ? Colors.common.text_secondary_hovering : Colors.common.text_secondary
                                    horizontalAlignment: Text.AlignLeft
                                    elide: Text.ElideRight
                                    width: parent.width
                                }

                                Text {
                                    id: itemNameText
                                    text: itemAuthor
                                    font.pixelSize: 12
                                    font.family: "Segoe UI"
                                    color: versionHistoryItemMenuButton.shouldShowMenuButton() ? Colors.common.text_secondary_hovering : Colors.common.text_secondary
                                    elide: Text.ElideRight
                                    width: parent.width
                                    horizontalAlignment: Text.AlignLeft
                                }
                            }
                        }

                        CustomMenuButton {
                            id: versionHistoryItemMenuButton
                            visible: versionHistoryItemMenuButton.shouldShowMenuButton()
                            accessibleName: _("MenuButtonAccessibleName")

                            isUsingKeyboard: versionListView.isUsingKeyboard
                            KeyNavigation.right: hoverRectangle
                            KeyNavigation.left: hoverRectangle

                            primarycolor: "transparent"
                            hovercolor: Colors.version_window.list.button_hover
                            pressedcolor: Colors.version_window.list.button_pressed
                            bordercolor: root.focusBorderColor

                            callback: function() {
                                hoverRectangle.makeItemCurrent();
                                versionHistoryItemMenu.parent = versionHistoryItemMenuButton;
                                versionHistoryItemMenu.parentIndex = index;
                                versionHistoryItemMenu.parentItemWidth = versionHistoryItemMenuButton.width;

                                var offset = versionListItem.y - versionListView.contentY;
                                var totalHeight = versionListItem.height + versionHistoryItemMenu.height;
                                var extraVerticalSpacing = 2;
                                var listItemVerticalMargins = 8;

                                if (totalHeight + offset < versionListView.height)
                                {
                                    var bottomOfMenuButton = (versionHistoryItemMenuButton.y + versionHistoryItemMenuButton.height - listItemVerticalMargins);
                                    versionHistoryItemMenu.y = (bottomOfMenuButton + extraVerticalSpacing);
                                }
                                else
                                {
                                    var topOfMenuButton = (versionHistoryItemMenuButton.y - versionHistoryItemMenu.height - listItemVerticalMargins);
                                    versionHistoryItemMenu.y = (topOfMenuButton - extraVerticalSpacing);
                                }

                                versionHistoryItemMenu.visible = !versionHistoryItemMenu.visible;
                            }

                            // This function should return true whenever the menu button should be shown.
                            function shouldShowMenuButton() {
                                var shouldShowIfUsingKeyboard = (versionListView.isUsingKeyboard &&
                                                                 (versionHistoryItemMenuButton.activeFocus ||
                                                                  hoverRectangle.activeFocus ||
                                                                  (versionHistoryItemMenu.activeFocus && (versionHistoryItemMenu.parentIndex == index))));

                                if (shouldShowIfUsingKeyboard || versionListItem.containsHoverFocus()) {
                                    return true;
                                }
                                return false;
                            }
                        }
                        Connections {
                            target: versionListView
                            onContentYChanged: {
                                // This event is fired when the list view scrolls
                                versionHistoryItemMenu.close();
                            }
                        }
                    }
                }
            }
        }
    }

    CustomMenu {
        id: versionHistoryItemMenu
        property int parentItemWidth: 0
        property int parentIndex: 0

        // menu width is sum widths of longest string, left margin, and right margin
        menuWidth: Math.min(Math.max(restoreMenu.menuItemWidth, deleteVersionMenu.menuItemWidth, openFileMenu.menuItemWidth) + (2 * restoreMenu.menuItemMargin), versionListView.width);
        menuHeight: restoreMenu.height * 3

        x: viewModel.isRTL ? 0 : parentItemWidth - versionHistoryItemMenu.width

        onClosed: {
            versionListView.currentItem.forceActiveFocus();
            listModel.isMenuOpen = false; // For Telemetry
        }

        onOpened: {
            if (parentItemWidth == 0) {
                console.warn("Item Menu parentItemWidth set to 0, needs to be the size of the item that the menu belongs to");
            }

            listModel.isMenuOpen = true;

            // "Restore" will not be available for the 1st version history item
            // If "Restore" is not available, force focus on "OpenFile"
            if (versionHistoryItemMenu.itemAt(0).enabled) {
                versionHistoryItemMenu.itemAt(0).forceActiveFocus();
            }
            else {
                versionHistoryItemMenu.itemAt(1).forceActiveFocus();
            }
        }

        CustomMenuItem {
            id: restoreMenu

            property bool restoreMenuClicked: false

            textcontrol.text: _("VersionWindowRestore")
            LayoutMirroring.enabled: isRTL
            LayoutMirroring.childrenInherit: isRTL
            visible: (versionHistoryItemMenu.parentIndex !== 0)
            enabled: visible
            menuItemHeight: visible ? openFileMenu.height : 0
            callback: function() {
                versionListView.itemRestoreClicked(versionHistoryItemMenu.parentIndex);
                versionHistoryItemMenu.close();
                errorHeader.dismissButtonClicked = false;
                restoreMenuClicked = true;
            }
        }

        CustomMenuItem {
            id: openFileMenu
            textcontrol.text: ((versionHistoryItemMenu.parentIndex == 0) && !viewModel.fileBlocked) ? _("VersionWindowOpenFile") : _("VersionWindowDownloadFile")
            LayoutMirroring.enabled: isRTL
            LayoutMirroring.childrenInherit: isRTL
            callback: function() {
                versionListView.itemOpenFileClicked(versionHistoryItemMenu.parentIndex);
                versionHistoryItemMenu.close();
                errorHeader.dismissButtonClicked = false;
                restoreMenu.restoreMenuClicked = false;
            }
        }

        CustomMenuItem {
            id: deleteVersionMenu
            textcontrol.text: _("VersionWindowDeleteVersion")
            menuItemHeight: visible ? openFileMenu.height : 0
            LayoutMirroring.enabled: isRTL
            LayoutMirroring.childrenInherit: isRTL
            visible: (viewModel.isDeleteVersionVisible && (versionHistoryItemMenu.parentIndex !== 0))
            enabled: visible
            callback: function() {
                versionListView.itemDeleteVersionClicked(versionHistoryItemMenu.parentIndex);
                versionHistoryItemMenu.close();
                errorHeader.dismissButtonClicked = false;
                restoreMenu.restoreMenuClicked = false;
            }
        }
    }

    Rectangle {
        id: versionListHeader
        width: parent.width
        height: 72
        anchors.top: parent.top
        color: Colors.version_window.listHeader.background
        z: 3

        Accessible.role: Accessible.StaticText
        Accessible.name: fileNameText.text + ";" + titleText.text
        Accessible.focusable: true
        Accessible.readOnly: true
        focus: true

        Column {
            id: header
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Text {
                id: titleText
                text: _("VersionWindowPrimaryText")
                color: Colors.common.text
                font.family: "Segoe UI Semibold"
                font.pixelSize: 20
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                width: versionListHeader.width
                leftPadding: rootLevelHorizontalPadding
                rightPadding: rootLevelHorizontalPadding
            }

            Text {
                id: fileNameText
                text: viewModel.fileName
                color: Colors.common.text
                font.family: "Segoe UI"
                font.pixelSize: 14
                elide: Text.ElideMiddle
                horizontalAlignment: Text.AlignHCenter
                width: versionListHeader.width
                leftPadding: rootLevelHorizontalPadding
                rightPadding: rootLevelHorizontalPadding
            }
        }
    }

    InfoBarWithDismissButton{
        id: errorHeader

        property bool dismissButtonClicked: false

        anchors.top: versionListHeader.bottom
        height: visible ? 64 : 0
        visible: (!dismissButtonClicked) && (viewModel.state === VersionWindowViewModel.ItemMenuRequestsError)
        color: Colors.version_window.error.background

        image.source: "file:///" + imageLocation + "errorIcon.svg";
        primaryText.text: viewModel.errorHeaderText
        secondaryText.text: viewModel.errorSecondaryText
        dismissButtonAccessibleName: _("ActivityCenterMessageDismissHint")
        dismissButtonCallback: function() {
            errorHeader.dismissButtonClicked = true;
        }
    }

    Rectangle {
        id: infoBorderRectangle
        width: parent.width
        height: infoHeader.visible ? (infoHeader.height + 1) : 0
        anchors.top: versionListHeader.bottom
        color: Colors.version_window.listHeader.border

        InfoBarWithDismissButton{
            id: infoHeader

            property bool dismissButtonClicked: false

            anchors.top: infoBorderRectangle.top
            anchors.topMargin: 1
            height: visible ? 52 : 0
            visible: restoreMenu.restoreMenuClicked && (viewModel.state === VersionWindowViewModel.Ready) && viewModel.isRestoreInfoVisible
            color: Colors.version_window.list.background_hovering

            image.source: "file:///" + imageLocation + "infoIcon.svg";
            image.height: 24
            image.width: 24
            secondaryText.text: _("VersionWindowRestoreInfo")
            dismissButtonAccessibleName: _("ActivityCenterMessageDismissHint")
            dismissButtonCallback: function() {
                restoreMenu.restoreMenuClicked = false;
            }
        }
    }

    ListView {
        id: versionListView
        objectName: "versionHistoryList"
        anchors.top: (errorHeader.visible ? errorHeader.bottom : (infoBorderRectangle.visible ? infoBorderRectangle.bottom : versionListHeader.bottom))
        anchors.bottom: parent.bottom
        width: parent.width
        model: listModel
        delegate: versionListItemDelegate
        clip: true
        activeFocusOnTab: (versionListView.count != 0)

        flickableDirection: Flickable.AutoFlickDirection
        ScrollBar.vertical: ScrollBar {
            active: true
            // Scrollbar or ScrollIndicator not needed with Screen Reader tools,
            // items will scroll into view when receiving Accessible focus
            // when the user navigates to them using the keyboard.
            Accessible.ignored: true
        }

        Accessible.role: Accessible.List
        Accessible.focusable: true
        Accessible.ignored: ((versionListView.count == 0) || !visible)
        Accessible.name: _("VersionWindowListAccessibleText")
        highlightFollowsCurrentItem: true
        visible: ((viewModel.state === VersionWindowViewModel.Ready) ||
                 (viewModel.state === VersionWindowViewModel.DeleteConfirmDialogUp) ||
                 (viewModel.state === VersionWindowViewModel.ItemMenuRequestsError))

        // changes when a keypress vs mouse movement is detected
        // used to determine whether list item has a border or not,
        property bool isUsingKeyboard: false

        signal itemRestoreClicked(int index);
        signal itemOpenFileClicked(int index);
        signal itemDeleteVersionClicked(int index);

        function updateIndexAndScrollToItem(theIndex) {
            var newIndex = theIndex;
            if (newIndex < 0) {
                newIndex = 0;
            }
            else if (newIndex >= versionListView.count) {
                newIndex = versionListView.count - 1;
            }

            versionListView.currentIndex = newIndex;
            versionListView.positionViewAtIndex(newIndex, ListView.Visible);
        }

        Keys.onPressed: {
            if (versionListView.count > 0)
            {
                isUsingKeyboard = true;

                var newIndex = -1;
                var pageIncrement = 4;
                if (event.key === Qt.Key_End) {
                    newIndex = versionListView.count - 1;
                    updateIndexAndScrollToItem(newIndex);
                }
                else if (event.key === Qt.Key_Home) {
                    newIndex = 0;
                    updateIndexAndScrollToItem(newIndex);
                }
                else if (event.key === Qt.Key_PageUp) {
                    newIndex = versionListView.currentIndex - pageIncrement;
                    updateIndexAndScrollToItem(newIndex);
                }
                else if (event.key === Qt.Key_PageDown) {
                    newIndex = versionListView.currentIndex + pageIncrement;
                    updateIndexAndScrollToItem(newIndex);
                }
            }
        }
    }

    Rectangle {
        id: processingRect
        anchors.top: (errorHeader.visible) ? errorHeader.bottom : versionListHeader.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        color: Colors.common.background
        visible: viewModel.state === VersionWindowViewModel.Processing
        z: 1
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        Accessible.focusable: true
        Accessible.ignored: !visible
        Accessible.role: Accessible.StaticText
        Accessible.name: processingTxt.text
        Accessible.readOnly: true

        Text {
            id: processingTxt
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: viewModel.processingText
            font.family: "Segoe UI"
            font.pixelSize: 12
            color: Colors.fabric_button.primary.background
        }

        Image {
            id: spinningGraphic
            width: 28
            height: 28
            source: "file:///" + imageLocation + "loading_spinner.svg"
            sourceSize.height: 44
            sourceSize.width: 44
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: processingTxt.top
                bottomMargin: 4
            }

            NumberAnimation on rotation {
                id: rotationAnimation
                easing.type: Easing.InOutQuad
                from: -45
                to: 315
                duration: 1500
                loops: Animation.Infinite
                running: processingRect.visible
            }
        }
    }

    Rectangle {
        id: errorStatusRect
        objectName: "errorStatus"
        anchors.top: versionListHeader.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        color: Colors.common.background
        visible: viewModel.state === VersionWindowViewModel.ListVersionHistoryError
        z: 2 // The errors view goes on top of other views when toggled on

        Accessible.role: Accessible.StaticText
        Accessible.name: errorTitle.text + ";" + errorText.text
        Accessible.focusable: true
        Accessible.ignored: !visible
        Accessible.readOnly: true

        readonly property int horizontalPadding: 16
        readonly property int verticalPadding: 8
        readonly property int topPadding: 60
        readonly property int botPadding: 84

        signal tryAgainButtonClicked();

        Item {
            id: errorStatusInner
            anchors.top: parent.top
            anchors.topMargin: errorStatusRect.topPadding
            anchors.bottom: parent.bottom
            anchors.bottomMargin: errorStatusRect.botPadding
            anchors.left: parent.left
            anchors.leftMargin: errorStatusRect.horizontalPadding
            anchors.right: parent.right
            anchors.rightMargin: errorStatusRect.horizontalPadding
            width: 260

            Item {
                id: errorTitleRect
                height: errorIcon.height + errorTitle.height
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: errorStatusRect.horizontalPadding
                anchors.right: parent.right
                anchors.rightMargin: errorStatusRect.horizontalPadding

                Image {
                    id: errorIcon
                    width: 48
                    height: 48
                    sourceSize.width:  48
                    sourceSize.height: 48
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    fillMode: Image.PreserveAspectFit
                    source: "file:///" + imageLocation + "errorIcon.svg"
                }

                Text {
                    id: errorTitle
                    text: _("VersionWindowGenericErrorTitle")
                    color: Colors.common.text
                    font.family: "Segoe UI"
                    font.pixelSize: 20
                    anchors.top: errorIcon.bottom
                    anchors.topMargin: errorStatusRect.verticalPadding
                    anchors.left: parent.left
                    anchors.leftMargin: errorStatusRect.horizontalPadding
                    anchors.right: parent.right
                    anchors.rightMargin: errorStatusRect.horizontalPadding
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            SimpleButton {
                id: tryAgainButton
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: 120
                height: 32
                primarycolor: Colors.fabric_button.primary.background
                hovercolor:  Colors.fabric_button.primary.hovered
                pressedcolor: Colors.fabric_button.primary.down
                focusunderline: true
                activeFocusOnTab: true

                textcontrol.color: Colors.fabric_button.primary.text
                textcontrol.text: _("VersionWindowErrorButtonTryAgain")
                textcontrol.font.family: "Segoe UI"
                textcontrol.font.pixelSize: 14
                callback: errorStatusRect.tryAgainButtonClicked
                Accessible.name: textcontrol.text
                Accessible.ignored: !visible
            }
        }
    }

    ConfirmDialog {
        id: confirmDialog
        isRTL: isRTL
        visible: viewModel.state === VersionWindowViewModel.DeleteConfirmDialogUp
        z: 1

        dialogBodyText: _("VersionWindowDeleteConfirmBody")

        button1Text: _("VersionWindowDeleteButton")
        button2Text: _("VersionWindowCancelButton")
        xButtonAltText: _("ActivityCenterMessageDismissHint")
        accessibleDialogTitleText: dialogBodyText
        headerBottomPadding: 0

        modal: true

        onButton2Clicked: reject()
        onDismissed: reject()

        onRejected: {
            // Cancel
            viewModel.onDialogClosed(0);
        }

        onButton1Clicked: {
            // Delete
            viewModel.onDialogClosed(1);
        }

        closePolicy: Popup.CloseOnEscape
    }
}
