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
      ...
    }:

    let
      nixConfig = builtins.toFile "nix.conf" ''
        warn-dirty = false
        http2 = true
        experimental-features = nix-command flakes pipe-operators
        use-xdg-base-directories = true
      '';

      nix-unit = inputs'.nix-unit.packages.default;
      deploy-rs = inputs'.deploy-rs.packages.deploy-rs; # remote deployment
      agenix = inputs'.agenix.packages.agenix; # remote deployment
    in

    {

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
              nh

              gitAndTools.hub
              gh

              onefetch
              fastfetch

              just
              agenix
              nix-unit

              config.formatter
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
              category = "info";
              name = "fastfetch";
              help = "display host info";
              package = pkgs.fastfetch;
            }
            {
              name = "environment";
              category = "info";
              help = "display environment variables";
              command = "printenv";
            }
            {
              name = "flake-show";
              category = "info";
              help = "display your flake outputs";
              command = "nix flake show";
            }
            {
              name = "tests";
              category = "dev";
              help = "run unit tests";
              command = "nix-unit --flake .#tests";
            }
          ];

        };
      };

    };
}
