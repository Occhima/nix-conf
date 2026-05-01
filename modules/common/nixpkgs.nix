{ self, ... }:
{
  # system specific overrides,
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
    permittedInsecurePackages = [ ];
    allowUnsupportedSystem = false;
  };
  nixpkgs.overlays = builtins.attrValues self.overlays;
}
