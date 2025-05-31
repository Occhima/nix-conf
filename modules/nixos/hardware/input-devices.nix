{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.modules.hardware.input;
in
{
  options.modules.hardware.input = {
    keyboard = {
      layout = mkOption {
        type = types.enum [
          "us"
          "gb"
          "br"
          "de"
          "fr"
        ];
        default = "us";
        description = "Keyboard layout";
      };

      variant = mkOption {
        type = types.str;
        default = "";
        description = "Keyboard variant";
      };
    };

    naturalScrolling = mkOption {
      type = types.bool;
      default = true;
      description = "Enable natural scrolling for mice and touchpads";
    };
  };

  config = {
    # Apply keyboard layout to console
    console.keyMap = mkIf (cfg.keyboard.variant == "") cfg.keyboard.layout;

    # Apply settings to X server
    services.xserver.xkb = {
      layout = cfg.keyboard.layout;
      variant = cfg.keyboard.variant;
    };

    # Apply natural scrolling to libinput devices
    services.libinput = {
      enable = true;
      mouse.naturalScrolling = cfg.naturalScrolling;
      touchpad.naturalScrolling = cfg.naturalScrolling;
    };
  };
}
