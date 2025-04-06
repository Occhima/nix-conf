{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;

in
{
  config = {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;
      };

    };
    services.hypridle = {
      enable = true;

      #TODO  add expr to enable hyprlock
      settings = mkIf config.programs.hyprlock.enable {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

      };
    };

    services.mako = {
      enable = true;
      anchor = "center";
    };
  };

}
