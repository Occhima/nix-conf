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
  # NOTE: Stole from https://github.com/Gerg-L/nixos/blob/beeb8b6d907309d3ff10acc6c17a2aa0a2c235ad/nixosConfigurations/gerg-desktop/spicetify.nix#L4
  stylix.targets.spicetify.enable = lib.mkIf (cfg.enable && cfg.name == "guernica") false;

  # Override font and theme settings conditionally
  programs.spicetify = lib.mkIf (cfg.enable && cfg.name == "guernica") {
    theme = spicePkgs.themes.text;
    colorScheme = "custom";
    customColorScheme = {
      text = "f8f8f8";
      subtext = "f8f8f8";
      sidebar-text = "79dac8";
      main = "000000";
      sidebar = "323437";
      player = "000000";
      card = "000000";
      shadow = "000000";
      selected-row = "7c8f8f";
      button = "74b2ff";
      button-active = "74b2ff";
      button-disabled = "555169";
      tab-active = "80a0ff";
      notification = "80a0ff";
      notification-error = "e2637f";
      misc = "282a36";
    };
  };
}
