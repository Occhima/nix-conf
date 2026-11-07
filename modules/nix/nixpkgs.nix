# Cross-cutting Nix policy modules.
#
# Modules register their own unfree package names by appending to
# `config.nixpkgs.allowedUnfree`; the shared nixpkgsConfig turns the merged
# list into allowUnfreePredicate. Internal package sets apply the explicit
# internal overlay list; exported overlay outputs stay public.
{
  config,
  inputs,
  lib,
  ...
}:
let
  # cudaPackages ship dozens of components (cuda-merged, cuda_cuobjdump,
  # libcublas, libnpp, ...) — the active NVIDIA configuration requires the
  # family prefixes, matched narrowly.
  cudaFamilyPredicate =
    pkg:
    builtins.match "^(cuda.*|cudnn.*|libcu.*|libnpp.*|libnv.*)$" (lib.getName pkg) != null
    || lib.any (l: (l.shortName or "") == "CUDA EULA") (lib.toList (pkg.meta.license or [ ]));
in
{
  options.nixpkgs.allowedUnfree = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Unfree package names allowed by nixpkgs.config.allowUnfreePredicate.";
  };

  options.nixpkgs.internalOverlays = lib.mkOption {
    type = lib.types.listOf lib.types.raw;
    default = [ ];
    description = "Overlays applied to every internal package set (hosts, standalone homes, perSystem).";
  };

  config = {
    flake.lib.custom.nixpkgsConfig = {
      allowUnfreePredicate =
        pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfree || cudaFamilyPredicate pkg;
      allowBroken = false;
      # No insecure packages are permitted anywhere.
      permittedInsecurePackages = [ ];
      allowUnsupportedSystem = false;
    };

    flake.lib.custom.mkPkgs =
      {
        system,
        overlays ? config.nixpkgs.internalOverlays,
      }:
      import inputs.nixpkgs {
        inherit system overlays;
        config = config.flake.lib.custom.nixpkgsConfig;
      };

    flake.modules.nixos.nixpkgs-config =
      let
        nixpkgsConfig = config.flake.lib.custom.nixpkgsConfig;
        overlays = config.nixpkgs.internalOverlays;
      in
      { config, ... }:
      {
        nixpkgs = {
          config = nixpkgsConfig;
          inherit overlays;
        };

        assertions = [
          {
            assertion =
              !(lib.any (lib.hasPrefix "electron-") (config.nixpkgs.config.permittedInsecurePackages or [ ]));
            message = "no host may reopen an insecure electron";
          }
        ];
      };
  };
}
