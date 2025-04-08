{
  config,
  lib,
  inputs,
  ...
}:

let
  inherit (lib.types) enum nullOr;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.options) mkOption;

  cfg = config.modules.desktop.ui.themes;

in
{

  options.modules.desktop.ui.themes = {
    enable = mkEnableOption "Enable UI themes";
    name = mkOption {
      type = nullOr (enum [ "guernica" ]);
      description = "The active theme to use";
      default = "guernica ";
    };
  };

  imports = [
    inputs.stylix.homeManagerModules.stylix
    ./guernica
  ];

  # Base configuration when themes are enabled
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.name != null;
        message = "When themes are enabled, you must select a theme name.";
      }
    ];
    stylix = {
      enable = true;
      enableReleaseChecks = true;
      autoEnable = true;
    };
  };
}
