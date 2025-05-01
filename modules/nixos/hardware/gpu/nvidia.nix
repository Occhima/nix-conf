{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.modules.hardware.gpu;
in
{
  config = mkIf (cfg.type == "nvidia") {

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [
          pkgs.vaapiVdpau
          pkgs.nvidia-vaapi-driver
          pkgs.libva
        ];
        extraPackages32 = [
          pkgs.pkgsi686Linux.nvidia-vaapi-driver
        ];
      };

      nvidia = {
        # Use the beta driver package by default
        package = mkDefault config.boot.kernelPackages.nvidiaPackages.beta;

        # Use the NVidia open source kernel module (for Turing+ GPUs)
        # Currently alpha-quality/buggy, so false is currently the recommended setting
        open = false;

        # Power management settings
        powerManagement = {
          enable = true;
          finegrained = false;
        };

        # Other settings
        nvidiaSettings = true;
        nvidiaPersistenced = true;
        modesetting.enable = true;
      };
    };

    boot = {
      # Blacklist nouveau module as it conflicts with NVIDIA driver
      blacklistedKernelModules = [ "i2c_nvidia_gpu" ];

      # Enable NVIDIA's experimental framebuffer device
      kernelParams = [ "nvidia-drm.fbdev=1" ];
    };

    # Wayland support environment variables
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";

      # May cause Firefox crashes
      # GBM_BACKEND = "nvidia-drm";

      # If you face problems with Discord or Zoom, remove this
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    # System packages
    environment.systemPackages = with pkgs; [
      # NVIDIA utilities
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      libva
      libva-utils
      mesa

      # CUDA support
      cudaPackages.cudatoolkit

      # Monitoring tools
      (nvtopPackages.nvidia)
    ];

    # CUDA environment variables
    environment.variables = {
      CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    };

    # X server settings to disable screen blanking
    services.xserver = {
      # disable DPMS
      monitorSection = ''
        Option "DPMS" "false"
      '';

      # disable screen blanking in general
      serverFlagsSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
        Option "BlankTime" "0"
      '';
    };
  };
}
