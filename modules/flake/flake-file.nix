# flake-file: the root flake.nix is generated with `nix run .#write-flake`.
# Only the evaluation plumbing is declared here — every other input is
# declared by the feature module that consumes it (`flake-file.inputs` is
# a mergeable option), so deleting a module also drops its input on the
# next write-flake. The dendritic flake module also wires flake-parts'
# `modules` option and the import-tree outputs form.
{ inputs, ... }:
{
  imports = [ inputs.flake-file.flakeModules.dendritic ];

  flake-file.description = "My dendritic NixOS config";

  # flake-file defaults to `pkgs.nixfmt`, which nixpkgs renamed to
  # nixfmt-classic and now warns about on every eval. Same formatter,
  # explicit name, no reformat of the generated flake.nix.
  flake-file.formatter = pkgs: pkgs.nixfmt-classic;

  flake-file.inputs = {
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    nixpkgs.url = "github:nixos/nixpkgs";
  };
}
