{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # enabling modules
  modules = {
    # Hardware configuration
    hardware = {
      # CPU and GPU
      cpu.type = "amd";
      gpu.type = "nvidia";

      # Media
      media = {
        sound = {
          enable = true;
          backend = "pipewire";
          optimizedSettings = true;
        };
        video = {
          enable = true;
          benchmarking = false;
        };
      };

      # Input devices
      input = {
        keyboard = {
          layout = "us";
          variant = "";
        };
        naturalScrolling = true;
      };

      # Monitors configuration
      monitors = {
        primaryMonitorName = "dp1";
        displays = {
          dp1 = {
            name = "DP-1";
            mode = "2560x1440@144";
            position = "0,0";
          };
        };
      };

      # Wireless and Bluetooth
      bluetooth = {
        enable = true;
        gui = true;
        autoReset = true;
      };

      wifi = {
        enable = true;
        interfaces = [ "wlan0" ];
      };

      # Security devices
      yubikey.enable = true;
    };

    # Secrets management
    secrets = {
      agenix-rekey = {
        enable = true;
        secretsDir = ../secrets/vault;
        hostPublicKey = ../secrets/identity/id_ed25519.pub;
        publicKeys = [ ../secrets/identity/yubi-identity.pub ];
        storageDir = ./rekeyed;
      };
    };
  };
}
