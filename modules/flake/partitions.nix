# Development partition: dev-only inputs (formatters, test runners, CI
# tooling) live in dev/flake.nix and never enter host evaluation.
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
    extraInputsFlake = ../../dev;
    module.imports = [ ../../dev/flake-module.nix ];
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
