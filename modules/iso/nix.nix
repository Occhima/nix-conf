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

      http-connections = 50;

      flake-registry = "";

      accept-flake-config = false;

      auto-optimise-store = false;

      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://devenv.cachix.org"
        "https://occhima.cachix.org"
        "https://anyrun.cachix.org"
        "https://niri.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
        "occhima.cachix.org-1:Uzuoh9jCigJUFzRKj6OAgHsgwfDZ23hhJIBUru3aULI="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="

      ];

    };
  };
}
