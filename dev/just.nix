{ inputs, ... }:
{
  imports = [ inputs.just-flake.flakeModule ];
  perSystem =
    { ... }:
    {
      just-flake.features = {
        treefmt.enable = true;
        rust.enable = true;
        convco.enable = true;
        hello = {
          enable = true;
          justfile = ''
            hello:
            echo Hello World
          '';
        };
      };
    };
}
