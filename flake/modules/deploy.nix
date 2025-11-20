{
  lib,
  config,
  inputs,
  self,
  ...
}:
let
  inherit (builtins)
    elem
    mapAttrs
    attrNames
    hasAttr
    ;
  inherit (lib.attrsets) filterAttrs;

  deployableSystems = attrNames (filterAttrs (_: attrs: attrs.deployable) config.easy-hosts.hosts);
  deployableConfigs = filterAttrs (name: _: elem name deployableSystems) self.nixosConfigurations;

  nodes = mapAttrs (
    hostname: node:
    let
      system = self.nixosConfigurations.${hostname}._module.args.pkgs.stdenv.hostPlatform.system;
      hostConfig = "occhima@${hostname}";
      homeConfig =
        if hasAttr hostConfig self.homeConfigurations then
          builtins.getAttr hostConfig self.homeConfigurations
        else
          self.homeConfigurations.occhima;
    in
    {
      hostname = "localhost";
      profilesOrder = [
        "system"
        "home"
      ];
      profiles = {
        system = {
          user = "root";
          path = inputs.deploy-rs.lib.${system}.activate.nixos node;
        };
        home = {
          user = "occhima";
          path = inputs.deploy-rs.lib.${system}.activate.home-manager homeConfig;
        };
      };
    }
  ) deployableConfigs;
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
