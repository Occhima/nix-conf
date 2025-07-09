{ lib, config, ... }:
let

  inherit (lib.strings) optionalString;
  desktopCfg = config.modules.desktop;
  editorCfg = config.modules.editor;
  flameshotCfg = desktopCfg.apps.flameshot;

in
{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind = [

      # Terminal
      "$mainMod, Q, exec, ${desktopCfg.terminal.active}"

      # Window management
      "$mainMod, F4, killactive,"
      "$mainMod, L, exec, hyprlock"
      "$mainMod, SPACE, exec, rofi -show drun"
      "$mainMod SHIFT, M, exit,"
      "$mainMod SHIFT, R, exec, hyprctl reload"
      "$mainMod, V, togglefloating,"
      "$mainMod, J, togglesplit,"
      "$mainMod, K, exec, clipcat-menu --rofi-menu-length 10"
      (optionalString flameshotCfg.enable "$mainMod, S, exec, flameshot gui")

      # Focus movement
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Emacs
      (optionalString editorCfg.emacs.service "$mainMod, E, exec, emacsclient -c")
      # Utils
      "$mainMod, B, exec, rofi-bluetooth"

      # Power
      "$mainMod, P, exec, rofi -show power-menu -modi power-menu:rofi-power-menu"

      # Workspace switching
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move windows to workspaces
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Scroll through workspaces
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];

    bindm = [
      # Move/resize windows with mouse
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
