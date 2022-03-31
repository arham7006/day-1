// Gets the background color of a list item
function chooseListItemBackgroundColor(hasFocus, usePrimaryColor, isHovering) {
    var color = usePrimaryColor ? Colors.common.background : Colors.activity_center.list.background_secondary;
    if (isHovering) {
        color = Colors.activity_center.error.list_background_hovering;
    }
    if (hasFocus) {
        color = Colors.activity_center.list.background_focus;
    }
    return color;
}

// True if key is one that we handle in the lists
function isHandledKeyPress(event)
{
    return ((event.key === Qt.Key_Up) ||
            (event.key === Qt.Key_Down) ||
            (event.key === Qt.Key_End) ||
            (event.key === Qt.Key_Home) ||
            (event.key === Qt.Key_PageUp) ||
            (event.key === Qt.Key_PageDown));
}

function chooseErrorOrWarningBGColor(isWarnings, hasFocus) {
    return ((isWarnings) ?
        ((hasFocus) ?
            Colors.activity_center.error.background_warning_hovering :
            Colors.activity_center.error.background_warning) :
        ((hasFocus) ?
            Colors.activity_center.error.background_hovering :
            Colors.activity_center.error.background));
}
