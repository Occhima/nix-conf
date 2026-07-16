{
  inputs,
  self,
  ...
}:
{
  config.flake.modules.nixos.accounts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        all
        filter
        elem
        toString
        mkOption
        types
        ;
      inherit (lib.attrsets)
        filterAttrs
        hasAttr
        genAttrs
        ;

      hostname = config.networking.hostName;
      cfg = config.modules.accounts;
      allUsers = {
        occhima = import ./_users/occhima.nix { inherit pkgs lib config; };
        root = ./_users/root.nix;
      };
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      options.modules.accounts = {
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

        mainUser = mkOption {
          type = types.str;
          default = "root";
          description = "Main user in nixos";
        };

        enableHomeManager = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to enable home-manager for normal users (excluding root)";
        };
      };

      config = {
        assertions = [
          {
            assertion = all (user: hasAttr user allUsers) cfg.enabledUsers;
            message = "Some users in enabledUsers are not defined in allUsers: ${
              toString (filter (user: !(hasAttr user allUsers)) cfg.enabledUsers)
            }";
          }
          {
            assertion = elem cfg.mainUser cfg.enabledUsers;
            message = "Main user ${cfg.mainUser} not in list of enabled users: ${cfg.enabledUsers}";
          }
        ];

        users.users = filterAttrs (username: _: elem username cfg.enabledUsers) allUsers;
        users.mutableUsers = false;

        home-manager = lib.mkIf cfg.enableHomeManager {
          verbose = true;

          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";

          sharedModules = [ ];

          extraSpecialArgs = {
            inherit inputs self hostname;
          };

          users = genAttrs (filter (username: username != "root") cfg.enabledUsers) (username: {
            imports = [ inputs.self.modules.homeManager.${username} ];
          });
        };
      };
    };
}
