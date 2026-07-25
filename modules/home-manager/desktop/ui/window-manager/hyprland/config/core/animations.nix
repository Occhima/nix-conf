{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.hyprland = { config, ... }: {
    wayland.windowManager.hyprland.settings =
      hyprlandLib.mkConfig config.wayland.windowManager.hyprland.configType
        {
          animations.enabled = true;
        };
  };
}
