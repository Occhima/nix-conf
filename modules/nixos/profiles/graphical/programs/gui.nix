{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.custom) hasProfile;
in
{
  config = mkIf (hasProfile config [ "graphical" ]) {
    programs = {
      # we need dconf to interact with gtk
      dconf.enable = true;

      # gnome's keyring manager
      seahorse.enable = false;

      # networkmanager tray uility, pretty useful actually
      # nm-applet.enable = config.programs.waybar.enable;
    };
  };
}
