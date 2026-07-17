{ ... }:
{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings.animations = {
      enabled = true;
    };
  };
}
