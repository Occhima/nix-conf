{
  gum,
  vim,
  disko,
  openssh,
  nix-output-monitor,
  nixos-install-tools,
  writeShellApplication,
}:
writeShellApplication {
  name = "install-tools";

  runtimeInputs = [
    gum
    vim
    openssh
    disko
    nixos-install-tools
    nix-output-monitor
  ];

  text = builtins.readFile ./install-script.sh;
}
