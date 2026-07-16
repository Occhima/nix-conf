{ ... }:
{
  config.flake.modules.homeManager.caelestia-dock =
    {
      inputs,
      pkgs,
      ...
    }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      shellPkg = inputs.caelestia-shell.packages.${system}.default;
    in
    {
      # ponytail: caelestia target (_caelestia.nix) excluded from import-tree;
      # theme settings for caelestia are only applied when caelestia-dock is active
      imports = [ inputs.caelestia-shell.homeManagerModules.default ];

      programs.caelestia = {
        enable = true;
        package = shellPkg;
        systemd = {
          enable = true;
          target = "graphical-session.target";
        };

        cli.enable = true;
      };
    };
}
