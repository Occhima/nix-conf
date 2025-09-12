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
    languageserver
    devtools
    lintr
    styler
    tidyverse
    dagitty
    knitr
    rmarkdown
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
    home.sessionVariables.R_PROFILE = "${config.xdg.configHome}/R/Rprofile";
  };
}
