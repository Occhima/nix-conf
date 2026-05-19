{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkForce elem;
  hyprCfg = config.modules.desktop.ui.windowManagerOpts.hyprland;
  enabled = hyprCfg.enable && hyprCfg.plugins.enable && elem "hy3" hyprCfg.plugins.enabledPlugins;

  hy3 = pkgs.hyprlandPlugins.hy3.overrideAttrs (_: {
    version = "hl0.55.0";
    src = pkgs.fetchFromGitHub {
      owner = "outfoxxed";
      repo = "hy3";
      rev = "a7282db2d7ca336d3c9faa5d10d75fc43eed37aa";
      hash = "sha256-P3wwiIfqo89evW7xzI+wOI/qM1WPZBiiSmGNtBmYeVk=";
    };
  });
in
{
  config = mkIf enabled {
    wayland.windowManager.hyprland = {
      plugins = [ hy3 ];

      settings = {
        general.layout = mkForce "hy3";

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
