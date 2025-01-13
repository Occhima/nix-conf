{ lib, ... }:
let
  loadTestSuite =
    suiteTitle: path:
    let
      suite = import path { inherit lib; };
    in
    lib.attrsets.foldlAttrs (
      acc: testTitle: test:
      acc
      // {
        "test_${suiteTitle}_${testTitle}" = test;
      }
    ) { } suite;

  testSuiteFiles = {
    "custom" = ./testCustom.nix;
  };
in
lib.attrsets.mergeAttrsList (
  lib.attrValues (
    lib.mapAttrs loadTestSuite testSuiteFiles
  )
)
