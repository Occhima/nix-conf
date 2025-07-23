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
              excludes = [
                # "modules"
                # "hosts"
                # "home"
              ];
            };

            alejandra = {
              enable = true;
            };

            convco = {
              enable = true;
            };

            commitzen.enable = false;
            actionlint.enable = true;
            check-added-large-files.enable = false;
            check-case-conflicts.enable = true;
            check-executables-have-shebangs.enable = true;
            check-shebang-scripts-are-executable.enable = false; # many of the scripts in the config aren't executable because they don't need to be.
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
