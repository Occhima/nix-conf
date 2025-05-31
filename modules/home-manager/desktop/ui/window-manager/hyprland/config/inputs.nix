{ config, ... }:
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
      sensitivity = -0.5;
      repeat_delay = 200;
      repeat_rate = 50;
    };

    cursor = {
      no_hardware_cursors = true;
    };
  };
}
