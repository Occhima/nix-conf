{
  config,
  lib,
  inputs,
  pkgs,
  self,
  ...
}:

with lib;
with lib.types;
with lib.attrsets;
with lib.custom;

let
  cfg = config.modules.accounts;
  allUsers = {
    occhima = import ./users/occhima.nix { inherit pkgs lib config; };
    root = ./users/root.nix;
  };

  mkHomeManagerConfig = username: import "${self}/home/${username}";
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.modules.accounts = {
    enable = mkEnableOption "User account management with home-manager integration";

    enabledUsers = mkOption {
      type = types.listOf types.str;
      default = [ "root" ];
      example = [
        "alice"
        "bob"
        "root"
      ];
      description = "List of usernames to enable from the accounts/users directory";
    };

    enableHomeManager = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable home-manager for normal users (excluding root)";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = all (user: hasAttr user allUsers) cfg.enabledUsers;
        message = "Some users in enabledUsers are not defined in allUsers: ${
          toString (filter (user: !(hasAttr user allUsers)) cfg.enabledUsers)
        }";
      }
    ];

    users.users = filterAttrs (username: _: elem username cfg.enabledUsers) allUsers;
    users.mutableUsers = false;

    home-manager = mkIf cfg.enableHomeManager {
      verbose = true;

      # FIXME: pkgs should be global but home-manager is not picking up my overlays, I don't know but there's a probably a bug in my config
      useGlobalPkgs = false;

      useUserPackages = true;
      backupFileExtension = "bak";

      sharedModules = collectNixModulePaths "${self}/modules/home-manager";

      extraSpecialArgs = {
        inherit
          hostname
          inputs
          self
          ;
      };

      users = genAttrs (filter (username: username != "root" && elem username cfg.enabledUsers) (
        attrNames allUsers
      )) mkHomeManagerConfig;
    };
  };
}
