{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  occhima.browser-nyxt.homeManager = (
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.modules) mkIf;
    in
    {
      config = mkIf (pkgs.stdenv.isLinux) {
        home = {
          packages = [ flakePkgs.${pkgs.stdenv.hostPlatform.system}.nyxt-source ];
          sessionVariables = {
            WEBKIT_DISABLE_COMPOSITING_MODE = 1;
          };
        };
        xdg.configFile."nyxt".source = ./config;
      };
    }
  );
}
