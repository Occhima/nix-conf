{ inputs, ... }: {
  flake-file.inputs.flatpaks.url = "github:gmodena/nix-flatpak";

  flake.modules.homeManager.flatpak =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkOption types;
      inherit (lib.modules) mkIf;

      cfg = config.modules.desktop.apps.flatpak;
    in
    {
      imports = [ inputs.flatpaks.homeManagerModules.nix-flatpak ];

      options.modules.desktop.apps.flatpak = {
        packages = mkOption {
          type = types.listOf (types.either types.str (types.attrsOf types.anything));
          default = [
          ];
          description = "List of Flatpak packages to install";
        };
      };

      # Platform guard required by the upstream nix-flatpak module.
      config = mkIf pkgs.stdenv.hostPlatform.isLinux {
        services.flatpak = {
          packages = cfg.packages;
          uninstallUnmanaged = false;
          uninstallUnused = true;
          update.auto.enable = false;
          update.onActivation = false;
        };
      };
    };
}
