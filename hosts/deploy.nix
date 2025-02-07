{
  lib,
  config,
  inputs,
  self,
  ...
}:
let
  inherit (builtins) elem mapAttrs attrNames;
  inherit (lib.attrsets) filterAttrs;

  deployableSystems = attrNames (filterAttrs (_: attrs: attrs.deployable) config.easy-hosts.hosts);
  deployableConfigs = filterAttrs (name: _: elem name deployableSystems) self.nixosConfigurations;

  nodes = mapAttrs (hostname: node: {
    inherit hostname;
    profiles = {
      system = {
        user = "root";
        path = inputs.deploy-rs.lib.${config.easy-hosts.hosts.${hostname}.system}.activate.nixos node;
      };
      home = {
        user = "occhima";
        path =
          inputs.deploy-rs.lib.${config.easy-hosts.hosts.${hostname}.system}.activate.home-manager
            self.homeConfigurations."occhima@${hostname}";
      };
    };
  }) deployableConfigs;
in
{
  flake = {
    deploy = {
      remoteBuild = false;
      magicRollback = true;
      inherit nodes;

    };
    checks = mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };

}
