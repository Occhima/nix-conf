# Boot each NixOS host in a QEMU VM with the nixpkgs test driver:
#
#   nix build .#bootTests.<host> -L
#
# The VM is the host's real configuration (extendModules), plus only the
# test framework's VM modules. Kept out of `checks` on purpose: building a
# full host closure on every CI run is too expensive.
{ config, lib, ... }:
let
  hosts = lib.filterAttrs (name: _: name != "voyager") config.flake.nixosConfigurations;
in
{
  perSystem =
    { pkgs, system, ... }:
    {
      legacyPackages.bootTests = lib.mapAttrs (
        name: host:
        let
          inherit (host._module.specialArgs) modulesPath;
        in
        pkgs.testers.runNixOSTest (
          {
            config,
            hostPkgs,
            ...
          }:
          {
            name = "boot-${name}";

            node.pkgsReadOnly = false;

            node.type =
              (host.extendModules {
                modules = [
                  "${modulesPath}/../lib/testing/nixos-test-base.nix"
                  "${modulesPath}/virtualisation/qemu-vm.nix"
                  config.defaults
                  config.nodeDefaults
                  config.extraBaseModules
                  config.extraBaseNodeModules
                  {
                    _module.args = {
                      inherit (config) containers;
                      nodes = config.nodesCompat;
                    };
                    virtualisation.qemu = { inherit (config.qemu) package forceAccel; };
                    virtualisation.host.pkgs = hostPkgs;
                  }
                ];
              }).type;

            nodes.machine = {
              virtualisation = {
                memorySize = 4096;
                cores = 4;
                graphics = false;
                fileSystems."/boot" = {
                  device = "tmpfs";
                  fsType = "tmpfs";
                };
              };
              boot.consoleLogLevel = lib.mkForce 7;
              systemd.settings.Manager = {
                DefaultTimeoutStartSec = lib.mkForce 300;
                DefaultDeviceTimeoutSec = lib.mkForce 300;
              };
              systemd.user.settings.Manager = {
                DefaultTimeoutStartSec = lib.mkForce 300;
                DefaultDeviceTimeoutSec = lib.mkForce 300;
              };
              boot.kernelModules = lib.mkForce (
                lib.filter (m: !lib.hasPrefix "nvidia" m) host.config.boot.kernelModules
              );
            };

            testScript = ''
              machine.wait_for_unit("multi-user.target")
              ${lib.concatMapStrings (user: ''
                machine.wait_for_unit("home-manager-${user}.service")
              '') (lib.attrNames (host.config.home-manager.users or { }))}
              failed = machine.succeed("systemctl list-units --failed --plain --no-legend")
              assert failed == "", f"failed units:\n{failed}"
            '';
          }
        )
      ) (lib.filterAttrs (_: host: host.pkgs.stdenv.hostPlatform.system == system) hosts);
    };
}
