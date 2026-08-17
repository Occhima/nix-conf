{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  flake.modules.homeManager.browser-nyxt =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.modules) mkIf;
    in
    {
      config = mkIf (pkgs.stdenv.hostPlatform.isLinux) {
        home = {
          packages = [ flakePkgs.${pkgs.stdenv.hostPlatform.system}.nyxt-source ];
        };
        xdg.configFile."nyxt".source = ./config;
      };
    };
}
