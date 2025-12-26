{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui;
  system = pkgs.stdenv.hostPlatform.system;
  shellPkg = inputs.caelestia-shell.packages.${system}.default;
in
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  config = mkIf (cfg.dock == "caelestia") {
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
