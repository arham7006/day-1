pragma Singleton
import QtQuick 2.0
import "palettes.js" as Palettes;

// NOTE:  Since singletons cannot reload during runtime, this file must be built before running
//        *even in qtDeveloperMode*

QtObject {
    id: root
    property string currentTheme: colorThemeManager.currentThemeName

    // Colors.common
    // These colors are used by multiple UI elements.  When modifying, be sure to verify all places they are used.
    property QtObject common:
    {
        var properties = {"Standard":      {"hyperlink":                    "Palettes.Fabric.themePrimary",
                                            "hyperlink_hovering":           "Palettes.Fabric.themeDark",
                                            "hyperlink_pressed":            "Palettes.Fabric.themeDarker",
                                            "text":                         "Palettes.Fabric.neutralPrimary",
                                            "text_secondary":               "Palettes.Fabric.neutralSecondary",
                                            "text_secondaryAlt":            "Palettes.Fabric.neutralSecondaryAlt",
                                            "text_hover":                   "Palettes.Fabric.neutralPrimary",
                                            "text_disabled":                "Palettes.Fabric.neutralTertiary",
                                            "text_secondary_hovering":      "Palettes.Fabric.neutralSecondary",
                                            "text_secondary_hovering_alt":  "Palettes.Fabric.neutralSecondaryAlt",
                                            "text_tertiary":                "Palettes.Fabric.neutralTertiaryAlt",
                                            "checkmark":                    "Palettes.Basic.green",
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
                                            "checkmark":                    "systemColors.windowText",
                                            "background":                   "systemColors.window"},

                          "Dark":          {"hyperlink":                    "Palettes.DarkThemeBlue.dtblue80",
                                            "hyperlink_hovering":           "Palettes.DarkThemeBlue.dtblue70",
                                            "hyperlink_pressed":            "Palettes.DarkThemeBlue.dtblue60",
                                            "text":                         "Palettes.Neutrals.white",
                                            "text_secondary":               "Palettes.Neutrals.gray80",
                                            "text_secondaryAlt":            "Palettes.Neutrals.gray80",
                                            "text_hover":                   "Palettes.Neutrals.gray50",
                                            "text_disabled":                "Palettes.Neutrals.gray50",
                                            "text_secondary_hovering":      "Palettes.Neutrals.gray70",
                                            "text_secondary_hovering_alt":  "Palettes.Neutrals.gray90",
                                            "text_tertiary":                "Palettes.Neutrals.gray80",
                                            "checkmark":                    "Palettes.Shared.green20",
                                            "background":                   "Palettes.Neutrals.gray180"}};
        return itemFromThemes(properties);
    }


    property QtObject fabric_button:
        QtObject {
            // Colors.fabric_button.primary
            property QtObject primary:
            {
                var properties = {"Standard":    {"background":        "Palettes.Fabric.themePrimary",
                                                  "down":              "background", // Same as background
                                                  "hovered":           "Palettes.Fabric.themeDark",
                                                  "disabled":          "Palettes.Fabric.neutralLighter",
                                                  "text":              "Palettes.Basic.white",
                                                  "text_disabled":     "Palettes.Fabric.neutralTertiary",
                                                  "focused_border":    "Palettes.Fabric.themeDarker"},

                                 "HighContrast": {"background":         "systemColors.windowText",
                                                  "down":               "background", // Same as background
                                                  "hovered":            "systemColors.hotlight",
                                                  "disabled":           "systemColors.inactiveBorder",
                                                  "text":               "systemColors.window",
                                                  "text_disabled":      "systemColors.window",
                                                  "focused_border":     "systemColors.hotlight"},

                                 "Dark":         {"background":        "Palettes.DarkThemeBlue.dtblue130",
                                                  "down":              "background", // Same as background
                                                  "hovered":           "Palettes.DarkThemeBlue.dtblue100",
                                                  "disabled":          "Palettes.DarkThemeBlue.dtblue130",
                                                  "text":              "Palettes.Neutrals.white",
                                                  "text_disabled":     "Palettes.Neutrals.gray90",
                                                  "focused_border":    "Palettes.Neutrals.gray70"}};
                return itemFromThemes(properties);
            }

            // Colors.fabric_button.standard
            property QtObject standard:
            {
                var properties = {"Standard":    {"background":        "Palettes.Fabric.neutralLighter",
                                                  "down":              "Palettes.Fabric.themePrimary",
                                                  "hovered":           "Palettes.Fabric.neutralLight",
                                                  "disabled":          "Palettes.Fabric.neutralLighter",
                                                  "text":              "Palettes.Fabric.neutralPrimary",
                                                  "text_hovered":      "Palettes.Basic.black",
                                                  "text_down":         "Palettes.Basic.white",
                                                  "text_disabled":     "Palettes.Fabric.neutralTertiary",
                                                  "focused_border":    "Palettes.Fabric.themePrimary"},

                                 "HighContrast": {"background":         "systemColors.windowText",
                                                  "down":               "systemColors.hotlight",
                                                  "hovered":            "systemColors.hotlight",
                                                  "disabled":           "systemColors.inactiveBorder",
                                                  "text":               "systemColors.window",
                                                  "text_hovered":       "systemColors.window",
                                                  "text_down":          "systemColors.window",
                                                  "text_disabled":      "systemColors.window",
                                                  "focused_border":     "systemColors.hotlight"},

                                 "Dark":         {"background":        "Palettes.Neutrals.gray150",
                                                  "down":              "background", // Same as background
                                                  "hovered":           "Palettes.Neutrals.gray140",
                                                  "disabled":          "Palettes.Neutrals.gray130",
                                                  "text":              "Palettes.Neutrals.white",
                                                  "text_hovered":      "Palettes.Neutrals.white",
                                                  "text_down":         "Palettes.Neutrals.white",
                                                  "text_disabled":     "Palettes.Neutrals.gray90",
                                                  "focused_border":    "Palettes.DarkThemeBlue.dtblue100"}};
                return itemFromThemes(properties);
            }
        }

    // Colors.fabric_textfield
    property QtObject fabric_textfield:
    {
        var properties = {  "Standard":   { "background":             "Palettes.Basic.white",
                                            "background_disabled":    "Palettes.Neutrals.gray20",
                                            "border":                 "Palettes.Neutrals.gray80",
                                            "border_hover":           "Palettes.Neutrals.gray160",
                                            "border_selected":        "Palettes.Comm.Primary",
                                            "border_disabled":        "Palettes.Neutrals.gray20",
                                            "border_error":           "Palettes.Basic.redDark",
                                            "text":                   "Palettes.Fabric.neutralPrimary",
                                            "text_disabled":          "Palettes.Fabric.neutralTertiary"},

                          "HighContrast": { "background":             "systemColors.windowText",
                                            "background_disabled":    "systemColors.inactiveBorder",
                                            "border":                 "systemColors.hotlight",
                                            "border_hover":           "systemColors.hotlight",
                                            "border_selected":        "systemColors.hotlight",
                                            "border_disabled":        "systemColors.inactiveBorder",
                                            "border_error":           "systemColors.hotlight",
                                            "text":                   "systemColors.window",
                                            "text_disabled":          "systemColors.window"},

                           "Dark":        { "background":             "Palettes.Neutrals.gray180",
                                            "background_disabled":    "Palettes.Neutrals.gray130",
                                            "border":                 "Palettes.DarkThemeBlue.dtblue100",
                                            "border_hover":           "Palettes.Neutrals.gray140",
                                            "border_selected":        "Palettes.DarkThemeBlue.dtblue100",
                                            "border_disabled":        "Palettes.Neutrals.gray130",
                                            "border_error":           "Palettes.DarkThemeBlue.dtblue100",
                                            "text":                   "Palettes.Neutrals.white",
                                            "text_disabled":          "Palettes.Neutrals.gray90"}};
        return itemFromThemes(properties);
    }

    // Colors.floodgate_survey
    property QtObject floodgate_survey:
    {
        var properties = {"Standard":      {"input_placeholder":         "Palettes.Fabric.neutralPrimary",
                                            "input_border":              "Palettes.Fabric.neutralTertiaryAlt",
                                            "input_border_focused":      "Palettes.Fabric.themeTertiary",
                                            "title_text":                "Palettes.Fabric.themePrimary"},

                          "HighContrast":   {"input_placeholder":        "systemColors.windowText",
                                             "input_border":             "systemColors.hotlight",
                                             "input_border_focused":     "systemColors.highlightText",
                                             "title_text":               "systemColors.windowText"},

                          "Dark":          {"input_placeholder":         "Palettes.Neutrals.white",
                                            "input_border":              "Palettes.Neutrals.gray70",
                                            "input_border_focused":      "Palettes.Neutrals.gray40",
                                            "title_text":                "Palettes.DarkThemeBlue.dtblue80"}};
        return itemFromThemes(properties);
    }

    // Colors.send_feedback
    property QtObject send_feedback:
    {
        var properties = {"Standard":      {"input_placeholder":         "Palettes.Fabric.neutralPrimary",
                                            "input_border":              "Palettes.Fabric.neutralTertiaryAlt",
                                            "input_border_focused":      "Palettes.Fabric.themeTertiary",
                                            "title_text":                "Palettes.Fabric.themePrimary"},

                          "HighContrast":   {"input_placeholder":        "systemColors.windowText",
                                             "input_border":             "systemColors.hotlight",
                                             "input_border_focused":     "systemColors.highlightText",
                                             "title_text":               "systemColors.windowText"},

                          "Dark":          {"input_placeholder":         "Palettes.Neutrals.white",
                                            "input_border":              "Palettes.Neutrals.gray70",
                                            "input_border_focused":      "Palettes.Neutrals.gray40",
                                            "title_text":                "Palettes.DarkThemeBlue.dtblue80"}};
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
                                            "close_button":              "Palettes.Fabric.themePrimary",
                                            "close_button_hover":        "Palettes.Fabric.themeSecondary",
                                            "tou_title":                 "Palettes.Fabric.neutralSecondary"},

                          "HighContrast":   {"title":                    "Palettes.Shared.cyanBlue10",
                                            "error_title":               "Palettes.Shared.redOrange10",
                                            "main_background":           "Palettes.Neutrals.gray31",
                                            "purchase_button":           "Palettes.Basic.green",
                                            "purchase_button_hover":     "Palettes.Shared.green20",
                                            "close_button":              "Palettes.Fabric.themePrimary",
                                            "close_button_hover":        "Palettes.Fabric.themeSecondary",
                                            "tou_title":                 "Palettes.Fabric.neutralSecondary"},

                          "Dark":          {"title":                     "Palettes.DarkThemeBlue.dtblue65",
                                            "error_title":               "Palettes.Shared.redOrange10",
                                            "main_background":           "Palettes.Neutrals.gray160",
                                            "purchase_button":           "Palettes.Basic.green",
                                            "purchase_button_hover":     "Palettes.Shared.green20",
                                            "close_button":              "Palettes.DarkThemeBlue.dtblue100",
                                            "close_button_hover":        "Palettes.DarkThemeBlue.dtblue60",
                                            "tou_title":                 "Palettes.Neutrals.white"}};                                  
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
                          "Dark":          {"title_text":                "Palettes.DarkThemeBlue.dtblue80",
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
                                          "scrollViewBorderColor":          "Palettes.Fabric.neutralSecondary",
                                          "confirmButtonHover":             "Palettes.Fabric.neutralLighter",
                                          "confirmButtonPressed":           "Palettes.Fabric.neutralLight"},

                         "HighContrast": {"title":                          "systemColors.windowText",
                                          "folderItemBackgroundSelected":   "systemColors.highlight",
                                          "folderItemBackgroundDone":       "systemColors.highlight",
                                          "folderItemBackgroundDoneText":   "systemColors.highlight",
                                          "cancelledSecondaryText":         "systemColors.highlight",
                                          "folderItemPrimaryText":          "systemColors.windowText",
                                          "folderItemSecondaryText":        "systemColors.highlightText",
                                          "folderItemLinkText":             "systemColors.hotlight",
                                          "folderItemBorderColor":          "systemColors.hotlight",
                                          "scrollViewBorderColor":          "systemColors.hotlight",
                                          "confirmButtonHover":             "systemColors.highlight",
                                          "confirmButtonPressed":           "systemColors.highlight"},

                           "Dark":       {"title":                          "Palettes.DarkThemeBlue.dtblue100",
                                          "folderItemBackgroundSelected":   "Palettes.Neutrals.gray150",
                                          "folderItemBackgroundDone":       "Palettes.Neutrals.gray150",
                                          "folderItemBackgroundDoneText":   "Palettes.Neutrals.gray80",
                                          "cancelledSecondaryText":         "Palettes.Basic.redLight",
                                          "folderItemPrimaryText":          "Palettes.Neutrals.white",
                                          "folderItemSecondaryText":        "Palettes.Neutrals.gray80",
                                          "folderItemLinkText":             "Palettes.DarkThemeBlue.dtblue100",
                                          "folderItemBorderColor":          "Palettes.Neutrals.gray70",
                                          "scrollViewBorderColor":          "Palettes.Neutrals.gray80",
                                          "confirmButtonHover":             "Palettes.Neutrals.gray150",
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
                                                     "focused_border":               "Palettes.Fabric.neutralPrimaryAlt"},

                                  "HighContrast":   {"mac_border":                   "systemColors.activeCaption",
                                                     "focused_border":               "systemColors.hotlight"},

                                  "Dark":           {"mac_border":                   "Palettes.Neutrals.gray100",
                                                     "focused_border":               "Palettes.Neutrals.gray160"}};
                return itemFromThemes(properties);
            }

            // Colors.activity_center.header
            property QtObject header:
            {
                var properties = {"Standard":       {"normal":    "Palettes.Fabric.themePrimary",
                                                     "paused":    "Palettes.Fabric.neutralPrimaryAlt",
                                                     "error":     "Palettes.Basic.orangeLight",
                                                     "caption":   "Palettes.Basic.white"},

                                  "HighContrast":   {"normal":    "systemColors.activeCaption",
                                                     "paused":    "systemColors.activeCaption",
                                                     "error":     "systemColors.activeCaption",
                                                     "caption":   "systemColors.captionText"},

                                  "Dark":           {"normal":    "Palettes.Fabric.themePrimary",
                                                     "paused":    "Palettes.Neutrals.gray130",
                                                     "error":     "Palettes.Basic.orangeLight",
                                                     "caption":   "Palettes.Basic.white"}};
                return itemFromThemes(properties);
            }

            // Colors.activity_center.footer
            property QtObject footer:
            {
                var properties = {"Standard":       {"background":             "Palettes.Fabric.neutralLight",
                                                     "button":                 "Palettes.Fabric.neutralLight",
                                                     "button_hovered":         "Palettes.Fabric.neutralTertiaryAlt",
                                                     "button_pressed":         "Palettes.Fabric.neutralTertiary",
                                                     "button_text":            "Palettes.Basic.black",
                                                     "button_focused_border":  "Palettes.Basic.black",
                                                     "rule":                   "Palettes.Fabric.neutralLightAlt"},

                                  "HighContrast":   {"background":             "systemColors.window",
                                                     "button":                 "systemColors.window",
                                                     "button_hovered":         "systemColors.highlight",
                                                     "button_pressed":         "systemColors.highlight",
                                                     "button_text":            "systemColors.btnText",
                                                     "button_focused_border":  "systemColors.btnText",
                                                     "rule":                   "systemColors.btnText"},

                                  "Dark":           {"background":             "Palettes.Neutrals.gray150",
                                                     "button":                 "Palettes.Neutrals.gray150",
                                                     "button_hovered":         "Palettes.Neutrals.gray140",
                                                     "button_pressed":         "Palettes.Neutrals.gray130",
                                                     "button_text":            "Palettes.Basic.white",
                                                     "button_focused_border":  "Palettes.Neutrals.gray70",
                                                     "rule":                   "Palettes.Neutrals.gray100"}};
                return itemFromThemes(properties);
            }

            // Colors.activity_center.list
            property QtObject list:
            {
                var properties = {"Standard":       {"background_secondary":         "Palettes.Fabric.neutralLighterAlt",
                                                     "background_hovering":          "Palettes.Fabric.themeLighter",
                                                     "background_focus":             "Palettes.Fabric.themeLight",
                                                     "border_focus":                 "Palettes.Fabric.themeTertiary",
                                                     "progress_background":          "Palettes.Fabric.neutralTertiaryAlt",
                                                     "progress":                     "Palettes.Fabric.themePrimary"},


                                  "HighContrast":   {"background_secondary":         "systemColors.window",
                                                     "background_hovering":          "systemColors.highlight",
                                                     "background_focus":             "systemColors.highlight",
                                                     "border_focus":                 "systemColors.highlightText",
                                                     "progress_background":          "systemColors.activeBorder",
                                                     "progress":                     "systemColors.inactiveBorder"},

                                  "Dark":           {"background_secondary":         "Palettes.Neutrals.gray150",
                                                     "background_hovering":          "Palettes.Neutrals.gray160",
                                                     "background_focus":             "Palettes.Neutrals.gray150",
                                                     "border_focus":                 "Palettes.Neutrals.gray70",
                                                     "progress_background":          "Palettes.Neutrals.gray100",
                                                     "progress":                     "Palettes.DarkThemeBlue.dtblue100"}};
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
                                                     "border_alert_focus":           "systemColors.highlightText",
                                                     "mass_delete_checkbox":         "systemColors.hotlight",
                                                     "mass_delete_checkbox_focused": "systemColors.highlightText",
                                                     "error_rect_text":              "systemColors.windowText",
                                                     "error_rect_text_hovering":     "systemColors.windowText"},

                                  "Dark":           {"background":                   "Palettes.OneOff.errorBackground",
                                                     "background_alert":             "Palettes.OneOff.alertBackground",
                                                     "background_hovering":          "'#f2cdd0'",
                                                     "background_warning":           "Palettes.OneOff.warningBackground",
                                                     "background_warning_hovering":  "Palettes.OneOff.warningBackgroundActiveFocus",
                                                     "border_alert_focus":           "Palettes.Neutrals.gray70",
                                                     "mass_delete_checkbox":         "Palettes.Fabric.neutralSecondary",
                                                     "mass_delete_checkbox_focused": "Palettes.Fabric.themeTertiary",
                                                     "error_rect_text":              "Palettes.Neutrals.black",
                                                     "error_rect_text_hovering":     "Palettes.Neutrals.black"}};

                return itemFromThemes(properties);
            }

            // Colors.activity_center.message
            property QtObject message:
            {
                var properties = {"Standard":       {"button_hovering":              "'transparent'",
                                                     "button_border":                "Palettes.Basic.redDark",
                                                     "button_border_hovering":       "Palettes.Basic.redDarker",
                                                     "button_pressed":               "Palettes.Basic.redDark",
                                                     "button_border_pressed":        "Palettes.Basic.white",
                                                     "button_text":                  "Palettes.Basic.redDark",
                                                     "button_text_hovering":         "Palettes.Basic.redDarker",
                                                     "button_text_pressed":          "Palettes.Basic.white",
                                                     "background_upsell":            "Palettes.OneOff.upsellBackground",
                                                     "dismiss_button_primary":       "'transparent'",
                                                     "dismiss_button_pressed":       "Palettes.OneOff.acm_dismiss_pressed",
                                                     "dismiss_button_hovered":       "Palettes.OneOff.acm_dismiss_hover",
                                                     "dismiss_button_focus_border":  "Palettes.Fabric.themeTertiary"},

                                  "HighContrast":   {"button_hovering":              "systemColors.highlight",
                                                     "button_border":                "systemColors.btnText",
                                                     "button_border_hovering":       "systemColors.highlightText",
                                                     "button_pressed":               "systemColors.btnText",
                                                     "button_border_pressed":        "'transparent'",
                                                     "button_text":                  "systemColors.btnText",
                                                     "button_text_hovering":         "systemColors.highlightText",
                                                     "button_text_pressed":          "systemColors.highlightText",
                                                     "background_upsell":            "systemColors.window",
                                                     "dismiss_button_primary":       "systemColors.window",
                                                     "dismiss_button_pressed":       "systemColors.highlight",
                                                     "dismiss_button_hovered":       "systemColors.window",
                                                     "dismiss_button_focus_border":  "systemColors.hotlight"},

                                  "Dark":           {"button_hovering":              "'transparent'",
                                                     "button_border":                "Palettes.Basic.redDark",
                                                     "button_border_hovering":       "Palettes.Basic.redDarker",
                                                     "button_pressed":               "Palettes.Basic.redDark",
                                                     "button_border_pressed":        "Palettes.Basic.white",
                                                     "button_text":                  "Palettes.Basic.redDark",
                                                     "button_text_hovering":         "Palettes.Basic.redDarker",
                                                     "button_text_pressed":          "Palettes.Basic.white",
                                                     "background_upsell":            "Palettes.OneOff.upsellBackground",
                                                     "dismiss_button_primary":       "'transparent'",
                                                     "dismiss_button_pressed":       "Palettes.OneOff.acm_dismiss_pressed",
                                                     "dismiss_button_hovered":       "Palettes.OneOff.acm_dismiss_hover",
                                                     "dismiss_button_focus_border":  "Palettes.Fabric.themeTertiary"}};
                return itemFromThemes(properties);
            }

            // Colors.activity_center.context_menu
            property QtObject context_menu:
            {
                var properties = {"Standard":       {"background":       "Palettes.Basic.white",
                                                     "button_hover":     "'#9ac8ed'",
                                                     "button_pressed":   "Palettes.Fabric.themeTertiary",
                                                     "item_hover":       "Palettes.Fabric.neutralLighter",
                                                     "item_focus":       "Palettes.Fabric.neutralLighterAlt",
                                                     "item_pressed":     "Palettes.Fabric.neutralLight",
                                                     "menu_border":      "Palettes.Neutrals.gray70"},

                                  "HighContrast":   {"background":       "systemColors.menu",
                                                     "button_hover":     "systemColors.highlightText",
                                                     "button_pressed":   "systemColors.highlightText",
                                                     "item_hover":       "systemColors.highlight",
                                                     "item_focus":       "systemColors.highlight",
                                                     "item_pressed":     "systemColors.highlight",
                                                     "menu_border":      "systemColors.hotlight"},

                                  "Dark":           {"background":       "Palettes.Neutrals.gray180",
                                                     "button_hover":     "Palettes.Neutrals.gray140",
                                                     "button_pressed":   "Palettes.Neutrals.gray130",
                                                     "item_hover":       "Palettes.Neutrals.gray160",
                                                     "item_focus":       "Palettes.Neutrals.gray160",
                                                     "item_pressed":     "Palettes.Neutrals.gray150",
                                                     "menu_border":      "Palettes.Neutrals.gray70"}};
                return itemFromThemes(properties);
            }
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
    property string qtQuickImport:       'import QtQuick 2.0;'
    property string fabricColorsImport:  'import "palettes.js" as Palettes;'
    property string itemStart:       'QtObject { '
}
