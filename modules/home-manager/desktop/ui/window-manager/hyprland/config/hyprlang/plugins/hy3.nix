{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf elem;
  hyprCfg = config.modules.desktop.ui.windowManagerOpts.hyprland;
  enabled = hyprCfg.enable && hyprCfg.plugins.enable && elem "hy3" hyprCfg.plugins.enabledPlugins;
in
{
  config = mkIf enabled {
    wayland.windowManager.hyprland = {
      plugins = [ pkgs.hyprlandPlugins.hy3 ];

      settings = {
        general.layout = "hy3";

        bind = [
          # Tab groups
          "$mainMod, T, hy3:makegroup, tab"
          "$mainMod, H, hy3:makegroup, h"
          "$mainMod, U, hy3:makegroup, v"
          "$mainMod, A, hy3:changefocus, raise"
          "$mainMod SHIFT, A, hy3:changefocus, lower"

          # Tree-aware focus (base movefocus binds are gated off in keybindings.nix)
          "$mainMod, left, hy3:movefocus, l"
          "$mainMod, right, hy3:movefocus, r"
          "$mainMod, up, hy3:movefocus, u"
          "$mainMod, down, hy3:movefocus, d"

          # Move window in tree
          "$mainMod CTRL, left, hy3:movewindow, l"
          "$mainMod CTRL, right, hy3:movewindow, r"
          "$mainMod CTRL, up, hy3:movewindow, u"
          "$mainMod CTRL, down, hy3:movewindow, d"
        ];
      };
    };
  };
}
