{ inputs, self, ... }:
let
  inherit (inputs) namaka;
  inherit (self) lib;
in
{

  imports = [ inputs.nix-unit.modules.flake.default ];

  perSystem =
    { ... }:
    {
      nix-unit = {
        allowNetwork = true;
        # TODO: load tests with haumea
        tests = import ./tests { inherit lib; };
      };

    };

  flake.checks = namaka.lib.load {
    src = ./tests/namaka;
  };

}
