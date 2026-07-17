{ inputs, ... }:
{
  occhima.spotify.homeManager = (
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (inputs) spicetify-nix;

      # TODO: Should I inject the system here using extraSpecialArgs?
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [ spicetify-nix.homeManagerModules.default ];

      config = {
        programs.spicetify = {
          enable = true;
          enabledCustomApps = builtins.attrValues { inherit (spicePkgs.apps) lyricsPlus ncsVisualizer; };
          enabledExtensions = builtins.attrValues {
            inherit (spicePkgs.extensions)
              adblockify
              hidePodcasts
              shuffle
              betterGenres
              ;
          };
          experimentalFeatures = true;
          alwaysEnableDevTools = true;
          # TODO: Change to theme targets ...
        };
      };
    }
  );
}
