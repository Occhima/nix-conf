{ localFlake, importApply, ... }:
{ ... }:
let

  inherit (localFlake) inputs config;

  lib = import ./lib/flake-module.nix { inherit inputs; };
  nixosModules = import ./modules/flake-module.nix { inherit inputs config; };
  overlays.default = importApply ./overlays/flake-module.nix { inherit localFlake; };

in

{

  # NOTE: For debugging, see:
  # https://flake.parts/debug
  debug = true;

  systems = import inputs.systems;
  imports = [
    inputs.flake-parts.flakeModules.partitions
    overlays.default
    ./parts/flake-module.nix
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
