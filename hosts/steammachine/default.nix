{
  modules = {
    profiles = {
      enable = true;
      active = [
        "desktop"
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
      hostName = "steammachine";
      networkmanager.enable = true;
      firewall.enable = true;
      blocker.enable = true;
      wireless.enable = true;

      vpn = {

        # removing, broken builx fld
        openvpn.enable = false;

      };
    };

    hardware = {
      cpu.type = "amd";
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

      monitors = {
        primaryMonitorName = "dp1";
        displays = {
          dp1 = {
            output = "DP-1";
            mode = "2560x1080@180";
            position = "0x0";
          };
          hdmi = {
            output = "HDMI-A-1";
            mode = "1920x1080@180";
            position = "2560x0";
          };
        };
      };

      bluetooth = {
        enable = true;
        gui = true;
        autoReset = false;
      };

      wifi = {
        enable = false;
      };

      yubikey.enable = true;
    };

    security = {
      kernel.enable = false;
      # auditd.enable = true;
    };

    virtualisation = {
      docker = {
        enable = false;
        usePodman = true; # Use podman for docker compatibility
      };
      containers.pentesting.enable = false;
    };

    system = {
      appimage.enable = true;
      boot = {
        loader = {
          type = "grub";
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
        manager = "sddm";
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
      oom = {
        enable = true;
        earlyoom.enable = true;
      };
      firmware.enable = true;
      flatpak.enable = true;
      ssh.enable = true;
    };

  };
}
