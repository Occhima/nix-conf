{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  inherit (inputs) spicetify-nix;
  cfg = config.modules.desktop.ui.themes;
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Disable stylix integration for kitty conditionally
  stylix.targets.spicetify.enable = lib.mkIf (cfg.enable && cfg.name == "guernica") false;

  # Override font and theme settings conditionally
  programs.spicetify = lib.mkIf (cfg.enable && cfg.name == "guernica") {
    theme = spicePkgs.themes.text;
  };
}
