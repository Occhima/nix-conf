{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.partitions ];

  # Development-only inputs and outputs live in the `dev` partition so that
  # normal host evaluation never needs them.
  partitions.dev = {
    extraInputsFlake = ../../dev;
    module.imports = [ ../../dev/flake-module.nix ];
  };

  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    tests = "dev";
  };
}
