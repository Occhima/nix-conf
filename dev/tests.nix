{ inputs, self, ... }:
let
  # Test against the same helpers the flake exports, on top of a plain
  # nixpkgs lib (the flake never merges libs into `self.lib`).
  lib = inputs.nixpkgs.lib.extend (_: _: { inherit (self.lib) custom; });
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
