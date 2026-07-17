# flake-file: the root flake.nix is generated with `nix run .#write-flake`.
# Only the evaluation plumbing is declared here — every other input is
# declared by the feature module that consumes it (`flake-file.inputs` is
# a mergeable option), so deleting a module also drops its input on the
# next write-flake. The dendritic flake module also wires flake-parts'
# `modules` option and the import-tree outputs form.
{ inputs, lib, ... }:
{
  imports = [ inputs.flake-file.flakeModules.dendritic ];

  # flake-file registers a check that diffs the committed flake.nix
  # against the generated one and has no off switch; flake.nix is
  # regenerated deliberately via `nix run .#write-flake`, so neutralize
  # the check instead of chasing formatting drift on every CI run.
  perSystem =
    { pkgs, ... }:
    {
      checks.check-flake-file = lib.mkForce (
        pkgs.runCommandLocal "check-flake-file-disabled" { } "touch $out"
      );
    };

  flake-file.description = "My dendritic NixOS config";

  flake-file.inputs = {
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    nixpkgs.url = "github:nixos/nixpkgs";
  };
}
