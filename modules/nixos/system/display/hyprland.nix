# System-side Hyprland enablement. The Home Manager module
# (modules/home-manager/desktop/ui/window-manager/hyprland/hyprland.nix)
# sets `wayland.windowManager.hyprland.package = null` expecting the host
# to provide the hyprland binary and register the wayland session.
# Importing this module does both: `programs.hyprland.enable = true`
# installs hyprland system-wide and registers `hyprland.desktop` under
# /run/current-system/sw/share/wayland-sessions/, which Ly (and greetd)
# pick up automatically.
{
  flake.modules.nixos.display-hyprland = { pkgs, ... }: {
    programs.hyprland.enable = true;
    services.displayManager.sessionPackages = [ pkgs.hyprland ];
    environment.etc."greetd/environments".text = "Hyprland";

  };
}
