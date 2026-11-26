{
  flake.modules.nixos.flatpak-daemon =
    { config, lib, ... }:
    {
      services.flatpak.enable = true;

      fonts.packages = lib.concatMap (
        user: lib.optionals (user.stylix.enable or false) user.stylix.fonts.packages
      ) (lib.attrValues (config.home-manager.users or { }));
    };
}
