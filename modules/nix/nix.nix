# Cross-cutting nix daemon/client settings, shared between NixOS hosts and
# standalone Home Manager (non-NixOS machines).
# stolen from: https://github.com/isabelroses/dotfiles/blob/main/modules/base/nix/nix.nix
let
  # Settings meaningful in any nix.conf (system or user level).
  commonSettings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      # "https://install.determinate.systems"
      "https://devenv.cachix.org"
      "https://cache.nixos-cuda.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "occhima.cachix.org-1:Uzuoh9jCigJUFzRKj6OAgHsgwfDZ23hhJIBUru3aULI="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];

    # Minimal experimental feature set: flakes and the nix3 commands.
    # Nothing in this configuration uses the removed features.
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # continue building derivations even if one fails
    # this is important for keeping a nice cache of derivations, usually because I walk away
    # from my PC when building and it would be annoying to deal with nothing saved
    keep-going = true;

    # show more log lines for failed builds, as this happens alot and is useful
    log-lines = 30;

    # don't warn me if the current working tree is dirty
    # i don't need the warning because i'm working on it right now
    warn-dirty = false;

    # maximum number of parallel TCP connections used to fetch imports and binary caches, 0 means no limit
    http-connections = 50;

    # whether to accept nix configuration from a flake without prompting
    # littrally a CVE waiting to happen <https://x.com/puckipedia/status/1693927716326703441>
    accept-flake-config = false;

    # IFD is disabled globally: no derivation output may be read back during
    # evaluation (regression gate: nix flake check --option allow-import-from-derivation false).
    allow-import-from-derivation = false;

    # for direnv GC roots
    keep-derivations = true;
    keep-outputs = true;

    use-xdg-base-directories = true;
  };
in
{
  flake.modules.nixos.nix =
    { pkgs, lib, ... }:
    let
      sudoers = "@wheel";
    in
    {
      nix = {
        gc = {
          automatic = true;
          options = "--delete-older-than 3d";
        };
        package = lib.mkDefault pkgs.nix;
        optimise = {
          automatic = true;
          dates = [ "04:00" ];
        };

        settings = commonSettings // {
          auto-optimise-store = pkgs.stdenv.hostPlatform.isLinux;

          # Refuse to use substituted paths that carry no valid signature from a
          # trusted key. Default is true but making it explicit prevents accidental
          # override via flake nixConfig or environment variables.
          require-sigs = true;

          # users or groups which are allowed to do anything with the Nix daemon
          allowed-users = [ sudoers ];
          # users or groups which are allowed to manage the nix store
          trusted-users = [
            sudoers
          ];
          max-jobs = "auto";
          sandbox = pkgs.stdenv.hostPlatform.isLinux;
          # supported system features
          system-features = [
            "nixos-test"
            "kvm"

            # "big-parallel"
          ];
        };
      };
    };

  # User-level nix.conf for homes outside NixOS; daemon-only knobs
  # (sandbox, allowed-users, ...) stay in the NixOS module above.
  flake.modules.homeManager.nix =
    { pkgs, lib, ... }:
    {
      nix = {
        package = lib.mkDefault pkgs.nix;
        settings = commonSettings;
      };
    };
}
