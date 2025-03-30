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
    enable = mkEnableOption "Enable dropbox service for the user";
  };

  config = mkIf cfg.enable {

    services.dropbox = {
      enable = true;
    };

    # FIXME: also not working bc i don't know how pkgs work
    home.packages = [ pkgs.dropbox-cli ];
  };
}
