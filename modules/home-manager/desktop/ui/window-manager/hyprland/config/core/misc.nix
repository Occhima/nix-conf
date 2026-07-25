{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.hyprland = { config, ... }: {
    wayland.windowManager.hyprland.settings =
      hyprlandLib.mkConfig config.wayland.windowManager.hyprland.configType
        {
          misc = {
            enable_swallow = true;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
            disable_autoreload = true;
          };
        };
  };
}
