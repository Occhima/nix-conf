# Aggregate: ISO image base — modules from modules/iso/.
# ponytail: single aggregate, split if ISO variants diverge.
{
  inputs,
  ...
}:
{
  config.flake.modules.nixos.iso-base = {
    imports = with inputs.self.modules.nixos; [
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
