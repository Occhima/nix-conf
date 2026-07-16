# Standalone Home Manager output for occhima (non-NixOS machines).
# No fabricated osConfig and no extraSpecialArgs: modules that want host
# facts take `osConfig ? { }` and degrade intentionally when standalone.
{ config, inputs, ... }:
{
  flake.homeConfigurations.occhima = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        allowBroken = false;
        allowUnsupportedSystem = false;
      };
      overlays = builtins.attrValues config.flake.overlays;
    };
    modules = [ config.flake.modules.homeManager.occhima ];
  };
}
