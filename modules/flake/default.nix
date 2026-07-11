# Structural layer: every `*.nix` file under this directory is a
# flake-parts (top-level) module and is imported automatically.
#
# Rules:
#   1. every `*.nix` file is imported, recursively;
#   2. `default.nix` files are never imported (this loader is the only one
#      allowed in the tree);
#   3. files and directories whose name starts with `_` are skipped.
#
# Modules in this tree declare top-level schema, register the root NixOS
# and Home Manager modules, load host specifications and construct flake
# outputs. They must not contain machine-specific behavioral configuration.
let
  collect =
    dir:
    builtins.concatLists (
      builtins.attrValues (
        builtins.mapAttrs (
          name: type:
          if builtins.substring 0 1 name == "_" then
            [ ]
          else if type == "directory" then
            collect (dir + "/${name}")
          else if type == "regular" && builtins.match ".*\\.nix" name != null && name != "default.nix" then
            [ (dir + "/${name}") ]
          else
            [ ]
        ) (builtins.readDir dir)
      )
    );
in
{
  imports = collect ./.;
}
