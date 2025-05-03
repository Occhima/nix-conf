{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (inputs) spicetify-nix;
  inherit (lib) mkEnableOption mkIf;

  # TODO: Should I inject the system here using extraSpecialArgs?
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  cfg = config.modules.desktop.apps.spotify;
in
{

  imports = [ spicetify-nix.homeManagerModules.default ];

  options.modules.desktop.apps.spotify = {
    enable = mkEnableOption "spotify";
  };

  config = mkIf cfg.enable {
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
