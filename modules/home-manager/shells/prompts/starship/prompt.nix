{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.shell;
in
{
  config = mkIf (cfg.prompt.type == "starship") {
    programs.starship = {
      package = pkgs.starship;
      enable = true;
      settings = importTOML ./starship.toml;

    };
  };
}
