{ lib, ... }:
let
  inherit (lib.custom)
    attrsToList
    mapModulesRec
    collectNixModulePaths
    filterNixFiles
    filterIgnoreModules
    ;
in
{
  "test attrsToList with non-empty attributes" = {
    expr = attrsToList {
      a = 1;
      b = 2;
    };
    expected = [
      {
        name = "a";
        value = 1;
      }
      {
        name = "b";
        value = 2;
      }
    ];
  };

  "test attrsToList with empty attributes" = {
    expr = attrsToList { };
    expected = [ ];
  };

  # "test mapFilterAttrs with predicate and function" = {
  #   expr = mapFilterAttrs (name: _: name != "b") (name: value: value * 2) {
  #     a = "a";
  #     b = "b";
  #     c = "c";
  #   };
  #   expected = {
  #     a = "a";
  #     c = "c";
  #   };
  # };

  "test mapModulesRec with empty directory" = {
    expr = mapModulesRec ./fixtures/empty-dir import;
    expected = { };
  };

  "test mapModulesRec with directory and excludes" = {
    expr = mapModulesRec ./fixtures/empty-dir import;
    expected = { };
  };
  "test filterNixFiles filters only .nix files" = {
    expr = filterNixFiles [
      "foo.nix"
      "bar.txt"
      "baz.nix"
      "README.md"
    ];
    expected = [
      "foo.nix"
      "baz.nix"
    ];
  };

  "test filterNixFiles with empty input" = {
    expr = filterNixFiles [ ];
    expected = [ ];
  };

  #####################################################################
  # Tests for collectNixModulePaths
  #####################################################################

  # Assuming that ./fixtures/empty-dir is an empty directory.
  "test collectNixModulePaths with empty directory" = {
    expr = collectNixModulePaths ./fixtures/empty-dir;
    expected = [ ];
  };

  #####################################################################
  # Tests for filterIgnoreModules
  #####################################################################

  "test filterIgnoreModules with no flag" = {
    expr = filterIgnoreModules [
      "/test/dir1/file1.nix"
      "/test/dir2/file2.nix"
      "/test/dir3/file3.nix"
    ];

    expected = [
      "/test/dir1/file1.nix"
      "/test/dir2/file2.nix"
      "/test/dir3/file3.nix"
    ];
  };

  "test filterIgnoreModules with empty input" = {
    expr = filterIgnoreModules [ ];
    expected = [ ];
  };

  "test filterIgnoreModules with flag" = {
    expr = filterIgnoreModules [
      "/test/dir1/file1.nix"
      "/test/dir2/file2.nix"
      "/test/dir3/file3.nix"
      "/test/dir4/.moduleIgnore"
      "/test/dir4/file1.nix"
      "/test/dir4/file2.nix"
      "/test/dir4/dir5/file.nix"
      "/test/dir4/a/b/c/file.nix"
      "/test/a/b/c/d/.moduleIgnore"
      "/test/a/b/c/d/test.nix"
      "/test/a/b/c/test.nix"
    ];

    expected = [
      "/test/dir1/file1.nix"
      "/test/dir2/file2.nix"
      "/test/dir3/file3.nix"
      "/test/a/b/c/test.nix"
    ];
  };

}
