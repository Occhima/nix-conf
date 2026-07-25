# Aggregate: foundational NixOS config imported by all NixOS hosts.
# Contains common modules (nix, nixpkgs, nh, system, environment).
# ponytail: single aggregate module, split if hosts diverge on which common modules they need.
{ config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.system-base.imports = [
    nixos.nix
    nixos.nixpkgs-config
    nixos.nh
    nixos.system-config
    nixos.environment-console
    nixos.environment-fonts
    nixos.environment-locale
    nixos.environment-packages
  ];
}
