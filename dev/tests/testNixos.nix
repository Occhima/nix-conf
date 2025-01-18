{ lib, ... }:
let
  inherit (lib.custom)
    attrsToList
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
  #     a = 1;
  #     b = 2;
  #     c = 3;
  #   };
  #   expected = {
  #     a = 2;
  #     c = 6;
  #   };
  # };

  # "test mapModulesRec with sample directory" = {
  #   expr = mapModulesRec ./sampleDir (path: path);
  #   expected = {
  #     module1 = ./sampleDir/module1.nix;
  #     subdir = {
  #       module2 = ./sampleDir/subdir/module2.nix;
  #     };
  #   };
  # };

}
