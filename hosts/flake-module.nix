# idea stolen from:https://github.com/isabelroses/dotfiles/blob/8638011479e9906ab234fbd759dee9e9828d357e/systems/default.nix
{ self, inputs, ... }:
let
  inherit (self) lib;
  inherit (lib) concatLists;
  inherit (lib.lists) optionals;

  mkModulesForClass =
    class:
    concatLists [
      [
        self.nixosModules.${class}
      ]
      (optionals (class != "iso") [ self.nixosModules.common ])
    ];
in
{
  imports = [
    inputs.easy-hosts.flakeModule
  ];

  config.easy-hosts = {

    perClass = class: {
      modules = mkModulesForClass class;
    };

    shared = {
      specialArgs = { inherit lib inputs; };
    };

    hosts = {
      crescendoll = {
        deployable = false;
        path = ./crescendoll;
      };

      aerodynamic = {
        deployable = false;
        path = ./aerodynamic;
      };

      steammachine = {
        deployable = false; # disabled bc of the time to build
        path = ./steammachine;
      };

      voyager = {
        deployable = false;
        path = ./voyager;
        class = "iso";
      };
    };
  };

  # config.nixOnDroidConfigurations = {

  #   draftendirekt = nix-on-droid.lib.nixOnDroidConfiguration {
  #     pkgs = import nixpkgs {
  #       system = "aarch64-linux";
  #       overlays = [
  #         nix-on-droid.overlays.default
  #       ];
  #     };

  #     # modules = mkModulesForClass "android";
  #   };

  # };

}
