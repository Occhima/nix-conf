# Account policy + Home Manager plumbing for NixOS hosts.
# Accounts are feature modules (flake.modules.nixos.user-*); Den attaches each declared host
# user's Home Manager environment. There is no enabled-users list.
{ inputs, ... }: {
  flake.modules.nixos.accounts = { lib, config, ... }: {
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
      assertions = [
        {
          assertion = lib.all (home: home.services.flatpak.enable -> config.services.flatpak.enable) (
            lib.attrValues config.home-manager.users
          );
          message = "a user manages flatpaks but the host does not run the flatpak service";
        }
      ];

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
