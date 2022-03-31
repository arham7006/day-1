/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

import "fabricMdl2.js" as FabricMDL

// Progress bar with Fabric UI customizations
Rectangle {
    id: root

    // These properties need to be defined to use this object
    property int animatorObjectWidth: 150  // Object width is used to determine animation length
    property bool isRTL
    property bool isDeterminate: false
    property int progressPercentage : 0
    // End properties
    
    Accessible.ignored: !visible
    color: Colors.activity_center.list.progress_background
    
    Item {
        id: progressGauge
        anchors.fill: parent
        clip: true
        visible: parent.visible
        Rectangle {
            visible: parent.visible && root.isDeterminate
            width: (parent.width * progressPercentage) / 100
            height: parent.height
            color: Colors.activity_center.list.progress
        }

        Rectangle {
            visible: parent.visible && !root.isDeterminate
            width: parent.width
            height: parent.width
            // gradients are only applied vertically. Rotation is used to simulate a horizontal gradient
            rotation: 90 
            gradient: Gradient {
                GradientStop { position: 0.0; color: Colors.activity_center.list.progress_background }
                GradientStop { position: 0.25; color: Colors.activity_center.list.progress }
                GradientStop { position: 0.75; color: Colors.activity_center.list.progress }
                GradientStop { position: 1.0; color: Colors.activity_center.list.progress_background }
            }
            XAnimator on x {
                running: parent.visible
                from: isRTL ? animatorObjectWidth : -animatorObjectWidth
                to: isRTL ? -animatorObjectWidth : animatorObjectWidth
                duration: 4000
                loops: Animation.Infinite
            }
        }
    }
}
