{
  inputs,
  partitionStack,
  config,
  ...
}:
let
  inherit (inputs) nixpkgs home-manager;
  customLib = import ./lib nixpkgs;
  lib = customLib // home-manager.lib;
in

{

  systems = [ "x86_64-linux" ];
  # debug = true;

  imports = [
    ./overlays/flake-module.nix
    ./packages/flake-module.nix
    ./apps/flake-module.nix

    ./modules
    inputs.flake-parts.flakeModules.partitions
  ];

  partitions = {
    dev = {
      extraInputsFlake = ./dev;
      module.imports = [ ./dev/flake-module.nix ];
    };
  };

  # partitions
  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    tests = "dev";
  };

  # Stolen from the nixvim github repo
  perSystem =
    { system, ... }:
    {
      packages = lib.optionalAttrs (partitionStack == [ ]) {
        inherit (config.partitions.dev.module.flake.packages.${system})
          render-workflows
          ;
      };
    };

  flake = {
    inherit lib;
  };

}
