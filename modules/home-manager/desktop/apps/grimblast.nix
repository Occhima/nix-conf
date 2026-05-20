{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.desktop.apps.grimblast;
in
{
  options.modules.desktop.apps.grimblast = {
    enable = mkEnableOption "grimblast + satty screenshot tool";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.grimblast ];

    programs.satty = {
      enable = true;
      settings = {
        general = {
          early-exit = true;
          copy-command = "wl-copy";
          save-after-copy = true;
          output-filename = "${config.xdg.userDirs.extraConfig.SCREENSHOTS}/satty-{ts}.png";
          annotation-size-factor = 2;
        };
      };
    };

    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, S, exec, grimblast save area - | satty --filename -"
    ];
  };
}
