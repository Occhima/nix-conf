# idea stolen from:https://github.com/isabelroses/dotfiles/blob/8638011479e9906ab234fbd759dee9e9828d357e/systems/default.nix
{ localFlake, lib, ... }:
{ ... }:

let
  inherit (localFlake) inputs;
  inherit (lib.custom) collectNixModulePaths;
  inherit (lib) concatLists;

  profilesPath = ./class/profiles; # the base directory for the types module

  wsl = profilesPath + /wsl; # for wsl systems
  headless = profilesPath + /headless; # for wsl systems

in
{
  imports = [
    inputs.easy-hosts.flakeModule
    ./deploy.nix
  ];

  config.easy-hosts = {

    perClass = class: {
      modules = concatLists [

        # From class
        (collectNixModulePaths ./class/${class})

        # common  nix stuff aacross a
        (collectNixModulePaths ./class/common)

        # all of my nixos modules
        (collectNixModulePaths ../modules/nixos)

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
    };
  };
}
