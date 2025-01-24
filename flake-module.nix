{ localFlake, importApply, ... }:
{ ... }:
let

  inherit (localFlake)
    inputs
    config
    options
    pkgs
    ;
  inherit (inputs) haumea nixpkgs;

  lib = import ./lib nixpkgs;

  nixosModules = haumea.lib.load {
    src = ./modules;
    inputs = {
      inherit
        inputs
        config
        options
        pkgs
        ;
    };
  };

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
    inherit
      lib
      nixosModules
      overlays
      ;
  };

}
