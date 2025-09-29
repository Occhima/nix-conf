{ config, ... }:
let
  inherit (builtins) concatStringsSep;
in
{

  programs.niri.settings = {
    input = {
      warp-mouse-to-focus.enable = true;
      workspace-auto-back-and-forth = true;
      keyboard = {
        xkb = {
          layout = config.home.keyboard.layout;
          variant = config.home.keyboard.variant;
          options = concatStringsSep "," config.home.keyboard.options;
        };
      };

      mouse = {
        enable = true;
        natural-scroll = true;

      };
    };

    # TODO...
    # touchpad = {
    # }

  };
}
