{ ... }:
{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    let
      nixConfig = builtins.toFile "nix.conf" ''
        warn-dirty = false
        http2 = true
        experimental-features = nix-command flakes pipe-operators
        use-xdg-base-directories = true
      '';
    in
    {
      devShells = {
        default = config.devShells.flake-devshell;
        flake-devshell = pkgs.mkShell {
          name = "nixos-config-dev";
          inputsFrom = [ config.treefmt.build.devShell ];
          NIX_USER_CONF_FILES = "${nixConfig}";
          AGENIX_REKEY_ADD_TO_GIT = true;
          FLAKE = ".";

          #
          buildInputs = with pkgs; [
            nil
            nix
            gitAndTools.hub
            config.formatter
          ];
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
      };
    };
}
