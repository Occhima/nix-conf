# This was stolen from : https://github.com/mstream/nix-chad/blob/main/test/default.nix
{ lib, ... }:
let
  loadTestSuite =
    suiteTitle: path:
    let
      suite = import path { inherit lib; };
    in
    lib.attrsets.foldlAttrs (
      acc: testTitle: test:
      acc // { "test_${suiteTitle}_${testTitle}" = test; }
    ) { } suite;

  testSuiteFiles = {
    "custom" = ./testCustom.nix;
    "nixos" = ./testNixos.nix;
  };
in
lib.attrsets.mergeAttrsList (lib.attrValues (lib.mapAttrs loadTestSuite testSuiteFiles))
