/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: root
    color: "transparent"

    LayoutMirroring.enabled: pageModel.isRTL
    LayoutMirroring.childrenInherit: true

    property int verticalPageMargin: 30
    property int horizontalPageMargin: 35
    property int primaryFontSize: 13

    onVisibleChanged: {
        if (visible) {
            nextBtn.forceActiveFocus();

            wizardWindow.announceTextChange(header, header.title.text, Accessible.AnnouncementProcessing_ImportantAll);
        }
    }

    WizardPageHeader {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        title.text: _("RequiredDiagnosticDataHeaderPrimary")
        subtitle.text: _("RequiredDiagnosticDataHeaderSecondary")
        subtitle.anchors.leftMargin: 30
        subtitle.anchors.rightMargin: 30
        image.source: "file:///" + imageLocation + "requiredDiagnosticData.svg"
        image.sourceSize.height: 176
        image.sourceSize.width: 376
        image.anchors.topMargin: 1
    }

    Column {
        id: bodyText
        spacing: primaryFontSize
        anchors {
            top: header.bottom
            left: parent.left
            leftMargin: horizontalPageMargin
            right: parent.right
            rightMargin: horizontalPageMargin
        }

        Text {
            id: bodyPrimary
            anchors {
                left: parent.left
                right: parent.right
            }

            text: _("RequiredDiagnosticDataBodyPrimary")
            font.family: "Segoe UI"
            font.pixelSize: primaryFontSize
            color: Colors.common.text_secondary
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft

            Accessible.role: Accessible.StaticText
            Accessible.name: text
        }

        Text {
            id: bodySecondary
            anchors {
                left: parent.left
                right: parent.right
            }
            
            text: _("RequiredDiagnosticDataBodySecondary")
            font.family: "Segoe UI"
            font.pixelSize: primaryFontSize
            color: Colors.common.text_secondary
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft

            Accessible.role: Accessible.StaticText
            Accessible.name: text
        }

        SimpleButtonLink {
            id: learnMoreLink
            anchors {
                left: parent.left
                right: parent.right
            }

            textcontrol.text: _("RequiredDiagnosticDataLearnMoreLink")
            textcontrol.font.pixelSize: primaryFontSize
            textcontrol.font.family: "Segoe UI"
            textcontrol.color: getTextColor()
            textcontrol.linkColor: getTextColor()
            textcontrol.horizontalAlignment: Text.AlignLeft

            Accessible.name: _("RequiredDiagnosticDataLearnMoreDescription")

            callback: function() {
                Qt.openUrlExternally(pageModel.learnMoreUrl);
            }
        }
    }

    FabricButton {
        id: nextBtn

        anchors {
            bottom: parent.bottom
            right: parent.right

            bottomMargin: verticalPageMargin
            rightMargin: horizontalPageMargin
        }

        Accessible.role: Accessible.Button
        Accessible.name: nextBtn.buttonText
        Accessible.onPressAction: nextBtn.clicked()
        Keys.onReturnPressed: nextBtn.clicked()
        Keys.onEnterPressed: nextBtn.clicked()

        onClicked: pageModel.onNextButtonClicked()
        buttonText: _("RequiredDiagnosticDataNextButton")
    }
}
