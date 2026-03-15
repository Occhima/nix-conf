{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    {
      config,
      ...
    }:
    {
      formatter = config.treefmt.programs.alejandra.package;
      treefmt = {
        flakeFormatter = true;
        flakeCheck = true;
        projectRootFile = "flake.nix";

        programs = {
          # Nix
          alejandra.enable = true;
          deadnix.enable = true;

          # GitHub Actions
          actionlint.enable = true;

          # Bash
          beautysh.enable = true;

          # YAML
          prettier.enable = true;
        };
      };
    };
}
