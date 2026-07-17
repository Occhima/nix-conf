{ ... }:
{
  flake.modules.homeManager.hyprland =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.hyprpicker ];
      wayland.windowManager.hyprland.settings.bind = [
        "$mainMod, C, exec, ${lib.getExe pkgs.hyprpicker}"
      ];
    };
}
