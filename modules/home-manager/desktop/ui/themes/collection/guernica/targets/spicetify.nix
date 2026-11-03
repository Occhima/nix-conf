{ inputs, ... }: {
  flake.modules.homeManager.themes-guernica-spicetify =
    { pkgs, ... }:
    let
      inherit (inputs) spicetify-nix;
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      programs.spicetify = {
        theme = spicePkgs.themes.text;
      };
    };
}
