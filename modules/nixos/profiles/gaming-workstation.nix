# Aggregate: a workstation that also plays games — Steam, OOM tuning and
# nix-ld on top of the shared workstation stack.
{ occhima, ... }:
{
  config.occhima.gaming-workstation.includes = with occhima; [
    workstation
    steam
    oom
    nix-ld
  ];
}
