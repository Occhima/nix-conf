{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.hardware.gpu;
in
{
  config = mkIf (cfg.type == "intel") {
    # Enable i915 kernel module
    boot.initrd.kernelModules = [ "i915" ];

    # Enable modesetting since this is recommended for Intel GPUs
    services.xserver.videoDrivers = [ "modesetting" ];

    # Enable graphics with OpenCL support and VAAPI
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = [
        pkgs.libva-vdpau-driver
        pkgs.intel-media-driver
        (pkgs.intel-vaapi-driver.override { enableHybridCodec = true; })
      ];

      extraPackages32 = [
        pkgs.pkgsi686Linux.libva-vdpau-driver
        pkgs.pkgsi686Linux.intel-media-driver
        (pkgs.pkgsi686Linux.intel-vaapi-driver.override { enableHybridCodec = true; })
      ];
    };

    # Add Intel GPU tools and other utilities
    environment.systemPackages = with pkgs; [
      intel-gpu-tools
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      libva
      libva-utils
      mesa
    ];

    # Set proper VDPAU driver
    environment.variables = mkIf config.hardware.graphics.enable {
      VDPAU_DRIVER = "va_gl";
    };
  };
}
