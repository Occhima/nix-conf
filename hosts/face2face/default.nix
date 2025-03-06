{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];
  networking = {
    useDHCP = true;
    hostName = "face2face";
  };

  modules = {
    virtualisation = {

      vm = {
        enable = true;
        memorySize = 10192; # 8GB RAM
        diskSize = 180960; # 40GB disk
      };

      docker = {
        enable = true;
        usePodman = true; # Use podman for docker compatibility
      };

      distrobox.enable = true;
      qemu.enable = false; # Not needed for a headless VM
    };

    home-manager.enable = true;
    hardware.yubikey.enable = false;

    secrets.agenix-rekey = {
      enable = true;
      secretsDir = ../secrets/vault;
      hostPublicKey = ../secrets/identity/id_ed25519.pub;
      publicKeys = [ ../secrets/identity/yubi-identity.pub ];
      storageDir = ./rekeyed;
    };
  };

}
