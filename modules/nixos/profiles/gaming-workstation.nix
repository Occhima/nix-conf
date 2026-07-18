# Aggregate: a workstation that also plays games — Steam, OOM tuning and
# nix-ld on top of the shared workstation stack.
{ config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.gaming-workstation.imports = [
    nixos.workstation
    nixos.steam
    nixos.oom
    nixos.nix-ld
  ];
}
