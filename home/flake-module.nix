{ localFlake, lib, ... }:
{ config, self, ... }:

let
  inherit (localFlake) inputs;
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
        inherit inputs hostname username;
      };

    };

  hostnames = builtins.attrNames localFlake.config.easy-hosts.hosts;

  homeConfigs = lib.genAttrs (map (hostname: "occhima@${hostname}") hostnames) (
    hostname:
    let
      host = lib.removePrefix "occhima@" hostname;
      pkgs = localFlake.config.flake.nixosConfigurations.${host}._module.args.pkgs;
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
