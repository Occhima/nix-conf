{ inputs, ... }:
{
  flake-file.inputs.caelestia-shell = {
    url = "github:caelestia-dots/shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.caelestia-dock =
    {
      pkgs,
      ...
    }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      shellPkg = inputs.caelestia-shell.packages.${system}.default;
    in
    {
      # Guernica styling for caelestia contributes to this same aspect from
      # the theme's targets/caelestia.nix, so it only applies when the dock is imported.
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
