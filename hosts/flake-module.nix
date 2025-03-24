# idea stolen from:https://github.com/isabelroses/dotfiles/blob/8638011479e9906ab234fbd759dee9e9828d357e/systems/default.nix
{ self, inputs, ... }:
let
  inherit (self) lib;
  inherit (lib.custom) collectNixModulePaths;
  inherit (lib) concatLists optionals;

  # Profiles
  profilesPath = ../modules/profiles; # the base directory for the types module

  wsl = profilesPath + /wsl; # for wsl systems
  headless = profilesPath + /headless; # for wsl systems
  desktop = profilesPath + /desktop; # for wsl systems # for wsl systems

  # TODO...
  # TODO: Turn graphical / laptop in to modules and iso to a proper profile
  graphical = profilesPath + /graphical;
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
        (optionals (class != "iso") (collectNixModulePaths "${self}/modules/profiles/common"))
      ];
    };

    shared = {
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
        deployable = false; # disabled bc of the time to build
        path = ./steammachine;
        modules = [
          desktop
          graphical
        ];
      };

      # Minmal VM
      face2face = {
        deployable = true;
        path = ./face2face;
        modules = [
          desktop
        ];
      };

      # ISO
      voyager = {
        deployable = false;
        path = ./voyager;
        class = "iso";
        modules = [
          headless
        ];
      };
    };
  };
}
