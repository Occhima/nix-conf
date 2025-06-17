{ lib, ... }:
let
  inherit (lib.custom)
    kebabCaseToCamelCase
    modulesFromDir
    recursiveMergeAttrs
    ifTheyExist
    ;
in
{
  "test if kebabToCamelCase works correcty" = {
    expr = kebabCaseToCamelCase "a-b-c-d";
    expected = "aBCD";
  };
  "test if kebabToCamelCase works correct with camel Case string" = {
    expr = kebabCaseToCamelCase "aBCD";
    expected = "aBCD";
  };

  "test if modulesFromDir returns empty set" = {
    expr = modulesFromDir ./fixtures/empty-dir;
    expected = { };
  };

  "test if modulesFromDir returns set of modules when dir not empty" = {
    expr =
      let
        myAttrs = {
          a = 1;
          b = 2;
        };
        attrsToCheck = [
          "a"
          "b"
        ];
      in
      builtins.all (attr: builtins.hasAttr attr myAttrs) attrsToCheck;
    expected = true;

  };

  "test if can recursively merge attributes (top-level)" = {
    expr = recursiveMergeAttrs [
      { a = "foo"; }
      { b = "bar"; }
    ];
    expected = {
      a = "foo";
      b = "bar";
    };
  };

  "test if can recursively merge attributes (nested)" = {
    # Example from the docstring
    expr = recursiveMergeAttrs [
      { a.b = "foo"; }
      { a.c = "bar"; }
    ];
    expected = {
      a = {
        b = "foo";
        c = "bar";
      };
    };
  };

  "test if can filter groups" = {
    # Example from the docstring
    expr =
      let
        conf.users.groups = {
          "a" = "a";
          "b" = "b";
        };
        groups = [
          "a"
          "b"
          "c"
        ];
      in
      ifTheyExist conf groups;
    expected = [
      "a"
      "b"
    ];
  };

}
