{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.modules.data.xdg;
in
{
  options.modules.data.xdg = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable XDG directory configuration";
    };
  };

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      cacheHome = "${config.home.homeDirectory}/.cache";
      userDirs = mkIf pkgs.stdenv.isLinux rec {
        enable = true;
        createDirectories = true;
        documents = "${config.home.homeDirectory}/documents";
        download = "${config.home.homeDirectory}/downloads";
        desktop = "${config.home.homeDirectory}/desktop";
        videos = "${config.home.homeDirectory}/media/videos";
        music = "${config.home.homeDirectory}/media/music";
        pictures = "${config.home.homeDirectory}/media/pictures";
        publicShare = "${config.home.homeDirectory}/public/share";
        templates = "${config.home.homeDirectory}/public/templates";
        extraConfig = {
          SCREENSHOTS = "${config.home.homeDirectory}/media/pictures/screenshots";
          DEV = "${config.home.homeDirectory}/dev";
        };
      };
    };
  };
}
