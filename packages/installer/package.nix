{
  gum,
  vim,
  disko,
  openssh,
  nix-output-monitor,
  nixos-install,
  writeShellApplication,
}:
writeShellApplication {
  name = "custom-installtools";

  runtimeInputs = [
    gum
    vim
    openssh
    disko
    nixos-install
    nix-output-monitor
  ];

  text = builtins.readFile ./install-script.sh;
}
