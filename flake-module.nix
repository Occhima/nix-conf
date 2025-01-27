{ localFlake, importApply, ... }:
{ ... }:
let

  inherit (localFlake)
    inputs
    ;
  inherit (inputs) nixpkgs;

  lib = import ./lib nixpkgs;

  # nixosConfigutarions = { };
  # homeConfigutarions = { };

  # homeModules = haumea.lib.load {
  #   src = ./modules/home;
  #   inputs = {
  #     inherit
  #       inputs
  #       config
  #       options
  #       pkgs
  #       ;
  #   };
  # };
  #
  modules.default = importApply ./modules/flake-module.nix { inherit localFlake lib; };
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
    modules.default

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
      ;
  };

}
