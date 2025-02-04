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

    # perClass = class: {
    #   modules = concatLists [
    #     [
    #       # import the class module, this contains the common configurations between all systems of the same class
    #       "${self}/modules/${class}/default.nix"
    #     ]

    #     (optionals (class != "iso") [
    #       # import the home module, which is users for configuring users via home-manager
    #       "${self}/home/default.nix"

    #       # import the base module, this contains the common configurations between all systems
    #       "${self}/modules/base/default.nix"
    #     ])
    #   ];
    # };

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
