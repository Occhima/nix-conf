# System flatpak daemon for hosts (needs xdg portals — workstation
# includes display-portals). The Home Manager `flatpak` aspect manages
# the user's apps and is deliberately a separate feature.
{ ... }:
{
  flake.modules.nixos.flatpak-daemon = {
    config = {
      services.flatpak.enable = true;
    };
  };
}
