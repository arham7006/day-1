import Colors 1.0
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import TreeModel 1.0

import "fabricMdl2.js" as FabricMDL

/*
  Customizes TreeView for the Selective Sync UI
  Users need to specify:
    model - the model of the tree
 */
TreeView {
    id: theTree

    Accessible.role: Accessible.Tree
    Accessible.name: _("SelectiveSyncTreeAccessibleName")
    property bool isRTL: false

    Keys.onSpacePressed: {
        pageModel.toggleItem(currentIndex)
    }

    FontLoader {
        id: fabricMDL2;
        source: Qt.platform.os === "osx" ? "FabExMDL2.ttf" : "file:///" + qmlEngineBasePath + "FabExMDL2.ttf"
    }

    TableViewColumn {
        title: "Name"
        role: "Name"
        resizable: true
    }

    headerDelegate: Component {
        Rectangle {
            height: 0
        }
    }

    frameVisible: false

    property int hoveredItemIndex : -1

    onExpanded : function (index) {
        if (!pageModel.treeModel.isLoading) {
            if (!pageModel.onNodeExpanded(index))
            {
                // if model rejected the expansion, then collapse
                collapse(index);
            }
        }
    }

    style: TreeViewStyle {
        backgroundColor: "transparent"
        indentation: 0      // we calculate our own indentation by multiplying desired indent of 22 * depth

        incrementControl: Rectangle {
            width: 12
            height: 12
            color: (styleData.pressed ?
                       Colors.selective_sync_scrollbar.chevron_background_pressed :
                       Colors.selective_sync_scrollbar.chevron_background)

            Image {
                sourceSize.width: 16
                sourceSize.height: 16
                source: "file:///" + imageLocation + "scrollbarChevronDown"
                anchors.centerIn: parent
            }
        }

        decrementControl: Rectangle {
            width: 12
            height: 12
            color: (styleData.pressed ?
                       Colors.selective_sync_scrollbar.chevron_background_pressed :
                       Colors.selective_sync_scrollbar.chevron_background)

            Image {
                sourceSize.width: 16
                sourceSize.height: 16
                source: "file:///" + imageLocation + "scrollbarChevronUp"
                anchors.centerIn: parent
            }
        }

        scrollBarBackground: Item {
            implicitWidth: 12
            implicitHeight: 12
            clip: true

            Rectangle {
                anchors.fill: parent
                color: Colors.selective_sync_scrollbar.background
                anchors.rightMargin: styleData.horizontal ? -2 : -1
                anchors.leftMargin: styleData.horizontal ? -2 : 0
                anchors.topMargin: styleData.horizontal ? 0 : -2
                anchors.bottomMargin: styleData.horizontal ? -1 : -2
            }
        }

        handle: Rectangle {
            color: "transparent"
            implicitWidth: 12
            implicitHeight: 12

            Rectangle {
                id: img
                opacity: styleData.pressed && !transientScrollBars ? 0.5 : styleData.hovered ? 1 : 0.8
                color: Colors.selective_sync_scrollbar.handle
                anchors.top: !styleData.horizontal ? parent.top : undefined
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.left: styleData.horizontal ? parent.left : undefined
                anchors.horizontalCenter: (!styleData.horizontal) ? parent.horizontalCenter : undefined
                width: 12
            }
        }

        itemDelegate: Rectangle {
            id: itemRect
            color: "transparent"
            height: 20

            // Mac does not have the concept of a TreeItem, so expose as a Grouping with children instead.
            Accessible.role: (Qt.platform.os === "osx") ?
                                 (chevronImg.visible ? Accessible.Grouping : Accessible.CheckBox) :
                                 Accessible.TreeItem
            Accessible.onToggleAction: chkBox.toggleHelper()
            Accessible.selectable: true
            Accessible.selected: styleData.selected
            Accessible.checkable: true
            Accessible.checked: ((chkBox.checkState === Qt.Checked) || (chkBox.checkState === Qt.PartiallyChecked))
            Accessible.checkStateMixed: (chkBox.checkState === Qt.PartiallyChecked)

            Accessible.expandable: styleData.hasChildren
            Accessible.expanded: styleData.isExpanded

            Accessible.name: chkBox.text
            Accessible.focusable: true
            Accessible.focused: styleData.hasActiveFocus

            function accessibleExpandAction() {
                theTree.expand(styleData.index);
            }

            function accessibleCollapseAction() {
                theTree.collapse(styleData.index);
            }

            property bool hasChildren: styleData.hasChildren
            property int treeRow : styleData.row
            property int parentId: (model ? model.ParentId : 0)
            property int treeItemId: (model ? model.TreeItemId : 0)
            property int loadingState: (model ? model.LoadingState : TreeModel.NotLoaded)
            property int depth: styleData.depth

            property bool isSelected : styleData.selected
            onIsSelectedChanged: {
                // The TreeView has a weird quirk where
                // if an item is selected (up/down arrow keys) it doesn't
                // mean it's also focused.
                // A focused item is definitely also selected though.
                //
                // From a keyboard handling point of view, what happens is
                // the TreeView receives up/down/other key presses
                // and delegates some of the handling to the tree items, without
                // formally assigning them focus.
                // The only way to make a tree item focused is to click on it.
                // You can try it by inspecting the styleData.hasActiveFocus
                // property when navigating up/down using keys vs. when clicking
                // on an item.
                //
                // This is incorrect in the Accessibility world, where if an item is
                // not focused then it doesn't get read out.
                //
                // Thus we keep the selected and activeFocus properties in sync
                // by forcing active focus on the tree item.
                if (styleData.selected && !styleData.hasActiveFocus)
                {
                    this.forceActiveFocus();
                }
            }

            Keys.onSpacePressed: chkBox.toggleHelper()
            Keys.onEnterPressed: chkBox.toggleHelper()
            Keys.onReturnPressed: chkBox.toggleHelper()

            Rectangle {
                id: chevron
                color: "transparent"
                width: 18
                height: 18

                anchors.left: itemRect.left
                anchors.leftMargin: depth * 12
                anchors.verticalCenter: parent.verticalCenter

                // For Windows, ignore this item since we already expose it as part of TreeItem
                Accessible.ignored: !chevronImg.visible || (Qt.platform.os !== "osx")
                Accessible.role: Accessible.ColorChooser        // we override the ColorChooser to map to NSAccessibilityDisclosureTriangleRole

                // handle the accessibility "click" as we would a mouse click
                Accessible.onPressAction: {
                    if (styleData.isExpanded) {
                        theTree.collapse(styleData.index);
                    }
                    else {
                        theTree.expand(styleData.index);
                    }
                }

                Image {
                    id: chevronImg
                    visible: (styleData.column === 0) && styleData.hasChildren
                    sourceSize.width: 14
                    sourceSize.height: 14
                    source: "file:///" + imageLocation + (styleData.isExpanded ? "treeChevronDown.svg" :
                                                                                 isRTL ? "treeChevronLeft.svg" : "treeChevronRight.svg")
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: branchMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (styleData.isExpanded) {
                            theTree.collapse(styleData.index);
                        }
                        else {
                            theTree.expand(styleData.index);
                        }
                    }
                }
            }

            TreeItemCheckBox {
                id: chkBox
                activeFocusOnTab: false

                anchors.left: chevron.right
                anchors.leftMargin: 2
                anchors.verticalCenter: parent.verticalCenter

                // For Windows, ignore this item since we already expose it as part of TreeItem
                Accessible.ignored: (Qt.platform.os !== "osx")
                Accessible.onToggleAction: toggleHelper()

                text: styleData.value
                imageSrc: "file:///" + imageLocation + (hasChildren ?
                                                            (Qt.platform.os === "osx" ? "macFolder.svg" : "yellowFolder.svg") : "file.svg")

                checkState: (model ? model.State : Qt.Unchecked)
                hasActiveFocus: styleData.hasActiveFocus || styleData.selected

                function toggleHelper() {
                    var checkStateName = (checkState === Qt.Checked) ? "Checked" : (checkState === Qt.PartiallyChecked) ? "Partial" : "Unchecked";
                    pageModel.toggleItem(styleData.index, checkState);
                }

                onClicked: toggleHelper()
            }
        }

        // branchDelegate does not appear for RTL. Do not use.
        branchDelegate: Item {}

        rowDelegate: Rectangle {
            height: 22
            color: "transparent"
        }
    }
}
