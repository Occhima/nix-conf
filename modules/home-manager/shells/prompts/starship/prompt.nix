{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf importTOML;
  cfg = config.modules.shell;
in
{
  config = mkIf (cfg.prompt.type == "starship") {
    programs.starship = {
      package = pkgs.starship;
      enable = true;

      # is this file to big?
      settings = importTOML ./starship.toml;

    };
  };
}
