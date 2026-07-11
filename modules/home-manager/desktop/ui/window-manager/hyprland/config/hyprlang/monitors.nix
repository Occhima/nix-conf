{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mapAttrsToList
    ;
  monitors = config.modules.hostContext.monitors;
  displays = monitors.displays or { };

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
