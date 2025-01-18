{ lib, ... }:
let
  inherit (lib.custom) mapModulesRec;
  modules = mapModulesRec ./. import;
in
modules
