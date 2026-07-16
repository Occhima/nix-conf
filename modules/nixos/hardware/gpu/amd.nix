{ ... }:
{
  config.flake.modules.nixos.gpu-amd =
    { pkgs, ... }:
    {
      # Enable AMD GPU Xorg drivers
      services.xserver.videoDrivers = [ "amdgpu" ];

      # Enable AMDGPU kernel module
      boot = {
        kernelModules = [ "amdgpu" ];
        initrd.kernelModules = [ "amdgpu" ];
      };

      # Enable graphics packages
      hardware.graphics = {
        enable = true;
        # enable32Bit = true;

        # Enable AMDVLK & OpenCL support
        extraPackages = [
          pkgs.rocmPackages.clr
          pkgs.rocmPackages.clr.icd
        ];
      };

      # Add Vulkan support
      environment.systemPackages = with pkgs; [
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        libva
        libva-utils
        mesa
      ];
    };
}
