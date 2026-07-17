{ ... }:
{
  config.occhima.flatpak.nixos = {
    config = {
      services.flatpak.enable = true;
    };
  };
}
