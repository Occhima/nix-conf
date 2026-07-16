# Public module exports: every aspect is exported individually as
# `nixosModules.<aspect>` / `homeModules.<aspect>`, so external consumers
# pick exactly what they want — there is no kitchen-sink module that
# merges everything (importing one of those would, among other things,
# create this repo's users on a foreign machine).
# Host and user environment aspects are excluded; their names are derived
# from the actual outputs, never from a duplicated list.
{ config, lib, ... }:
let
  hostNames = builtins.attrNames config.flake.nixosConfigurations;
  userNames = builtins.attrNames config.flake.homeConfigurations;
in
{
  flake.nixosModules = lib.filterAttrs (
    name: _: !(builtins.elem name hostNames)
  ) config.flake.modules.nixos;

  flake.homeModules = lib.filterAttrs (
    name: _: !(builtins.elem name userNames)
  ) config.flake.modules.homeManager;
}
