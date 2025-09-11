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
      default = null;
    };
  };

  imports = [
    inputs.stylix.homeModules.stylix
    ./collection
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

      # FIXME: This should not be necesary https://github.com/nix-community/stylix/issues/1832
      # manually set when setting use global pkgs in home-manager
      overlays = {
        enable = false;
      };
    };
  };
}
