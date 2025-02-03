{ localFlake, importApply, ... }:
let
  inherit (localFlake)
    inputs

    ;
  inherit (inputs) nixpkgs;

  lib = import ./lib nixpkgs;

  overlays.default = importApply ./overlays/flake-module.nix { inherit localFlake; };
  hosts.default = importApply ./hosts/flake-module.nix { inherit localFlake lib; };
  mods.default = importApply ./modules/flake-module.nix {
    inherit
      localFlake
      lib
      ;
  };

in

{

  # NOTE: For debugging, see:
  # https://flake.parts/debug

  systems = [ "x86_64-linux" ];
  debug = true;

  imports = [
    inputs.flake-parts.flakeModules.partitions
    overlays.default
    mods.default
    hosts.default
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
    inherit lib;
  };

}
