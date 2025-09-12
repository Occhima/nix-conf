{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.dev.julia;
  juliaPackages = [
    "LanguageServer"
    "SymbolServer"
    "StaticLint"
    "DataFrames"
    "CSV"
    "Plots"
    "StatsBase"
    "Distributions"
    "GLM"
    "Query"
    "Gadfly"

  ];

  juliaEnv = pkgs.julia.withPackages juliaPackages;
in
{
  options.modules.dev.julia = {
    enable = mkEnableOption "Enable Julia development tools";
  };

  config = mkIf cfg.enable {
    home.packages = [
      juliaEnv
    ];
  };
}
