{
  config,
  lib,
  inputs,
  ...
}:

let
  inherit (lib.types)
    enum
    nullOr
    attrsOf
    attrs
    ;
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.modules.desktop.ui.themes;

  availableThemes = builtins.attrNames cfg.registry;

in
{
  options.modules.desktop.ui.themes = {
    enable = mkEnableOption "Enable UI themes";

    registry = mkOption {
      type = attrsOf attrs;
      default = { };
      internal = true;
      description = "Registry of available themes with their metadata";
    };

    name = mkOption {
      type = nullOr (enum availableThemes);
      description = "The active theme to use. Available: ${builtins.concatStringsSep ", " availableThemes}";
      default = null;
    };

    variant = mkOption {
      type = enum [
        "default"
        "compact"
      ];
      default = "default";
      description = "Optional specialization for the selected theme (e.g. a compact layout)";
    };
  };

  imports = [
    inputs.stylix.homeModules.stylix
    ./collection
  ];

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.name != null;
        message = "When themes are enabled, you must select a theme name.";
      }
      {
        assertion = cfg.name != null -> builtins.hasAttr cfg.name cfg.registry;
        message = "Theme '${cfg.name}' is not registered. Available themes: ${builtins.concatStringsSep ", " availableThemes}";
      }
      {
        assertion =
          let
            themeMeta = cfg.registry.${cfg.name}.meta or { };
            supportedVariants = themeMeta.variants or [ "default" ];
          in
          cfg.name != null -> builtins.elem cfg.variant supportedVariants;
        message =
          let
            themeMeta = cfg.registry.${cfg.name}.meta or { };
            supportedVariants = themeMeta.variants or [ "default" ];
          in
          "Variant '${cfg.variant}' is not supported by theme '${cfg.name}'. Supported variants: ${builtins.concatStringsSep ", " supportedVariants}";
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
