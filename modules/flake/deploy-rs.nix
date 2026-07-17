# deploy-rs integration. No host registry: a host opts into deployment by
# contributing its own node, e.g. from its host module:
#
#   flake.deploy.nodes.<host> = { hostname = ...; profiles.system = ...; };
#
# All hosts are currently non-deployable, so `nodes` is empty.
{ config, lib, inputs, ... }:
{
  flake-file.inputs.deploy-rs = {
    url = "github:serokell/deploy-rs";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake = {
    deploy = {
      remoteBuild = false;
      magicRollback = true;
      nodes = { };
    };
    checks = lib.mapAttrs (_: deployLib: deployLib.deployChecks config.flake.deploy) inputs.deploy-rs.lib;
  };
}
