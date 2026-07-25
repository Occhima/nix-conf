# Cross-cutting Nix policy modules.
#
# Modules register their own unfree package names by appending to
# `config.nixpkgs.allowedUnfree`; the shared nixpkgsConfig turns the merged
# list into allowUnfreePredicate. Internal package sets apply the explicit
# internal overlay list; exported overlay outputs stay public.
{
  config,
  lib,
  ...
}:
let
  # cudaPackages ship dozens of components (cuda-merged, cuda_cuobjdump,
  # libcublas, libnpp, ...) — the active NVIDIA configuration requires the
  # family prefixes, matched narrowly.
  cudaFamilyPredicate =
    pkg: builtins.match "^(cuda.*|cudnn.*|libcu.*|libnpp.*|libnv.*)$" (lib.getName pkg) != null;
in
{
  options.nixpkgs.allowedUnfree = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Unfree package names allowed by nixpkgs.config.allowUnfreePredicate.";
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

    flake.modules.nixos.nixpkgs-config = {
      nixpkgs.config = config.flake.lib.custom.nixpkgsConfig;
      nixpkgs.overlays = [
        config.flake.overlays.emacs-overlay
        config.flake.overlays.nur
      ];
    };
  };
}
