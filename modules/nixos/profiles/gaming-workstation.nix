# Aggregate: a workstation that also plays games — Steam, OOM tuning and
# nix-ld on top of the shared workstation stack.
{ config, ... }:
{
  flake.modules.nixos.gaming-workstation.imports = with config.flake.modules.nixos; [
    workstation
    steam
    oom
    nix-ld
  ];
}
