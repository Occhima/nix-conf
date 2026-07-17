{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  flake.modules.homeManager.browser-nyxt = (
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
