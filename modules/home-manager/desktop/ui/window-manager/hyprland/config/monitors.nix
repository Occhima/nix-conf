{
  lib,
  osConfig,
  ...
}:
let
  inherit (lib)
    mkIf
    mapAttrsToList
    range
    ;
  monitors = osConfig.modules.hardware.monitors or { };
  displays = monitors.displays or { };
  primaryMonitor = monitors.primaryMonitorName;

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

  mkHyprWorkspaces =
    displays: primaryMonitor:
    let
      primary = displays.${primaryMonitor}.output;
      monitorNames = map (m: m.output) (lib.attrValues displays);
      secondary = lib.findFirst (m: m != primary) primary monitorNames;
    in
    [ "1, monitor:${primary}, default:true" ]
    ++ map (num: "${toString num}, monitor:${primary}") (range 2 9)
    ++ [ "10, monitor:${secondary}" ];

in
{
  config = mkIf (displays != { }) {
    wayland.windowManager.hyprland.settings = {
      # monitor = mkHyprMonitors displays;
      monitorv2 = mkHyprMonitorsV2 displays;
      workspace = mkHyprWorkspaces displays primaryMonitor;
    };
  };
}
