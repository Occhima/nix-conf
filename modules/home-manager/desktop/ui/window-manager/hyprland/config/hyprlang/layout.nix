{ ... }:
{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings.dwindle = {
      preserve_split = true;
    };
  };
}
