{ lib, importApply, ... }:
let
  contextModules = { shells = ./shell.nix; };

  rawModules = { };

  externalParts = import ./parts { };

  mergedModules = externalParts // rawModules
    // lib.mapAttrs (_: importApply) contextModules;
in mergedModules
