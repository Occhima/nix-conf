{
  config,
  lib,
  ...
}:
let

  inherit (lib.custom) themeLib;

in
{
  stylix.targets.zen-browser = {
    enable = false; # disabled by default
  };

  programs.zen-browser.profiles.default = themeLib.whenTheme config "guernica" {
    mods = [
      "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better find bar
      "79dde383-4fe7-404a-a8e6-9be440022542" # Tidy Popup
      "5941aefd-67b0-453d-9b62-9071a31cbb0d" # Smaller compact mode
      "bc25808c-a012-4c0d-ad9a-aa86be616019" # sleek border
      "642854b5-88b4-4c40-b256-e035532109df" # transparent zen
    ];
    keyboardShortcuts = [
      {
        id = "zen-compact-mode-toggle";
        # Ctrl+Alt+C: swallowed by US-International keymap (Ctrl+Alt = AltGr).
        # Ctrl+Shift+M: collides with Firefox Responsive Design Mode.
        # Alt+Shift+M: clean — no AltGr, no Firefox built-in.
        key = "m";
        modifiers = {
          alt = true;
          shift = true;
        };
      }
    ];
    settings = {
      "zen.theme.gradient.show-custom-color" = true;
      "zen.urlbar.behavior" = "float";
      "zen.workspaces.continue-where-left-off" = true;
      "zen.welcome-screen.seen" = true;

      "zen.view.compact.enable-at-startup" = true;
      "zen.view.compact.hide-tabbar" = true;

      "zen.widget.linux.transparency" = true;
      "browser.tabs.allow_transparent_browser" = true;
      "zen.view.grey-out-inactive-windows" = false;

      # ── Transparent-Zen mod (sameerasw 642854b5) tunables ───────────────
      "mod.sameerasw.zen_transparent_glance_enabled" = true;
      "mod.sameerasw.zen_transparent_sidebar_enabled" = true;
      "mod.sameerasw.zen_bg_color_enabled" = true;
      "mod.sameerasw.zen_transparency_color" = "#0e0e12cc";
      "mod.sameerasw.zen_no_shadow" = true;
      "mod.sameerasw_zen_light_tint" = "2"; # strip the light tint entirely
      "mod.sameerasw_zen_animations" = "1"; # smooth (0=snap, 2=heavy, 3=spring)
      "mod.sameerasw.zen_tab_switch_anim" = true;
      "mod.sameerasw.zen_urlbar_zoom_anim" = false;

      # ── Webpage font defaults (chrome UI handled in userChrome below) ───
      "font.default.x-western" = "sans-serif";
      "font.name.sans-serif.x-western" = config.stylix.fonts.sansSerif.name;
      "font.name.serif.x-western" = config.stylix.fonts.serif.name;
      "font.name.monospace.x-western" = config.stylix.fonts.monospace.name;
      "font.size.variable.x-western" = 15;
      "font.size.monospace.x-western" = 13;

    };

    # ── userChrome.css ────────────────────────────────────────────────────
    # Dark layered gradient that lives ABOVE the transparent-zen mod's flat
    # colour. `:root:root` doubles specificity so we beat the mod's
    # `:root { ... !important }` override on `--zen-main-browser-background`.
    userChrome = ''
      :root:root {
        --zen-main-browser-background:
          radial-gradient(
            ellipse at 30% 0%,
            #1a1a22 0%,
            #121218 45%,
            #0a0a0d 100%
          ) !important;
        --zen-themed-toolbar-bg: transparent !important;
        --zen-colors-primary: #1a1a22 !important;
        --zen-colors-secondary: #121218 !important;
        --zen-colors-tertiary: #0a0a0d !important;
        --zen-dialog-background: rgba(14, 14, 18, 0.92) !important;
        --arrowpanel-background: rgba(14, 14, 18, 0.92) !important;
        --toolbar-bgcolor: transparent !important;
      }

      /* Main window: layered gradient so the bottom edge fades to pure
         black, the top picks up a faint cool tint. */
      #main-window {
        background:
          linear-gradient(180deg, rgba(26, 26, 34, 0.55) 0%, rgba(10, 10, 13, 0.85) 100%),
          radial-gradient(ellipse at 50% -10%, #1a1a22 0%, #0a0a0d 70%) !important;
        background-attachment: fixed !important;
      }

      /* Toolbox / urlbar: kill any opaque fill so the gradient shows through */
      #navigator-toolbox,
      #nav-bar,
      #urlbar-background,
      #PersonalToolbar {
        background-color: transparent !important;
        background-image: none !important;
        border: none !important;
        box-shadow: none !important;
      }

      /* Sidebar / tab strip: soft translucent panel using color-mix so it
         tints the gradient instead of replacing it. */
      #titlebar,
      #TabsToolbar,
      #zen-tabbox-wrapper,
      #zen-sidebar-bottom-buttons,
      #zen-appcontent-navbar-container {
        background:
          color-mix(in srgb, #0a0a0d 35%, transparent) !important;
        backdrop-filter: blur(8px) saturate(1.1);
      }

      /* Rounded corners on the browser viewport for a softer dark frame */
      #tabbrowser-tabbox,
      .browserStack {
        border-radius: 10px !important;
        overflow: hidden;
      }

      /* Chrome (UI) font override — uses the stylix sans for menus + tabs
         and stylix mono for the urlbar so it matches the terminal look. */
      #main-window,
      #main-window menupopup,
      #main-window panel,
      #main-window tooltip {
        font-family: "${config.stylix.fonts.sansSerif.name}", system-ui, sans-serif !important;
      }
      #urlbar,
      #urlbar-input,
      .urlbarView-row {
        font-family: "${config.stylix.fonts.monospace.name}", monospace !important;
      }
    '';

    # ── userContent.css ───────────────────────────────────────────────────
    # Strip opaque backgrounds from Zen's built-in pages so the gradient
    # below stays visible (otherwise about:home/newtab paint solid white).
    userContent = ''
      @-moz-document url("about:home"),
                     url("about:newtab"),
                     url("about:privatebrowsing"),
                     url("about:blank") {
        html, body, .activity-stream {
          background: transparent !important;
          background-color: transparent !important;
          color: #e6e6ea !important;
        }
        .top-sites-list .top-site-outer .tile,
        .card-outer {
          background-color: rgba(20, 20, 26, 0.55) !important;
          box-shadow: none !important;
        }
      }
    '';

  };

}
