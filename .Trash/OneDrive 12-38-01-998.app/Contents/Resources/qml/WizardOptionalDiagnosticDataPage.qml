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
    property int primaryFontSize: 14

    onVisibleChanged: {
        if (visible) {
            acceptButton.forceActiveFocus();

            wizardWindow.announceTextChange(header, header.title.text, Accessible.AnnouncementProcessing_ImportantAll);
        }
    }

    WizardPageHeaderWithLink {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        title.text: _("OptionalDiagnosticDataHeaderPrimary")
        subtitle.embeddedLinkModel: pageModel.getSecondaryTextModel(_("OptionalDiagnosticDataHeaderSecondary"))
        subtitle.onLinkActivated: function(link) {
            Qt.openUrlExternally(pageModel.learnMoreUrl);
        }

        image.source: "file:///" + imageLocation + "optionalDiagnosticData.svg"
        image.sourceSize.height: 190
        image.sourceSize.width: 405
        image.anchors.topMargin: 12
    }

    Column {
        id: body
        spacing: 0
        anchors {
            top: header.bottom
            left: parent.left
            leftMargin: horizontalPageMargin
            right: parent.right
            rightMargin: horizontalPageMargin
        }

        Text {
            id: bodyPrimary

            text: _("OptionalDiagnosticDataQuestion")
            font.family: "Segoe UI Semibold"
            font.pixelSize: primaryFontSize
            color: Colors.common.text
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft

            anchors.left: parent.left
            anchors.right: parent.right
            bottomPadding: 6

            Accessible.role: Accessible.StaticText
            Accessible.name: text
            Accessible.focusable: true
        }

        // Radio buttons are auto-exclusive by default. Only one button can be checked
        // at any time amongst radio buttons that belong to the same parent item.
        // https://doc.qt.io/qt-5/qml-qtquick-controls2-radiobutton.html
        //
        // See FabricRadioButton.qml for expected keyboard navigation behavior.
        ListView {
            id: responsesList
            anchors {
                left: parent.left
                right: parent.right
            }
            height: contentHeight

            activeFocusOnTab: true
            keyNavigationEnabled: true
            keyNavigationWraps: true
            interactive: false

            model: 2
            delegate: FabricRadioButton {
                toggleOnFocus: false
                activeFocusOnTab: false
                text: (index == 0) ? _("OptionalDiagnosticDataRadioButtonOptIn") : _("OptionalDiagnosticDataRadioButtonOptOut")
                checked: pageModel.anyOptInSelectionMade && ((index == 0) ? pageModel.isOptionalDiagnosticDataOptIn : !pageModel.isOptionalDiagnosticDataOptIn)
                onToggled: {
                    pageModel.anyOptInSelectionMade = true;
                    pageModel.isOptionalDiagnosticDataOptIn = (index == 0);
                }
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }
    }

    FabricButton {
        id: acceptButton

        anchors {
            bottom: parent.bottom
            right: parent.right

            bottomMargin: verticalPageMargin
            rightMargin: horizontalPageMargin
        }

        Accessible.role: Accessible.Button
        Accessible.disabled: !enabled
        Accessible.name: acceptButton.buttonText
        Accessible.onPressAction: acceptButton.clicked()
        Keys.onReturnPressed: acceptButton.clicked()
        Keys.onEnterPressed: acceptButton.clicked()

        onClicked: {
            if (enabled) {
                pageModel.onAcceptClicked();
            }
        }
        enabled: pageModel.anyOptInSelectionMade
        buttonText: _("OptionalDiagnosticDataAcceptButton")
    }
}
