# Account policy + integrated Home Manager wiring.
# Users are aspects: hosts import `user-occhima` / `user-root` (defined
# under modules/users/) next to this base aspect. Importing a user aspect
# creates the account — there is no enabled-users list.
{ inputs, ... }:
{
  config.flake.modules.nixos.accounts =
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
