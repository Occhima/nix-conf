{ ... }:
{
  config.occhima.hyprland.homeManager =
    {
      config,
      osConfig ? { },
      lib,
      ...
    }:
    let
      inherit (lib) mkIf;
      monitors = osConfig.modules.hardware.monitors or { };
      primary = monitors.primaryMonitorName or "";
      displays = monitors.displays or { };
      output = displays.${primary}.output or "";
    in
    {
      config = mkIf (primary != "") {
        wayland.windowManager.hyprland.settings = {
        input = {
          kb_layout = config.home.keyboard.layout;
          kb_variant = config.home.keyboard.variant;
          kb_options = config.home.keyboard.options;
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
