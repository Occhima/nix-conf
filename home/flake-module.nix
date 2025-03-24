# { localFlake, lib, ... }:
{
  self,
  config,
  inputs,
  ...
}:

let
  # inherit (localFlake) inputs;
  inherit (self) lib;
  inherit (inputs) home-manager;
  inherit (lib.custom) collectNixModulePaths;
  inherit (lib) concatLists;

  mkHomeConfiguration =
    {
      hostname,
      pkgs,
      username ? "occhima",
      extraModules ? [ ],
    }:

    # maake it user generic
    home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      modules = concatLists [
        [
          ./${username}
        ]
        (collectNixModulePaths "${self}/modules/home-manager")
        extraModules
      ];
      extraSpecialArgs = {
        osConfig = self.nixosConfigurations.${hostname}.config;
        inherit inputs hostname username;
      };

    };

  hostnames = builtins.attrNames config.easy-hosts.hosts;

  homeConfigs = lib.genAttrs (map (hostname: "occhima@${hostname}") hostnames) (
    hostname:
    let
      host = lib.removePrefix "occhima@" hostname;
      pkgs = config.flake.nixosConfigurations.${host}._module.args.pkgs;
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
