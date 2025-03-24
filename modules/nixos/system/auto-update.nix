{
  system.autoUpgrade = {
    enable = false;
    dates = "*-*-* 03:00:00";
    randomizedDelaySec = "1h";
    flake = "github:Occhima/nix-conf";
  };
}
