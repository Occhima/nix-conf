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
  # For any output attrs normally defined by the root flake configuration,
  # any exceptions must be manually propagated from the `dev` partition.
  #
  # NOTE: Attrs should be explicitly propagated at the deepest level.
  # Otherwise the partition won't be lazy, making it pointless.
  # E.g. propagate `packages.${system}.foo` instead of `packages.${system}`
  # See: https://github.com/hercules-ci/flake-parts/issues/258
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
