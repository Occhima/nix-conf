{
  self,
  config,
  inputs,
  ...
}:

let
  inherit (self) lib;
  inherit (inputs) home-manager;
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

  mkHomeConfiguration =
    {
      username,
      hostname ? null,
      extraModules ? [ ],

    }:
    let
      homeModule = if hostname == null then username else "${username}@${hostname}";
    in
    home-manager.lib.homeManagerConfiguration {
      pkgs = self.nixosConfigurations.${hostname}._module.args.pkgs;
      modules = concatLists [
        [
          ./${homeModule}
          self.homeModules.default
        ]

        extraModules
      ];
      extraSpecialArgs = {
        osConfig = self.nixosConfigurations.${hostname}.config;
        inherit
          inputs
          hostname
          username
          self
          ;
      };

    };

in
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeConfigurations = {
    "occhima@face2face" = mkHomeConfiguration {
      username = "occhima";
      hostname = "face2face";
    };
    "occhima" = mkHomeConfiguration {
      username = "occhima";
    };
  };
}
