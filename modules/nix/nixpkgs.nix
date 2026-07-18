# Cross-cutting nixpkgs policy. The single source of truth lives in
# flake.lib.custom.nixpkgsConfig so NixOS hosts, standalone homes and any
# future class share it instead of duplicating the attrset.
{ config, ... }:
{
  flake.lib.custom.nixpkgsConfig = {
    allowUnfree = true;
    allowBroken = false;
    permittedInsecurePackages = [ ];
    allowUnsupportedSystem = false;
  };

  flake.modules.nixos.nixpkgs-config = {
    nixpkgs.config = config.flake.lib.custom.nixpkgsConfig;
    nixpkgs.overlays = builtins.attrValues config.flake.overlays;
  };

  # For homes not managed by a NixOS host (den.homes / other distros);
  # NixOS-managed homes inherit the host's pkgs via useGlobalPkgs.
  flake.modules.homeManager.nixpkgs-config = {
    nixpkgs.config = config.flake.lib.custom.nixpkgsConfig;
    nixpkgs.overlays = builtins.attrValues config.flake.overlays;
  };
}
