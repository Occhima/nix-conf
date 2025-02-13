# stolen from: https://github.com/isabelroses/dotfiles/blob/main/modules/base/nix/nix.nix
{
  pkgs,
  ...
}:

{

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };

    settings = {
      auto-optimise-store = pkgs.stdenv.hostPlatform.isLinux;

      # users or groups which are allowed to do anything with the Nix daemon
      allowed-users = [ "occhima" ];
      # users or groups which are allowed to manage the nix store
      trusted-users = [ "occhima" ];
      max-jobs = "auto";
      # supported system features
      system-features = [
        "nixos-test"
        "kvm"
        "recursive-nix"
        "big-parallel"
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
        "cgroups"

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
