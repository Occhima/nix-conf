# Aggregate: ISO image base — modules from modules/iso/.
# ponytail: single aggregate, split if ISO variants diverge.
{ config, ... }:
{
  config.flake.modules.nixos.iso-base = {
    imports = with config.flake.modules.nixos; [
      iso-boot
      iso-fixes
      iso-image
      iso-networking
      iso-nix
      iso-programs
      iso-space
    ];
  };
}
