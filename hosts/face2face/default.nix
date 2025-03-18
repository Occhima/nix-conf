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
        memorySize = 8192; # 8GB RAM - balanced for performance and host resource usage
        diskSize = 40960; # 40GB disk
      };
      docker = {
        enable = false;
        usePodman = false; # Use podman for docker compatibility
      };
      distrobox.enable = false;
      qemu.enable = true;
    };
    # User accounts management
    accounts = {
      enable = true;
      enabledUsers = [
        "occhima"
        "root"
      ];
      enableHomeManager = true;
    };

    hardware.yubikey.enable = true;

    secrets.agenix-rekey = {
      enable = true;
      secretsDir = ../secrets/vault;
      hostPublicKey = ../secrets/identity/id_ed25519.pub;
      publicKeys = [ ../secrets/identity/yubi-identity.pub ];
      storageDir = ./rekeyed;
    };
  };

}
