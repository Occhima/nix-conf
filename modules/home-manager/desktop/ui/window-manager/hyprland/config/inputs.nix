{ config, osConfig, ... }:
let
  primary = osConfig.modules.hardware.monitors.primaryMonitorName;
  output = osConfig.modules.hardware.monitors.displays.${primary}.output;

in
{
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
}
