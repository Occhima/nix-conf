{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.shell;
  capitalize = str: strings.toUpper (builtins.substring 0 1 str) + builtins.substring 1 (-1) str;
in

{
  config = mkIf (cfg.prompt.type == "starship") {
    programs.starship = {
      package = pkgs.starship;
      enable = true;

      # Dynamically enable integration based on the selected shell
      "enable${capitalize cfg.type}Integration" = true;
      settings = importTOML ./starship.toml;

    };
  };
}
