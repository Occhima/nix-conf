{lib, ...}:
{
  "test if kebabToCamelCase works correcty" = {
    expr = lib.custom.kebabCaseToCamelCase"a-b-c-d";
    expected =  "aBCD";
  };
  "test if kebabToCamelCase works correct with camel Case string" = {
    expr = lib.custom.kebabCaseToCamelCase "aBCD";
    expected =  "aBCD";
  };

  "test if modulesFromDir returns empty set" = {
    expr = lib.custom.modulesFromDir ./fixtures/empty-dir;
    expected = {};
  };

  "test if modulesFromDir returns set of modules when dir not empty" = {
    expr = let
    myAttrs = { a = 1; b = 2; };
    attrsToCheck = [ "a" "b" ];
  in
    builtins.all (attr: builtins.hasAttr attr myAttrs) attrsToCheck;
    expected = true;

  };


}
