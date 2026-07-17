# Aggregate: ISO image base. The upstream installation-cd module provides
# the whole installer/ISO option surface (isoImage.*, image.*) — never
# recreate those options locally; our iso-* fragments only customize them.
{ occhima, ... }:
{
  config.occhima.iso-base = {
    includes = with occhima; [
      iso-boot
      iso-fixes
      iso-image
      iso-networking
      iso-nix
      iso-programs
      iso-space
    ];

    nixos =
      { modulesPath, ... }:
      {
        imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix" ];
      };
  };
}
