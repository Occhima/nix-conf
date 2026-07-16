{ ... }:
{
  config.flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = null;
      portalPackage = null;
      settings.ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      configType = "hyprlang"; # Bc some of my plugins rely on this

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
