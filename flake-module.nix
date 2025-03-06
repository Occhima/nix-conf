### There is a better way to do this... ( use _module.args to pass the same input to everyone, no need for sooooo many importApply... )
{
  localFlake,
  importApply,
  ...
}:
let
  inherit (localFlake)
    inputs
    ;
  inherit (inputs) nixpkgs home-manager;

  customLib = import ./lib nixpkgs;

  lib = customLib // home-manager.lib;

  overlays.default = importApply ./overlays/flake-module.nix { inherit localFlake; };
  hosts.default = importApply ./hosts/flake-module.nix { inherit localFlake lib; };
  home.default = importApply ./home/flake-module.nix {
    inherit
      localFlake
      lib
      ;
  };
  customModules.default = importApply ./modules/flake-module.nix {
    inherit
      localFlake
      lib
      ;
  };
  packages.default = ./packages/flake-module.nix;

in

{

  # NOTE: For debugging, see:
  # https://flake.parts/debug

  # systems = import inputs.systems;
  systems = [ "x86_64-linux" ];
  debug = true;

  imports = [
    inputs.flake-parts.flakeModules.partitions

    overlays.default
    customModules.default
    hosts.default
    home.default
    packages.default
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
    inherit lib overlays;
  };

}
