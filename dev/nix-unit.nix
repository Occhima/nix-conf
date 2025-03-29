{ inputs, ... }:
let
  inherit (inputs) nixpkgs namaka;
  customLib = import ../lib nixpkgs;
in
{

  imports = [ inputs.nix-unit.modules.flake.default ];

  perSystem =
    { ... }:
    {
      nix-unit = {
        allowNetwork = true;
        tests = import ./tests { lib = customLib; };
      };

    };

  flake.checks = namaka.lib.load {
    src = ./tests/namaka;
  };

}
