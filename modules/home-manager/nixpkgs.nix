{ self, ... }:
{
  # system specific overrides,
  nixpkgs.config = {
    allowUnfree = true; # super restrictive configs
    allowUnfreePredicate = _: false;
    allowBroken = false;
    permittedInsecurePackages = [ ];
    allowUnsupportedSystem = true;
  };
  nixpkgs.overlays = builtins.attrValues self.overlays;
}
