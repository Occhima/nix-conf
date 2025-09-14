{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  inherit (inputs) spicetify-nix;
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui.themes;
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  cond = (cfg.enable && cfg.name == "guernica");
in
{
  # Disable stylix integration for kitty conditionally
  # NOTE: Stole from https://github.com/Gerg-L/nixos/blob/beeb8b6d907309d3ff10acc6c17a2aa0a2c235ad/nixosConfigurations/gerg-desktop/spicetify.nix#L4
  stylix.targets.spicetify.enable = !cond;

  # Override font and theme settings conditionally
  programs.spicetify = mkIf cond {
    theme = spicePkgs.themes.text;
  };
}
