{ config, ... }:
let
  primary = config.modules.hostContext.monitors.primaryMonitorName;
  output = config.modules.hostContext.monitors.displays.${primary}.output;

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
        inherit output;
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
