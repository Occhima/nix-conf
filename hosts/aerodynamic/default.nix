{
  modules = {
    profiles = {
      enable = true;
      active = [
        "laptop"
        "graphical"
      ];
    };

    accounts = {
      enable = true;
      enabledUsers = [
        "occhima"
        "root"
      ];
      enableHomeManager = true;
    };

    network = {
      enable = true;
      hostName = "aerodynamic";
      networkmanager.enable = true;
      firewall.enable = true;
      blocker.enable = true;
      wireless.enable = true;
    };

    hardware = {
      cpu.type = "intel";
      gpu.type = "nvidia";
      ssd.enable = true;

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
          variant = "intl";
        };
      };

      bluetooth = {
        enable = true;
        gui = true;
        autoReset = false;
      };

      wifi = {
        enable = true;
      };

      yubikey.enable = true;
    };

    security = {
      kernel.enable = false;
      # auditd.enable = true;
    };

    system = {
      appimage.enable = true;

      boot = {
        loader = {
          type = "grub";
          grub.device = "/dev/nvme0n1";
        };
        kernel = {
          enableKernelTweaks = true;
          loadRecommendedModules = true;
          initrd = {
            enableTweaks = true;
          };
        };
        plymouth.enable = true;

      };

      display = {
        type = "wayland";
        enableHyprlandEssentials = true;
      };

      file-system = {
        impermanence.enable = true;
        disko.enable = true;
      };

      login = {
        enable = true;
        manager = "greetd";
      };
    };

    # TODO ...
    secrets = {
      agenix = {
        enable = true;
      };
    };

    services = {
      systemd = {
        enable = true;
        optimizeServices = false;
      };
      firmware.enable = true;
      flatpak.enable = false;
      ssh.enable = true;
    };

  };
}
