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
        animation = "colormix";
        animation_timeout_sec = 300;
        clock = "%c";
        clear_password = true;
      };
    };

  };
}
