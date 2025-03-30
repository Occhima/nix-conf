{ self, ... }:
{
  # user specific overrides, I don't want in my system pkgs
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      allowBroken = false;
      permittedInsecurePackages = [ ];
      allowUnsupportedSystem = true;
    };
    overlays = builtins.attrValues self.overlays;

  };

}
