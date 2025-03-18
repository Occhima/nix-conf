# idea stolen from:https://github.com/isabelroses/dotfiles/blob/8638011479e9906ab234fbd759dee9e9828d357e/systems/default.nix
{ localFlake, lib, ... }:
{ self, ... }:

let
  inherit (localFlake) inputs;
  inherit (lib.custom) collectNixModulePaths;
  inherit (lib) concatLists;

  # Profiles
  profilesPath = ../modules/profiles; # the base directory for the types module

  common = profilesPath + /common; # common config across all classes
  wsl = profilesPath + /wsl; # for wsl systems
  headless = profilesPath + /headless; # for wsl systems
  desktop = profilesPath + /desktop; # for wsl systems # for wsl systems

  # TODO...
  # TODO: Turn graphical / laptop in to modules and iso to a proper profile
  # graphical = profilesPath + /graphical;
  # laptop = profilesPath + /laptop;
  # iso = profilesPath + /iso;

in
{
  imports = [
    inputs.easy-hosts.flakeModule
    ./deploy.nix
  ];

  config.easy-hosts = {

    perClass = class: {
      modules = concatLists [
        (collectNixModulePaths "${self}/modules/${class}")
      ];
    };

    shared = {
      modules = collectNixModulePaths common;
      specialArgs = { inherit lib inputs; };
    };

    hosts = {
      crescendoll = {
        deployable = false;
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

      # Minmal VM
      face2face = {
        deployable = true;
        path = ./face2face;
        modules = [
          desktop
          headless
        ];
      };

      # ISO
      # voyager = {
      #   deployable = false;
      #   path = ./voyager;
      #   modules = [
      #     iso
      #   ];
      # };
    };
  };
}
