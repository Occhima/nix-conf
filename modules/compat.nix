{ config, lib, ... }:
let
  hostNames = [
    "aerodynamic"
    "beyond"
    "crescendoll"
    "steammachine"
    "voyager"
  ];
  # Filter out host-specific composition aspects
  nixosAspects = lib.filterAttrs (
    name: _: !(builtins.elem name hostNames)
  ) config.flake.modules.nixos;
  hmAspects = lib.filterAttrs (name: _: name != "occhima") config.flake.modules.homeManager;
in
{
  flake.nixosModules = {
    common = {
      imports = builtins.attrValues nixosAspects;
    };
    nixos = {
      imports = builtins.attrValues nixosAspects;
    };
    iso = {
      imports = builtins.attrValues nixosAspects;
    };
  };
  flake.homeModules = {
    default = {
      imports = builtins.attrValues hmAspects;
    };
  };
}
