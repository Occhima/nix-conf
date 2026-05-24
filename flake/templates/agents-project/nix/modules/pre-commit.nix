{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      pre-commit = {
        check.enable = true;
        settings = {
          excludes = [ "^_sources/.*.nix$" ];

          hooks = {
            deadnix = {
              enable = true;
              package = pkgs.deadnix;
            };

            convco.enable = true;
            actionlint.enable = true;

            # Basic commit checks
            check-case-conflicts.enable = true;
            check-executables-have-shebangs.enable = true;
            check-merge-conflicts.enable = true;
            detect-private-keys.enable = true;
            fix-byte-order-marker.enable = true;
            mixed-line-endings.enable = true;
            trim-trailing-whitespace.enable = true;
            end-of-file-fixer.enable = true;
          };
        };
      };
    };
}
