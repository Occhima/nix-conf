# Aggregate: a workstation that also plays games — Steam, OOM tuning and
# nix-ld on top of the shared workstation stack.
{ occhima, ... }:
{
  occhima.gaming-workstation.includes = with occhima; [
    workstation
    steam
    oom
    nix-ld
  ];
}
