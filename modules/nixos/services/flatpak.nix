{ ... }:
{
  config.flake.modules.nixos.flatpak = {
    config = {
      services.flatpak.enable = true;
    };
  };
}
