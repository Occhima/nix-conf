{ inputs, ... }:
{
  imports = [ inputs.just-flake.flakeModule ];
  perSystem =
    { ... }:
    {
      just-flake = {
        features = {
          treefmt.enable = false;
          convco.enable = false;
          nixos-dev = {
            enable = true;
            justfile = ''
              # Dev: Reloads the current direnv config
              [group('dev')]
              reload:
                  direnv reload

              # Dev: Reloads the current direnv config and run check
              [group('dev')]
              check:
                  direnv reload && nix flake check
            '';
          };
        };
      };

    };
}
