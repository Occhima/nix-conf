{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.system.login;

in
{
  config = mkIf (cfg.enable && cfg.manager == "ly") {
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
        clear_password = true;
        hide_version_string = true;
        xinitrc = ""; # Hide xinitrc option (X11 not configured)
        setup_cmd = ""; # Don't use xsession-wrapper for shell sessions
      };
    };
  };
}
