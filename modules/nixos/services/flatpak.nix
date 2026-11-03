{
  flake.modules.nixos.flatpak-daemon = {
    config = {
      services.flatpak.enable = true;
    };
  };
}
