{ ... }: {
  perSystem = { config, pkgs, ... }:
    let
      nixConfig = builtins.toFile "nix.conf" ''
        warn-dirty = false
        http2 = true
        experimental-features = nix-command flakes
        use-xdg-base-directories = true
      '';
    in {

      devShells = {

        default = config.devShells.nixos-config;

        nixos-config = pkgs.mkShell {
          name = "nixos-config";
          buildInputs = with pkgs; [
            git
            home-manager
            nix-zsh-completions
            nil
            nixfmt-classic
            nix
            just
          ];
          packages = with pkgs; [ direnv ];

          shellHook = ''
            ${config.pre-commit.installationScript}
            export NIX_USER_CONF_FILES="${nixConfig}"
            export PATH="$(pwd)/bin:$PATH"
          '';
        };
      };
    };
}
