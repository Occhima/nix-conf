# Nixvim flake plumbing. `flake.nixvimModules` is declared here as a
# mergeable option so every fragment under modules/nixvim/ contributes to
# `flake.nixvimModules.default` independently; the merged module is
# evaluated into the `nvim` configuration and its packages.
{
  config,
  inputs,
  lib,
  flake-parts-lib,
  ...
}:
{
  imports = [ inputs.nixvim.flakeModules.default ];

  options.flake = flake-parts-lib.mkSubmoduleOptions {
    nixvimModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
      description = "Nixvim modules assembled from independent fragment files.";
    };
  };

  config = {
    nixvim = {
      packages.enable = true;
      checks.enable = false;
    };

    perSystem =
      { system, ... }:
      {
        nixvimConfigurations = {
          nvim = inputs.nixvim.lib.evalNixvim {
            inherit system;
            modules = [ config.flake.nixvimModules.default ];
          };
        };
      };
  };
}
