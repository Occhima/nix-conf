{
  lib,
  inputs,
  self,
  ...
}:
let
  # ponytail: empty — all hosts currently deployable=false. Add hostnames here to enable.
  deployableHosts = [ ];
  nodes = lib.genAttrs deployableHosts (
    hostname:
    let
      system = self.nixosConfigurations.${hostname}._module.args.pkgs.stdenv.hostPlatform.system;
      homeConfig = self.homeConfigurations.occhima;
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
          path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${hostname};
        };
        home = {
          user = "occhima";
          path = inputs.deploy-rs.lib.${system}.activate.home-manager homeConfig;
        };
      };
    }
  );
in
{
  flake = {
    deploy = {
      remoteBuild = false;
      magicRollback = true;
      inherit nodes;
    };
    checks = lib.mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
