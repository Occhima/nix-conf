{
  localFlake,
  ...
}:
let
  inherit (localFlake)
    inputs
    ;
  inherit (inputs) nixpkgs home-manager;

  customLib = import ./lib nixpkgs;

  lib = customLib // home-manager.lib;

in

{

  # NOTE: For debugging, see:
  # https://flake.parts/debug

  # systems = import inputs.systems;
  systems = [ "x86_64-linux" ];
  debug = true;

  imports = [

    inputs.flake-parts.flakeModules.partitions

    ./overlays/flake-module.nix
    ./hosts/flake-module.nix
    ./modules/flake-module.nix
    ./home/flake-module.nix
    ./packages/flake-module.nix
  ];

  # partitions
  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    agenix-rekey = "dev";
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
