# Guernica styling for spicetify. Contributed to the spotify aspect (the
# sole importer of the spicetify module).
{ inputs, ... }:
{
  config.occhima.spotify.homeManager =
    {
      pkgs,
      ...
    }:
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
