{ config, ... }:
{
  config.flake.modules.nixos.nixpkgs-config = {
    # system specific overrides,
    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = false;
      permittedInsecurePackages = [ ];
      allowUnsupportedSystem = false;
    };
    nixpkgs.overlays = builtins.attrValues config.flake.overlays;
  };
}
