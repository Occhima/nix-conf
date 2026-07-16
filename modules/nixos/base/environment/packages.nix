{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  config.flake.modules.nixos.environment-packages =
    { pkgs, ... }:
    let
      inherit (flakePkgs.${pkgs.stdenv.hostPlatform.system}) install-tools;
    in
    {
      programs = {
        git.enable = true;
        vim.enable = true;
        zsh.enable = true;
      };

      environment.systemPackages = [
        install-tools
      ];
    };
}
