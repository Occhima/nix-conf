{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.hyprland =
    {
      config,
      lib,
      osConfig ? { },
      ...
    }:
    let
      inherit (lib)
        mkIf
        mapAttrsToList
        filterAttrs
        ;
      monitors = osConfig.modules.hardware.monitors or { };
      displays = monitors.displays or { };
      enabled = filterAttrs (_: d: d.enable) displays;

      renderMode =
        d:
        "${toString d.width}x${toString d.height}"
        + (if d.refreshRate == null then "" else "@${toString d.refreshRate}");
      renderPosition = d: "${toString d.x}x${toString d.y}";

      mkHyprMonitorsV2 =
        monitorConfig:
        mapAttrsToList (
          _: d:
          {
            inherit (d) output scale transform;
            mode = renderMode d;
            position = renderPosition d;
          }
          // d.extraConfig
        ) monitorConfig;
    in
    {
      config = mkIf (displays != { }) {
        wayland.windowManager.hyprland.settings = hyprlandLib.mkMonitors config.wayland.windowManager.hyprland.configType (
          mkHyprMonitorsV2 enabled
        );
      };
    };
}
