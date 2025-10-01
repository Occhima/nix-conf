# stolen from: https://github.com/isabelroses/dotfiles/blob/main/modules/base/nix/nix.nix
{
  pkgs,
  lib,
  _class,
  # inputs,
  ...
}:
let
  sudoers = if (_class == "nixos") then "@wheel" else "@admin";
in
{

  # imports = [ inputs.determinate.nixosModules.default ];
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

    settings = {

      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://install.determinate.systems"
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
      auto-optimise-store = pkgs.stdenv.hostPlatform.isLinux;

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
        "recursive-nix"

        # "big-parallel"
      ];

      # continue building derivations even if one fails
      # this is important for keeping a nice cache of derivations, usually because I walk away
      # from my PC when building and it would be annoying to deal with nothing saved
      keep-going = true;

      # show more log lines for failed builds, as this happens alot and is useful
      log-lines = 30;

      # https://docs.lix.systems/manual/lix/nightly/contributing/experimental-features.html
      experimental-features = [
        # enables flakes, needed for this config
        "flakes"

        # enables the nix3 commands, a requirement for flakes
        "nix-command"

        # allow nix to call itself
        "recursive-nix"

        # allow nix to build and use content addressable derivations, these are nice beaccase
        # they prevent rebuilds when changes to the derivation do not result in changes to the derivation's output
        "ca-derivations"

        # Allows Nix to automatically pick UIDs for builds, rather than creating nixbld* user accounts
        # which is BEYOND annoying, which makes this a really nice feature to have
        "auto-allocate-uids"

        # allows Nix to execute builds inside cgroups
        # remember you must also enable use-cgroups in the nix.conf or settings
        # "cgroups"

        # allow passing installables to nix repl, making its interface consistent with the other experimental commands
        # "repl-flake"

        # allow usage of the pipe operator in nix expressions
        "pipe-operators"

        # enable the use of the fetchClosure built-in function in the Nix language.
        "fetch-closure"

        # dependencies in derivations on the outputs of derivations that are themselves derivations outputs.
        "dynamic-derivations"

        # allow parsing TOML timestamps via builtins.fromTOML
        "parse-toml-timestamps"
      ];

      # don't warn me if the current working tree is dirty
      # i don't need the warning because i'm working on it right now
      warn-dirty = false;

      # maximum number of parallel TCP connections used to fetch imports and binary caches, 0 means no limit
      http-connections = 50;

      # whether to accept nix configuration from a flake without prompting
      # littrally a CVE waiting to happen <https://x.com/puckipedia/status/1693927716326703441>
      accept-flake-config = false;

      # build from source if the build fails from a binary source
      # fallback = true;

      # this defaults to true, however it slows down evaluation so maybe we should disable it
      # some day, but we do need it for catppuccin/nix so maybe not too soon
      allow-import-from-derivation = true;

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      use-xdg-base-directories = true;
    };

  };

}
