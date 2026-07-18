# Aggregate: ISO image base. The upstream installation-cd module provides
# the whole installer/ISO option surface (isoImage.*, image.*) — never
# recreate those options locally; our iso-* fragments only customize them.
{ config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.iso-base.imports = [
    nixos.iso-boot
    nixos.iso-fixes
    nixos.iso-image
    nixos.iso-networking
    nixos.iso-nix
    nixos.iso-programs
    nixos.iso-space
    (
      { modulesPath, ... }:
      {
        imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix" ];
      }
    )
  ];
}
