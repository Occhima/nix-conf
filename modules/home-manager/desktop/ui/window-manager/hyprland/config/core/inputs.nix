{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.hyprland =
    {
      config,
      osConfig ? { },
      lib,
      ...
    }:
    let
      inherit (lib) concatStringsSep mkIf;
      monitors = osConfig.modules.hardware.monitors or { };
      primary = monitors.primaryMonitorName or "";
      displays = monitors.displays or { };
      output = displays.${primary}.output or "";
    in
    {
      config = mkIf (primary != "") {
        wayland.windowManager.hyprland.settings =
          hyprlandLib.mkConfig config.wayland.windowManager.hyprland.configType
            {
              input = {
                kb_layout = config.home.keyboard.layout;
                kb_variant = config.home.keyboard.variant;
                kb_options = concatStringsSep "," config.home.keyboard.options;
                follow_mouse = 1;
                touchpad = {
                  natural_scroll = false;
                };
                tablet = {
                  transform = 1;
                  output = output;
                };
                sensitivity = -0.5;
                repeat_delay = 250;
                repeat_rate = 50;
              };

              cursor = {
                no_hardware_cursors = true;
              };
            };
      };
    };
}
