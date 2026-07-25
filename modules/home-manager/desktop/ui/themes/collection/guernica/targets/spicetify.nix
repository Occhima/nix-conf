# Guernica styling for spicetify. Explicit integration module: importing
# Requires `themes-guernica` in the same composition (homeManager.desktop provides it).
# `spotify` alone no longer activates any theme configuration.
{ inputs, ... }: {
  flake.modules.homeManager.themes-guernica-spicetify =
    { pkgs, ... }:
    let
      inherit (inputs) spicetify-nix;
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      # Guernica ships its own spicetify theme; keep stylix's target off.
      # NOTE: Stole from https://github.com/Gerg-L/nixos/blob/beeb8b6d907309d3ff10acc6c17a2aa0a2c235ad/nixosConfigurations/gerg-desktop/spicetify.nix#L4
      stylix.targets.spicetify.enable = false;

      programs.spicetify = {
        theme = spicePkgs.themes.text;
      };
    };
}
