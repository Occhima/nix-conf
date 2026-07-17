{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  config.occhima.iso-programs.nixos =
    { pkgs, ... }:
    {
      system = {
        disableInstallerTools = true;

        tools = {
          nixos-enter.enable = true;
          nixos-install.enable = true;
          nixos-generate-config.enable = true;
        };
      };

      # we only need a basic git install
      programs.git.package = pkgs.gitMinimal;
      # needed packages for the installer
      environment.systemPackages = builtins.attrValues {
        inherit (pkgs)
          vim # we are not installing neovim here so we have a light dev environment
          pciutils # going to need this for lspci
          age-plugin-yubikey
          disko
          nix-output-monitor
          ;
        inherit (flakePkgs.${pkgs.stdenv.hostPlatform.system}) install-tools;
      };

      hardware.enableRedistributableFirmware = true;
    };
}
