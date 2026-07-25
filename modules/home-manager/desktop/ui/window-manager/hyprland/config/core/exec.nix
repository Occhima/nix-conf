{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.hyprland = { config, ... }: {
    wayland.windowManager.hyprland.settings =
      hyprlandLib.mkAutostart config.wayland.windowManager.hyprland.configType
        [
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
        ];
  };
}
