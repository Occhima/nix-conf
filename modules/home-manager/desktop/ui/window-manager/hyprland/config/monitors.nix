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
    concatLists
    ;
  inherit (lib.lists) flatten optionals;
  monitors = osConfig.modules.hardware.monitors or { };
  displays = monitors.displays or { };
  primaryMonitor = monitors.primaryMonitorName;

  mkHyprMonitors =
    dispArg:
    let
      rawLists = mapAttrsToList (
        name: mon:
        concatLists [
          [ "${mon.name}, ${mon.mode}, ${mon.position or "0x0"}, ${toString (mon.scale or 1)}" ]
          (optionals (mon.transform) [
            "${mon.name}, transform, ${toString mon.transform}"
          ])
        ]
      ) dispArg;
    in
    flatten rawLists;

  mkHyprWorkspaces =
    displays: primaryMonitor:
    let
      primary = displays.${primaryMonitor}.name;
      monitorNames = map (m: m.name) (lib.attrValues displays);
      secondary = lib.findFirst (m: m != primary) primary monitorNames;
    in
    [ "1, monitor:${primary}, default:true" ]
    ++ map (num: "${toString num}, monitor:${primary}") (range 2 9)
    ++ [ "10, monitor:${secondary}" ];

in
{
  config = mkIf (displays != { }) {
    wayland.windowManager.hyprland.settings = {
      monitor = mkHyprMonitors displays;
      workspace = mkHyprWorkspaces displays primaryMonitor;
    };
  };
}
