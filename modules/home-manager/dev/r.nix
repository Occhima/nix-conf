{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.dev.r;
  R-with-my-packages = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [
      ggplot2
      languageR
      languageserver
      lintr
      styler
      tidyverse
    ];
  };
in
{
  options.modules.dev.r = {
    enable = mkEnableOption "Enable R development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      R-with-my-packages
      pandoc
      quarto
    ];
    home.sessionVariables.R_PROFILE = "$XDG_CONFIG_HOME/R/Rprofile";
  };
}
