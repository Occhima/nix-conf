# Compatibility exports: aggregate every non-host aspect into the
# conventional `nixosModules`/`homeModules` outputs for external consumers.
# Host aspects are excluded by deriving their names from the actual
# nixosConfigurations/homeConfigurations outputs — no duplicated name list.
{ config, lib, ... }:
let
  hostNames = builtins.attrNames config.flake.nixosConfigurations;
  userNames = builtins.attrNames config.flake.homeConfigurations;
  nixosAspects = lib.filterAttrs (name: _: !(builtins.elem name hostNames)) config.flake.modules.nixos;
  hmAspects = lib.filterAttrs (name: _: !(builtins.elem name userNames)) config.flake.modules.homeManager;
in
{
  flake.nixosModules = {
    common.imports = builtins.attrValues nixosAspects;
    nixos.imports = builtins.attrValues nixosAspects;
    iso.imports = builtins.attrValues nixosAspects;
  };
  flake.homeModules = {
    default.imports = builtins.attrValues hmAspects;
  };
}
