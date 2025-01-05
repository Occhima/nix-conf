{ inputs, ... }:

# let
#   # Define `collectNixFiles` within the same let block
#   collectNixFiles = path:
#     let entries = builtins.readDir path;
#     in builtins.foldl' (acc: name:
#       let
#         fullPath = "${path}/${name}";
#         isDir = entries.${name}.isDirectory;
#       in if isDir then
#         acc ++ collectNixFiles fullPath
#       else if lib.hasSuffix ".nix" name then
#         acc ++ [ fullPath ]
#       else
#         acc) [ ] (builtins.attrNames entries);

#   nixFiles = collectNixFiles ./tests;

#   # Import all .nix files and merge them into one attribute set
#   allTests = builtins.map (file: import file) nixFiles // { };

# in
{

  imports = [ inputs.nix-unit.modules.flake.default ];
  perSystem = { ... }: {

    nix-unit = {
      inputs = { inherit (inputs) nixpkgs flake-parts nix-unit; };
      allowNetwork = true;
      enableSystemAgnostic = true;
      # tests = allTests;

      tests = {
        "test integer equality is reflexive" = {
          expr = "123";
          expected = "123";
        };
      };
    };
  };

}
