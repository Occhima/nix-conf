{inputs, ...}: {
  imports = [
    inputs.git-hooks-nix.flakeModule
    inputs.treefmt-nix.flakeModule
    # inputs.nix-unit.modules.flake.default
  ];

  perSystem = {
    config,
    pkgs,
    inputs,
    self,
    ...
  }: {
    pre-commit = import ./pre-commit.nix {};
    treefmt = import ./treefmt.nix {};
  };

  flake = {
    tests = {
      "teste 1" = {
        expr = "asdf";
        expected = "asdf";
      };
    };
  };
}
