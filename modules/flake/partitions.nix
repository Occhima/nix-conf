# Development partition: dev-only inputs (formatters, test runners, CI
# tooling) live in ./_dev (its own flake + lock, skipped by import-tree)
# and never enter host evaluation.
{
  config,
  inputs,
  lib,
  partitionStack,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.partitions ];

  partitions.dev = {
    extraInputsFlake = ./_dev;
    module.imports = [ ./_dev/flake-module.nix ];
  };

  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    tests = "dev";
  };

  perSystem =
    { system, ... }:
    {
      # Surface selected dev-partition packages on the main flake.
      packages = lib.optionalAttrs (partitionStack == [ ]) {
        inherit (config.partitions.dev.module.flake.packages.${system})
          render-workflows
          ;
      };
    };
}
