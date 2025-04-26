{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.data.dropbox;
in
{
  options.modules.data.dropbox = {
    enable = mkEnableOption "Enable dropbox for the user";
    service = mkEnableOption "Enable dropbox service for the user";
  };

  config = mkIf cfg.enable {

    services.dropbox = {
      enable = cfg.service;
    };

    home.packages = [ pkgs.maestral ];
  };
}
