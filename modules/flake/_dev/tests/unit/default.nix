# This was stolen from : https://github.com/mstream/nix-chad/blob/main/test/default.nix
{ lib, self, ... }:
let
  loadTestSuite =
    suiteTitle: path:
    let
      suite = import path { inherit lib self; };
    in
    lib.attrsets.foldlAttrs (
      acc: testTitle: test:
      acc // { "test_${suiteTitle}_${testTitle}" = test; }
    ) { } suite;

  testSuiteFiles = {
    "helpers" = ./testHelpers.nix;
    "themeLib" = ./testThemeLib.nix;
    "outputs" = ./testOutputs.nix;
  };
in
lib.attrsets.mergeAttrsList (lib.attrValues (lib.mapAttrs loadTestSuite testSuiteFiles))
