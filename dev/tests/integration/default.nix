{
  self,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mapAttrs;
  hosts = {
    minimal = ./hosts/minimal.nix;
  };
  mkTest =
    name: hostPath:
    pkgs.testers.runNixOSTest {
      name = "integration-${name}";
      nodes = {
        machine =
          { ... }:
          {
            imports = [
              self.nixosModules.common
              self.nixosModules.nixos
              hostPath
            ];
            virtualisation.memorySize = 512;
          };
      };
      testScript = ''
        machine.start()
        machine.wait_for_unit("multi-user.target")
        machine.succeed("uname -a")
        machine.succeed("test $(cat /etc/hostname) = integration-test")
      '';
      specialArgs = {
        inherit self inputs;
      };
    };

  outDerivation = mapAttrs mkTest hosts;
in
outDerivation.minimal
