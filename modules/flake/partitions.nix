# Development partition: dev-only inputs (formatters, test runners, CI
# tooling) live in ./_dev (its own flake + lock, skipped by import-tree)
# and never enter host evaluation.
{ inputs, ... }: {
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
}
