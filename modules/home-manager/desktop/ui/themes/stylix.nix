# Stylix base module. A theme (e.g. themes-guernica) imports this and
# provides its palette, fonts and targets. Activation is composition:
# there is no theme registry or name selector — only the variant remains
# as genuine data.
{ inputs, ... }: {
  flake-file.inputs.stylix = {
    url = "github:danth/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.themes-stylix = { lib, ... }: {
    options.modules.desktop.ui.themes = {
      variant = lib.mkOption {
        type = lib.types.enum [
          "default"
          "compact"
        ];
        default = "default";
        description = "Layout specialization of the active theme (e.g. a compact layout)";
      };
    };

    imports = [ inputs.stylix.homeModules.stylix ];

    config = {
      stylix = {
        enable = true;
        enableReleaseChecks = true;
        autoEnable = true;
        overlays.enable = false;
      };
    };
  };
}
