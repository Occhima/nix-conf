{
  gum,
  vim,
  disko,
  nix-output-monitor,
  nixos-install-tools,
  writeShellApplication,
}:
writeShellApplication {
  name = "install-tools";

  runtimeInputs = [
    gum
    vim
    disko
    nixos-install-tools
    nix-output-monitor
  ];

  text = builtins.readFile ./install-script.sh;
}
