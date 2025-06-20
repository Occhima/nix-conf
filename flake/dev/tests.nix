{ inputs, self, ... }:
let
  inherit (self) lib;
in
{

  imports = [ inputs.nix-unit.modules.flake.default ];

  perSystem =
    { ... }:
    {
      nix-unit = {
        allowNetwork = true;
        tests = import ./tests/unit { inherit lib; };
      };

      # FIXME: integration tests are still broken
      # checks.integration = import ./tests/integration {
      #   inherit
      #     self
      #     lib
      #     pkgs
      #     inputs
      #     ;

      # };
    };
}
