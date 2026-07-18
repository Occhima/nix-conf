# Aggregate: development language toolchains in daily use.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.languages.imports = [
    hm.python
    hm.c
    hm.julia
  ];
}
