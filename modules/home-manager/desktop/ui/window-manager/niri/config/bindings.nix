{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  desktopCfg = config.modules.desktop;
  uiCfg = config.modules.desktop.ui;

  a = config.lib.niri.actions;
  spawn = a.spawn;

  termBin = desktopCfg.terminal.active;
in
{
  programs.niri.settings.binds =
    with a;
    mkMerge [
      {
        "Mod+Return".action = spawn termBin;

        # Window management
        "Mod+Q".action = close-window; # Hypr: killactive
        "Mod+V".action = toggle-window-floating; # Hypr: togglefloating
        "Mod+J".action = toggle-column-tabbed-display; # Hypr: togglesplit-ish

        # Focus movement (columns/workspaces)
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Up".action = focus-workspace-up;
        "Mod+Down".action = focus-workspace-down;

        # Column / window sizing tweaks similar to your example set
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Plus".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Plus".action = set-window-height "+10%";

        # Column / workspace moves
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+J".action = move-column-to-workspace-down;
        "Mod+Shift+K".action = move-column-to-workspace-up;

        # Misc quality-of-life
        "Mod+C".action = center-visible-columns;
        "Mod+Tab".action = switch-focus-between-floating-and-tiling;

        # Example: set fixed column widths
        "Mod+1".action = set-column-width "25%";
        "Mod+2".action = set-column-width "50%";
        "Mod+3".action = set-column-width "75%";
        "Mod+4".action = set-column-width "100%";
      }

      # --- launcher: rofi ---
      (mkIf (uiCfg.launcher == "rofi") {
        "Mod+Space".action = spawn "${pkgs.rofi}/bin/rofi" [
          "-show"
          "drun"
        ];
        "Mod+B".action = spawn "rofi-bluetooth";
        "Mod+P".action = spawn [
          "rofi"
          "-show"
          "power-menu"
          "-modi"
          "power-menu:rofi-power-menu"
        ];
        # clipboard menu (only when your service is enabled)
        "Mod+K".action = mkIf config.modules.services.clipboard.enable (
          spawn "clipcat-menu" [
            "--rofi-menu-length"
            "10"
          ]
        );
      })

      # --- launcher: anyrun ---
      (mkIf (uiCfg.launcher == "anyrun") {
        "Mod+Space".action = spawn "anyrun";
      })

      # --- optional apps ---
      (mkIf desktopCfg.apps.flameshot.enable {
        "Mod+S".action = spawn "flameshot" [ "gui" ];
      })
      (mkIf desktopCfg.apps.wlogout.enable {
        "Mod+W".action = spawn "wlogout";
      })
      (mkIf (uiCfg.locker == "hyprlock") {
        "Mod+L".action = spawn "hyprlock";
      })
      (mkIf (config.modules.editor.emacs.enable && config.modules.editor.emacs.service) {
        "Mod+E".action = spawn "emacsclient" [ "-c" ];
      })
    ];
}
