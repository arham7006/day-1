/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import QtQuick 2.7
import QtQuick.Window 2.2
import com.microsoft.OneDrive 1.0
import Colors 1.0

// Header Rectangle
//   This is the actual colored rectangle which shows as the top element of the Activity center.
Rectangle {

    Accessible.role: Accessible.StaticText
    Accessible.name: titleText.text + ";" + tenantNameText.text
    Accessible.focusable: true

    // State properties. isPaused, needsAttention and isOnlineMode are inherited from the parent ActivityCenter
    property bool isPaused
    property bool needsAttention
    property bool isOnlineMode
    property bool isSyncingBlocked
    property bool showErrorBackground
    property bool showAsSyncing: (headerModel.isSyncing && !isPaused && !needsAttention)
    
    // Set the color of the header based on state
    color: !(isOnlineMode || isSyncingBlocked) ? Colors.activity_center.header.paused : (showErrorBackground ? Colors.activity_center.header.error : Colors.activity_center.header.normal)

    // Header visual Content
    //   Visible content in the header is aligned in a column, so it's centered.
    Column {
        // Align all content to the center of the header both vertically and horizontally
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        // Ensure we can use full width of the header (minus some padding for wrapping text)
        width: parent.width
        padding: 4

        // Icon And Title
        //   A title at the top of the header which contains: "[OD Icon / Syncing Animation] OneDrive"
        Row {
            // Align the Onedrive icon and title text (combined) in center of the header.
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: showAsSyncing ? 8 : 4  // Amount of space between icon and title

            Rectangle {
                id: oneDriveIconContainer
                width: 20
                height: 20
                color: "transparent"

                // The OneDrive icon
                //   A small OneDrive cloud icon.  This is intended to be visible when OD is not updating.
                Image {
                    id: theOneDriveIcon
                    anchors.centerIn: parent
                    source: "file:///" + imageLocation + "cloud.svg"
                    sourceSize.width: 20
                    sourceSize.height: 20
                    width: 20
                    height: 20
                    fillMode:Image.PreserveAspectFit
                    visible: !showAsSyncing
                }

                // Spinning arrows icon (animated)
                //   A small cyclical arrows icon. It is visible and animated when OD is updating.
                Image {
                    width: 20
                    height: 20
                    anchors.centerIn: parent
                    source: "file:///" + imageLocation + "loading.svg"
                    sourceSize.width: 20
                    sourceSize.height: 20
                    visible: showAsSyncing

                    // 360 degree infinite animation
                    //   Note that this is targeted on the "rotation" property of its parent.
                    // NOTE on battery drain and Animations: we need to explicitly disable the animation
                    // the the window is hidden (the Window.visibility attached property is Window.Hidden)
                    NumberAnimation on rotation {
                        id: rot;
                        from: 0;
                        to: 359;
                        duration: 2000;
                        loops: Animation.Infinite
                        property bool enabled : false
                        running: enabled && showAsSyncing
                    }

                    Window.onVisibilityChanged : {
                        if (Window.visibility === Window.Hidden) {
                            rot.enabled = false;
                        } else {
                            rot.enabled = true;
                        }
                    }
                }
            }

            // Title text
            //   The title text of "OneDrive" (when updating, the phrase will be "OneDrive is updating...")
            Text {
                id: titleText

                // Aligning to the center of the parent (Icon and title), so that the text is vertically centered next to the icon.
                anchors.verticalCenter: parent.verticalCenter
                wrapMode: Text.WordWrap

                color: Colors.activity_center.header.caption
                text: headerModel.titleText
                font.family: "Segoe UI Semibold"
                font.pixelSize: 15
            }
        }

        // Subtitle or tenant text
        //   The subtitle text of "Personal" or "Microsoft".
         Text {
            id: tenantNameText

            // Text positioning properties: Intent is to horizontally align to center of the column so subtext is aligned with title & icon.
            //   inherit parent horizontal anchors to properly set correct text boundaries for wrapping
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width

            // within the area defined by anchors, center and wrap text
            horizontalAlignment: Text.Center
            wrapMode: Text.WordWrap

            color: Colors.activity_center.header.caption
            text: headerModel.tenantName
            visible: headerModel.isTenantVisible
            font.pixelSize: 13
            font.family: "Segoe UI"
        }
    }
}
