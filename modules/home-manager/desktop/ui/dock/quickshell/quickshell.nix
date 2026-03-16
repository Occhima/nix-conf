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

  qs-logout = pkgs.writeShellScriptBin "qs-logout" ''
    ${
      if config.modules.desktop.apps.wlogout.enable then
        "${pkgs.wlogout}/bin/wlogout"
      else
        "loginctl terminate-session"
    }
  '';

  qs-lock = pkgs.writeShellScriptBin "qs-lock" ''
    ${if cfg.locker == "hyprlock" then "${pkgs.hyprlock}/bin/hyprlock" else "loginctl lock-session"}
  '';

  qs-network-settings = pkgs.writeShellScriptBin "qs-network-settings" ''
    exec ${pkgs.networkmanagerapplet}/bin/nm-connection-editor
  '';
in
{
  config = mkIf (cfg.dock == "quickshell") {
    home.packages = [
      qs-logout
      qs-lock
      qs-network-settings
    ];

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
