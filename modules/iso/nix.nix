{
  config,
  ...
}:
{
  nix = {

    channel.enable = false;
    nixPath = [ "nixpkgs=${config.nix.registry.nixpkgs.to.path}" ];

    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];

      log-lines = 50;
      warn-dirty = false;

      # Its nice to have more http downloads when setting up
      http-connections = 50;

      # We can ignore the flake registry since we won't be using it
      # this is because we already have all the programs we need in the ISO
      flake-registry = "";

      # we don't need this nor do we want it
      accept-flake-config = false;

      # this is not important when your in a ISO
      auto-optimise-store = false;

      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];

    };
  };
}
