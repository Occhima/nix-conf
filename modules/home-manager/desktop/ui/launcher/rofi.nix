{ ... }:
{
  flake.modules.homeManager.rofi =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.rofi-bluetooth
        pkgs.rofi-power-menu
      ];

      programs.rofi = {
        enable = true;
        cycle = true;
      };

      wayland.windowManager.hyprland.settings.bind = [
        "$mainMod, SPACE, exec, rofi -show drun"
        "$mainMod, B, exec, rofi-bluetooth"
        "$mainMod, P, exec, rofi -show power-menu -modi power-menu:rofi-power-menu"
      ];
    };
}
