# Discovery of conventional (option-driven) module trees and host
# specifications. These loaders are the only automatic import mechanisms
# used below the flake level.
{ lib }:
{
  /*
    Collect every NixOS/Home Manager module in a directory tree.

    Rules:
      1. every `*.nix` file is imported;
      2. a directory containing a `default.nix` is imported through that
         `default.nix` and is not recursed into — the `default.nix` is
         responsible for wiring its own subtree;
      3. files and directories whose name starts with `_` are private
         helpers or data and are never imported.

    The function is meant to be called on a tree root that does not itself
    contain a `default.nix` (the root module lives in `modules/flake`).
  */
  nixModulesFromDir =
    dir:
    let
      collect =
        subdir:
        lib.flatten (
          lib.mapAttrsToList (
            name: type:
            let
              path = subdir + "/${name}";
            in
            if lib.hasPrefix "_" name then
              [ ]
            else if type == "directory" then
              (if builtins.pathExists (path + "/default.nix") then [ path ] else collect path)
            else if type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" then
              [ path ]
            else
              [ ]
          ) (builtins.readDir subdir)
        );
    in
    collect dir;

  /*
    Load host specifications: every immediate subdirectory of `dir` that
    contains a `default.nix` is a host, keyed by directory name. Other
    files in a host directory (hardware config, assets, disko data) are
    never picked up automatically — the specification references them
    explicitly.
  */
  hostSpecsFromDir =
    dir:
    lib.pipe (builtins.readDir dir) [
      (lib.filterAttrs (
        name: type: type == "directory" && builtins.pathExists (dir + "/${name}/default.nix")
      ))
      (lib.mapAttrs (name: _: import (dir + "/${name}")))
    ];
}
