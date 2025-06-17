{ ... }:
{
  perSystem =
    {
      config,
      lib,
      pkgs,
      inputs',
      self',
      ...
    }:
    let
      inherit (self'.packages) install-tools;
      nixConfig = builtins.toFile "nix.conf" ''
        warn-dirty = false
        http2 = true
        experimental-features = nix-command flakes pipe-operators
        use-xdg-base-directories = true
      '';
      nix-unit = inputs'.nix-unit.packages.default;
      namaka = inputs'.namaka.packages.default;
      deploy-rs = inputs'.deploy-rs.packages.deploy-rs;
      nix-search-tv = inputs'.nix-search-tv.packages.default;
    in
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-config-dev";
        inputsFrom = [ config.treefmt.build.devShell ];
        buildInputs =
          with pkgs;
          [
            direnv
            nil
            nix-output-monitor
            nix
            nh
            fzf
            gitAndTools.hub
            namaka
            onefetch
            fastfetch
            just
            nix-unit
            nix-search-tv
            config.formatter
            install-tools
          ]
          ++ lib.lists.optionals pkgs.stdenv.hostPlatform.isLinux [ deploy-rs ];
        shellHook = ''
          export NIX_USER_CONF_FILES=${nixConfig}
          export FLAKE=.
          export NH_FLAKE=.
          export AGENIX_REKEY_ADD_TO_GIT=true
          export PATH=$PWD/bin:$PATH
          ${config.pre-commit.installationScript}
          alias quit="exit"
          alias onefetch="${pkgs.onefetch}/bin/onefetch"
          alias agenix="${config.agenix-rekey.package}/bin/agenix"
          alias tv="nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history"
        '';
      };
    };
}
