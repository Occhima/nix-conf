# Aggregate: foundational NixOS config imported by all NixOS hosts.
# Contains common modules (nix, nixpkgs, nh, system, environment).
# ponytail: single aggregate aspect, split if hosts diverge on which common modules they need.
{ config, ... }:
{
  flake.modules.nixos.system-base.imports = with config.flake.modules.nixos; [
    nix
    nixpkgs-config
    nh
    system-config
    environment-console
    environment-fonts
    environment-locale
    environment-packages
    environment-variables
  ];
}
