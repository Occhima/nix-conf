{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui;
in
{

  imports = [
    ./config/hyprlang
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

      configType = "hyprlang";

      systemd = {
        enable = true;
        variables = [ "--all" ];
        extraCommands = [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };

    };
  };
}
