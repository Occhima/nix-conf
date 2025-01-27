{ localFlake, ... }:
{ ... }:
let
  inherit (localFlake)
    inputs
    config
    options
    pkgs
    ;
  inherit (inputs) haumea;

  nixModules = haumea.lib.load {
    src = ./nixos;
    inputs = {
      inherit
        inputs
        config
        options
        pkgs
        ;
    };
  };

  # homeModules = haumea.lib.load {
  #   src = ./home-manager;
  #   inputs = {
  #     inherit
  #       inputs
  #       config
  #       options
  #       pkgs
  #       ;
  #   };
  # };

in
{

  flake = {
    nixosModules = nixModules;

  };
}
