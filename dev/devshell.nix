{ inputs, ... }:
{
  perSystem =
    {
      config,
      system,
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
    in
    {

      devShells = {

        default = config.devShells.nixos-config;

        nixos-config = pkgs.mkShell {
          name = "my-nixos-devenv";
          inputsFrom = [
            config.treefmt.build.devShell
            config.just-flake.outputs.devShell
            config.pre-commit.devShell
          ];
          packages = with pkgs; [
            direnv
            nil
            home-manager
            colmena

            config.pre-commit.settings.tools.convco

            # Is this dumb??
            config.formatter

            inputs.omnix.packages.${system}.default
            inputs.nix-unit.packages.${system}.default

          ];

          shellHook = ''
            ${config.pre-commit.installationScript}
            export NIX_USER_CONF_FILES="${nixConfig}"
            export PATH="$(pwd)/bin:$PATH"
          '';
        };
      };
    };
}
