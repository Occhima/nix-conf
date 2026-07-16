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
      deploy-rs = inputs'.deploy-rs.packages.deploy-rs;
      nix-search-tv = inputs'.nix-search-tv.packages.default;
    in
    {
      devShells = {
        default = config.devShells.flake-devshell;
        flake-devshell = pkgs.mkShell {
          name = "nixos-config-dev";
          inputsFrom = [ config.treefmt.build.devShell ];
          nativeBuildInputs = [ config.agenix-rekey.package ];

          # Env
          NIX_USER_CONF_FILES = "${nixConfig}";
          AGENIX_REKEY_ADD_TO_GIT = true;
          FLAKE = ".";

          #
          buildInputs =
            with pkgs;
            [
              direnv
              nil
              nix-output-monitor
              nix
              nh
              gitAndTools.hub
              onefetch
              just
              nix-unit
              config.formatter
              install-tools

              # custom tv program
              (writeShellApplication {
                name = "tv";
                runtimeInputs = [
                  nix-search-tv
                  fzf
                ];
                text = ''
                  # same pipeline you had in the alias
                  nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history
                '';
              })

            ]
            ++ lib.lists.optionals pkgs.stdenv.hostPlatform.isLinux [ deploy-rs ];
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
      };
    };
}
