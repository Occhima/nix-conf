# Aggregate: HM base — foundational home-manager config.
# Contains home.nix only. nixgl removed: no nixgl flake input, was enable=false in original.
# ponytail: add nixgl back when nixgl input is added to flake.nix.
{ occhima, ... }:
{
  occhima.home-base.includes = with occhima; [
      home
    ];
}
