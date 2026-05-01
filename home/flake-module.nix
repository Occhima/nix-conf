{
  self,
  inputs,
  ...
}:

let
  inherit (self) lib;
  inherit (inputs) home-manager nixpkgs;
  inherit (lib) concatLists;

  # stolen from: https://github.com/MattSturgeon/nix-config/blob/main/hosts/flake-module.nix
  # guessUsername =
  #   name:
  #   let
  #     parts = lib.splitString "@" name;
  #     len = builtins.length parts;
  #   in
  #   if len == 2 then builtins.head parts else name;

  # guessHostname =
  #   name:
  #   let
  #     parts = lib.splitString "@" name;
  #     len = builtins.length parts;
  #   in
  #   lib.optionalString (len == 2) (builtins.elemAt parts 1);
  #
  mkHomeConfiguration =
    {
      path,
      system,
      extraModules ? [ ],

    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;

        # TODO: Use the same value from common/nixpkgs?
        overlays = builtins.attrValues self.overlays;
        config = {
          allowUnfree = true;
          allowBroken = false;
          allowUnsupportedSystem = false;

        };

      };
      modules = concatLists [
        [
          ./${path}
          self.homeModules.default
        ]

        extraModules
      ];
      extraSpecialArgs = {
        inherit
          inputs
          self
          lib
          ;
        osConfig = {
          modules = {
            system.display.type = "";
            hardware = {
              monitors = {
                primaryMonitorName = "dp1";
                displays = {
                  dp1 = {
                    output = "DP-1";
                    mode = "2560x1080@180";
                    position = "0x0";
                  };
                };
              };
              yubikey.enable = false;
            };
            services.steam.enable = false;
            secrets.agenix.enable = false;
          };
          users.users = { };
          programs.steam.package = null;
          age.secrets = { };
        };
      };

    };

in
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeConfigurations = {
    occhima = mkHomeConfiguration {
      path = "occhima";
      # TODO: how can I do this systemagnostic?.
      system = "x86_64-linux";
    };
  };
}
