{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui;

  quickshellConfigDir = ./quickshell;
in
{
  config = mkIf (cfg.dock == "quickshell") {
    home.packages = with pkgs; [
      quickshell
      qt6.qtimageformats
      adwaita-icon-theme
      kdePackages.kirigami
      pavucontrol
    ];

    xdg.configFile."quickshell" = {
      source = quickshellConfigDir;
      recursive = true;
    };

    systemd.user.services.quickshell = {
      Unit = {
        Description = "Quickshell desktop shell";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.quickshell}/bin/quickshell";
        Restart = "on-failure";
        RestartSec = 3;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
