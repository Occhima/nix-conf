{
  # system specific overrides,
  nixpkgs.config = {
    allowUnfree = false; # super restrictive configs
    allowUnfreePredicate = _: false;
    allowBroken = false;
    permittedInsecurePackages = [ ];
    allowUnsupportedSystem = true;
  };
}
