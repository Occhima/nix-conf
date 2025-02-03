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

in
{

  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  flake = {
    modules = {
      nixos = nixosModules;
      home = { };
    };
    nixosModules = config.flake.modules.nixos;
  };
}
