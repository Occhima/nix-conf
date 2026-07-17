{ ... }:
{
  config.occhima.r.homeManager = (
    {
      config,
      pkgs,
      ...
    }:
    let
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
      config = {
        home.packages = [
          rWithMyPackages
          rStudioWithMyPackages
        ];
        home.sessionVariables.R_PROFILE = "${config.xdg.configHome}/R/Rprofile";
      };
    }
  );
}
