{ localFlake, lib, ... }:
{ ... }:

let
  inherit (localFlake) inputs;
  inherit (lib.custom) collectNixModulePaths;

  profilesPath = ../modules/profiles; # the base directory for the types module

  wsl = profilesPath + /wsl; # for wsl systems
  headless = profilesPath + /headless; # for wsl systems

in
{
  imports = [
    inputs.easy-hosts.flakeModule
    ./deploy.nix
  ];

  config.easy-hosts = {
    shared = {
      specialArgs = { inherit lib inputs; };
      modules = collectNixModulePaths ../modules/nixos;
    };

    hosts = {
      sus = {
        deployable = true;
        path = ./sus;
        modules = [
          wsl
          headless
        ];
      };
    };
  };
}
