{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  modules = {
    network = {
      enable = true;
      hostName = "steammachine";
      networkmanager.enable = true;
      firewall.enable = true;
      blocker.enable = true;
      wireless.enable = true;
    };

    hardware = {
      cpu.type = "amd";
      gpu.type = "nvidia";

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

      input = {
        keyboard = {
          layout = "us";
          variant = "";
        };
        naturalScrolling = true;
      };

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

      bluetooth = {
        enable = true;
        gui = true;
        autoReset = true;
      };

      wifi = {
        enable = true;
        interfaces = [ "wlan0" ];
      };

      yubikey.enable = true;
    };

    security = {
      kernel.enable = true;
      auditd.enable = true;
    };

    system = {
      boot = {
        loader = {
          type = "grub";
          grub = {
            device = "nodev";
          };
        };
        kernel = {
          enableKernelTweaks = true;
          silentBoot = true;
          tmpOnTmpfs = true;
          loadRecommendedModules = true;
          initrd = {
            enableTweaks = true;
            optimizeCompressor = true;
          };
        };
        plymouth.enable = true;
      };

      display = {
        type = "wayland";
      };

      login = {
        enable = true;
        manager = "sddm";
        autoLogin = false;
      };
    };

    secrets = {
      agenix-rekey = {
        enable = true;
        secretsDir = ../secrets/vault;
        hostPublicKey = ../secrets/identity/id_ed25519.pub;
        publicKeys = [ ../secrets/identity/yubi-identity.pub ];
        storageDir = ./rekeyed;
      };
    };

    services = {
      systemd = {
        enable = true;
        optimizeServices = true;
      };

      oom = {
        enable = true;
        earlyoom = {
          enable = true;
          enableNotifications = true;
        };
      };

      firmware.enable = true;
    };
  };
}
