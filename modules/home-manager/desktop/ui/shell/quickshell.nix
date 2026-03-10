{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui;

  wrappedQuickshell = pkgs.symlinkJoin {
    name = "quickshell-wrapped";
    paths = [
      pkgs.quickshell
      pkgs.kdePackages.qtimageformats
      pkgs.adwaita-icon-theme
      pkgs.kdePackages.kirigami.unwrapped
    ];
    meta.mainProgram = pkgs.quickshell.meta.mainProgram;
  };
in
{
  config = mkIf (cfg.shell == "quickshell") {
    programs.quickshell = {
      enable = true;
      package = wrappedQuickshell;
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
    };
  };
}
