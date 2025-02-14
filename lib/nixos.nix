{ lib, ... }:
with builtins;
with lib;
with lib.filesystem;
rec {

  attrsToList = attrs: mapAttrsToList (name: value: { inherit name value; }) attrs;

  mapFilterAttrs =
    pred: f: attrs:
    filterAttrs pred (mapAttrs' f attrs);

  mapModulesRec =
    dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n)) (
      n: v:
      let
        path = "${toString dir}/${n}";
      in
      if v == "directory" then
        nameValuePair n (mapModulesRec path fn)
      else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n then
        nameValuePair (removeSuffix ".nix" n) (fn path)
      else
        nameValuePair "" null
    ) (readDir dir);

  # filterNixFiles =
  #   files:
  #   files
  #   |> map toString
  #   |> (f: filter (file: match ".*\\.nix$" file != null && file != "flake-module.nix") f);

  #####################################################################
  # collectNixModulePaths: Recursively collect all .nix files from the given
  # directory by using lib.filesystem.lisFilesRecursively and then filtering
  # the result with filterNixFiles.
  #####################################################################
  # collectNixModulePaths = dir: listFilesRecursive dir |> filterNixFiles;

  # filterNixFiles =
  #   files:
  #   lib.pipe files (map toString) (
  #     f: filter (file: match ".*\\.nix$" file != null && file != "flake-module.nix") f
  #   );

  #####################################################################
  # collectNixModulePaths: Recursively collect all .nix files from the given
  # directory by using lib.filesystem.listFilesRecursively and then filtering
  # the result with filterNixFiles.
  #####################################################################
  # collectNixModulePaths = dir: lib.pipe (listFilesRecursive dir) filterNixFiles;
  filterNixFiles =
    files:
    filter (file: match ".*\\.nix$" file != null && file != "flake-module.nix") (map toString files);

  #####################################################################
  # collectNixModulePaths: Recursively collect all .nix files from the given
  # directory by using lib.filesystem.listFilesRecursively and then filtering
  # the result with filterNixFiles.
  #####################################################################
  collectNixModulePaths = dir: filterNixFiles (listFilesRecursive dir);

  # stolen from :https://github.com/isabelroses/dotfiles/blob/main/modules/flake/lib/validators.nix
  ifTheyExist = config: groups: filter (group: hasAttr group config.users.groups) groups;
}
