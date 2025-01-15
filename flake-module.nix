localFlake:
{ ... }:
let

  inherit (localFlake) inputs;
in
# parts = { };
{

  # NOTE: For debugging, see:
  # https://flake.parts/debug
  debug = true;

  systems = import inputs.systems;
  imports = [
    inputs.flake-parts.flakeModules.partitions
    ./lib/flake-module.nix
    ./overlays/flake-module.nix
  ];

  # partitions
  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    githubActions = "dev";
    tests = "dev";
  };

  partitions = {
    dev = {
      extraInputsFlake = ./dev;
      module.imports = [ ./dev/flake-module.nix ];
    };

  };

  # flake = {};

}
