# Aggregate: HM base — foundational home-manager config.
# Contains home.nix only. nixgl removed: no nixgl flake input, was enable=false in original.
# ponytail: add nixgl back when nixgl input is added to flake.nix.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.home-base.imports = [
    hm.home
  ];
}
