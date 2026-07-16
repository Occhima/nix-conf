{
  inputs,
  partitionStack,
  config,
  self,
  ...
}:
let
  inherit (inputs) nixpkgs home-manager;
  customLib = import ./lib nixpkgs;
  lib = customLib // home-manager.lib;
in

{
  systems = [ "x86_64-linux" ];

  imports = [
    inputs.flake-parts.flakeModules.partitions
  ];

  partitions = {
    dev = {
      extraInputsFlake = ../dev;
      module.imports = [ ../dev/flake-module.nix ];
    };
  };

  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    tests = "dev";
  };

  perSystem =
    {
      system,
      ...
    }:
    {
      packages = lib.optionalAttrs (partitionStack == [ ]) {
        inherit (config.partitions.dev.module.flake.packages.${system})
          render-workflows
          ;
      };
      _module.args.pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = false;
        };
        overlays = builtins.attrValues self.overlays;
      };
    };

  flake = {
    inherit lib;
  };
}
