/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/
import QtQml 2.2
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2

Rectangle {
    anchors.fill: parent
    visible: true
    id: root

    property string fileResourceId : ""
    property string authTicket: ""

    function _(resourceId) {
        return viewModel.getLocalizedMessage(resourceId);
    }

    function startTicketFetch() {
        var task = {};
        task.task = "TicketFetch";
        task.args = {};
        task.args.scope = "service::ssl.live.com::MBI_SSL";
        taskmanager.startTask(task, ticketCallback);
    }

    function getLinkCallback(result) {
        root.fileResourceId = result.resourceId;
        startTicketFetch();
    }

    function startGetLink(path) {
        var task = {};
        task.task = "GetLink";
        task.args = {};
        task.args.isFolder = false;
        task.args.linkType = 5;
        task.args.path = path;
        taskmanager.startTask(task, getLinkCallback);
    }

    function ticketCallback(result) {
        authTicket = result.ticket;
        viewModel.doneLoading();
        getVersion(authTicket);
    }

    //TODO t-cykoh (#594875) ODB
    function getVersion(ticket) {
        var url = "https://api.onedrive.com/v1.0/drive/items/" + root.fileResourceId + "/versions";
        var request = new XMLHttpRequest();
        request.open("GET", url, true);
        request.setRequestHeader("Authorization", "WLID1.1 t=" + ticket);
        request.onreadystatechange = function() {
            httpCallback(request);
        };
        request.send();
    }

    function httpCallback(request) {
        if ((request.readyState === XMLHttpRequest.DONE) && (request.status === 200)) {
            versionListModel.clear();
            var responseText = request.responseText;
            var jsonVersionList = JSON.parse(responseText);
            var versionJSONValueId = jsonVersionList["value"];
            var count = versionJSONValueId.length;

            for (var i=0; i < count; i++) {
                try {
                    //TODO: t-cykoh (#594875) use Colors defined in Colors.qml
                    var dataobject = {};
                    var entry =  versionJSONValueId[i];
                    dataobject.index = i;
                    dataobject.versionID = entry["id"];
                    dataobject.lastModifiedDateTime = entry["lastModifiedDateTime"];
                    dataobject.dateModified = new Date(Date.parse(entry["lastModifiedDateTime"]));
                    dataobject.size = entry["size"];
                    dataobject.author = entry["lastModifiedBy"]["user"]["displayName"];
                    dataobject.downloadURL = entry["@content.downloadUrl"];
                    versionListModel.append(dataobject);
                }
                catch (e) {
                    console.log("Exception: " + e);
                }
            }
        }
        else if (request.readyState === XMLHttpRequest.DONE) {
            console.log("error: HTTP status code==" + request.status);
        }
        viewModel.doneLoading();
    }

    function sizeType(size) {
        var sizeStr = "";
        if (size <= 1024) {
            sizeStr = size + " " +  _("byteText");
        }

        else if (size <= 1024*1024) {
            size = Math.round(size / (1024));
            sizeStr = size + " " +  _("MegaByteAbbrv");
        }

        else if (size <= 1024*1024*1024) {
            size = Math.round(size / (1024*1024));
            sizeStr = size + " " +  _("KiloByteAbbrv");
        }

        else if (size > 1024*1024*1024) {
            size = Math.round(size / (1024*1024*1024));
            sizeStr = size + " " +  _("GigaByteAbbrv");
        }
        return sizeStr;
    }

    Component.onCompleted: {
        startGetLink(viewModel.path);
    }

    Rectangle {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        ListModel {
            id: versionListModel
        }

        Row {
            id: title
            anchors.top: parent.top;
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40
            bottomPadding: 10

            Text {
                text: _("VersionWindowModifiedDate")
                font.family: "Segoe UI"
                font.pointSize:8
                width: 370
            }
            Text {
                text: _("VersionWindowModifiedBy")
                font.family: "Segoe UI"
                font.pointSize: 8
                width: 240
            }
            Text {
                text: _("VersionWindowFileSize")
                font.family: "Segoe UI"
                font.pointSize: 8
            }
        }

        ListView {
            id: versionListView
            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            model: versionListModel

            flickableDirection: Flickable.AutoFlickDirection
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            delegate: Row {
                spacing: 10
                id: row
                Text {
                    //TODO TFS#594875 (t-cykoh)
                    //will need to add the other languages to viewModel later
                    text: dateModified.toLocaleDateString(Qt.locale("en-US"), "MMMM dd yyyy")
                    width: 250
                    font.family: "Segoe UI"
                    font.pixelSize: 15
                }

                Button{
                    contentItem : Image {
                        source: "file:///" + imageLocation + "overFlowIconLarge.svg";
                    }
                    onClicked:{
                        menu.open();
                    }

                    Menu {
                        id: menu

                        MenuItem {
                            text: _("VersionWindowRestore")
                            onTriggered:function()
                            {
                                var url = "https://api.onedrive.com/v1.0/drive/items/" + fileResourceId + "/versions/" + versionID + "/action.restoreVersion";
                                var request = new XMLHttpRequest();
                                request.open("POST", url, true);
                                request.setRequestHeader("Authorization", "WLID1.1 t=" + authTicket);
                                request.onreadystatechange = function() {
                                    httpCallback(request);
                                    //used to refresh the list model after the restore action is completed
                                    getVersion(authTicket);
                                };
                                request.send();
                            }
                        }
                        MenuItem {
                            text: _("VersionWindowDownload")
                            onTriggered: {
                                Qt.openUrlExternally(downloadURL);
                            }
                        }
                    }
                }
                Text {
                    text: author
                    width: 230
                    font.family: "Segoe UI"
                    font.pixelSize: 15
                }
                Text {
                    text: sizeType(size)
                    width: 250
                    font.family: "Segoe UI"
                    font.pixelSize: 15
                }
            }
        }
    }
}
