import Colors 1.0
import QtQuick.Window 2.2
import QtQuick 2.7
import SendFeedbackViewModel 1.0

Rectangle {
    id: root
    color: Colors.common.background
    opacity: 1.0

    property string fullImageLocation: "file:///" + imageLocation

    LayoutMirroring.enabled: model.isRTL
    LayoutMirroring.childrenInherit: true

    width: 380
    height: 380
      
    //Needed for accessibility
    Window.onActiveChanged: {
        if (Window.active && !Window.activeFocusItem) {
           root.forceActiveFocus();
        }
    }

    Image {
        id: spinningGraphic
        source: fullImageLocation + "loading_spinner.svg"
        sourceSize.height: 28
        sourceSize.width: 28

        visible: paneLoader.status !== Loader.Ready

        Accessible.ignored: true

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

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

    Loader {
        id: paneLoader
        anchors.fill: parent

        //Default source is UserInput state
        source: {
            var sourceFile = "SupportUserInputPane.qml";
            switch (model.state) {
                case SendFeedbackViewModel.Initial: {
                    sourceFile = "SupportOptionsPane.qml";
                    break;
                }
                case SendFeedbackViewModel.Sending: {
                    sourceFile = "SupportSendingPane.qml";
                    break;
                }
                case SendFeedbackViewModel.SendFailure: {
                    sourceFile = "SupportFailurePane.qml";
                    break;
                }
                case SendFeedbackViewModel.Confirm: {
                    sourceFile = "SupportConfirmPane.qml";
                    break;
                }
                default: {
                    sourceFile = "SupportUserInputPane.qml";
                    break;
                }
            }
            return sourceFile;
        }

        visible: status === Loader.Ready
        asynchronous: false
    }
}