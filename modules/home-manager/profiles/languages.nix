# Aggregate: development language toolchains in daily use.
{ config, ... }:
{
  config.flake.modules.homeManager.languages = {
    imports = with config.flake.modules.homeManager; [
      python
      c
      julia
    ];
  };
}
