{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib.custom) isWayland;

  cfg = config.modules.services.steam;

in
{
  options.modules.services.steam = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      extest.enable = true;
      package = mkIf (isWayland config) (
        pkgs.steam.override {
          extraEnv = {
            # Wayland & Display
            PROTON_ENABLE_WAYLAND = 1;
            PROTON_ENABLE_HDR = 1;
            ENABLE_HDR_WSI = 1;
            PROTON_NO_WM_DECORATION = 1;
            WAYLANDDRV_PRIMARY_MONITOR = config.modules.hardware.monitors.primaryMonitorName;

            # NVIDIA RTX 50 series optimizations
            PROTON_ENABLE_NVAPI = 1;
            PROTON_HIDE_NVIDIA_GPU = 0;
            PROTON_NVIDIA_LIBS_NO_32BIT = 1;
            PROTON_DLSS_UPGRADE = 1;
            PROTON_NVIDIA_NVOPTIX = 1;

            # Sync & Threading
            PROTON_USE_NTSYNC = 1;
            GAMEMODERUN = 1;

            # Shader compilation & caching
            DXVK_ASYNC = 1;
            DXVK_STATE_CACHE = 1;
            __GL_SHADER_DISK_CACHE = 1;
            __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;

            # DX12 / VKD3D ray tracing
            VKD3D_CONFIG = "dxr";
          };
        }
      );

    };
  };
}
