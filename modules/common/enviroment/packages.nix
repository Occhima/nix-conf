{ ... }:
{
  config.flake.modules.nixos.environment-packages =
    { inputs, pkgs, ... }:
    let
      inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) install-tools;
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
