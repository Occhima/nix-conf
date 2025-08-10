{
  config,
  osConfig,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui;
  usingUWSM = !osConfig.programs.hyprland.withUWSM or true;
in
{

  imports = [
    ./config
  ];
  config = lib.mkIf (cfg.windowManager == "hyprland") {

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = null;
      portalPackage = null;
      settings.ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      systemd = {
        enable = usingUWSM;
        variables = [ "--all" ];
        extraCommands = [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };

    };
  };
}
