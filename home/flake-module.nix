{ localFlake, lib, ... }:
{ ... }:

let
  inherit (localFlake) inputs;
  inherit (inputs) home-manager;
  inherit (lib.custom) collectNixModulePaths;

  sharedModules = collectNixModulePaths ../modules/home-manager;

  mkHomeConfiguration =
    {
      hostname,
      pkgs,
      extraModules ? [ ],

    }:
    home-manager.lib.homeManagerConfiguration {
      # maybe this is not necessary, see useGlobalPkgs;
      pkgs = pkgs;

      modules =
        [
          ./occhima
        ]
        ++ sharedModules
        ++ extraModules;

      extraSpecialArgs = {
        inherit inputs hostname;
      };
    };

  # Get hostnames from nixosConfigurations
  hostnames = builtins.attrNames localFlake.config.easy-hosts.hosts;

  # Create home configurations for each host
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
