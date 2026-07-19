# Cross-cutting Nix policy modules.
#
# Hosts and standalone homes read nixpkgs.config + overlays from
# `flake.lib.custom.nixpkgsConfig` via the `nixpkgs-config` class modules.
# Consumer modules register their unfree packages by appending to
# `flake.allowedUnfreePackages` (allowUnfreePredicate is a single function
# option — it cannot be defined per-module, so the list is the per-module knob).
{ config, lib, ... }:
{
  options.flake.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Unfree package names allowed by nixpkgs.config.allowUnfreePredicate.";
  };

  options.flake.allowedUnfreePredicates = lib.mkOption {
    type = lib.types.listOf (lib.types.functionTo lib.types.bool);
    default = [ ];
    description = "Extra allowUnfree checks, appended by modules (e.g. cuda family prefixes).";
  };

  config = {
    flake.lib.custom.nixpkgsConfig = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) config.flake.allowedUnfreePackages
        || builtins.any (p: p pkg) config.flake.allowedUnfreePredicates;
      allowBroken = false;
      permittedInsecurePackages = [
        # vesktop wraps electron; nixpkgs marks this EOL version insecure until it bumps.
        "electron-40.10.5"
      ];
      allowUnsupportedSystem = false;
    };

    # Single place where host/user configs read shared nixpkgs policy.
    flake.modules.nixos.nixpkgs-config = {
      nixpkgs.config = config.flake.lib.custom.nixpkgsConfig;
      nixpkgs.overlays = builtins.attrValues config.flake.overlays;
    };

    flake.modules.homeManager.nixpkgs-config = {
      nixpkgs.config = config.flake.lib.custom.nixpkgsConfig;
      nixpkgs.overlays = builtins.attrValues config.flake.overlays;
    };
  };
}
