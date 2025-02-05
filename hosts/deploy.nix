{
  lib,
  self,
  inputs,
  config,
  ...
}:
let
  inherit (builtins) elem mapAttrs attrNames;
  inherit (lib.attrsets) filterAttrs;

  deployableSystems = attrNames (filterAttrs (_: attrs: attrs.deployable) config.easy-hosts.hosts);

  easyHostsFromDeployableSystems = filterAttrs (
    name: _: elem name deployableSystems
  ) self.nixosConfigurations;
in
{
  flake = {
    deploy = {
      autoRollback = true;
      magicRollback = true;

      nodes = mapAttrs (name: node: {
        hostname = "localhost"; # all of my configs are local,
        profiles.system = {
          user = "root";
          sshUser = node.config.homeModules.user.mainUser or "root";
          path = inputs.deploy-rs.lib.${config.easy-hosts.hosts.${name}.system}.activate.nixos node;
        };
      }) easyHostsFromDeployableSystems;
    };
    checks = builtins.mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
