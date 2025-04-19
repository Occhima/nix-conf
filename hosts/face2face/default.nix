{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  modules.network = {
    enable = true;
    hostName = "face2face";
    networkmanager.enable = true;
    firewall.enable = true;
    blocker.enable = true;
  };

  modules = {
    profiles = {
      enable = true;
      active = [ "headless" ];
    };

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

    secrets = {
      agenix = {
        enable = true;
        masterKeys = [ ./assets/yubi-identity.pub ];
      };
    };
  };

}
