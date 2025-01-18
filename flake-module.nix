{ localFlake, ... }:
{ ... }:
let

  inherit (localFlake) inputs;

  lib = import ./lib/flake-module.nix { inherit inputs; };
  nixosModules = import ./modules/flake-module.nix { inherit lib; };
in

{

  # NOTE: For debugging, see:
  # https://flake.parts/debug
  debug = true;

  systems = import inputs.systems;
  imports = [
    inputs.flake-parts.flakeModules.partitions
    ./parts

    # FIXME: Still don't understand how overlays works
    # ./overlays/flake-module.nix
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

  flake = {
    inherit lib nixosModules;
  };

}
