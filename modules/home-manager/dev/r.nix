{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.dev.r;
  myRPackages = with pkgs.rPackages; [
    ggplot2
    languageR
    languageserver
    lintr
    styler
    tidyverse

  ];
  rWithMyPackages = pkgs.rWrapper.override {
    packages = myRPackages;
  };

  rStudioWithMyPackages = pkgs.rstudioWrapper.override {
    packages = myRPackages;
  };
in

{
  options.modules.dev.r = {
    enable = mkEnableOption "Enable R development tools";
  };

  config = mkIf cfg.enable {
    home.packages = [
      rWithMyPackages
      rStudioWithMyPackages
    ];
    home.sessionVariables.R_PROFILE = "$XDG_CONFIG_HOME/R/Rprofile";
  };
}
