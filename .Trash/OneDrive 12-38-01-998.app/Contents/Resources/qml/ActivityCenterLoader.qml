/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import QtQuick 2.7
import QtQuick.Window 2.2
import Colors 1.0

Rectangle
{
    id: acLoaderRoot
    width: 360
    height: 640
    color: Colors.common.background
    
    // NOTE on Accessiblity:
    // There's implicit logic in the Qt code that
    // automatically gives focus (and Accessibility focus) to
    // the item marked as "focus: true" in the current FocusScope.
    //
    // We can also manually set the Accessibility carret focus to any node
    // by calling QAccessibleEvent(Focus), but doing so at the creation/show time
    // of this QML file can conflict with Qt's call to give focus mentioned above.
    //
    // Thus, we simply let Qt handle it by specifying focus: true for the element
    // we want Narrator/VoiceOver to read out initially.
    //
    // For this file, it's the loading spinner below.
    //
    // Once the ActivityCenter.qml content is loaded, we want
    // the Accessibility focus to jump to the ActivityCenterHeader (and thus read it out loud).
    //
    // Since the Loader element is a FocusScope, when it's done loading
    // we call forceActiveFocus() on it which switches focus to the Loader FocusScope which in turn delegates
    // focus to the child item of the Loader (i.e. item from ActivityCenter.qml)
    // that has the "focus: true" property. Once we call forceActiveFocus, Qt's implicit logic
    // will also set the Accessibility carret focus on the ActivityCenterHeader, which
    // makes Narrator/VoiceOver read out the title in the Header.
    Loader {
        id: acLoader
        anchors.fill: parent
        asynchronous: true

        visible: (status === Loader.Ready)

        onLoaded: {
            activityCenterView.onLoaderOperationComplete(acLoader.item);
            acLoader.forceActiveFocus();
        }

        onStatusChanged: function () {
            if (status === Loader.Error)
            {
                activityCenterView.onLoaderError();
            }
        }

        source: "ActivityCenter.qml"
    }

    Image {
        id: spinningGraphic
        source: "file:///" + imageLocation + "loading_spinner.svg"
        sourceSize.height: 44
        sourceSize.width: 44
        visible: (acLoader.status !== Loader.Ready)

        Accessible.role: Accessible.Graphic
        Accessible.name: activityCenterView.loadingSpinnerAltText
        Accessible.ignored: !visible
        anchors.centerIn: parent
        focus: true

        NumberAnimation on rotation {
            id: rotationAnimation
            easing.type: Easing.InOutQuad
            from: -45
            to: 315
            duration: 1500
            loops: Animation.Infinite
            running: spinningGraphic.visible
        }
    }

    NumberAnimation {
        id: anim
        target: spinningGraphic.Window.window
        property: "y"
        duration: 550
        easing.type: Easing.OutQuint
    }

    function startPopupAnimation(startY, endY) {
        anim.from = startY;
        anim.to = endY;
        anim.start();
    }

    signal onEscapePressed();

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape)
        {
            onEscapePressed();
        }
    }
}
