{ lib, ... }:
let
  inherit (lib.custom) mapModulesRec;
  modules = mapModulesRec ./. import [
    "default.nix"
    "flake-module.nix"
  ];
in
modules
