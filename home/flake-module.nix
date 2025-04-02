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
      hostname,
      pkgs,
      username ? "occhima",
      extraModules ? [ ],
    }:

    home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      modules = concatLists [
        [
          ./${username}
          self.homeManagerModules.default
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

  hostnames = builtins.attrNames config.easy-hosts.hosts;

  homeConfigs = lib.genAttrs (map (hostname: "occhima@${hostname}") hostnames) (
    hostname:
    let
      host = lib.removePrefix "occhima@" hostname;
      pkgs = self.nixosConfigurations.${host}._module.args.pkgs;
    in
    mkHomeConfiguration {
      hostname = host;
      pkgs = pkgs;
    }
  );
in
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeConfigurations = homeConfigs;
}
