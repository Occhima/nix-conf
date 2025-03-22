{
  # modules.device.type = "headless";
  imports = [
    ./documentation.nix
    ./environment.nix
    ./fonts.nix
    ./services.nix
    ./systemd.nix
    ./xdg.nix
  ];

}
