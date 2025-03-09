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

  # Add swap file to help with memory-intensive operations

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
