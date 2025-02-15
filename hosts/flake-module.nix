# idea stolen from:https://github.com/isabelroses/dotfiles/blob/8638011479e9906ab234fbd759dee9e9828d357e/systems/default.nix
{ localFlake, lib, ... }:
{ ... }:

let
  inherit (localFlake) inputs;
  inherit (lib.custom) collectNixModulePaths;
  inherit (lib) concatLists;

  # Modules
  modulesPath = ../modules;

  # Profiles
  profilesPath = ./profiles; # the base directory for the types module

  common = profilesPath + /common; # common config across all classes
  wsl = profilesPath + /wsl; # for wsl systems
  headless = profilesPath + /headless; # for wsl systems
  desktop = profilesPath + /desktop; # for wsl systems

in
{
  imports = [
    inputs.easy-hosts.flakeModule
    ./deploy.nix
  ];

  config.easy-hosts = {

    perClass = class: {
      modules = concatLists [

        # common  nix  modules stuff aacross all classes
        (collectNixModulePaths common)

        # per class modules
        (collectNixModulePaths "${modulesPath}/${class}")

      ];
    };

    shared = {
      specialArgs = { inherit lib inputs; };
    };

    hosts = {
      crescendoll = {
        deployable = true;
        path = ./crescendoll;
        modules = [
          wsl
          headless
        ];
      };

      steammachine = {
        deployable = true;
        path = ./steammachine;
        modules = [
          desktop
        ];
      };

      # future ISO
      face2face = {
        deployable = false;
        path = ./face2face;
        modules = [
          headless
        ];
      };
    };
  };
}
