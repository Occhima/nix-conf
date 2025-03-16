{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.data.xdg;
in
{
  options.modules.data.xdg = {
    enable = mkEnableOption "Enable XDG directory configuration";
  };

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      cacheHome = "${config.home.homeDirectory}/.cache";
    };
  };
}
