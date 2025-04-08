{
  wayland.windowManager.hyprland.settings = {

    # TODO: Put the monitors here, probably use osConfig
    # monitors = [ ];
    # workspaces = [
    # ];

    input = {
      kb_layout = "us,br";
      kb_variant = "intl,abnt2";
      kb_options = "grp:alt_shift_toggle";
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
