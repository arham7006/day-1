/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7

import "fabricMdl2.js" as FabricMDL

Rectangle {
    id: root
    color: Colors.common.background
    opacity: 1.0

    Component.onCompleted: { if (visible) header.forceActiveFocus();}

    SupportPaneHeader {
        id: header
        title.text: _("FeedbackWindowTitle")
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }
    
    Column {
        id: body
        spacing: 16

        anchors {
            top: header.bottom
            topMargin: 4
            left: parent.left
            leftMargin: 12
            right: parent.right
            rightMargin: 12
        }

        SendFeedbackModeItem {
            id: modeSmile
            anchors {
                left: parent.left
                right: parent.right
            }
            primaryText: _("FeedbackSmileChoiceTitle")
            secondaryText: _("FeedbackSmileChoiceText")
            iconSymbol: FabricMDL.Icons.Emoji2
            iconColor: Colors.common.text
            activeFocusOnTab: true
            callback: model.onSendSmile
        }
        SendFeedbackModeItem {
            id: modeFrown
            anchors {
                left: parent.left
                right: parent.right
            }
            primaryText: _("FeedbackFrownChoiceTitle")
            secondaryText: _("FeedbackFrownChoiceText")
            iconSymbol: FabricMDL.Icons.Sad
            iconColor: Colors.common.text
            activeFocusOnTab: true
            callback: model.onSendFrown
        }
        SendFeedbackModeItem {
            id: modeSuggest
            anchors {
                left: parent.left
                right: parent.right
            }
            primaryText: _("FeedbackSuggestionChoiceTitle")
            secondaryText: _("FeedbackSuggestionChoiceText")
            iconSymbol: FabricMDL.Icons.Feedback
            iconColor: Colors.common.text
            activeFocusOnTab: true
            callback: function() {
                model.onSendSuggestion();
                Qt.openUrlExternally(model.suggestionUrl);
            }
        }
    }
}