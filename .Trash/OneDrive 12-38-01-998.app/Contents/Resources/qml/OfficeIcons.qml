/*************************************************************/
/*                                                           */
/* Copyright (C) Microsoft Corporation. All rights reserved. */
/*                                                           */
/*************************************************************/

import Colors 1.0
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import "fabricMdl2.js" as FabricMDL

Row {
    id: iconRow
    property int squareIconLength: 25
    property int iconSpacing: 10
    
    width: childrenRect.width
    spacing: iconSpacing
    
    Accessible.role: Accessible.Grouping
    
    Image {
        source: fullImageLocation + "word.svg"
        width: squareIconLength
        height: squareIconLength
        sourceSize.height: squareIconLength
        sourceSize.width: squareIconLength
        Accessible.role: Accessible.Graphic
        Accessible.name: "Microsoft Word"
    }        
    
    Image {
        source: fullImageLocation + "excel.svg"
        width: squareIconLength
        height: squareIconLength
        sourceSize.height: squareIconLength
        sourceSize.width: squareIconLength
        Accessible.role: Accessible.Graphic
        Accessible.name: "Microsoft Excel"
    }

    Image {
        source: fullImageLocation + "powerpoint.svg"
        width: squareIconLength
        height: squareIconLength
        sourceSize.height: squareIconLength
        sourceSize.width: squareIconLength
        Accessible.role: Accessible.Graphic
        Accessible.name: "Microsoft PowerPoint"
    }

    Image {
        source: fullImageLocation + "onenote.svg"
        width: squareIconLength
        height: squareIconLength
        sourceSize.height: squareIconLength
        sourceSize.width: squareIconLength
        Accessible.role: Accessible.Graphic
        Accessible.name: "Microsoft OneNote"
    }

    Image {
        source: fullImageLocation + "outlook.svg"
        width: squareIconLength
        height: squareIconLength
        sourceSize.height: squareIconLength
        sourceSize.width: squareIconLength
        Accessible.role: Accessible.Graphic
        Accessible.name: "Microsoft Outlook"
    }

    Image {
        source: fullImageLocation + "blue_cloud.svg"
        width: squareIconLength
        height: squareIconLength
        sourceSize.height: squareIconLength
        sourceSize.width: squareIconLength
        Accessible.role: Accessible.Graphic
        Accessible.name: "Microsoft OneDrive"
    }
}
