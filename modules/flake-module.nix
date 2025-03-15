{ localFlake, lib, ... }:
{
  ...
}:
let
  inherit (localFlake)
    inputs
    config
    pkgs
    options
    ;
  inherit (inputs) haumea;

  nixosModules = haumea.lib.load {
    src = ./nixos;

    inputs = {
      inherit
        inputs
        config
        options
        lib
        pkgs
        ;
    };

  };

  homeManagerModules = haumea.lib.load {
    src = ./home-manager;

    inputs = {
      inherit
        inputs
        config
        options
        lib
        pkgs
        ;
    };

  };

in
{

  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  flake = {
    modules = {
      nixos = nixosModules;
      home = homeManagerModules;
    };
    nixosModules = config.flake.modules.nixos;
    homeModules = config.flake.modules.home;
  };
}
