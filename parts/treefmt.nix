{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = { pkgs, ... }: {
    treefmt = {
      # enabled to be the base formatter
      flakeFormatter = true;
      projectRootFile = "flake.nix";

      programs = {
        # Nix
        nixfmt-rfc-style = {
          enable = false;
          package = pkgs.nixfmt-rfc-style;
        };

        alejandra = { enable = false; };

        deadnix = { enable = false; };

        # Github Actions
        actionlint = { enable = true; };

        # Bash
        beautysh = { enable = false; };

        # TypeScript / JSON
        biome = { enable = true; };

        # YAML
        yamlfmt = { enable = false; };
      };

    };
  };
}
