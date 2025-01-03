{ lib, importApply, ... }:
with lib;
let
  importApplyModules = mapAttrs (_: importApply);
  customFlakePartsModules = import ./parts { };
in
customFlakePartsModules
// {
  # modules that don't need to import module with apply ( don't need to access local flake)
  # TODO
  # Put this inside devShells?
  # pre-commit = ./checks/pre-commit.nix;

  # nix-unit = ./checks/pre-commit.nix;

}
// importApplyModules {

  shells = ./shell.nix;
  #   devShells = ./shell.nix;
  #   # githubActions = ./github-actions.nix;
  #   # homeManagerModules = ./modules/home-manager.nix;
}
