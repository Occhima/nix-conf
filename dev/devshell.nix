{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem =
    {
      config,
      inputs',
      pkgs,
      ...
    }:
    let
      nixConfig = builtins.toFile "nix.conf" ''
        warn-dirty = false
        http2 = true
        experimental-features = nix-command flakes
        use-xdg-base-directories = true
      '';

      omnix = inputs'.omnix.packages.default;
      nix-unit = inputs'.nix-unit.packages.default;
      colmena = inputs'.colmena.packages.colmena;

    in

    {

      devshells = {

        default = {
          name = "nixox-config-dev";
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
            config.just-flake.outputs.devShell
            config.pre-commit.devShell
            config.formatter
          ];

          packages = with pkgs; [
            direnv

            nil
            home-manager
            gitAndTools.hub
            onefetch
            fastfetch

            omnix
            nix-unit
            colmena
          ];

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
              command = "om show .";
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
