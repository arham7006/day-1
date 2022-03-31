pragma Singleton
import QtQuick 2.0
import "palettes.js" as Palettes;
import ColorThemeManager 1.0

// NOTE:  Since singletons cannot reload during runtime, this file must be built before running
//        *even in qtDeveloperMode*

QtObject {
    id: root
    property string currentTheme: colorThemeManager.currentThemeName

    // Colors.common
    // These colors are used by multiple UI elements.  When modifying, be sure to verify all places they are used.
    property QtObject common:
    {
        var properties = {"Standard":      {"hyperlink":                    "Palettes.Comm.Primary",
                                            "hyperlink_hovering":           "Palettes.Comm.Shade30",
                                            "hyperlink_pressed":            "Palettes.Comm.Shade30",
                                            "text":                         "Palettes.Fabric.neutralPrimary",
                                            "text_secondary":               "Palettes.Fabric.neutralSecondary",
                                            "text_secondaryAlt":            "Palettes.Fabric.neutralSecondaryAlt",
                                            "text_hover":                   "Palettes.Fabric.neutralPrimary",
                                            "text_disabled":                "Palettes.Fabric.neutralTertiary",
                                            "text_secondary_hovering":      "Palettes.Fabric.neutralSecondary",
                                            "text_secondary_hovering_alt":  "Palettes.Fabric.neutralSecondaryAlt",
                                            "text_tertiary":                "Palettes.Fabric.neutralTertiaryAlt",
                                            "border_focus":                 "Palettes.Basic.black",
                                            "mac_border_focus":             "Palettes.Neutrals.gray130",
                                            "checkmark":                    "Palettes.Basic.green",
                                            "error_badge":                  "Palettes.Basic.redDark",
                                            "background":                   "Palettes.Basic.white"},

                          "HighContrast":   {"hyperlink":                   "systemColors.hotlight",
                                            "hyperlink_hovering":           "systemColors.hotlight",
                                            "hyperlink_pressed":            "systemColors.hotlight",
                                            "text":                         "systemColors.windowText",
                                            "text_secondary":               "systemColors.windowText",
                                            "text_secondaryAlt":            "systemColors.windowText",
                                            "text_hover":                   "systemColors.highlightText",
                                            "text_disabled":                "systemColors.inactiveCaptionText",
                                            "text_secondary_hovering":      "systemColors.highlightText",
                                            "text_secondary_hovering_alt":  "systemColors.highlightText",
                                            "text_tertiary":                "systemColors.windowText",
                                            "border_focus":                 "systemColors.highlightText",
                                            "mac_border_focus":             "systemColors.highlightText",
                                            "checkmark":                    "systemColors.windowText",
                                            "error_badge":                  "systemColors.windowText",
                                            "background":                   "systemColors.window"},

                          "Dark":          {"hyperlink":                    "Palettes.DarkThemeBlue.themeDarkAlt",
                                            "hyperlink_hovering":           "Palettes.DarkThemeBlue.themeDarker",
                                            "hyperlink_pressed":            "Palettes.DarkThemeBlue.themeDarker",
                                            "text":                         "Palettes.Neutrals.white",
                                            "text_secondary":               "Palettes.Neutrals.gray80",
                                            "text_secondaryAlt":            "Palettes.Neutrals.gray80",
                                            "text_hover":                   "Palettes.Neutrals.gray50",
                                            "text_disabled":                "Palettes.Neutrals.gray50",
                                            "text_secondary_hovering":      "Palettes.Neutrals.gray70",
                                            "text_secondary_hovering_alt":  "Palettes.Neutrals.gray90",
                                            "text_tertiary":                "Palettes.Neutrals.gray80",
                                            "border_focus":                 "Palettes.Neutrals.white",
                                            "mac_border_focus":             "Palettes.Neutrals.gray90",
                                            "checkmark":                    "Palettes.Shared.green20",
                                            "error_badge":                  "Palettes.OneOff.error_history_item_dark",
                                            "background":                   "Palettes.Neutrals.gray170"}};
        return itemFromThemes(properties);
    }


    property QtObject fabric_button:
        QtObject {
            // Colors.fabric_button.primary
            property QtObject primary:
            {
                var properties = {"Standard":    {"background":        "Palettes.Comm.Primary",
                                                  "down":              "Palettes.Comm.Shade30",
                                                  "hovered":           "Palettes.Comm.Shade10",
                                                  "disabled":          "Palettes.Neutrals.gray20",
                                                  "text":              "Palettes.Basic.white",
                                                  "text_hovered":      "Palettes.Basic.white",
                                                  "text_down":         "Palettes.Basic.white",
                                                  "text_disabled":     "Palettes.Neutrals.gray50",
                                                  "focused_border":    "Palettes.Neutrals.gray130",
                                                  "radio_button_selected": "background"},

                                 "HighContrast": {"background":        "systemColors.windowText",
                                                  "down":              "background", // Same as background
                                                  "hovered":           "systemColors.hotlight",
                                                  "disabled":          "systemColors.inactiveBorder",
                                                  "text":              "systemColors.window",
                                                  "text_hovered":      "systemColors.window",
                                                  "text_down":         "systemColors.window",
                                                  "text_disabled":     "systemColors.window",
                                                  "focused_border":    "systemColors.hotlight",
                                                  "radio_button_selected": "Palettes.Basic.black"},

                                 "Dark":         {"background":        "Palettes.Fabric.themePrimary",
                                                  "down":              "Palettes.Fabric.themeDark",
                                                  "hovered":           "Palettes.Fabric.themeDarkAlt",
                                                  "disabled":          "Palettes.Neutrals.gray160",
                                                  "text":              "Palettes.Basic.white",
                                                  "text_hovered":      "Palettes.Neutrals.white",
                                                  "text_down":         "Palettes.Neutrals.white",
                                                  "text_disabled":     "Palettes.Neutrals.gray130",
                                                  "focused_border":    "Palettes.Neutrals.gray190",
                                                  "radio_button_selected": "background"}};
                return itemFromThemes(properties);
            }

            // Colors.fabric_button.standard
            property QtObject standard:
            {
                var properties = {"Standard":    {"background":        "Palettes.Neutrals.white",
                                                  "down":              "Palettes.Neutrals.gray30",
                                                  "hovered":           "Palettes.Neutrals.gray20",
                                                  "disabled":          "Palettes.Neutrals.gray20",
                                                  "text":              "Palettes.Neutrals.gray160",
                                                  "text_hovered":      "Palettes.Neutrals.gray190",
                                                  "text_down":         "Palettes.Neutrals.gray190",
                                                  "text_disabled":     "Palettes.Neutrals.gray50",
                                                  "focused_border":    "Palettes.Neutrals.gray130"},

                                 "HighContrast": {"background":        "systemColors.windowText",
                                                  "down":              "systemColors.hotlight",
                                                  "hovered":           "systemColors.hotlight",
                                                  "disabled":          "systemColors.inactiveBorder",
                                                  "text":              "systemColors.window",
                                                  "text_hovered":      "systemColors.window",
                                                  "text_down":         "systemColors.window",
                                                  "text_disabled":     "systemColors.window",
                                                  "focused_border":    "systemColors.hotlight"},

                                 "Dark":         {"background":        "Palettes.Neutrals.gray190",
                                                  "down":              "Palettes.Neutrals.gray150",
                                                  "hovered":           "Palettes.Neutrals.gray160",
                                                  "disabled":          "Palettes.Neutrals.gray160",
                                                  "text":              "Palettes.Neutrals.gray20",
                                                  "text_hovered":      "Palettes.Neutrals.gray10",
                                                  "text_down":         "Palettes.Neutrals.gray10",
                                                  "text_disabled":     "Palettes.Neutrals.gray130",
                                                  "focused_border":    "Palettes.Neutrals.gray70"}};
                return itemFromThemes(properties);
            }

            // Colors.fabric_button.upsell
            property QtObject upsell:
            {
                var properties = {"Standard":    {"background":        "Palettes.Basic.green",
                                                  "down":              "Palettes.Basic.greenDark",
                                                  "hovered":           "Palettes.Shared.green20",
                                                  "disabled":          "Palettes.Neutrals.gray20",
                                                  "text":              "Palettes.Basic.white",
                                                  "text_disabled":     "Palettes.Neutrals.gray50",
                                                  "focused_border":    "Palettes.Neutrals.gray130"},

                                 "HighContrast": {"background":         "systemColors.windowText",
                                                  "down":               "background", // Same as background
                                                  "hovered":            "systemColors.hotlight",
                                                  "disabled":           "systemColors.inactiveBorder",
                                                  "text":               "systemColors.window",
                                                  "text_disabled":      "systemColors.window",
                                                  "focused_border":     "systemColors.hotlight"},

                                 "Dark":         {"background":        "Palettes.Basic.green",
                                                  "down":              "Palettes.Basic.greenDark",
                                                  "hovered":           "Palettes.Shared.green20",
                                                  "disabled":          "Palettes.Neutrals.gray160",
                                                  "text":              "Palettes.Basic.white",
                                                  "text_disabled":     "Palettes.Neutrals.gray130",
                                                  "focused_border":    "Palettes.Neutrals.gray190"}};
                return itemFromThemes(properties);
            }
        }

    // Colors.fabric_textfield
    property QtObject fabric_textfield:
    {
        var properties = {  "Standard":   { "background":             "Palettes.Basic.white",
                                            "background_disabled":    "Palettes.Neutrals.gray20",
                                            "border":                 "Palettes.Neutrals.gray130",
                                            "border_hover":           "Palettes.Neutrals.gray160",
                                            "border_selected":        "Palettes.Comm.Primary",
                                            "border_disabled":        "Palettes.Neutrals.gray20",
                                            "border_error":           "Palettes.Basic.redDark",
                                            "text":                   "Palettes.Fabric.neutralPrimary",
                                            "text_disabled":          "Palettes.Fabric.neutralTertiary",
                                            "text_placeholder":       "Palettes.Neutrals.gray130"},

                          "HighContrast": { "background":             "systemColors.windowText",
                                            "background_disabled":    "systemColors.inactiveBorder",
                                            "border":                 "systemColors.hotlight",
                                            "border_hover":           "systemColors.hotlight",
                                            "border_selected":        "systemColors.hotlight",
                                            "border_disabled":        "systemColors.inactiveBorder",
                                            "border_error":           "systemColors.hotlight",
                                            "text":                   "systemColors.window",
                                            "text_disabled":          "systemColors.window",
                                            "text_placeholder":       "systemColors.window"},

                           "Dark":        { "background":             "Palettes.Neutrals.gray180",
                                            "background_disabled":    "Palettes.Neutrals.gray130",
                                            "border":                 "Palettes.Neutrals.gray130",
                                            "border_hover":           "Palettes.Neutrals.gray80",
                                            "border_selected":        "Palettes.DarkThemeBlue.themeSecondary",
                                            "border_disabled":        "Palettes.Neutrals.gray130",
                                            "border_error":           "Palettes.Basic.redLight",
                                            "text":                   "Palettes.Neutrals.white",
                                            "text_disabled":          "Palettes.Neutrals.gray90",
                                            "text_placeholder":       "Palettes.Neutrals.gray90"}};
        return itemFromThemes(properties);
    }

    // Colors.floodgate_survey
    property QtObject floodgate_survey:
    {
        var properties = {"Standard":      {"input_placeholder":         "Palettes.Fabric.neutralPrimary",
                                            "input_border":              "Palettes.Neutrals.gray130",
                                            "input_border_focused":      "Palettes.Fabric.themeTertiary",
                                            "title_text":                "Palettes.Fabric.themePrimary"},

                          "HighContrast":   {"input_placeholder":        "systemColors.windowText",
                                             "input_border":             "systemColors.hotlight",
                                             "input_border_focused":     "systemColors.hotlight",
                                             "title_text":               "systemColors.windowText"},

                          "Dark":          {"input_placeholder":         "Palettes.Neutrals.white",
                                            "input_border":              "Palettes.Neutrals.gray70",
                                            "input_border_focused":      "Palettes.Neutrals.gray40",
                                            "title_text":                "Palettes.DarkThemeBlue.themePrimary"}};
        return itemFromThemes(properties);
    }

    // Colors.treeview_container
    property QtObject treeview_container:
    {
        var properties = {  "Standard":   { "border":                 "Palettes.Neutrals.gray80",
                                            "border_focus":           "Palettes.Neutrals.gray160"},

                          "HighContrast": { "border":                 "systemColors.hotlight",
                                            "border_focus":           "systemColors.hotlight"},

                           "Dark":        { "border":                 "Palettes.DarkThemeBlue.themeSecondary",
                                            "border_focus":           "Palettes.Neutrals.gray140"}};

        return itemFromThemes(properties);
    }

    // Colors.treeview_checkbox
    property QtObject treeview_checkbox:
    {
        var properties = {  "Standard":   { "border_unchecked":              "Palettes.Neutrals.gray160",
                                            "border_unchecked_hovered":      "Palettes.Neutrals.black",
                                            "border_partial":                "Palettes.Comm.Primary",
                                            "fill_color_unchecked":          "Palettes.Neutrals.white",
                                            "fill_color_unchecked_pressed":  "Palettes.Neutrals.gray30",
                                            "fill_color_checked":            "Palettes.Comm.Primary",
                                            "fill_color_checked_pressed":    "Palettes.Comm.Shade10",
                                            "checked_partial_hovered":       "Palettes.Comm.Shade20",
                                            "checkmark":                     "Palettes.Neutrals.white",
                                            "partial":                       "Palettes.Comm.Primary",
                                            "text_hover":                    "Palettes.Fabric.themeLighter",
                                            "focused_border":                "Palettes.Fabric.neutralPrimaryAlt"},

                          "HighContrast": { "border_unchecked":              "systemColors.windowText",
                                            "border_unchecked_hovered":      "systemColors.windowText",
                                            "border_partial":                "systemColors.windowText",
                                            "fill_color_unchecked":          "systemColors.window",
                                            "fill_color_unchecked_pressed":  "systemColors.window",
                                            "fill_color_checked":            "systemColors.windowText",
                                            "fill_color_checked_pressed":    "systemColors.windowText",
                                            "checked_partial_hovered":       "systemColors.highlight",
                                            "checkmark" :                    "systemColors.window",
                                            "partial":                       "systemColors.windowText",
                                            "text_hover":                    "systemColors.highlight",
                                            "focused_border":                "systemColors.hotlight"},

                          "Dark":         { "border_unchecked":              "Palettes.Neutrals.gray20",
                                            "border_unchecked_hovered":      "Palettes.Neutrals.white",
                                            "border_partial":                "Palettes.DarkThemeBlue.themePrimary",
                                            "fill_color_unchecked":          "Palettes.Neutrals.gray160",
                                            "fill_color_unchecked_pressed":  "Palettes.Neutrals.gray150",
                                            "fill_color_checked":            "Palettes.DarkThemeBlue.themePrimary",
                                            "fill_color_checked_pressed":    "Palettes.DarkThemeBlue.themeSecondary",
                                            "checked_partial_hovered":       "Palettes.DarkThemeBlue.themeTertiarty",
                                            "checkmark" :                    "Palettes.Neutrals.white",
                                            "partial":                       "Palettes.DarkThemeBlue.themePrimary",
                                            "text_hover":                    "Palettes.Neutrals.gray130",
                                            "focused_border":                "Palettes.Neutrals.white"}};

        return itemFromThemes(properties);
    }

    // Colors.selective_sync_page
    property QtObject selective_sync_page:
    {
        var properties = {  "Standard":     { "infobar_background":      "Palettes.Neutrals.gray20",
                                              "hover_color":             "Palettes.Comm.Primary",
                                              "loading_pane_background": "Palettes.Neutrals.gray20",
                                              "error_disk_space":        "Palettes.Basic.redDark"},

                            "HighContrast": { "infobar_background" :     "systemColors.window",
                                              "hover_color":             "systemColors.highlight",
                                              "loading_pane_background": "systemColors.hotlight",
                                              "error_disk_space":        "systemColors.windowText"},

                            "Dark":         { "infobar_background" :     "Palettes.Neutrals.gray160",
                                              "hover_color":             "Palettes.Neutrals.gray130",
                                              "loading_pane_background": "Palettes.Neutrals.gray160",
                                              "error_disk_space":        "Palettes.Basic.redLight"}};

        return itemFromThemes(properties);
    }

    // Colors.selective_sync_scrollbar
    property QtObject selective_sync_scrollbar:
    {
        var properties = {  "Standard":   { "handle":                     "Palettes.Neutrals.gray80",
                                            "background":                 "Palettes.Neutrals.gray20",
                                            "chevron_background":         "Palettes.Neutrals.gray20",
                                            "chevron_background_pressed": "Palettes.Neutrals.gray80" },

                          "HighContrast": { "handle":                     "systemColors.window",
                                            "background":                 "systemColors.hotlight",
                                            "chevron_background":         "systemColors.window",
                                            "chevron_background_pressed": "systemColors.window" },

                          "Dark":         { "handle":                     "Palettes.Neutrals.gray130",
                                            "background":                 "Palettes.Neutrals.gray190",
                                            "chevron_background":         "Palettes.Neutrals.gray190",
                                            "chevron_background_pressed": "Palettes.Neutrals.gray130" }};

        return itemFromThemes(properties);
    }

    // Colors.send_feedback
    property QtObject send_feedback:
    {
        var properties = {"Standard":      {"input_placeholder":         "Palettes.Fabric.neutralPrimary",
                                            "input_border":              "Palettes.Neutrals.gray130",
                                            "input_border_focused":      "Palettes.Fabric.themeTertiary",
                                            "title_text":                "Palettes.Fabric.neutralPrimary",
                                            "text_secondary":            "Palettes.Neutrals.gray190" },

                          "HighContrast":  {"input_placeholder":         "systemColors.windowText",
                                            "input_border":              "systemColors.hotlight",
                                            "input_border_focused":      "systemColors.highlightText",
                                            "title_text":                "systemColors.windowText",
                                            "text_secondary":            "systemColors.windowText" },

                          "Dark":          {"input_placeholder":         "Palettes.Neutrals.white",
                                            "input_border":              "Palettes.Neutrals.gray70",
                                            "input_border_focused":      "Palettes.Neutrals.gray40",
                                            "title_text":                "Palettes.DarkThemeBlue.themePrimary",
                                            "text_secondary":            "Palettes.Neutrals.gray80" }};
        return itemFromThemes(properties);
    }

    property QtObject user_input_field:
    {
        var properties = {"Standard":      {"input_placeholder":         "Palettes.Fabric.neutralPrimary",
                                            "input_border":              "Palettes.Neutrals.gray130",
                                            "input_border_focused":      "Palettes.Fabric.themeTertiary"},

                          "HighContrast":  {"input_placeholder":         "systemColors.windowText",
                                            "input_border":              "systemColors.hotlight",
                                            "input_border_focused":      "systemColors.highlightText"},

                          "Dark":          {"input_placeholder":         "Palettes.Neutrals.white",
                                            "input_border":              "Palettes.Neutrals.gray70",
                                            "input_border_focused":      "Palettes.Neutrals.gray40"}};
        return itemFromThemes(properties);
    }

    property QtObject combo_box:
    {
        var properties = {"Standard":      {"input_placeholder":         "Palettes.Fabric.neutralPrimary",
                                            "item_hover":                "Palettes.Fabric.neutralLighter",
                                            "item_pressed":              "Palettes.Fabric.neutralLight",
                                            "item_focus":                "Palettes.Fabric.neutralLighterAlt",
                                            "input_border":              "Palettes.Neutrals.gray130",
                                            "input_border_focused":      "Palettes.Fabric.themeTertiary"},

                          "HighContrast":  {"input_placeholder":         "systemColors.windowText",
                                            "item_hover":                "systemColors.highlight",
                                            "item_pressed":              "systemColors.highlight",
                                            "item_focus":                "systemColors.highlight",
                                            "input_border":              "systemColors.hotlight",
                                            "input_border_focused":      "systemColors.highlightText"},

                          "Dark":          {"input_placeholder":         "Palettes.Neutrals.white",
                                            "item_hover":                "Palettes.Neutrals.gray160",
                                            "item_pressed":              "Palettes.Neutrals.gray150",
                                            "item_focus":                "Palettes.Neutrals.gray160",
                                            "input_border":              "Palettes.Neutrals.gray70",
                                            "input_border_focused":      "Palettes.Neutrals.gray40"}};
        return itemFromThemes(properties);
    }

    // Colors.in_app_purchase
    property QtObject in_app_purchase:
    {
        var properties = {"Standard":      {"title":                     "Palettes.Shared.cyanBlue10",
                                            "error_title":               "Palettes.Shared.redOrange10",
                                            "main_background":           "Palettes.Neutrals.gray31",
                                            "purchase_button":           "Palettes.Basic.green",
                                            "purchase_button_hover":     "Palettes.Shared.green20",
                                            "white_button_text":         "Palettes.Neutrals.white",
                                            "close_button":              "Palettes.Fabric.themePrimary",
                                            "close_button_hover":        "Palettes.Fabric.themeSecondary",
                                            "tou_title":                 "Palettes.Fabric.neutralSecondary",
                                            "card_background":           "Palettes.Neutrals.gray10",
                                            "card_border":               "Palettes.Neutrals.gray31"},

                          "HighContrast":   {"title":                    "systemColors.windowText",
                                            "error_title":               "systemColors.windowText",
                                            "main_background":           "systemColors.window",
                                            "purchase_button":           "systemColors.windowText",
                                            "purchase_button_hover":     "systemColors.hotlight",
                                            "white_button_text":         "systemColors.windowText",
                                            "close_button":              "systemColors.windowText",
                                            "close_button_hover":        "systemColors.hotlight",
                                            "tou_title":                 "systemColors.windowText",
                                            "card_background":           "systemColors.window",
                                            "card_border":               "systemColors.windowText"},

                          "Dark":          {"title":                     "Palettes.DarkThemeBlue.dtblue65",
                                            "error_title":               "Palettes.Shared.redOrange10",
                                            "main_background":           "Palettes.Neutrals.gray160",
                                            "purchase_button":           "Palettes.Basic.green",
                                            "purchase_button_hover":     "Palettes.Shared.green20",
                                            "white_button_text":         "Palettes.Neutrals.white",
                                            "close_button":              "Palettes.DarkThemeBlue.themeSecondary",
                                            "close_button_hover":        "Palettes.DarkThemeBlue.themeDark",
                                            "tou_title":                 "Palettes.Neutrals.white",
                                            "card_background":           "Palettes.Neutrals.gray160",
                                            "card_border":               "Palettes.Neutrals.gray190"}};
        return itemFromThemes(properties);
    }

    // Colors.reset_window
    property QtObject reset_window:
    {
        var properties = {"Standard":      {"title_text":                "Palettes.Fabric.themePrimary",
                                            "focused_border":            "Palettes.Fabric.neutralPrimaryAlt",
                                            "button_border":             "Palettes.Basic.redDark"},
                          "HighContrast":  {"title_text":                "systemColors.windowText",
                                            "focused_border":            "systemColors.hotlight",
                                            "button_border":             "systemColors.btnText"},
                          "Dark":          {"title_text":                "Palettes.DarkThemeBlue.themePrimary",
                                            "focused_border":            "Palettes.Neutrals.gray160",
                                            "button_border":             "Palettes.Basic.redDark"}};
        return itemFromThemes(properties);
    }

    // Colors.move_window
    property QtObject move_window:
    {
        var properties = {"Standard":    {"title":                          "Palettes.Fabric.themePrimary",
                                          "folderItemBackgroundSelected":   "Palettes.Fabric.neutralLight",
                                          "folderItemBackgroundDone":       "Palettes.Fabric.neutralLighter",
                                          "folderItemBackgroundDoneText":   "Palettes.Fabric.neutralSecondary",
                                          "cancelledSecondaryText":         "Palettes.Basic.redDark",
                                          "folderItemPrimaryText":          "Palettes.Fabric.neutralPrimary",
                                          "folderItemSecondaryText":        "Palettes.Fabric.neutralSecondary",
                                          "folderItemLinkText":             "Palettes.Fabric.themePrimary",
                                          "folderItemBorderColor":          "Palettes.Fabric.neutralTertiaryAlt",
                                          "scrollViewBorderColor":          "Palettes.Fabric.neutralSecondary"},

                         "HighContrast": {"title":                          "systemColors.windowText",
                                          "folderItemBackgroundSelected":   "systemColors.highlight",
                                          "folderItemBackgroundDone":       "systemColors.highlight",
                                          "folderItemBackgroundDoneText":   "systemColors.highlight",
                                          "cancelledSecondaryText":         "systemColors.highlight",
                                          "folderItemPrimaryText":          "systemColors.windowText",
                                          "folderItemSecondaryText":        "systemColors.highlightText",
                                          "folderItemLinkText":             "systemColors.hotlight",
                                          "folderItemBorderColor":          "systemColors.hotlight",
                                          "scrollViewBorderColor":          "systemColors.hotlight"},

                           "Dark":       {"title":                          "Palettes.DarkThemeBlue.themeSecondary",
                                          "folderItemBackgroundSelected":   "Palettes.Neutrals.gray150",
                                          "folderItemBackgroundDone":       "Palettes.Neutrals.gray150",
                                          "folderItemBackgroundDoneText":   "Palettes.Neutrals.gray80",
                                          "cancelledSecondaryText":         "Palettes.Basic.redLight",
                                          "folderItemPrimaryText":          "Palettes.Neutrals.white",
                                          "folderItemSecondaryText":        "Palettes.Neutrals.gray80",
                                          "folderItemLinkText":             "Palettes.DarkThemeBlue.themeSecondary",
                                          "folderItemBorderColor":          "Palettes.Neutrals.gray70",
                                          "scrollViewBorderColor":          "Palettes.Neutrals.gray80"}};
        return itemFromThemes(properties);
    }

    // Colors.confirm_dialog
    property QtObject confirm_dialog:
    {
        var properties = {"Standard":    {"confirmButtonHover":             "Palettes.Fabric.neutralLighter",
                                          "confirmButtonPressed":           "Palettes.Fabric.neutralLight"},

                         "HighContrast": {"confirmButtonHover":             "systemColors.highlight",
                                          "confirmButtonPressed":           "systemColors.highlight"},

                           "Dark":       {"confirmButtonHover":             "Palettes.Neutrals.gray150",
                                          "confirmButtonPressed":           "Palettes.Neutrals.gray140"}};
        return itemFromThemes(properties);
    }

    property QtObject activity_center:
        QtObject
        {
            // Colors.activity_center.common
            property QtObject common:
            {
                var properties = {"Standard":       {"mac_border":                   "Palettes.OneOff.mac_border",
                                                     "focused_border":               "Palettes.Fabric.neutralPrimaryAlt",
                                                     "text":                         "Palettes.Neutrals.gray160",
                                                     "text_hover":                   "Palettes.Neutrals.gray190",
                                                     "text_secondary":               "Palettes.Neutrals.gray130",
                                                     "text_secondary_hover":         "Palettes.Neutrals.gray160"},

                                  "HighContrast":   {"mac_border":                   "systemColors.activeCaption",
                                                     "focused_border":               "systemColors.hotlight",
                                                     "text":                         "systemColors.windowText",
                                                     "text_hover":                   "systemColors.highlightText",
                                                     "text_secondary":               "systemColors.windowText",
                                                     "text_secondary_hover":         "systemColors.highlightText"},

                                  "Dark":           {"mac_border":                   "Palettes.Neutrals.gray100",
                                                     "focused_border":               "Palettes.Neutrals.gray160",
                                                     "text":                         "Palettes.Neutrals.gray20",
                                                     "text_hover":                   "Palettes.Neutrals.gray10",
                                                     "text_secondary":               "Palettes.Neutrals.gray90",
                                                     "text_secondary_hover":         "Palettes.Neutrals.gray20"}};
                return itemFromThemes(properties);
            }

            // Colors.activity_center.header
            property QtObject header:
            {
                var properties = {"Standard":       {"normal":    "Palettes.Comm.Primary",
                                                     "paused":    "Palettes.Neutrals.gray160",
                                                     "error":     "Palettes.Basic.orangeLight",
                                                     "caption":   "Palettes.Basic.white"},

                                  "HighContrast":   {"normal":    "systemColors.activeCaption",
                                                     "paused":    "systemColors.activeCaption",
                                                     "error":     "systemColors.activeCaption",
                                                     "caption":   "systemColors.captionText"},

                                  "Dark":           {"normal":    "Palettes.DarkThemeBlue.newThemeSecondary",
                                                     "paused":    "Palettes.Neutrals.gray180",
                                                     "error":     "Palettes.Basic.orangeLight",
                                                     "caption":   "Palettes.Basic.white"}};
                return itemFromThemes(properties);
            }

            // Colors.activity_center.footer
            property QtObject footer:
            {
                var properties = {"Standard":       {"background":             "Palettes.Neutrals.gray20",
                                                     "button":                 "Palettes.Neutrals.gray20",
                                                     "button_hovered":         "Palettes.Neutrals.gray40",
                                                     "button_pressed":         "Palettes.Neutrals.gray50",
                                                     "button_focused_border":  "Palettes.Basic.black",
                                                     "rule":                   "Palettes.Neutrals.gray50"},

                                  "HighContrast":   {"background":             "systemColors.window",
                                                     "button":                 "systemColors.window",
                                                     "button_hovered":         "systemColors.highlight",
                                                     "button_pressed":         "systemColors.highlight",
                                                     "button_focused_border":  "systemColors.btnText",
                                                     "rule":                   "systemColors.btnText"},

                                  "Dark":           {"background":             "Palettes.Neutrals.gray180",
                                                     "button":                 "Palettes.Neutrals.gray180",
                                                     "button_hovered":         "Palettes.Neutrals.gray160",
                                                     "button_pressed":         "Palettes.Neutrals.gray150",
                                                     "button_focused_border":  "Palettes.Basic.white",
                                                     "rule":                   "Palettes.Neutrals.gray150"}};
                return itemFromThemes(properties);
            }

            // Colors.activity_center.list
            property QtObject list:
            {
                var properties = {"Standard":       {"background":                   "Palettes.Basic.white",
                                                     "background_secondary":         "Palettes.Fabric.neutralLighterAlt",
                                                     "background_hovering":          "Palettes.Neutrals.gray20",
                                                     "background_press":             "Palettes.Neutrals.gray30",
                                                     "background_focus":             "Palettes.Fabric.themeLight",
                                                     "border_focus":                 "Palettes.Basic.black",
                                                     "progress_background":          "Palettes.Neutrals.gray30",
                                                     "progress":                     "Palettes.Comm.Primary"},


                                  "HighContrast":   {"background":                   "systemColors.window",
                                                     "background_secondary":         "systemColors.window",
                                                     "background_hovering":          "systemColors.highlight",
                                                     "background_press":             "systemColors.window",
                                                     "background_focus":             "systemColors.highlight",
                                                     "border_focus":                 "systemColors.highlightText",
                                                     "progress_background":          "systemColors.activeBorder",
                                                     "progress":                     "systemColors.inactiveBorder"},

                                  "Dark":           {"background":                   "Palettes.Neutrals.gray200",
                                                     "background_secondary":         "Palettes.Neutrals.gray150",
                                                     "background_hovering":          "Palettes.Neutrals.gray180",
                                                     "background_press":             "Palettes.Neutrals.gray170",
                                                     "background_focus":             "Palettes.Neutrals.gray150",
                                                     "border_focus":                 "Palettes.Neutrals.white",
                                                     "progress_background":          "Palettes.Neutrals.gray160",
                                                     "progress":                     "Palettes.DarkThemeBlue.themeDarkAlt"}};
                return itemFromThemes(properties);
            }

            // Colors.activity_center.error
            property QtObject error:
            {
                var properties = {"Standard":       {"background":                   "Palettes.OneOff.errorBackground",
                                                     "background_alert":             "Palettes.OneOff.alertBackground",
                                                     "background_hovering":          "'#f2cdd0'",
                                                     "background_warning":           "Palettes.OneOff.warningBackground",
                                                     "background_warning_hovering":  "Palettes.OneOff.warningBackgroundActiveFocus",
                                                     "list_background_hovering":     "Palettes.Fabric.themeLighter",
                                                     "border_alert_focus":           "Palettes.OneOff.neutralPrimaryAlt",
                                                     "mass_delete_checkbox":         "Palettes.Fabric.neutralSecondary",
                                                     "mass_delete_checkbox_focused": "Palettes.Fabric.themeTertiary",
                                                     "error_rect_text":              "Palettes.Neutrals.black",
                                                     "error_rect_text_hovering":     "Palettes.Neutrals.black"},

                                  "HighContrast":   {"background":                   "systemColors.window",
                                                     "background_alert":             "systemColors.window",
                                                     "background_hovering":          "systemColors.highlight",
                                                     "background_warning":           "systemColors.window",
                                                     "background_warning_hovering":  "systemColors.highlight",
                                                     "list_background_hovering":     "systemColors.highlight",
                                                     "border_alert_focus":           "systemColors.highlightText",
                                                     "mass_delete_checkbox":         "systemColors.hotlight",
                                                     "mass_delete_checkbox_focused": "systemColors.highlightText",
                                                     "error_rect_text":              "systemColors.windowText",
                                                     "error_rect_text_hovering":     "Palettes.Neutrals.black"},

                                  "Dark":           {"background":                   "Palettes.OneOff.errorBackground",
                                                     "background_alert":             "Palettes.OneOff.alertBackground",
                                                     "background_hovering":          "'#f2cdd0'",
                                                     "background_warning":           "Palettes.OneOff.warningBackground",
                                                     "background_warning_hovering":  "Palettes.OneOff.warningBackgroundActiveFocus",
                                                     "list_background_hovering":     "Palettes.Neutrals.gray160",
                                                     "border_alert_focus":           "Palettes.Neutrals.gray70",
                                                     "mass_delete_checkbox":         "Palettes.Fabric.neutralSecondary",
                                                     "mass_delete_checkbox_focused": "Palettes.Fabric.themeTertiary",
                                                     "error_rect_text":              "Palettes.Neutrals.black",
                                                     "error_rect_text_hovering":     "Palettes.Neutrals.black"}};

                return itemFromThemes(properties);
            }

            // Colors.activity_center.error_button
            property QtObject error_button:
            {
                var properties = {"Standard":       {"hovering":              "'transparent'",
                                                     "border":                "Palettes.Basic.redDark",
                                                     "border_hovering":       "Palettes.Basic.redDarker",
                                                     "pressed":               "Palettes.Basic.redDark",
                                                     "border_pressed":        "Palettes.Basic.white",
                                                     "text":                  "Palettes.Basic.redDark",
                                                     "text_hovering":         "Palettes.Basic.redDarker",
                                                     "text_pressed":          "Palettes.Basic.white"},

                                  "HighContrast":   {"hovering":              "systemColors.highlight",
                                                     "border":                "systemColors.btnText",
                                                     "border_hovering":       "systemColors.highlightText",
                                                     "pressed":               "systemColors.btnText",
                                                     "border_pressed":        "'transparent'",
                                                     "text":                  "systemColors.btnText",
                                                     "text_hovering":         "systemColors.highlightText",
                                                     "text_pressed":          "systemColors.highlightText"},

                                  "Dark":           {"hovering":              "'transparent'",
                                                     "border":                "Palettes.Basic.redDark",
                                                     "border_hovering":       "Palettes.Basic.redDarker",
                                                     "pressed":               "Palettes.Basic.redDark",
                                                     "border_pressed":        "Palettes.Basic.white",
                                                     "text":                  "Palettes.Basic.redDark",
                                                     "text_hovering":         "Palettes.Basic.redDarker",
                                                     "text_pressed":          "Palettes.Basic.white"}};
                return itemFromThemes(properties);
            }

            // Colors.activity_center.message_dismiss
            property QtObject message_dismiss:
            {
                var properties = {"Standard":       {"primary":       "'transparent'",
                                                     "pressed":       "Palettes.OneOff.acm_dismiss_pressed",
                                                     "hovered":       "Palettes.OneOff.acm_dismiss_hover",
                                                     "focus_border":  "Palettes.Fabric.themeTertiary"},

                                  "HighContrast":   {"primary":       "systemColors.window",
                                                     "pressed":       "systemColors.btnText",
                                                     "hovered":       "systemColors.highlight",
                                                     "focus_border":  "systemColors.hotlight"},

                                  "Dark":           {"primary":       "'transparent'",
                                                     "pressed":       "Palettes.OneOff.acm_dismiss_pressed",
                                                     "hovered":       "Palettes.OneOff.acm_dismiss_hover",
                                                     "focus_border":  "Palettes.Fabric.themeTertiary"}};

                return itemFromThemes(properties);
            }

            // Colors.activity_center.context_menu
            property QtObject context_menu:
            {
                var properties = {"Standard":       {"background":       "Palettes.Basic.white",
                                                     "button_hover":     "Palettes.Neutrals.gray40",
                                                     "button_pressed":   "Palettes.Neutrals.gray50",
                                                     "item_hover":       "Palettes.Fabric.neutralLighter",
                                                     "item_focus":       "Palettes.Fabric.neutralLighterAlt",
                                                     "item_pressed":     "Palettes.Fabric.neutralLight",
                                                     "menu_border":      "Palettes.Neutrals.gray70",
                                                     "item_border":      "Palettes.Fabric.neutralSecondary"},

                                  "HighContrast":   {"background":       "systemColors.menu",
                                                     "button_hover":     "systemColors.highlightText",
                                                     "button_pressed":   "systemColors.highlightText",
                                                     "item_hover":       "systemColors.highlight",
                                                     "item_focus":       "systemColors.highlight",
                                                     "item_pressed":     "systemColors.highlight",
                                                     "menu_border":      "systemColors.hotlight",
                                                     "item_border":      "systemColors.hotlight"},

                                  "Dark":           {"background":       "Palettes.Neutrals.gray180",
                                                     "button_hover":     "Palettes.Neutrals.gray160",
                                                     "button_pressed":   "Palettes.Neutrals.gray150",
                                                     "item_hover":       "Palettes.Neutrals.gray160",
                                                     "item_focus":       "Palettes.Neutrals.gray160",
                                                     "item_pressed":     "Palettes.Neutrals.gray150",
                                                     "menu_border":      "Palettes.Neutrals.gray70",
                                                     "item_border":      "Palettes.Neutrals.gray70"}};
                return itemFromThemes(properties);
            }
        }

    property QtObject acm:
        QtObject
        {
            readonly property var highcontrast_message: new Object({"background":                   "systemColors.window",
                                                                    "primary_text":                 "systemColors.windowText",
                                                                    "secondary_text":               "systemColors.windowText"})

            // Colors.acm.primary
            property QtObject primary:
            {
                var properties = {"Standard":       {"background":                   "Palettes.Fabric.themeLighter",
                                                     "primary_text":                 "Palettes.Fabric.neutralPrimary",
                                                     "secondary_text":               "Palettes.Fabric.neutralPrimary"},

                                  "HighContrast":   highcontrast_message,

                                  "Dark":           {"background":                   "Palettes.OneOff.acm_dark_background",
                                                     "primary_text":                 "Palettes.Neutrals.gray20",
                                                     "secondary_text":               "Palettes.Neutrals.gray20"}};
                return itemFromThemes(properties);
            }

            // Colors.acm.error
            property QtObject error:
            {
                var properties = {"Standard":       {"background":                   "Palettes.OneOff.errorBackground",
                                                     "primary_text":                 "Palettes.Basic.black",
                                                     "secondary_text":               "Palettes.Basic.black"},

                                  "HighContrast":   highcontrast_message,

                                  "Dark":           {"background":                   "Palettes.Basic.redDarker",
                                                     "primary_text":                 "Palettes.Neutrals.gray20",
                                                     "secondary_text":               "Palettes.Neutrals.gray20"}};
                return itemFromThemes(properties);
            }

            // Colors.acm.transparent
            property QtObject transparent:
            {
                var properties = {"Standard":       {"background":                   "'transparent'",
                                                     "primary_text":                 "Palettes.Fabric.neutralPrimary",
                                                     "secondary_text":               "Palettes.Fabric.neutralPrimary"},

                                  "HighContrast":   highcontrast_message,

                                  "Dark":           {"background":                   "'transparent'",
                                                     "primary_text":                 "Palettes.Neutrals.gray20",
                                                     "secondary_text":               "Palettes.Neutrals.gray20"}};
                return itemFromThemes(properties);
            }

            // Colors.acm.warning
            property QtObject warning:
            {
                var properties = {"Standard":       {"background":                   "Palettes.OneOff.warningBackground",
                                                     "primary_text":                 "Palettes.Fabric.neutralPrimary",
                                                     "secondary_text":               "Palettes.Fabric.neutralPrimary"},

                                  "HighContrast":   highcontrast_message,

                                  "Dark":           {"background":                   "Palettes.OneOff.warningBackgroundDark",
                                                     "primary_text":                 "Palettes.Neutrals.gray20",
                                                     "secondary_text":               "Palettes.Neutrals.gray20"}};
                return itemFromThemes(properties);
            }
        }

    property QtObject acm_buttons:
        QtObject
        {

            readonly property variant highcontrast_button: new Object({"button":                       "'transparent'",
                                                                       "button_hovering":              "systemColors.highlight",
                                                                       "button_pressed":               "systemColors.btnText",
                                                                       "button_text":                  "systemColors.btnText",
                                                                       "button_text_hovering":         "systemColors.highlightText",
                                                                       "button_text_pressed":          "systemColors.highlightText"})

            // Colors.acm_buttons.primary
            property QtObject primary:
            {
                var properties = {"Standard":       {"button":                       "Palettes.Fabric.themePrimary",
                                                     "button_hovering":              "Palettes.Fabric.themeDark",
                                                     "button_pressed":               "Palettes.Fabric.themePrimary",
                                                     "button_text":                  "Palettes.Neutrals.gray20",
                                                     "button_text_hovering":         "Palettes.Neutrals.gray20",
                                                     "button_text_pressed":          "Palettes.Neutrals.gray20"},

                                  "HighContrast":   highcontrast_button,

                                  "Dark":           {"button":                       "Palettes.DarkThemeBlue.themePrimary",
                                                     "button_hovering":              "Palettes.DarkThemeBlue.themeDark",
                                                     "button_pressed":               "Palettes.DarkThemeBlue.themePrimary",
                                                     "button_text":                  "Palettes.Neutrals.gray170",
                                                     "button_text_hovering":         "Palettes.Neutrals.gray170",
                                                     "button_text_pressed":          "Palettes.Neutrals.gray170"}};
                return itemFromThemes(properties);
            }

            // Colors.acm_buttons.primary_transparent
            property QtObject primary_transparent:
            {
                var properties = {"Standard":       {"button":                       "'transparent'",
                                                     "button_hovering":              "'transparent'",
                                                     "button_pressed":               "'transparent'",
                                                     "button_text":                  "Palettes.Comm.Shade20",
                                                     "button_text_hovering":         "Palettes.Comm.Tint10",
                                                     "button_text_pressed":          "Palettes.Comm.Shade20"},

                                  "HighContrast":   highcontrast_button,

                                  "Dark":           {"button":                       "'transparent'",
                                                     "button_hovering":              "'transparent'",
                                                     "button_pressed":               "'transparent'",
                                                     "button_text":                  "Palettes.DarkThemeBlue.themePrimary",
                                                     "button_text_hovering":         "Palettes.DarkThemeBlue.themeDark",
                                                     "button_text_pressed":          "Palettes.DarkThemeBlue.themePrimary"}};
                return itemFromThemes(properties);
            }

            // Colors.acm_buttons.error
            property QtObject error:
            {
                var properties = {"Standard":       {"button":                       "Palettes.Basic.orange",
                                                     "button_hovering":              "Palettes.Basic.redDark",
                                                     "button_pressed":               "Palettes.Basic.orange",
                                                     "button_text":                  "Palettes.Neutrals.white",
                                                     "button_text_hovering":         "Palettes.Neutrals.white",
                                                     "button_text_pressed":          "Palettes.Neutrals.white"},

                                  "HighContrast":   highcontrast_button,

                                  "Dark":           {"button":                       "Palettes.Basic.orange",
                                                     "button_hovering":              "Palettes.Shared.red10",
                                                     "button_pressed":               "Palettes.Basic.orange",
                                                     "button_text":                  "Palettes.Neutrals.white",
                                                     "button_text_hovering":         "Palettes.Neutrals.white",
                                                     "button_text_pressed":          "Palettes.Neutrals.white"}};
                return itemFromThemes(properties);
            }

            // Colors.acm_buttons.error_transparent
            property QtObject error_transparent:
            {
                var properties = {"Standard":       {"button":                       "'transparent'",
                                                     "button_hovering":              "'transparent'",
                                                     "button_pressed":               "'transparent'",
                                                     "button_text":                  "Palettes.Basic.redDark",
                                                     "button_text_hovering":         "Palettes.Basic.black",
                                                     "button_text_pressed":          "Palettes.Basic.redDark"},

                                  "HighContrast":   highcontrast_button,

                                  "Dark":           {"button":                       "'transparent'",
                                                     "button_hovering":              "'transparent'",
                                                     "button_pressed":               "'transparent'",
                                                     "button_text":                  "Palettes.Neutrals.gray20",
                                                     "button_text_hovering":         "Palettes.OneOff.errorBackgroundActiveFocus",
                                                     "button_text_pressed":          "Palettes.Neutrals.gray20"}};
                return itemFromThemes(properties);
            }

            // Colors.acm_buttons.premium_upsell
            property QtObject premium_upsell:
            {
                var properties = {"Standard":       {"button":                       "Palettes.Basic.green",
                                                     "button_hovering":              "Palettes.Shared.green20",
                                                     "button_pressed":               "Palettes.Basic.greenDark",
                                                     "button_text":                  "Palettes.Neutrals.gray20",
                                                     "button_text_hovering":         "Palettes.Neutrals.gray20",
                                                     "button_text_pressed":          "Palettes.Neutrals.gray20"},

                                  "HighContrast":   highcontrast_button,

                                  "Dark":           {"button":                       "Palettes.Basic.green",
                                                     "button_hovering":              "Palettes.Shared.green20",
                                                     "button_pressed":               "Palettes.Basic.greenDark",
                                                     "button_text":                  "Palettes.Neutrals.gray20",
                                                     "button_text_hovering":         "Palettes.Neutrals.gray20",
                                                     "button_text_pressed":          "Palettes.Neutrals.gray20"}};
                return itemFromThemes(properties);
            }
        }

    property QtObject version_window:
        QtObject
        {
            // Colors.version_window.list
            property QtObject list:
            {
                var properties = {"Standard":       {"background_secondary":         "Palettes.Fabric.neutralLighterAlt",
                                                     "background_hovering":          "Palettes.Neutrals.gray20",
                                                     "background_press":             "Palettes.Neutrals.gray30",
                                                     "button_hover":                 "Palettes.Neutrals.gray40",
                                                     "button_pressed":               "Palettes.Neutrals.gray50"},


                                  "HighContrast":   {"background_secondary":         "systemColors.window",
                                                     "background_hovering":          "systemColors.highlight",
                                                     "background_press":             "systemColors.highlight",
                                                     "button_hover":                 "systemColors.highlightText",
                                                     "button_pressed":               "systemColors.highlightText"},

                                  "Dark":           {"background_secondary":         "Palettes.Neutrals.gray170",
                                                     "background_hovering":          "Palettes.Neutrals.gray160",
                                                     "background_press":             "Palettes.Neutrals.gray150",
                                                     "button_hover":                 "Palettes.Neutrals.gray140",
                                                     "button_pressed":               "Palettes.Neutrals.gray130"}};
                return itemFromThemes(properties);
            }

            // Colors.version_window.listHeader
            property QtObject listHeader:
            {
                var properties = {"Standard":       {"background":             "Palettes.Neutrals.gray20",
                                                     "border":                 "Palettes.Neutrals.gray50"},

                                  "HighContrast":   {"background":             "systemColors.window",
                                                     "border":                 "systemColors.window"},

                                  "Dark":           {"background":             "Palettes.Neutrals.gray150",
                                                     "border":                 "Palettes.Neutrals.gray160"}};
                return itemFromThemes(properties);
            }

            // Colors.version_window.error
            property QtObject error:
            {
                var properties = {"Standard":       {"background":                   "Palettes.OneOff.errorBackground",
                                                     "error_header_text":            "Palettes.Fabric.neutralPrimary"},

                                  "HighContrast":   {"background":                   "systemColors.window",
                                                     "error_header_text":            "systemColors.windowText"},

                                  "Dark":           {"background":                   "'#593433'",
                                                     "error_header_text":            "Palettes.Neutrals.gray10"}};
                return itemFromThemes(properties);
            }

            // Colors.version_window.message_dismiss
            property QtObject message_dismiss:
            {
                var properties = {"Standard":       {"primary":       "'transparent'",
                                                     "pressed":       "Palettes.OneOff.acm_dismiss_pressed",
                                                     "hovered":       "Palettes.OneOff.acm_dismiss_hover",
                                                     "focus_border":  "Palettes.Fabric.themeTertiary"},

                                  "HighContrast":   {"primary":       "systemColors.window",
                                                     "pressed":       "systemColors.btnText",
                                                     "hovered":       "systemColors.highlight",
                                                     "focus_border":  "systemColors.hotlight"},

                                  "Dark":           {"primary":       "'transparent'",
                                                     "pressed":       "Palettes.OneOff.acm_dismiss_pressed",
                                                     "hovered":       "Palettes.OneOff.acm_dismiss_hover",
                                                     "focus_border":  "Palettes.Fabric.themeTertiary"}};
                return itemFromThemes(properties);
            }
        }
	
	property QtObject errors_list:
        QtObject
        {
            readonly property var highcontrast_message: new Object({"background":              "systemColors.window",
                                                                    "background_hover":        "systemColors.highlight",
                                                                    "text":                    "systemColors.windowText",
                                                                    "text_hover":              "systemColors.highlightText"})

            // Colors.errors_list.error
            property QtObject error:
            {
                var properties = {"Standard":       {"background":                  "Palettes.OneOff.errorBackground",
                                                     "background_hover":            "Palettes.OneOff.errorBackgroundActiveFocus",
                                                     "text":                        "Palettes.Basic.black",
                                                     "text_hover":                  "Palettes.Basic.black"},

                                  "HighContrast":   highcontrast_message,

                                  "Dark":           {"background":                  "Palettes.Basic.redDarker",
                                                     "background_hover":            "Palettes.Basic.redDark",
                                                     "text":                        "Palettes.Neutrals.gray20",
                                                     "text_hover":                  "Palettes.Neutrals.gray20"}};
                return itemFromThemes(properties);
            }

            // Colors.errors_list.warning
            property QtObject warning:
            {
                var properties = {"Standard":       {"background":                  "Palettes.OneOff.warningBackground",
                                                     "background_hover":            "Palettes.OneOff.warningBackgroundActiveFocus",
                                                     "text":                        "Palettes.Fabric.neutralPrimary",
                                                     "text_hover":                  "Palettes.Fabric.neutralPrimary"},

                                  "HighContrast":   highcontrast_message,

                                  "Dark":           {"background":                  "Palettes.OneOff.warningBackgroundDark",
                                                     "background_hover":            "Palettes.OneOff.warningBackgroundDarkActiveFocus",
                                                     "text":                        "Palettes.Neutrals.gray20",
                                                     "text_hover":                  "Palettes.Neutrals.gray20"}};
                return itemFromThemes(properties);
            }
        }

    // Colors.tool_tip
    property QtObject tool_tip:
    {
        var properties = {"Standard":    {"background":                    "Palettes.Neutrals.gray10",
                                          "background_mac":                "Palettes.Neutrals.gray10",
                                          "border":                        "Palettes.Neutrals.gray60",
                                          "text":                          "Palettes.Basic.black"},

                         "HighContrast": {"background":                    "systemColors.window",
                                          "background_mac":                "systemColors.window",
                                          "border":                        "systemColors.inactiveBorder",
                                          "text":                          "systemColors.windowText"},

                           "Dark":       {"background":                    "Palettes.Neutrals.gray180",
                                          "background_mac":                "Palettes.Neutrals.gray170",
                                          "border":                        "Palettes.Neutrals.gray160",
                                          "text":                          "Palettes.Basic.white"}};
        return itemFromThemes(properties);
    }

    // Creates a qml item with property colors from a passed in js dictionary.
    function itemFromThemes(ThemeList)
    {
        var qmlToParse = qtQuickImport + fabricColorsImport + itemStart;
        for (var name in ThemeList[currentTheme])
        {
            qmlToParse += "property color " + name + ": " + ThemeList[currentTheme][name] + ";";
        }
        qmlToParse += "}"
        return Qt.createQmlObject(qmlToParse, root);
    }

    function getAcmThemeColors(theme) {
        var acmColorMap = {};
        acmColorMap['message'] = acm.primary;
        acmColorMap['button_one'] = acm_buttons.primary;
        acmColorMap['button_two'] = acm_buttons.primary_transparent;

        switch (theme) {
            case ColorThemeManager.ErrorTheme:
                acmColorMap['message'] =  acm.error;
                acmColorMap['button_one'] = acm_buttons.error;
                acmColorMap['button_two'] = acm_buttons.error_transparent;
                break;
            case ColorThemeManager.OfflineTheme:
                acmColorMap['message'] =  acm.transparent;
                acmColorMap['button_one'] = acm_buttons.primary;
                acmColorMap['button_two'] = acm_buttons.primary_transparent;
                break;
            case ColorThemeManager.WarningTheme:
                acmColorMap['message'] =  acm.warning;
                acmColorMap['button_one'] = acm_buttons.primary;
                acmColorMap['button_two'] = acm_buttons.primary_transparent;
                break;
            case ColorThemeManager.ErrorWithConfirmTheme:
                acmColorMap['message'] =  acm.error;
                acmColorMap['button_one'] = acm_buttons.primary;
                acmColorMap['button_two'] = acm_buttons.primary_transparent;
                break;
            case ColorThemeManager.PremiumUpsellTheme:
                acmColorMap['message'] =  acm.primary;
                acmColorMap['button_one'] = acm_buttons.premium_upsell;
                acmColorMap['button_two'] = acm_buttons.primary_transparent;
                break;
            case ColorThemeManager.DefaultTheme:
            default:
                acmColorMap['message'] = acm.primary;
                acmColorMap['button_one'] = acm_buttons.primary;
                acmColorMap['button_two'] = acm_buttons.primary_transparent;
                break;
        }

        return acmColorMap;
    }

    property string qtQuickImport:       'import QtQuick 2.0;'
    property string fabricColorsImport:  'import "palettes.js" as Palettes;'
    property string itemStart:       'QtObject { '
}
