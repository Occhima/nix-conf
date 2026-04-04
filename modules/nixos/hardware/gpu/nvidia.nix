{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkDefault
    getName
    optionals
    ;
  cfg = config.modules.hardware.gpu;
in
{
  config = mkIf (cfg.type == "nvidia") {
    nixpkgs.config = {
      cudaSupport = true;
      allowUnfreePredicate =
        pkg:
        builtins.elem (getName pkg) [
          "cudatoolkit"
          "cuda_cudart"
          "cuda_cccl"
          "cuda_nvcc"
          "libcublas"
          "libcufft"
          "libcurand"
          "libcusolver"
          "libcusparse"
          "libnpp"
          "nvidia-persistenced"
          "nvidia-settings"
          "nvidia-x11"
        ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      graphics = {
        extraPackages = with pkgs; [

          nvidia-vaapi-driver
          libva-vdpau-driver
          libvdpau-va-gl
          # Add CUDA packages to system graphics packages
          cudaPackages.cudatoolkit
          cudaPackages.cuda_cudart
        ];
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
      kernelParams = optionals (builtins.elem "nvidia" config.services.xserver.videoDrivers) [
        "nvidia-drm.modeset=1"
        "nvidia_drm.fbdev=1"
      ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";

      # NOTE: I had to add this to run nyxt appimages
      __EGL_VENDOR_LIBRARY_FILENAMES = mkDefault "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      # FIXME: ttps://forums.developer.nvidia.com/t/580-65-06-gtk-4-apps-hang-when-attempting-to-exit-close/341308/6
      GSK_RENDERER = "ngl";
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
      cudaPackages.cudatoolkit
      cudaPackages.cuda_nvcc
      cudaPackages.cuda_cccl
      cudaPackages.libcublas
      cudaPackages.cuda_cudart
      #(nvtopPackages.nvidia)
    ];

  };
}
