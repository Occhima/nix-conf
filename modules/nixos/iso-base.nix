# Aggregate: ISO image base. The upstream installation-cd module provides
# the whole installer/ISO option surface (isoImage.*, image.*) — never
# recreate those options locally; our iso-* fragments only customize them.
{ config, ... }:
{
  flake.modules.nixos.iso-base.imports = with config.flake.modules.nixos; [
    iso-boot
    iso-fixes
    iso-image
    iso-networking
    iso-nix
    iso-programs
    iso-space
    (
      { modulesPath, ... }:
      {
        imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix" ];
      }
    )
  ];
}
