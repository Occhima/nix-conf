{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui;

  wrappedPkg = pkgs.symlinkJoin {
    name = "quickshell-wrapped";
    paths = with pkgs; [
      quickshell
      qt6.qtimageformats
      adwaita-icon-theme
      kdePackages.kirigami
    ];
    meta.mainProgram = pkgs.quickshell.meta.mainProgram;
  };
in
{
  config = mkIf (cfg.dock == "quickshell") {
    programs.quickshell = {
      enable = true;
      package = wrappedPkg;
      activeConfig = "base";
      configs = {
        base = ./config;
      };
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
    };
  };
}
