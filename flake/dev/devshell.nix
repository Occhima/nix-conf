{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
  ];

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
      nixConfig = pkgs.writeText "nix.conf" ''
        warn-dirty = false
        http2 = true
        experimental-features = nix-command flakes pipe-operators
        use-xdg-base-directories = true
      '';

      nix-unit = inputs'.nix-unit.packages.default;
      namaka = inputs'.namaka.packages.default;
      deploy-rs = inputs'.deploy-rs.packages.deploy-rs; # remote deployment
      nix-search-tv = inputs'.nix-search-tv.packages.default;

    in

    {

      # Now I know what happened to just-flake. Change this to devshells made me unable to define the inputsFrom attr
      # devShells.default.inputsFrom = [ config.just-flake.outputs.devShell ];

      devshells = {

        default = {

          name = "nixos-config-dev";
          env = [
            {

              name = "NIX_USER_CONF_FILES";
              value = nixConfig;
            }
            {
              name = "PATH";
              prefix = "bin";
            }
            {
              name = "FLAKE";
              value = ".";
            }
            {
              name = "NH_FLAKE";
              value = ".";
            }
            {
              name = "AGENIX_REKEY_ADD_TO_GIT";
              value = "true";
            }

          ];
          packagesFrom = [
            config.treefmt.build.devShell
          ];

          packages =
            with pkgs;
            [
              direnv
              nil
              nix-output-monitor
              nix # always use same nix version of my flake
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

          devshell = {
            startup = {
              pre-commit.text = config.pre-commit.installationScript;
            };
          };

          commands = [
            {
              name = "quit";
              help = "exit dev shell";
              command = "exit";
            }
            {
              category = "info";
              name = "onefetch";
              help = "display repository info";
              package = pkgs.onefetch;
            }
            {
              name = "agenix";
              package = config.agenix-rekey.package;
              help = "Edit, generate and rekey secrets";
            }
            {
              name = "tv";
              help = "Search nixpkgs for packages with an interactive TUI";
              command = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
            }
          ];

        };
      };

    };
}
