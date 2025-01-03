{ ... }:
{

  gitHooks = ./pre-commit.nix;
  treeFormat = ./treefmt.nix;
  # unitTests = ./nix-unit.nix;
  # githubActions = ./actions.nix;

}
