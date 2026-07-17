# Account policy + Home Manager plumbing for NixOS hosts.
# Accounts are aspects (occhima.user-*); Den attaches each declared host
# user's Home Manager environment. There is no enabled-users list.
{ inputs, ... }:
{
  config.occhima.accounts.nixos =
    { lib, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      options.modules.accounts = {
        mainUser = lib.mkOption {
          type = lib.types.str;
          default = "root";
          description = "Primary interactive user (used by e.g. greetd autologin).";
        };
      };

      config = {
        users.mutableUsers = false;

        home-manager = {
          verbose = true;
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
        };
      };
    };
}
