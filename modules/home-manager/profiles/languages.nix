# Aggregate: development language toolchains in daily use.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  # hm.julia is intentionally NOT imported: even plain `pkgs.julia` performs
  # import-from-derivation on this pinned nixpkgs (its julia-sources.nix is
  # built and read back during evaluation), which the flake-wide no-IFD gate
  # forbids. The module stays available for hosts that accept IFD.
  flake.modules.homeManager.languages.imports = [
    hm.python
    hm.c
  ];
}
