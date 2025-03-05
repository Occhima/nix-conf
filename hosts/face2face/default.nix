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

  # Virtualization configuration
  modules = {
    # Enable overall virtualization support
    virtualisation = {

      # Configure as VM guest
      vm = {
        enable = true;
        memorySize = 8192; # 8GB RAM
        diskSize = 40960; # 40GB disk
      };

      # Add container support
      docker = {
        enable = true;
        usePodman = true; # Use podman for docker compatibility
      };

      distrobox.enable = true;
      qemu.enable = false; # Not needed for a headless VM
    };

    # Hardware configuration
    hardware.yubikey.enable = false;

    # Secrets management
    secrets.agenix-rekey = {
      enable = true;
      secretsDir = ../secrets/vault;
      hostPublicKey = ../secrets/identity/id_ed25519.pub;
      publicKeys = [ ../secrets/identity/yubi-identity.pub ];
      storageDir = ./rekeyed;
    };
  };

}
