{ lib, ... }:
let
  inherit (lib.occhima) nixModulesFromDir hostSpecsFromDir;
in
{
  "test nixModulesFromDir with empty directory" = {
    expr = nixModulesFromDir ./fixtures/empty-dir;
    expected = [ ];
  };

  "test nixModulesFromDir follows the documented rules" = {
    expr = lib.sort (a: b: toString a < toString b) (nixModulesFromDir ./fixtures/discovery-tree);
    expected = [
      # plain nix files are imported, recursively; _private is skipped
      ./fixtures/discovery-tree/nested/inner.nix
      # a directory with a default.nix is imported as a whole
      ./fixtures/discovery-tree/packaged
      ./fixtures/discovery-tree/top.nix
    ];
  };

  "test hostSpecsFromDir loads only directories with a default.nix" = {
    expr = hostSpecsFromDir ./fixtures/host-tree;
    expected = {
      alpha = {
        system = "x86_64-linux";
        stateVersion = "25.05";
      };
    };
  };
}
