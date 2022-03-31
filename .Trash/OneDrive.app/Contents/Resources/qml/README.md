This directory contains all QML components authored by OneDrive client team and assets used
by those QML components, specifically:
- Fabric MDL2 Icons font (FabExMDL2.ttf)
- JavaScript constants for icons (fabricMdl2.js)
- JavaScript constants for shared colors

To update Fabric MDL2 Icons font, for example to bring new icons:
- Navigate to ![Microsoft UI Fabric website](https://microsoft.sharepoint.com/OfficeUIFabric97/SitePages/Office%20%UI%20Fabric%20Design%20Toolkit.aspx)
- Download TTF file following instructions
- Update JavaScript icons constants in fabricMdl2.js
- Commit changes
- If updated font has new name, also update QmlLoader.rc, references within QML components and project files to package it properly
