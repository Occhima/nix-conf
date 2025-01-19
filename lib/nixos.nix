{ lib, ... }:
with builtins;
with lib;
rec {

  attrsToList = attrs: mapAttrsToList (name: value: { inherit name value; }) attrs;

  mapFilterAttrs =
    pred: f: attrs:
    filterAttrs pred (mapAttrs' f attrs);

  mapModulesRec =
    dir: fn: excludes:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n)) (
      n: v:
      let
        path = "${toString dir}/${n}";
      in
      if v == "directory" then
        nameValuePair n (mapModulesRec path fn)
      else if v == "regular" && !elem n excludes && hasSuffix ".nix" n then
        nameValuePair (removeSuffix ".nix" n) (fn path)
      else
        nameValuePair "" null
    ) (readDir dir);

  # mkModules =
  #   {
  #     path,
  #   }:
  #   {

  #   };
  # mkHost =
  #   path:
  #   attrs@{
  #     system,
  #     ...
  #   }:
  #   nixosSystem {
  #     inherit system;
  #     specialArgs = {
  #       inherit lib inputs system;
  #     };
  #     modules = [
  #       {
  #         nixpkgs.pkgs = pkgs;
  #         networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
  #       }
  #       (filterAttrs (n: _v: !elem n [ "system" ]) attrs)
  #       ../.
  #       (import path)
  #     ];
  #   };

}
