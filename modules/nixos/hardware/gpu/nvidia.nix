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
    nixpkgs.config.allowUnfree = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      graphics = {
        extraPackages = [ pkgs.nvidia-vaapi-driver ];
      };

      nvidia = {
        package = mkDefault config.boot.kernelPackages.nvidiaPackages.beta;
        open = true;
        powerManagement = {
          enable = true;
          finegrained = false;
        };

        nvidiaSettings = true;
        nvidiaPersistenced = true;
        modesetting.enable = true;
      };
    };

    boot = {
      blacklistedKernelModules = [
        "i2c_nvidia_gpu"
      ];
      kernelParams = [ "nvidia-drm.fbdev=1" ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      __EGL_VENDOR_LIBRARY_FILENAMES = mkDefault "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    environment.systemPackages = with pkgs; [
      # NVIDIA utilities
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      libva
      libva-utils
      mesa
      #(nvtopPackages.nvidia)
    ];

  };
}
