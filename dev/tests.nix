{ inputs, self, ... }:
let
  # Tests exercise the custom library exactly as modules see it.
  lib = inputs.nixpkgs.lib.extend (_: _: { occhima = self.lib.occhima; });
in
{
  imports = [ inputs.nix-unit.modules.flake.default ];

  perSystem = {
    nix-unit = {
      allowNetwork = true;
      tests = import ./tests/unit { inherit lib; };
    };
  };
}
