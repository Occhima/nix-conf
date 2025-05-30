{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { pkgs, config, ... }:
    {
      formatter = config.treefmt.programs.nixfmt.package;
      treefmt = {

        # enabled to be the base formatter
        flakeFormatter = true;

        # pre commit already makes this check
        flakeCheck = true;
        projectRootFile = "flake.nix";

        programs = {
          # Nix
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };

          alejandra = {
            enable = false;
          };

          deadnix = {
            enable = true;
          };

          # Github Actions
          actionlint = {
            enable = true;
          };

          # Bash
          beautysh = {
            enable = true;
          };

          # TypeScript / JSON
          # biome = { enable = true; };

          # YAML
          prettier = {
            enable = true;
          };
        };

      };
    };
}
