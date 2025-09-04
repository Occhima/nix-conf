{
  lib,
  osConfig,
  ...
}:
let
  inherit (lib)
    mkIf
    mapAttrsToList
    ;
  monitors = osConfig.modules.hardware.monitors or { };
  displays = monitors.displays or { };

  # TODO...
  mkHyprMonitorsV2 =
    _monitorConfig:
    mapAttrsToList (_: monitorCfg: {
      inherit (monitorCfg)
        mode
        position
        output
        ;
    }) _monitorConfig;

in
{
  config = mkIf (displays != { }) {
    wayland.windowManager.hyprland.settings = {
      # monitor = mkHyprMonitors displays;
      monitorv2 = mkHyprMonitorsV2 displays;
      # workspace = mkHyprWorkspaces displays primaryMonitor;
    };
  };
}
